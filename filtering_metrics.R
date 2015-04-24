old=getwd();
basedir="/home/peipei/course/CSC547/experiment_docker_hadoop";
setwd(basedir);

t4=output_launch_dockerhadoopprogram_null_metric;
t3=output_launch_dockerhadoop_null_metric;
t2=output_launch_docker_null_metric;
t1=output_empty_null_metric=null_metric;
m1=output_empty_metrics;
m2=output_launch_docker_metrics;
m3=output_launch_dockerhadoop_metrics;
m4=output_launch_dockerhadoopprogram_metrics;
m=m1;

null_metrics=Reduce(intersect,list(t1,t2,t3,t4));

used_metrics= setdiff(m,null_metrics);
# [1] "br0.net.rxkb.dat"      "br0.net.rxpck.dat"     "br0.net.txkb.dat"      "br0.net.txpck.dat"     "cpu.busy.dat"          "cpu.idle.dat"         
# [7] "cpu.iowait.dat"        "cpu.system.dat"        "cpu.user.dat"          "disk.brdps.dat"        "disk.bwrps.dat"        "disk.rtps.dat"        
# [13] "disk.tps.dat"          "disk.wtps.dat"         "docker0.net.rxkb.dat"  "docker0.net.rxpck.dat" "docker0.net.txkb.dat"  "docker0.net.txpck.dat"
# [19] "eth0.net.rxkb.dat"     "eth0.net.rxmcst.dat"   "eth0.net.rxpck.dat"    "eth0.net.txkb.dat"     "eth0.net.txpck.dat"    "eth1.net.rxkb.dat"    
# [25] "eth1.net.rxmcst.dat"   "eth1.net.rxpck.dat"    "eth1.net.txkb.dat"     "eth1.net.txpck.dat"    "mem.commit.dat"        "mem.kbbuffers.dat"    
# [31] "mem.kbcached.dat"      "mem.kbcommit.dat"      "mem.kbmemfree.dat"     "mem.kbmemused.dat"     "mem.memused.dat"      

for(null_metric in null_metrics){
  file_patterns=c(paste(null_metric,"$",sep=""),paste(null_metric,".png$",sep=""))
  for(file_pattern in file_patterns){
    #data_files=list.files(path=basedir,pattern=file_pattern);
    rm(list=ls(pattern=file_pattern));
  }
}


setwd(old);

statistics<-function(v1,v2,v3){
  avg=c(sum(v1)/length(v1),sum(v2)/length(v2),sum(v3)/length(v3));
  max=c(max(v1),max(v2),max(v3));
}