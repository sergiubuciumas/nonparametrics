library(perm)
library(asbio)
###Chapter 1 Exercises: 3

rain <- c(21.3, 28.8, 17.6, 23.0, 27.2, 28.5, 32.8, 28.2, 25.9, 22.5, 27.2, 33.1, 28.7, 24.8, 24.3, 27.1, 30.6, 26.8, 18.9, 36.3, 28.0, 17.9, 25.0, 27.5, 27.7, 32.1, 28.0, 30.9, 20.0, 20.2, 33.5, 26.4, 30.9, 33.2)

# a) create a 95% interval for the median, will start with finding the median for rain

summary(rain)

length(rain)
rain[1:5]
mean(rain)
median(rain)
sd(rain)

test.median <- function(datvec,medval,Ha.dir=c('two.sided','less','greater')){
  n <- length(datvec[datvec!=medval])
  if (sum(datvec==medval)>0) print(paste("Note: ",sum(datvec==medval)," value(s) ignored because of equality to the null value of the median"))
  B <- sum(datvec>medval)
  print(paste("Number of data values exceeding the null median: B=",B, " of ",n))
  if (Ha.dir[1]=="less"){
    pval <- pbinom(B,n,.5)
    print(paste("P-value for Ha: median < ",medval,":  ",pval))
  } else {
    if (Ha.dir[1]=="greater"){
      pval <- 1-pbinom(B-1,n,.5)
      print(paste("P-value for Ha: median > ",medval,":  ",pval))
    } else {
      if (Ha.dir[1]=="two.sided") {
        pval <- sum(dbinom(0:n,n,.5)[dbinom(0:n,n,.5)<= dbinom(B,n,.5)])
        print(paste("P-value for Ha: median not equal to ",medval,":  ",pval))
      }
    }
  }
  return(pval)
}

test.median(rain, 27.35, "greater")

ci.median<-function(x,conf=.95){
  n<-nrow(as.matrix(x))
  if(qbinom((1-conf)/2,n,0.5)==0)stop("CI not calculable")
  L<- qbinom((1-conf)/2,n,0.5)
  U<-n-L+1
  if(L>=U)stop("CI not calculable")
  order.x<-sort(x)
  res<-list()
  res$head<-paste(paste(as.character(conf*100),"%",sep=""),c("Confidence interval for population median"))
  res$ci<-c(median=median(x),lower=order.x[L],upper=order.x[n-L+1])
  res$ends<-c("Estimate",paste(as.character(c((1-conf)/2,1-((1-conf)/2))*100),"%",sep=""))
  res$coverage<-1-(2*pbinom(q=L-1,n,0.5))
  class(res)<-"ci"
  res
}



ci.median(rain, conf = 0.95)