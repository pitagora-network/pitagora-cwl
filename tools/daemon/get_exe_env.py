import argparse
import subprocess
import sys


def main(output_file):

    try:
        # for IMSBIO server.
        region = "null"
        instance_type = "null"
        host_name = "null"

        # get total memory.
        mem_total_command = 'grep ^MemTotal /proc/meminfo | awk \'{print $2}\''
        mem_total = subprocess.check_output(mem_total_command, shell=True)
        mem_total = mem_total.strip().decode('utf-8')
        # get memory gb.
        mem_gb_command = 'python -c "print(round(float(' + mem_total + ')/1024/1024,2))"'
        mem_gb = subprocess.check_output(mem_gb_command, shell=True)
        mem_gb = mem_gb.strip().decode('utf-8')
        # get disk size.
        disk_size_command = 'df -k --output=size / | sed 1d'
        disk_size = subprocess.check_output(disk_size_command, shell=True)
        disk_size = disk_size.strip().decode('utf-8')
    except Exception as e:
        print(e)
    finally:
        # write variables in an output file.
        with open(output_file, mode='w') as f:
            f.write('region: ' + region + '\n')
            f.write('instance_type: ' + instance_type + '\n')
            f.write('host_name: ' + host_name + '\n')
            f.write('memory_total: ' + mem_total + '\n')
            f.write('memory_gb: ' + mem_gb + '\n')
            f.write('disk_size: ' + disk_size + '\n')

if __name__ == '__main__':

    ### arguments.
    # set arguments.
    parser = argparse.ArgumentParser(description='get execution environments')
    parser.add_argument('--output_file', metavar='<output_file>', type=str, required=True)
    # get arguments.
    args = parser.parse_args()
    output_file = args.output_file

    main(output_file)
