#EXAMPLE 1: confidence interval of one-sample proportion

#A newspaper with 100000 subscribers selects a simple random sample of 1600 subscribers.
#They are asked whether there should be an increase of local news. 40% said yes and 60% said no.
#The following code will give a 99% confidence interval on the actual population proportion of subscribers who prefer an increase of local news.

prop.test(x=0.4*1600,n=1600,conf.level=0.99)

##> prop.test(x=.4*1600,n=1600,conf.level=0.99)
##        1-sample proportions test with continuity correction
##data:  0.4 * 1600 out of 1600, null probability 0.5
##X-squared = 63.601, df = 1, p-value = 1.524e-15
##alternative hypothesis: true p is not equal to 0.5
##99 percent confidence interval:
## 0.3686210 0.4322131
##sample estimates:
##  p 
##0.4 

#Conclusion: we are 99% confident that the actual proportion of subscribers who prefer an increase of local news lies between 0.3686210 and 0.4322131 (36% and 43%)


#EXAMPLE 2: one-sample z-test

#A company with 1000000 customers selects a simple random sample of 100 customers.
#This company believes that at least 80% of customers are satisfied with their service. But the proportion of satisfied customers in the sample is 73%.
#Null hypothesis: the true population proportion of satisfied customers is >= 0.8
#Alternative hypothesis: the true population proportion of satisfied customers is < 0.8 
#significance level: 0.05

prop.test(x=73,n=100,p=0.8,alternative="less",correct=F)

##> prop.test(x=73,n=100,p=0.8,alternative="less",correct=F)
##        1-sample proportions test without continuity correction
##data:  73 out of 100, null probability 0.8
##X-squared = 3.0625, df = 1, p-value = 0.04006
##alternative hypothesis: true p is less than 0.8
##95 percent confidence interval:
## 0.000000 0.796252
##sample estimates:
##   p 
##0.73

#the p-value is less than 0.05, so we reject the null hypothesis.
#Conclusion: our sample seems to suggest that the company's claim is false, so that the proportion of satisfied customers is <0.8.

#EXAMPLE 3: two sample z-test 

#A company develops a new drug to prevent colds. They claim that this drug is equally effective in men and women. 
#From 100000 volunteers, they select 100 women and 200 men, but 38% of the sampled women caught a cold (after taking the drug) and 51% of the sampled men caught a cold (after taking the drug).
#Null hypothesis: the proportion of total men catching a cold is equal to the proportion of total women catching a cold. 
#Alternative hypothesis: these proportions are not equal
#significance level: 0.05

prop.test(x=c(0.38 * 100, 0.51 * 200),n=c(100,200),alternative="two.sided",correct=F)

##> prop.test(x=c(0.38 * 100, 0.51 * 200),n=c(100,200),alternative="two.sided",correct=F)
##        2-sample test for equality of proportions without continuity
##        correction
##data:  c(0.38 * 100, 0.51 * 200) out of c(100, 200)
##X-squared = 4.5268, df = 1, p-value = 0.03337
##alternative hypothesis: two.sided
##95 percent confidence interval:
## -0.24768764 -0.01231236
##sample estimates:
##prop 1 prop 2 
##  0.38   0.51  

#the p-value is less than 0.05, so reject the null hypothesis.
#conclusion: the new drug is not equally effective in men and women.