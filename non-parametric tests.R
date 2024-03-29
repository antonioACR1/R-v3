#EXAMPLE 1: Mann Whitney U test (Wilcoxon rank sum test)

#A hospital applies a new drug to reduce symptoms of asthma in children. They select a simple random sample of size 10.
#The new drug is given to 5 children, and the other 5 children are used as placebo effect (they are part of the study, but no drug is given to them in order to see their reaction as consequence of only participating in the experiment)
#The following table shows the number of episodes of shortness of breath after applying the new drug in the first group, and the corresponding number in the second group where the drug is not provided.

df <- data.frame(cbind(c(7,5,6,4,12),c(3,6,4,2,1)))
colnames(df)=c('placebo','new_drug')
df
##> df
##  placebo new_drug
##1       7        3
##2       5        6
##3       6        4
##4       4        2
##5      12        1

#is the new drug really effective?

#null hypothesis: the two populations (the population taking the drug and the population without the drug) are equal. In other words, the drug shows no significance difference between both groups
#alternative hypothesis: the two populations are not equal. 
#signficance level

#apply Mann Whitney U test
wilcox.test(df$new_drug,df$placebo, correct=TRUE)
##> wilcox.test(df$new_drug,df$placebo, correct=TRUE)
##        Wilcoxon rank sum test with continuity correction
##data:  df$new_drug and df$placebo
##W = 3, p-value = 0.05855
##alternative hypothesis: true location shift is not equal to 0
##Warning message:
##In wilcox.test.default(df$new_drug, df$placebo, correct = TRUE) :
##  cannot compute exact p-value with ties

#the p-value is greater than 0.05, so do not reject the null hypothesis
#conclusion: apparently there is no difference between the population taking the drug and the population without it. The drug is probably not efficient. 
#The sample shows a differene bewteen the two samples, but the sample size is probably too small to determine whether or not this difference is statistically significant

#Another way:

#the test statistic is the minimum value W obtained from the following tests
wilcox.test(df$new_drug,df$placebo)
##> wilcox.test(df$new_drug,df$placebo)
##        Wilcoxon rank sum test with continuity correction
##data:  df$new_drug and df$placebo
##W = 3, p-value = 0.05855
##alternative hypothesis: true location shift is not equal to 0
##Warning message:
##In wilcox.test.default(df$new_drug, df$placebo) :
##  cannot compute exact p-value with ties
#here W=3

wilcox.test(df$placebo,df$new_drug)
##> wilcox.test(df$placebo,df$new_drug)
##        Wilcoxon rank sum test with continuity correction
##data:  df$placebo and df$new_drug
##W = 22, p-value = 0.05855
##alternative hypothesis: true location shift is not equal to 0
##Warning message:
##In wilcox.test.default(df$placebo, df$new_drug) :
##  cannot compute exact p-value with ties
#here W=22

#therefore, the minimum value W is W=3. This is the test statistic

#the critical value is obtained by using qwilcox(), the sample sizes of my two groups and the fact that I'm using two-tailed test
qwilcox(0.05/2,n=5,m=5)
##> qwilcox(0.05/2,n=5,m=5)
##[1] 3

#important: the critical value is obtained by substracting 1 to my result
#therefore, the critical value is 3-1=2
#check http://ocw.umb.edu/psychology/psych-270/other-materials/RelativeResourceManager.pdf

#rule: if the critical value test statistic is < the critical value, then reject the null hypothesis, otherwise do not reject the null hypothesis
#in my case, W=3 > critical value=2, so do not reject the null hypothesis
#we get the same conclusion as before

#EXAMPLE 2: Kruskal-Wallis test

#there are three protein diets applied to 3,5 and 4 persons, respectively
#the albumim levels of each person are measured after applying the protein. The following code shows this information:

g1 <- c(3.1,2.6,2.9)
g2 <- c(3.8,4.1,2.9,3.4,4.2)
g3 <- c(4.0,5.5,5.0,4.8)

dati <- list(five.percent.protein=g1, ten.percent.protein=g2, fifteen.percent.protein=g3)

##> dati
##$five.percent.protein
##[1] 3.1 2.6 2.9
##$ten.percent.protein
##[1] 3.8 4.1 2.9 3.4 4.2
##$fifteen.percent.protein
##[1] 4.0 5.5 5.0 4.8

#null hypothesis: the albumim levels are equal among the three groups, no matter which protein diet is used
#alternative hypothesis: the albumim level are not equal among the three groups, so the specific diet is important
#significance level: 0.05

kruskal.test(dati)
##> kruskal.test(dati)
##        Kruskal-Wallis rank sum test
##data:  dati
##Kruskal-Wallis chi-squared = 7.5495, df = 2, p-value = 0.02294

#the p-value is less than 0.05, so reject the null hypothesis
#conclusion: the albumim levels aro not equal among the three groups

#another way to conclude is given as follows

#the degrees of freedom is 2, the significance level is 0.05, so the critical value is:

qchisq(0.95,2)

##> qchisq(0.95,2)
##[1] 5.991465

#the critical value is less than the test statistic (7.5495), so reject the null hypothesis and conclude as before
