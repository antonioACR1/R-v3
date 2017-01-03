
#EXAMPLE 1: Chi-square test for independence

#the following code gives a contingency table showing a sample of 400 men and 600 women and how many of them voted for Republican, Democrat and Independent, respectively

df1 <- data.frame(cbind(c(200,250),c(150,300),c(50,50)))
colnames(df1) <- c("Republican","Democrat","Independent")
row.names(df1) <- c("Male","Female")

##> df1
##       Republican Democrat Independent
##Male          200      150          50
##Female        250      300          50

#Null hypothesis: Gender and voting preferences are independent variables
#Alternative hypothesis: these variables are dependent
#significance level: 0.05

chisq.test(df1)

##> chisq.test(df1)
##        Pearson's Chi-squared test
##data:  df1
##X-squared = 16.204, df = 2, p-value = 0.000303

#the p-value is less than 0.05, so reject null hypothesis
#conclusion: there is a relationship between gender and voting preferences



#EXAMPLE 2: Chi-square test for goodness of fit

#A company prints baseball cards of three types: rookies, veterans and all-stars. 
#They don't keep count of how many card of each type they produce, but they claim that 30% are rookies, 60% are veterans and 10% are all-stars.
#They select a simple random sample of size 100. There are 50 rookies, 45 veterans and 5 all-stars.

#null hypothesis: the proportion of rookies, veterans and all-stars cards is 0.3,0.6 and 0.1, respectively
#alternative hypothesis: at least one of the proportions is not true
#significance level: 0.05

#these are the number of rookies, veterans and all-stars cards in the sample of size 100
sample.probabilities <- c(50,45,5)

#these are the claimed probabilities by the company
expected.probabilities <- c(0.30,0.60,0.10)

#apply chi-square test
chisq.test(x=sample.probabilities, p=expected.probabilities)

##> chisq.test(x=sample.probabilities, p=expected.probabilities)
##        Chi-squared test for given probabilities
##data:  sample.probabilities
##X-squared = 19.583, df = 2, p-value = 5.592e-05

#the p-value is less than 0.05, so reject the null hypothesis
#conclusion: the company's claim is not true






