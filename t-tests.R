#EXAMPLE 1: One sample t-test

#The principal of a school with 1000 students believes that the average IQ of his school is at least 110. 
#He selects a simple random sample of 20 students and applies an IQ test to this sample. The IQ average of this sample is 108 with standard deviation 10.

#Null hypothesis: the IQ average of the 1000 students is >= 110
#Alternative hypothesis: the IQ average of these 1000 students is <110
#Significance level: 0.01

#In order to apply t.test(), I need an actual list containing the results of the 20 students after the test.
#The actual results are not important as long as the mean is 108 and the standard deviation is 10

#the following function creates such a list
lista <- function(n,mean,sd){mean + sd*scale(rnorm(n))}
x<-lista(20,108,10)
x <- data.frame(x)
x

##> x
##           x
##1  111.47793
##2   88.36761
##3   95.08124
##4  104.18510
##5   93.24597
##6  107.10057
##7  116.93569
##8  117.47970
##9  104.03813
##10 106.65333
##11 119.07846
##12 121.99277
##13 102.28272
##14 121.32467
##15  98.91990
##16 123.96887
##17 105.26222
##18 104.15981
##19 112.67697
##20 105.76832

t.test(x,mu=110,conf.int=0.99,alternative="less")

##> t.test(x,mu=110,conf.int=0.99,alternative="less")
##        One Sample t-test
##data:  x
##t = -0.89443, df = 19, p-value = 0.1911
##alternative hypothesis: true mean is less than 110
##95 percent confidence interval:
##     -Inf 111.8665
##sample estimates:
##mean of x 
##      108 

#the p-value is greater than 0.01, so we reject it
#recall, the p-value here means that if we assume the null hypothesis (the average IQ of the 1000 students is >= 110), then the probability that any sample of size 20 having mean less than 108 is 19%. This number is just too big given our assumption, so we reject the null hypothesis.

#conclusion: the IQ average of the 1000 students is less than 110.


