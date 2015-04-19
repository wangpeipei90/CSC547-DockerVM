#!/usr/bin/Rscript
old=getwd();
basedir="/home/peipei/course/CSC547/experiment_docker_hadoop";
setwd(basedir);

#file_patterns=c("output_empty.txt.*.dat$","output_empty_2.txt.*.dat$","output_empty_3.txt.*.dat$")
file_patterns=c("output_launch_docker_1.txt.*.dat$","output_launch_docker_2.txt.*.dat$","output_launch_docker_3.txt.*.dat$")
XC=list();

for(file_pattern in file_patterns){
  data_files=list.files(path=basedir,pattern=file_pattern);
  #print(data_files)
  X=list();
  
  for(data_file in data_files){
    data=as.numeric(readLines(data_file));
    X=cbind(X,data);
  }
  X=as.data.frame(X);
  colnames(X)=data_files;
  XC[[file_pattern]]=X
}

null_metric=vector();
metrics=vector();
for(col_num in 1:length(X)){
  name=data_files[col_num];
  name1=strsplit(name,"txt.")[[1]][2];
  # name=paste("output_empty",name1,sep=".");
  name=paste("output_launch_docker",name1,sep=".");
  metrics=append(metrics,name1);
  
  #print(col_num)
  value1=as.vector(XC[[1]][[col_num]]);
  value2=as.vector(XC[[2]][[col_num]]);
  value3=as.vector(XC[[3]][[col_num]]);
  
  #v=as.matrix(cbind(value1,value2,value3));
  v=as.matrix(cbind(as.numeric(value1),as.numeric(value2),as.numeric(value3)));
  
  average=apply(v,1,mean);
  v_max=max(apply(v,1,max));
  v_min=min(apply(v,1,min));
  
  if(v_max==v_min){
    null_metric=append(null_metric,name1);
  }else{
    avg_e=c(Reduce("+",value1)/length(value1),Reduce("+",value2)/length(value2),Reduce("+",value3)/length(value3));
    max_e=c(Reduce(max,value1),Reduce(max,value2),Reduce(max,value3));
    print(name);
    print(avg_e);
    print(max_e);
  }
  
  #x_axis=seq(0,28,2);
  x_axis=seq(0,58,2);
  
  # postscript(paste(getwd(),paste(name,"eps",sep="."),sep="/"));
  png(paste(getwd(),paste(name,"png",sep="."),sep="/"));
 # print(average)
 # print(value1)
  plot(x=x_axis,y=average,ylim=c(v_min,v_max),type="p",pch=4,cex=0.4,xlab="time(seconds)",ylab=name1,col="black");
  lines(x=x_axis,y=average,col="black",lwd=2);
  points(x=x_axis,y=average,type="p",pch=3,cex=0.4,xlab="time(seconds)",ylab="experiment1",col="black");
  lines(x=x_axis,y=value1,col="red",lty=2);
  points(x=x_axis,y=value2,type="p",pch=8,cex=0.4,xlab="time(seconds)",ylab="experiment2",col="black");
  lines(x=x_axis,y=value2,col="green",lty=2);
  points(x=x_axis,y=value3,type="p",pch=24,cex=0.4,xlab="time(seconds)",ylab="experiment3",col="black");
  lines(x=x_axis,y=value3,col="blue",lty=2);
  dev.off();
}
print(null_metric);
output_launch_docker_null_metric=null_metric;
output_launch_docker_metrics=metrics;
setwd(old);