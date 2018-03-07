import os
import sys
import atexit
import subprocess
import psutil
import time
import glob
import datetime
import re
from Daemon import Daemon

class TelegrafCwlLogDaemon(Daemon):

    telegraf_conf = ''
    telegraf_docker_command = ''
    telegraf_docker_name = ''
    bucket_name = ''
    cwl_log_command = ''
    cwl_log_name = ''
    def get_setting(self, config):
        with open(config, mode='r') as f:
            lines = f.readlines()
            for line in lines:
                settings = line.strip().split(': ')
                if settings[0] == 'telegraf_conf':
                    self.telegraf_conf = settings[1]
                elif settings[0] == 'telegraf_docker_command':
                    self.telegraf_docker_command = settings[1]
                elif settings[0] == 'telegraf_docker_name':
                    self.telegraf_docker_name = settings[1]
                elif settings[0] == 'bucket_name':
                    self.bucket_name = settings[1]
                elif settings[0] == 'cwl_log_command':
                    self.cwl_log_command = settings[1]
                elif settings[0] == 'cwl_log_name':
                    self.cwl_log_name = settings[1]
                else:
                    continue

    def get_telegraf_log_name(self):
        with open(self.telegraf_conf, mode='r') as f:
            lines = f.readlines()
            for line in lines:
                line = line.strip()
                if 'files' in line and not '#' in line:
                    log_path = line.split('=')[1].replace('"', '').replace('[', '').replace(']', '')
                    file_name = os.path.basename(log_path)
                    return file_name
            return 'metrics.json'

    # override.
    def run(self):
        pids ={}
        docker_id = {}
        res_path_list = {}
        result_dir_path = {}
        while True:
            # get pids for cwltool exection.
            self.get_cwltool_exec_process(pids, result_dir_path)
            if (len(pids)) > 0:
                for pid, status in pids.items():
                    pid = int(pid)
                    if status == 'stop':
                        # start docker telegraf.
                        container_id = self.start_telegraf(pid, result_dir_path[pid])
                        pids[pid] = 'start'
                        docker_id[pid] = container_id
                        continue
                    # check cwltool execution status.
                    if status == 'start':
                        existence = self.exist_pid(pid)
                        if existence == False:
                            # stop and remove docker telegraf.
                            self.stop_telegraf(docker_id[pid])
                            # get program name.
                            program_name = self.get_program_name(result_dir_path[pid])
                            # create CWL stderr based json log file.
                            self.exec_cwl_json_log_maker(result_dir_path[pid])
                            # create prefix.
                            prefix = self.create_prefix()
                            # get telegraf log name from telegraf.conf
                            telegraf_log_name = self.get_telegraf_log_name()
                            # upload telegraf log files.
                            telegraf_log_file = result_dir_path[pid] + '/' + telegraf_log_name
                            self.upload_log_to_s3(telegraf_log_file, prefix, program_name)
                            # upload cwl log files.
                            cwl_log_file = result_dir_path[pid] + '/' + self.cwl_log_name
                            self.upload_log_to_s3(cwl_log_file, prefix, program_name)
                            del docker_id[pid]
                            del pids[pid]
                            del result_dir_path[pid]
            time.sleep(5)

    def create_prefix(self):
        now = datetime.datetime.now()
        return str(now.year) + '-' + str(now.month) + '-' + str(now.day) + '-' + str(now.hour) + '-' + str(now.minute) + '-' + str(now.second)

    def get_program_name(self, result_dir_path):
        program_name_file = result_dir_path + '/program_name'
        with open(program_name_file, mode='r') as f:
            return f.readline().strip()

    def get_cwltool_exec_process(self, pids, result_dir_path):
        command = 'ps aux | grep cwltool'
        ret = subprocess.Popen(command,
                           shell=True,
                           stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE).communicate()
        ps_out = ret[0].decode('utf-8')
        ps_lines = ps_out.split('\n')
        for line in ps_lines:
            if '.cwl' in line and 'python' in line:
                pid_info = line.split()
                pid = int(pid_info[1])
                dirHit = False
                if not pid in pids.keys():
                    pids[pid] = 'stop'
                    for data in pid_info:
                        if data == '--outdir':
                            dirHit = True
                            continue
                        if dirHit == True:
                            result_dir_path[pid] = data
                            break

    def exist_pid(self, pid):
        if psutil.pid_exists(pid):
            return True
        else:
            return False

    def start_telegraf(self, pid, result_dir_path):
        self.check_docker_telegraf_exe_status()
        docker_command = self.telegraf_docker_command.replace('TELEGRAF_CONF', self.telegraf_conf).replace('RESULT_DIR_PATH', result_dir_path).replace('TELEGRAF_DOCKER_NAME', self.telegraf_docker_name)
        try:
            subprocess.call(docker_command, shell=True)
            docker_inspect_command = 'docker ps -a'
            rtn = subprocess.Popen(docker_inspect_command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
            docker_ps_lines = rtn[0].decode('utf-8')
            lines = docker_ps_lines.split('\n')
            for line in lines:
                if line.startswith('CONTAINER'):
                    continue
                docker_info = line.split()
                if docker_info[1] == self.telegraf_docker_name:
                    container_id = docker_info[0]
                    return container_id
        except Exception:
            print('docker telegraf execution failed:') 
            raise

    def stop_telegraf(self, container_id):
        stop_command = 'docker stop ' + container_id
        remove_command = 'docker rm ' + container_id
        try:
            subprocess.call(stop_command, shell=True)
            subprocess.call(remove_command, shell=True)
        except Exception:
            print('docker telegraf stopping failed:')
            raise

    def check_docker_telegraf_exe_status(self):
        docker_ps_command = 'docker ps'
        try:
            ret = subprocess.Popen(docker_ps_command, shell=True,
                                   stdout=subprocess.PIPE).communicate()
            docker_ps_lines = ret[0].decode('utf-8')
            lines = docker_ps_lines.split('\n')
            for line in lines:
                if line.startswith('CONTAINER'):
                    continue
                if line == '':
                    continue
                container_info = line.split()
                if container_info[1] == self.telegraf_docker_name:
                    container_id = container_info[0]
                    self.stop_telegraf(container_id)
        except Exception:
            print('docker ps error')
            raise

    def exec_cwl_json_log_maker(self, result_dir_path):
        try:
            psfile_time_count = 0;
            while True:
                for ps_log in glob.iglob(result_dir_path + '/*.dockerpslog'):
                    if os.path.exists(ps_log):
                        psfile_time_count = 100
                        break;
                time.sleep(1)
                psfile_time_count = psfile_time_count + 1
                if psfile_time_count > 100:
                    break
            command = self.cwl_log_command.replace('RESULT_DIR', result_dir_path)
            subprocess.call(command, shell=True)
        except Exception:
            print('execution error: make_json_format_log.py')
            raise

    def upload_log_to_s3(self, log_file, prefix, program_name):
        try:
            ### create prefix directory
            create_command = 'aws s3api put-object --bucket ' + self.bucket_name + ' --key ' + program_name + '/' + prefix + '/'
            subprocess.call(create_command, shell=True)
            ### upload logs.
            upload_command = 'aws s3 cp ' + log_file + ' s3://' + self.bucket_name + '/' + program_name + '/' + prefix + '/'
            subprocess.call(upload_command, shell=True)
        except Exception:
            print('upload error: aws s3: ' + log_file)

def main():
    config = './telegraf_cwl_log.config'
    pid_file = '/tmp/telegraf_cwl_daemon.pid'
    daemon = TelegrafCwlLogDaemon(pid_file)
    daemon.get_setting(config)
    if len(sys.argv) == 2:
        if sys.argv[1] == 'start':
            daemon.start()
        elif sys.argv[1] == 'stop':
            daemon.stop()
        elif sys.argv[1] == 'restart':
            daemon.restart()
        else:
            print('Usage: python %s start|stop|restart' % sys.argv[0])
            sys.exit(2)
        sys.exit(0)
    else:
        print('Usage: python %s start|stop|restart' % sys.argv[0])
        sys.exit(2)

if __name__ == '__main__':
    main()
