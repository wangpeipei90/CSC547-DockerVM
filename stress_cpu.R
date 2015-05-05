#!/usr/bin/Rscript
# this is for plotting the tendency of Docker container with stressed cpu cores
old=getwd();
basedir="/home/peipei/course/CSC547/experiment_docker_hadoop/stress_docker";
setwd(basedir);

hadoop_no_stress=c(42,50,52,41,49,41,50,46);
hadoop_cpu4_stress=c(79,83,85,86,77,84,81,83);
hadoop_cpu6_stress=c(177,192,184,189,175,192,193,187);
hadoop_cpu8_stress=c(372,368,360,356,369,369,370,370);
hadoop_stress=c(hadoop_no_stress,hadoop_cpu4_stress,hadoop_cpu6_stress,hadoop_cpu8_stress);
x_hadoop=c(rep(0,each=8),rep(4,each=8),rep(6,each=8),rep(8,each=8))

job_no_stress=c(56,60,57,55,58,56,60,57);
job_cpu4_stress=c(123,126,118,105,124,116,116,121);
job_cpu6_stress=c(314,269,299,303,342,296,288,305);
job_stress=c(job_no_stress,job_cpu4_stress,job_cpu6_stress);
x_job=c(rep(0,each=8),rep(4,each=8),rep(6,each=8));

name="stress_cpu";
png(paste(getwd(),paste(name,"png",sep="."),sep="/"));
plot(x=NULL,y=NULL,mai="Time of launching Docker container and running Hadoop",xlab="Number of Stressed CPU Cores",ylab="Execution time",xlim=range(0:9),ylim=range(0:450));

points(x_hadoop,hadoop_stress,type="p",pch=8,cex=0.4,col="blue");
reg1<-lm(hadoop_stress~x_hadoop);
abline(reg1,col="blue");

points(x_job,job_stress,type="p",pch=3,cex=0.4,col="red");
reg2<-lm(job_stress~x_job);
abline(reg2,col="red");

legend("top",horiz=FALSE,legend=c("running job Teragen ","launching Docker container and starting Hadoop"), pch=c(3,8), col=c("red","blue"))

dev.off();
