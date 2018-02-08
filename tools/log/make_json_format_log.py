import subprocess
import os
import re
import json
from collections import OrderedDict
import argparse
import yaml


def get_execution_environment(env_output_file, env_info):

    try:
#        cmd = 'python ' + os.environ.get('CWL_HOME') + '/src/get_exe_env.py --output_file ' + env_output_file
        cmd = 'python get_exe_env.py --output_file ' + env_output_file
        subprocess.check_call(cmd, shell=True)
    except Exception as e:
        print(e)
        print('get_exe_env.py should be located in the same directory as this script.')
    finally:
        with open(env_output_file, mode='r') as f:
            lines = f.readlines()
            for line in lines:
                line = line.strip()
                values = line.split(': ')
                env_info[values[0]] = values[1]

def yaml_to_json(yaml_file):

    ### add a new constructor (OrderedDict version).
    # to guarantee order.
    yaml.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, lambda loader, node: OrderedDict(loader.construct_pairs(node)))
    # load yaml in the correct order.
    yaml_data = yaml.load(file(yaml_file))
    # convert yaml to json
    json_data = json.dumps(yaml_data, indent=4)

    # decode json data in the correct order (using OrderedDict).
    return json.JSONDecoder(object_pairs_hook=OrderedDict).decode(json_data)

def get_input_file_size(yaml_file, size_list):

    with open(yaml_file, mode='r') as f:
        lines = f.readlines()
        for line in lines:
            line = line.strip('\n')
            if re.match('\s*path:', line):
                path = line.split(' ')[-1]
                base_name = os.path.basename(path)
                calc_file_size_recur(path, base_name, size_list)

def calc_file_size_recur(path, base_name, size_list):

    if os.path.isfile(path): # base_name => file name
        if not size_list.get(base_name):
            size_list[base_name] = os.path.getsize(path)
    elif os.path.isdir(path): # base_name => directory name
        dir_lists = os.listdir(path)
        for dir_list in dir_lists:
            dir_list_path = path + '/' + dir_list
            base_name = os.path.basename(dir_list_path)
            calc_file_size_recur(dir_list_path, base_name, size_list)

def get_output_file_size(result_dir, size_list):

    result_files = os.listdir(result_dir)
    for result_file in result_files:
        path = result_dir + '/' + result_file
        if os.path.isfile(path):
            base_name = os.path.basename(path)
            if not size_list.get(base_name):
                size_list[base_name] = os.path.getsize(path)
        else: # skip directories.
            continue

def read_docker_ps_log_file(docker_ps_log, container_info_list):

    with open(docker_ps_log, mode='r') as f:
        ps_lines = f.readlines()
        # initialization
        con_id_start = 0
        image_start = 0
        command_start = 0
        created_start = 0
        status_start = 0
        ports_start = 0 # end.
        for line in ps_lines:
            if line.startswith('CONTAINER ID'): # skip header line
                # get positional information for fields in the header line.
                con_id_start = re.search('CONTAINER ID', line).start()
                image_start = re.search('IMAGE', line).start()
                command_start = re.search('COMMAND', line).start()
                created_start = re.search('CREATED', line).start()
                status_start = re.search('STATUS', line).start()
                ports_start = re.search('PORTS', line).start()
                continue
            line = line.strip('\n')
            # get container information.
            container_id = line[con_id_start:image_start - 1].strip()
            container_name = line[image_start:command_start - 1].strip()
            container_cmd = line[command_start:created_start - 1].strip().replace('"', '')
            container_status = line[status_start:ports_start - 1].strip()
            if "Exited" in container_status:
                container_status = re.search('Exited \(\d+\)', container_status).group(0)
            if "rancher" in container_name or "cadvisor" in container_name:
                container_id = ''
                container_name = ''
                container_cmd = ''
                container_status = ''
                continue
            container_cmd_key = container_cmd
            if container_cmd.startswith('bwa mem -M -R'): # for BWA
                container_cmd_key = container_cmd_key.replace('@', '\'@').replace('PL:Illumina', 'PL:Illumina\'').replace('\\t', 't')
            container_info_list[container_name, container_cmd_key] = [container_id, container_name, container_cmd, container_status]

    return container_info_list

def read_stderr_log_file(stderr_log):

    with open(stderr_log, mode='r') as f:
        return f.readlines()

def parse_stderr_contents(stderr_log_contents, step_contents, versions, size_list):

    workflow_cwl_name = ''
    each_cwl_name = ''
    step_name = ''
    version = ''
    job_tag = ''
    job_step_tag = ''
    docker_line_hit = False
    docker_name = ''
    docker_command = ''
    job_input = False
    job_input_lines = ''
    base_name = ''
    location = ''
    spaces = ''
    size_hit = False
    fail = False
    status = ''

    # for listing.
    listing_start_hit = False
    listing_start_hit_count = 0
    listing_end_hit = False

    for line in stderr_log_contents:
        line = line.strip('\n')
        if line.endswith(' '): # delete a space at the end of each line.
            line = line[:-1]
        # get a workflow program name. for RNA-seq and Variant Call
        if line.startswith('[workflow') and workflow_cwl_name == '':
            workflow_cwl_name = line.replace(']', '').split(' ')[1]
            step_contents.append([workflow_cwl_name])
            continue
        # get each step name.
        if line.startswith('[step') and line.endswith('start'):
            step_name = line.replace(']', '').split(' ')[1]
            job_tag = '[job ' + step_name + ']'
            continue
        # get a cwl program name.
        if 'initializing from file' in line:
            each_cwl_name = re.search('\/.+\.cwl', line).group(0).split('/')[-1]
            continue
        # get job input information
        if 'evaluated job input to' in line and job_input == False:
            job_step_tag = re.search('\[job step .+\]\s{1}', line).group(0).split(' ')[2].replace(']', '')
            if '{}' in line:
                job_input_lines = '{}'
            else:
                job_input_lines = '{'
                job_input = True
            continue
        # get job files.
        if job_input == True:
            if not line.startswith('}'): # not end line
                if '\"listing\":' in line: # class Directory
                    listing_start_hit = True
                    listing_start_hit_count += 1
                if line.startswith('    "file:///'):
                    field_tag = re.search('#.+', line).group(0).replace('#', '').split('":')[0].split('/')[1]
                    if line.endswith('{'): # file or directory
                        job_input_lines += '\n    "' + field_tag + '": {'
                    else:
                        field_tag_value = ''.join(re.search('#.+', line).group(0).split('/')[1:])
                        job_input_lines += '\n    "' + field_tag_value
                else:
                    # skip nameroot, nameext and commonwl.org lines.
                    if 'nameroot\":' in line or 'nameext\":' in line or 'commonwl.org' in line:
                        continue
                    if 'location\":' in line:
                        location = line.split('\"file://')[1].replace('\"', '').replace(',', '')
                    if 'basename\":' in line:
                        base_name = line.split()[1].replace(',', '').replace('"', '')
                        spaces = re.search('^\s+', line).group(0)
                    if re.match('^\s+\"size\":', line):
                        size_hit = True
                    if re.match('^\s+\},*', line):
                        size = ''
                        if size_hit == False:
                            if listing_end_hit == False:
                                size = spaces + '"size": ' + str(size_list[base_name])
                        if job_input_lines.endswith(','):
                            # line => '}' or '},'
                            if size_hit == False and listing_end_hit == False: # add the size line.
                                job_input_lines += '\n' + size + '\n' + line
                            else: # delte commma. (i.e. ', }' => ' }')
                                job_input_lines = job_input_lines[:-1] + '\n' + line
                        else:
                            if size_hit == False and listing_end_hit == False:
                                job_input_lines += ',\n' + size + '\n' + line
                            else:
                                job_input_lines += '\n' + line
                        location = ''
                        base_name = ''
                        size = ''
                        size_hit = False
                        listing_end_hit = False
                    elif re.match('^\s+\],*', line) and listing_start_hit == True: # listing.
                        if job_input_lines.endswith(','):
                            job_input_lines = job_input_lines[:-1] + '\n' + line
                        else:
                            job_input_lines += '\n' + line
                        listing_start_hit_count -= 1
                        if listing_start_hit_count == 0:
                            listing_start_hit = False
                        listing_end_hit = True
                    else:
                        job_input_lines += '\n' + line
            else:
                job_input = False
                job_input_lines = job_input_lines + "\n}"
            continue
        # get docker commands. for container information.
        if line.startswith('    --env=HOME='):
            docker_line_hit = True
            continue
        if docker_line_hit == True:
            if line.endswith(' \\'):
                line = line[4:-2]
                if docker_name == '':
                    docker_name = line
                    # for picard.
                    if 'picard' in docker_name:
                        docker_command += '/usr/picard/docker_helper.sh '
                else:
                    # docker ps output ommits redirect commands.
                    if '>' in line:
                        docker_command += re.split('\s+.*>', line)[0] + ' '
                    else:
                        docker_command += line + ' '
            else:
                line = line[4:]
                # docker ps output ommits redirect commands.
                if '>' in line:
                    docker_command += re.split('\s+.*>', line)[0]
                else:
                    docker_command += line
                docker_line_hit = False
        # get status information
        if line.startswith(job_tag + ' completed'):
            status = line.replace(job_tag + ' completed ', '')
            if line.endswith('success'):
                if step_name == 'trim':
                    version = '1.0.0'
                else:
                    if 'pfastq-dump' in step_name:
                        version = versions[step_name.split('_')[0]]
                    else:
                        version = versions[step_name.split('_')[0].split('-')[0]]
                step_contents.append([step_name, each_cwl_name, version, status, job_input_lines, docker_name, docker_command])
                step_name = ''
                version = ''
                job_tag = ''
                job_step_tag = ''
                job_input = False
                job_input_lines = ''
                docker_name = ''
                docker_command = ''
                location = ''
                base_name = ''
                size_hit = False
                fail = False
                status = ''
                docker_line_hit = False
                docker_command = ''
                docker_name = ''
                continue
            else:
                fail = True
        if fail == True or line.startswith('Unexpected exception'):
            version = versions[step_name.split("_")[0].split("-")[0]]
            step_contents.append([step_name, each_cwl_name, version, 'permanentFail', job_input_lines, docker_name, docker_command])
            step_name = ''
            each_cwl_name = ''
            version = ''
            job_tag = ''
            job_step_tag = ''
            job_input = False
            job_input_lines = ''
            docker_name = ''
            docker_command = ''
            location = ''
            base_name = ''
            size_hit = False
            fail = False
            status = ''
            docker_line_hit = False
            docker_command = ''
            docker_name = ''
            continue

def parse_assembler_stderr_contents(stderr_log_contents, step_contents, versions, size_list):

    workflow_cwl_name = ''
    each_cwl_name = ''
    initial_hit = False
    docker_line_hit = False
    docker_name = ''
    docker_command = ''
    step_name = ''
    version = ''
    job_input = False
    job_input_lines = ''
    fail = False
    status = ''

    for line in stderr_log_contents:
        line = line.strip('\n')
        if line.endswith(' '): # delete a space at the end of each line.
            line = line[:-1]
        # get a cwl program name.
        if 'initializing from file' in line:
            each_cwl_name = re.search('\/.+\.cwl', line).group(0).split('/')[-1]
            if '-version' in line:
                step_name = line.split('.cwl')[0].replace('[job ', '')
            else:
                step_name = step_name.split('-')[0] # e.g. sga-version => sga
                if workflow_cwl_name == '':
                    workflow_cwl_name = line.replace(']', '').split(' ')[1]
                    step_contents.insert(0, [workflow_cwl_name])
            initial_hit = True
            continue
        # get job input information
        if initial_hit == True:
            if line.startswith('[job ' + each_cwl_name + '] {}'):
                job_input_lines = '{}'
            else:
                job_input_lines = '{'
                job_input = True
            initial_hit = False
            continue
        if job_input == True:
            if not line.startswith('}'): # not end line
                if 'nameroot\":' in line or 'nameext\":' in line or 'commonwl.org' in line:
                    continue
                if re.match('^\s+\},*', line):
                    if job_input_lines.endswith(','):
                        # delete commma. (i.e. ', }' => ' }')
                        job_input_lines = job_input_lines[:-1] + '\n' + line
                    else:
                        job_input_lines += '\n' + line
                else:
                    job_input_lines += '\n' + line
            else:
                job_input = False
                job_input_lines = job_input_lines + "\n}"
            continue
        # get docker commands. for container information.
        # docker assembler executes a shell program (nucleotids(2).sh)
        if line.startswith('    --env=HOME=') or line.endswith('.sh \\'):
            docker_line_hit = True
            continue
        if docker_line_hit == True:
            if line.endswith(' \\'):
                line = line[4:-2]
                if docker_name == '':
                    docker_name = line
                    docker_command += 'run '
                else:
                    if '-version' in step_name:
                        docker_command += line + ' '
                    else:
                        if '/' in line:
                            fastq_name = line.split('/')[-1]
                            docker_command += '/inputs/' + fastq_name + ' '
                        else:
                            docker_command += line + ' '
            else:
                line = line[4:]
                if '-version' in step_name:
                    docker_command += line
                else:
                    docker_command += '/outputs'
                docker_line_hit = False
            continue

        # get status information
        if line.startswith('[job ' + each_cwl_name + '] completed'):
            status = line.replace('[job ' + each_cwl_name + '] completed ', '')
            if line.endswith('success'):
                version = versions['version']
                step_contents.append([step_name, each_cwl_name, version, status, job_input_lines, docker_name, docker_command])
                each_cwl_name = ''
                version = ''
                job_input = False
                job_input_lines = ''
                fail = False
                status = ''
                docker_line_hit = False
                docker_command = ''
                docker_name = ''
                continue
            else:
                fail = True
        if fail == True or line.startswith('Unexpected exception'):
            version = versions['version']
            step_contents.append([step_name, each_cwl_name, version, 'permanentFail', job_input_lines, docker_name, docker_command])
            each_cwl_name = ''
            version = ''
            job_input = False
            job_input_lines = ''
            fail = False
            status = ''
            docker_line_hit = False
            docker_command = ''
            docker_name = ''
            continue

def read_one_line_file(date):

    with open(date, mode='r') as f:
        return f.readline().strip()



def write_json(start_date, end_date, container_info_list, stderr_log_contents, step_contents, inputs_jobs, env_info, output_file, genome_version):

    template = OrderedDict()

    ### workflow section.
    workflow = OrderedDict()
    workflow['start_date'] = start_date
    workflow['end_date'] = end_date
    workflow['cwlfile'] = step_contents[0][0]
    del step_contents[0]
    # added. 13.Dec.2017
    workflow['genome_version'] = genome_version
    workflow['input_jobfile'] = inputs_jobs
#    workflow['debug_output'] = None
#    workflow['debug_output'] = stderr_log_contents
    workflow['debug_output'] = ''.join(stderr_log_contents)
    ### steps section.
    step = OrderedDict()
    for i in range(len(step_contents)):
        # contents.
        step_name = step_contents[i][0]
        each_cwl_name = step_contents[i][1]
        version = step_contents[i][2]
        status = step_contents[i][3]
        job_input_lines = json.loads(step_contents[i][4])
        docker_name = step_contents[i][5]
        docker_command = step_contents[i][6]
        if docker_name != '' and docker_command != '':
            con_info_list = container_info_list[docker_name, docker_command]
            container_id = con_info_list[0]
            container_name = con_info_list[1]
            container_cmd = con_info_list[2]
            container_status = con_info_list[3]
        else:
            container_id = None
            container_name = None
            container_cmd = None
            container_status = None
        # set contents.
        each_field = OrderedDict()
        each_field['platform'] = env_info['instance_type']
        each_field['stepname'] = step_name
        each_field['cwlfile'] = each_cwl_name
        each_field['container_id'] = container_id
        each_field['container_name'] = container_name
        each_field['container_cmd'] = container_cmd
        each_field['container_status'] = container_status
        each_field['tool_version'] = version
        each_field['tool_status'] = status
        each_field['input_files'] = job_input_lines
        # set contents to each step.
        step[step_name] = each_field
 
    template['workflow'] = workflow
    template['steps'] = step

    with open(output_file, mode='w') as f:
        json.dump(template, f, indent=4)

def get_genome_version(yaml_file):

    genome_version = ''
    with open(yaml_file, mode='r') as f:
        lines = f.readlines()
        for line in lines:
            if 'genome_version:' in line:
                genome_version = line.strip().replace('genome_version:', '').strip()
                break
    if genome_version == '':
        genome_version = '-'

    return genome_version

def main():

    ### arguments.
    # set arguments.
    parser = argparse.ArgumentParser(description='read stderr and container log files and make a json format file for elasticsearch.')
    parser.add_argument('--data_dir', metavar='<data_stored_directory>', type=str, required=True)
    parser.add_argument('--data_type', metavar='<assembler, rnaseq or mutation>', type=str, required=True)
    # get arguments.
    args = parser.parse_args()
    result_dir = args.data_dir
    data_type = args.data_type

    # set file paths
    stderr_log = result_dir + '/stderr.log'
    start = result_dir + '/start'
    end = result_dir + '/end'
    output_file = result_dir + '/cwl_log.json'
    # set docker ps log and yaml files to variables.
    docker_ps_log = ''
    yaml_file = ''
    result_files = os.listdir(result_dir)
    for result_file in result_files:
        if result_file.endswith('.dockerpslog'):
            docker_ps_log = result_dir + "/" + result_file
        if result_file.endswith('.yml'):
            yaml_file = result_dir + "/" + result_file

    ### execute get_exe_env.py and get execution environments.
    env_info = {}
    env_output_file = result_dir + '/exe_env'
    get_execution_environment(env_output_file, env_info)

    ### added. 13.Dec.2017
    genome_version = get_genome_version(yaml_file)

    ### convert yaml data (path setting file) to json format, and
    ### get all settings.
    inputs_jobs = yaml_to_json(yaml_file)

    ### get file sizes.
    size_list = {}
    get_input_file_size(yaml_file, size_list)
    get_output_file_size(result_dir, size_list)

    ### get start and end date 
    start_date = ''
    start_date = read_one_line_file(start)
    end_date = ''
    end_date = read_one_line_file(end)

    ### get software version
    versions = {}
    if data_type == 'assembler': # for assembler
        version_file = result_dir + '/version' 
        version = read_one_line_file(version_file)
        versions['version'] = version
    else: # for rnaseq and mutation
        result_files = os.listdir(result_dir)
        for result_file in result_files:
            if "_version" in result_file:
                version_file = result_dir + '/' + result_file
                version = read_one_line_file(version_file)
                versions[result_file[:-8]] = version.split('	')[1]

    ### get container info from outputs obtained by using docker ps command.
    # key: Container name and Command
    # value: Container ID (full), Container name, Command and Status.
    container_info_list = {}
    read_docker_ps_log_file(docker_ps_log, container_info_list)

    ### get all stderr log contents.
    stderr_log_contents = []
    stderr_log_contents = read_stderr_log_file(stderr_log)

    ### parse stderr contents to create arrays for json objects.
    step_contents = []
    if data_type != 'assembler':
        parse_stderr_contents(stderr_log_contents, step_contents, versions, size_list)
    else:
        parse_assembler_stderr_contents(stderr_log_contents, step_contents, versions, size_list)

    ### write log
    # modified. 13.Dec.2017
    write_json(start_date, end_date, container_info_list, stderr_log_contents, step_contents, inputs_jobs, env_info, output_file, genome_version)


if __name__ == '__main__':
    main()
