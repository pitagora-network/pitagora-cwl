import argparse
import subprocess


def main(output_file):

    # URL (for Amazon AWS)
    base_url = 'http://169.254.169.254'

    region_url = base_url + '/latest/meta-data/placement/availability-zone'
    instance_type_url = base_url + '/latest/meta-data/instance-type'
    host_name_url = base_url + '/latest/meta-data/hostname'

    # initialization.
    region = ''
    instance_type = ''
    host_name = ''
    mem_total = ''
    mem_gb = ''
    disk_size = ''

    try:
        # get region info.
        region_command = 'curl -s ' + region_url
        region = subprocess.check_output(region_command, shell=True)
        region = region.strip()
        # get instance type.
        instance_type_command = 'curl -s ' + instance_type_url
        instance_type = subprocess.check_output(instance_type_command, shell=True)
        instance_type = instance_type.strip()
        # get host name.
        host_name_command = 'curl -s ' + host_name_url
        host_name = subprocess.check_output(host_name_command, shell=True)
        host_name = host_name.strip()
        # get total memory.
        mem_total_command = 'grep ^MemTotal /proc/meminfo | awk \'{print $2}\''
        mem_total = subprocess.check_output(mem_total_command, shell=True)
        mem_total = mem_total.strip()
        # get memory gb.
        mem_gb_command = 'python -c "print(round(float(' + mem_total + ')/1024/1024,2))"'
        mem_gb = subprocess.check_output(mem_gb_command, shell=True)
        mem_gb = mem_gb.strip()
        # get disk size.
        disk_size_command = 'df -k --output=size / | sed 1d'
        disk_size = subprocess.check_output(disk_size_command, shell=True)
        disk_size = disk_size.strip()
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
