#required libraries

library(stringr)
library(plyr)
library(lubridate)
library(randomForest)
library(reshape2)
library(ggplot2)

#read file and have a look

df <- read.csv(file="~/LoanStats3a.csv", header = TRUE, stringsAsFactors=FALSE, skip = 1)
head(df)

#too many columns with NA, delete those having at least 80% NA’s
poor_coverage <- sapply(df, function(x){
   coverage <- 1-sum(is.na(x))/length(x)
   coverage < 0.8}
)

df <- df[,poor_coverage==FALSE]

#now get rid of columns that I consider not important 

df[,'desc']<-NULL
df[,'url']<- NULL
df[,'zip_code']<-NULL
df[,'addr_state']<-NULL
df[,'purpose']<-NULL
df[,'member_id']<- NULL
df[,'title']<-NULL
#check again
head(df)
#check loan_status values

unique(df$loan_status)

#decide bad indicators and create new column indicating this (1 is bad, 0 is not bad)

bad_indicators <- c("Late (16-30 days)", "Late (31-120 days)", "Default", "Charged Off", "Does not meet the credit policy. Status:Charged Off")
df$is_bad <- ifelse(df$loan_status %in% bad_indicators, 1, ifelse(df$loan_status=="", NA, 0))

#check again
head(df) 

#BEFORE CONTINUE, WE TRY LOGISTIC REGRESSION USING 'annual_inc', 'inq_last_6mths' and 'is_bad'.

ldf <- df[,c('id','annual_inc','inq_last_6mths','is_bad')]
ldf
#choose random sample of size 50
ldf1 <- ldf[sample(nrow(ldf), size=50,replace=FALSE, prob=NULL),]
ldf1

#we want the probability that a person will fail to pay back a loan (1) given their income and number of inquiries in the last 6 months

#start model

model <- glm(is_bad ~ annual_inc + inq_last_6mths, data=ldf1, family=binomial)
model

#the model is logit(pi) = -5.9 + -1.1 * annual_inc + 5.2 * inq_last_6mths where pi is the probability of getting 1 

#construct a reduced model for some reason

model.reduced <- glm(is_bad ~ 1, data=ldf1, family = binomial)

model.reduced

#now use anova for some reason

anova(model.reduced, model, test="Chisq")

#now what?

summary(model)

# perform tests on each individual regression parameter ('annual_inc' and 'inq_last_6mths')

#from the summary, we conclude two things:

#if we set a significance level equal to 0.05, then from summary(model) we get
#that 

pi.hat = predict.glm(model, data.frame(annual_inc = 10560.00, inq_last_6mths = 8), type = "response", se.fit=TRUE)
pi.hat$fit



