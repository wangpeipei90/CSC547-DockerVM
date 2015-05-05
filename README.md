# CSC547-DockerVM

This folder containers of 7 experiments to evaluate the overhead and scalability of Docker containers and to compare Docker container with VM, and all related data analysis script(e.g.,format_sar_output and R script files)

The first experiment is to test Docker scalability with stress tool. To do the experiment, you should have stress and docker preinstalled in the host OS.

The commands_stress file records related commands to run this experiment.  Since the CPU cores on the host OS is 8, we will launch 8 Docker containers simultaneously.

To stress 4 CPU cores, use command “stress -c 4 &”. Then use the command 
for i in {1..8};do 
date>output_$i&&docker run sequenceiq/hadoop-docker:2.6.0 sh -c 'etc/bootstrap.sh&& date&& sleep 30 && date && /usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar  teragen  -Dmapreduce.map.env="yarn.nodemanager.docker-container-executor.image-name=sequenceiq/hadoop-docker:2.6.0" -Dyarn.app.mapreduce.am.env="yarn.nodemanager.docker-container-executor.image-name=sequenceiq/hadoop-docker:2.6.0"   1000   teragen_out_dir;date' >>output_$i & 
done;

to record the execution time of launching Docker container and starting Hadoop, the execution time of  running MapReduce job Teragen.

We did 4 times of stress experiment, stressing 0,4,6,8 CPU cores so the the available CPU cores are 8,4,2,0. All recorded execution timestamp are in the subdirectories of “stress_docker”. nostress_start8 means stressing 0 CPU cores, cpu4_stress_start8 means stressing 4 CPU cores, cpu6_stress_start8 means stressing 6 CPU cores, and CPU8_stress_start8 means stressing 8 CPU cores.

The calculated execution time duration is listed in the spreadsheet strees_docker/stress_cpu_time.ods.

To note that stressing 8 CPU cores will prevent the execution of Teragen MapReduce job. So use the command 
for i in {1..8};do  date>output_$i&&docker run sequenceiq/hadoop-docker:2.6.0 sh -c 'etc/bootstrap.sh&& date' >>output_$i &  done;
would avoid executing MapReduce job.

stress_cpu.R use the execution time to do the exponential regression and to plot figure stress_docker/stress_cpu.png.



The left 6 experiments use “sar” to evaluate the overhead. Specifically, the folder output_empty is to evaluate the overhead of “sar” tool; output_launch_docker is to evaluate the overhead of launching a Docker container; output_launch_dockerhadoop is to to evaluate the overhead of launching a Docker container and starting Hadoop inside the Docker container; output_launch_dockerhadoopprogram is to evaluate the overhead of launching a Docker container, starting Hadoop and running a MapReduce job Teragen; output_launch_vm is to evaluate the overhead of launching a VM; output_lauch_vmhadoop is to evaluate the overhead of launching a VM and starting Hadoop inside the VM. Because of lacking of enough available resources, running the MapReduce job Teragen fails in the VM.

To use “sar”, sysstat package has to be first installed. Here are commands to install sysstat.

For Ubuntu: sudo apt-get install sysstat
For Centos: yum install sysstat.

“war -u” is to collect CPU Usages of all cpus; “sar -r” to collect memory statistics; “war -b” to collect I/O statistics; “sar -n DEVICENAME” to collect network statistics.

Our experiments collected CPU, Memory, IO and Network statistics, and use the interval of 2 seconds. Thus the command is like “sar -urb -n DEV 2 NumberOfTimes”. NumberOfTimes is an Integer specifying how many times you want to collect the metrics.

The times of collecting metrics for output_empty, output_launch_docker, output_launch_dockerhadoop, output_launch_dockerhadoopprogram, output_launch_vm, output_lauch_vmhadoop are 15, 30, 30, 90, 30,60.

For each experiment, we did 3 times, so there are 3 files of the collected data are put under each folder accordingly. We use the awk script “format_sar_output.awk” to separate various metrics into different files. The command tis “./format_sar_output.awk sar_metric_filename”. It will generate the files with the name pattern “sar_metric_filename.”+ “cpu,men,disk,network device” +”metric_name”+”.dat”. These .dat files are also under the folder of each experiment.

parse_output_output_empty.R, parse_output_output_launch_docker.R, parse_output_output_launch_dockerhadoop.R, parse_output_output_launch_dockerhadoopprogram.R, parse_output_output_launch_vm.R, parse_output_output_launch_vmhadoop.R are the R scripts to read the metric values from the .dat files and to plot figures for each metrics. The plotted figures are the .png files under each folder.

compare_docker_vm.R and compare_docker_vm_hadoop.R are the R scripts to compare the overhead of VM to Docker container. These two scripts use variables created in the parse*.R scripts and should only be executed after all the parse*.R have been executed. docker_vm.png and docker_vm_hadoop.png are the generated two figures.

Not all the metrics are impacted by Docker or VM. The selected_png folder selected the figures that are most interesting.
