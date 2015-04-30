#!/usr/bin/Rscript
old=getwd();
basedir="/home/peipei/course/CSC547/experiment_docker_hadoop";
setwd(basedir);

fs_docker=c("output_launch_dockerhadoop_1.txt","output_launch_dockerhadoop_2.txt","output_launch_dockerhadoop_3.txt");
metrics_docker=c("cpu.busy.dat","mem.memused.dat","disk.tps.dat","eth1.net.rxkb.dat","eth1.net.txkb.dat","docker0.net.rxkb.dat","docker0.net.txkb.dat");

fs_vm=c("output_launch_vmhadoop1.txt","output_launch_vmhadoop2.txt","output_launch_vmhadoop3.txt");
metrics_vm=c("cpu.busy.dat","mem.memused.dat","disk.tps.dat","eth1.net.rxkb.dat","eth1.net.txkb.dat","virbr0.net.rxkb.dat","virbr0.net.txkb.dat");

name="docker_vm_hadoop"
png(paste(getwd(),paste(name,"png",sep="."),sep="/"));
#par(xpd=TRUE);

cnames_vm_cpu=paste(fs_vm,metrics_vm[1],sep=".");
cnames_vm_mem=paste(fs_vm,metrics_vm[2],sep=".");

sample=1;
x_cpu=as.vector(XC_vmhadoop[[sample]][[cnames_vm_cpu[sample]]]);
y_mem=as.vector(XC_vmhadoop[[sample]][[cnames_vm_mem[sample]]]);

plot(x=NULL,y=NULL,mai="Overhead comparision of launching Docker container and VM",xlab="Percentage of CPU usage(%)",ylab="Percentage of MEM usage(%)",xlim=range(0:60),ylim=range(20:60));
points(x_cpu,y_mem,type="p",pch=8,cex=0.4,col="blue");

sample=2;
x_cpu=as.vector(XC_vmhadoop[[sample]][[cnames_vm_cpu[sample]]]);
y_mem=as.vector(XC_vmhadoop[[sample]][[cnames_vm_mem[sample]]]);
points(x_cpu,y_mem,type="p",pch=8,cex=0.4,col="blue");

sample=3;
x_cpu=as.vector(XC_vmhadoop[[sample]][[cnames_vm_cpu[sample]]]);
y_mem=as.vector(XC_vmhadoop[[sample]][[cnames_vm_mem[sample]]]);
points(x_cpu,y_mem,type="p",pch=8,cex=0.4,col="blue");

cnames_docker_cpu=paste(fs_docker,metrics_docker[1],sep=".");
cnames_docker_mem=paste(fs_docker,metrics_docker[2],sep=".");

sample=1;
x_cpu=as.vector(XC_dockerhadoop[[sample]][[cnames_docker_cpu[sample]]]);
y_mem=as.vector(XC_dockerhadoop[[sample]][[cnames_docker_mem[sample]]]);

points(x_cpu,y_mem,type="p",pch=3,cex=0.4,col="red");

sample=2;
x_cpu=as.vector(XC_dockerhadoop[[sample]][[cnames_docker_cpu[sample]]]);
y_mem=as.vector(XC_dockerhadoop[[sample]][[cnames_docker_mem[sample]]]);
points(x_cpu,y_mem,type="p",pch=3,cex=0.4,col="red");

sample=3;
x_cpu=as.vector(XC_dockerhadoop[[sample]][[cnames_docker_cpu[sample]]]);
y_mem=as.vector(XC_dockerhadoop[[sample]][[cnames_docker_mem[sample]]]);
points(x_cpu,y_mem,type="p",pch=3,cex=0.4,col="red");
legend(1,-1,c("group A", "group B"), pch = c(1,2), lty = c(1,2))

#legend(x=1,y=-1,legend=c("docker", "vm"),pch=3,cex=.8,col=c("red", "blue"));
legend("top",horiz=TRUE,legend=c("docker","vm"), pch=c(3,8), col=c("red","blue"))
dev.off();
setwd(old);