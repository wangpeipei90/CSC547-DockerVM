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
plot(x=NULL,y=NULL,mai="Linear regression of launching 8 Docker containers and running Hadoop",xlab="Number of Stressed CPU Cores",ylab="Execution time(seconds)",xlim=range(0:9),ylim=range(0:450));


f <- function(x,a,b) {a * exp(b * x)}

points(x_hadoop,hadoop_stress,type="p",pch=8,cex=0.4,col="blue");
#reg1<-lm(hadoop_stress~x_hadoop);
#reg1<-nls(hadoop_stress~exp(b*x_hadoop),start=list(b=1.3));
reg1<-nls(hadoop_stress~f(x_hadoop,a,b),start=c(a=2, b=1));
abline(reg1,col="blue");

points(x_job,job_stress,type="p",pch=3,cex=0.4,col="red");
#reg2<-lm(job_stress~x_job);
#reg2<-nls(job_stress~exp(a*x_job),start=list(a=1.3));
reg2<-nls(job_stress~f(x_job,a,b),start=c(a=2, b=1));
abline(reg2,col="red");

legend("top",horiz=FALSE,legend=c("running MapReduce job Teragen inside the Docker container","launching 8 Docker containers and starting Hadoop"), pch=c(3,8), col=c("red","blue"))

dev.off();
