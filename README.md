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
