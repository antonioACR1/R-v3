PART 0: Preparing data

#libraries to be used:

#for str_replace_all()
library(stringr)

#for as.yearmon()
library(zoo)

#for random forest classifier
library(randomForest)

#for melt()
library(reshape2)

#for ggplot()
library(ggplot2)


#read and analyze
df <- read.csv(file="~/LoanStats3a.csv", header = TRUE, stringsAsFactors=FALSE, skip = 1)
str(df)

#have a look

head(df)

#get rid of columns that I consider not important 

df[,'desc']<-NULL
df[,'url']<- NULL
df[,'zip_code']<-NULL
df[,'addr_state']<-NULL
df[,'purpose']<-NULL
df[,'member_id']<- NULL
df[,'title']<-NULL
#check again
head(df)

#many columns have too many NA's, delete those having more than 80% of NA's

poor_coverage <- sapply(df, function(x){
   coverage <- 1-sum(is.na(x))/length(x)
   coverage < 0.8}
)

df <- df[,poor_coverage==FALSE]

#have a look

head(df)
#looks better

#now decide bad indicators and create new column indicating this (1 is bad, 0 is not bad)

unique(df$loan_status)

##> unique(df$loan_status)
## [1] "Fully Paid"                                         
## [2] "Charged Off"                                        
## [3] "Current"                                            
## [4] "In Grace Period"                                    
## [5] "Late (16-30 days)"                                  
## [6] "Late (31-120 days)"                                 
## [7] "Default"                                            
## [8] ""                                                   
## [9] "Does not meet the credit policy. Status:Fully Paid" 
##[10] "Does not meet the credit policy. Status:Charged Off"

#these are the bad indicators
bad_indicators <- c("Late (16-30 days)", "Late (31-120 days)", "Default", "Charged Off", "Does not meet the credit policy. Status:Charged Off")
#create column
df$is_bad <- ifelse(df$loan_status %in% bad_indicators, 1, ifelse(df$loan_status=="", NA, 0))

#check new column
head(df$is_bad)

##> head(df$is_bad)
##[1] 0 1 0 0 0 0

head(df)

#the columns 'int_rate' and 'revol_util' have percentage symbols. Delete those symbols and then convert to numeric

df$revol_util <- str_replace_all(df$revol_util, "[%]", "")
df$revol_util <- as.numeric(df$revol_util)

df$int_rate <- str_replace_all(df$int_rate, "[%]", "")
df$int_rate <- as.numeric(df$int_rate, "[%]", "")

#check types to see our changes

str(df)

#note that the columns 'issue_d','earliest_cr_line','last_pymnt_d','next_pymnt_d' and 'last_credit_pull_d' are dates but they are not in date format. Change their type to date. 
#To deal with the problem of locale system date format, use the following code first

Sys.setlocale("LC_TIME", "C")

#now proceed
df$issue_d <- as.yearmon(df$issue_d, format = "%b-%Y")
df$earliest_cr_line <- as.yearmon(df$earliest_cr_line, format = "%b-%Y")
df$last_pymnt_d <- as.yearmon(df$last_pymnt_d, format = "%b-%Y")
df$next_pymnt_d <- as.yearmon(df$next_pymnt_d, format = "%b-%Y")
df$last_credit_pull_d <- as.yearmon(df$last_credit_pull_d, format = "%b-%Y")

#have a look again
str(df)
#ok!

head(df)


#delete further columns that I consider irrelevant

df[,'id'] <- NULL

#is the column 'application_type' important?
unique(df$application_type)
#only one value, so no
df[,'application_type']<-NULL

df[,'emp_title']<-NULL
df[,'term']<-NULL

#is the column 'initial_list_status' important?
unique(df$initial_list_status)
#only one value, so no
df[,'initial_list_status']<-NULL

#loan_status is not useful anymore
df[,'loan_status']<-NULL

head(df)

#In order to do extra analysis, I will filter those numeric columns and plot them against the column 'is_bad'. 
#Each plot will correspond to each numeric column. Also, each plot will show two curves, blue and red.
#If the two curves are significantly different then it means that the numeric column corresponding to that plot is relevant for our analysis.

#now, check types one more time
str(df)


#subset the numeric columns and apply melt(). The 'id' parameter of the function melt() will be the column 'is_bad'.

numeric_cols <- sapply(df, is.numeric)

head(numeric_cols)

df.lng <- melt(df[,numeric_cols], id="is_bad")
head(df.lng)

#now use density plots to check probability distribution and hence which features show a significant impact on the value 1 (bad applicant) and which features show a significant impact on the value 0 (good applicants).

p <- ggplot(aes(x=value, group=is_bad, colour=factor(is_bad)), data=df.lng)

p + geom_density() + facet_wrap(~variable, scales="free")


#from these plots I decided to delete those features showing no significant difference between 1's and 0's

df[,'loan_amnt']<-NULL
df[,'funded_amnt']<-NULL
df[,'funded_amnt_inv']<-NULL
df[,'int_rate']<-NULL
df[,'installment']<-NULL
df[,'annual_inc']<-NULL
df[,'dti']<-NULL
df[,'open_acc']<-NULL
df[,'revol_bal']<-NULL
df[,'revol_util']<-NULL
df[,'total_acc']<-NULL
df[,'total_rec_int']<-NULL
df[,'collections_12_mths_ex_med']<-NULL
df[,'policy_code']<-NULL
df[,'chargeoff_within_12_mths']<-NULL

#There are 16 remaining numeric columns which seem to be important.
#After some thinking, I decided to use the following columns for my analysis:
#'delinq_2yrs','inq_last_6mths','pub_rec','' and 'pub_rec_bankruptcies' 

#now delete the remaining numeric columns

df[,'out_prncp']<-NULL  
df[,'out_prncp_inv']<-NULL          
df[,'total_pymnt']<-NULL  
df[,'total_pymnt_inv']<-NULL        
df[,'total_rec_prncp']<-NULL      
df[,'total_rec_late_fee']<-NULL     
df[,'recoveries']<-NULL             
df[,'collection_recovery_fee']<-NULL
df[,'last_pymnt_amnt']<-NULL        
df[,'acc_now_delinq']<-NULL         
df[,'delinq_amnt']<-NULL          
df[,'tax_liens']<-NULL 


#have a look
head(df)

#now analyze the non-numeric columns

numeric_cols[numeric_cols==FALSE]
##> numeric_cols[numeric_cols==FALSE]
##              grade           sub_grade          emp_length      home_ownership 
##              FALSE               FALSE               FALSE               FALSE 
##verification_status             issue_d          pymnt_plan    earliest_cr_line 
##              FALSE               FALSE               FALSE               FALSE 
##       last_pymnt_d        next_pymnt_d  last_credit_pull_d 
##              FALSE               FALSE               FALSE 

#after some thinking, I decide that the non-numeric features 'grade', 'sub_grade', 'emp_length' are not significant for my analysis
df[,'grade']<-NULL
df[,'sub_grade']<-NULL
df[,'emp_length'] <-NULL

#home ownership is important, so convert to factor (in random forest, categorical variables should be converted to factor)
df$home_ownership <- factor(df$home_ownership)

#verification_status doesn't seem to be relevant for my analysis
df[,'verification_status']<-NULL

#payment plan doesn't seem to be relevant either
df[,'pymnt_plan']<-NULL

#now I check how many distinct unique values each date column has

length(unique(df$issue_d))
##> length(unique(df$issue_d))
##[1] 56
#I can't use this column as given because I want to apply random forest in R, however the maximum number of distinct unique values in a column should be 32
#so I remove this column
df[,'issue_d']<-NULL

#repeat the same procedure with the remaining date columns

length(unique(df$last_pymnt_d))
##> length(unique(df$last_pymnt_d))
##[1] 106
df[,'last_pymnt_d']<-NULL


length(unique(df$next_pymnt_d))
##> length(unique(df$next_pymnt_d))
##[1] 103
df[,'next_pymnt_d']<-NULL


length(unique(df$last_credit_pull_d))
##> length(unique(df$last_credit_pull_d))
##[1] 111
df[,'last_credit_pull_d']<-NULL

df[,'earliest_cr_line']<-NULL
length(unique(df$earliest_cr_line))
##> length(unique(df$earliest_cr_line))
##[1] 531
df[,'earliest_cr_line']<-NULL

#finally, is_bad is a categorical variable, so convert it to factor for my analysis
df$is_bad <- factor(df$is_bad)

#we finished the preparation of our data

PART 1: Applying random forest
#have a look
head(df)
##> head(df)
##  home_ownership delinq_2yrs inq_last_6mths pub_rec pub_rec_bankruptcies is_bad
##1           RENT           0              1       0                    0      0
##2           RENT           0              5       0                    0      1
##3           RENT           0              2       0                    0      0
##4           RENT           0              1       0                    0      0
##5           RENT           0              0       0                    0      0
##6           RENT           0              3       0                    0      0
#check types

str(df)
##> str(df)
##'data.frame':   42538 obs. of  6 variables:
## $ home_ownership      : Factor w/ 6 levels "","MORTGAGE",..: 6 6 6 6 6 6 6 6 5 6 ...
## $ delinq_2yrs         : int  0 0 0 0 0 0 0 0 0 0 ...
## $ inq_last_6mths      : int  1 5 2 1 0 3 1 2 2 0 ...
## $ pub_rec             : int  0 0 0 0 0 0 0 0 0 0 ...
## $ pub_rec_bankruptcies: int  0 0 0 0 0 0 0 0 0 0 ...
## $ is_bad              : Factor w/ 2 levels "0","1": 1 2 1 1 1 1 1 1 2 2 ...


#now create train and test datasets

idx <- runif(nrow(df))>0.75
train <- df[idx==FALSE,]
test <- df[idx==TRUE,]

#check training set
head(train)
##> head(train)
##  home_ownership delinq_2yrs inq_last_6mths pub_rec pub_rec_bankruptcies is_bad
##1           RENT           0              1       0                    0      0
##3           RENT           0              2       0                    0      0
##4           RENT           0              1       0                    0      0
##5           RENT           0              0       0                    0      0
##6           RENT           0              3       0                    0      0
##7           RENT           0              1       0                    0      0

#copy and then remove the 'is_bad' column from testing set and have a look
actual <- test$is_bad
test[,'is_bad']<-NULL

head(test)
##> head(test)
##   home_ownership delinq_2yrs inq_last_6mths pub_rec pub_rec_bankruptcies
##2            RENT           0              5       0                    0
##13           RENT           0              1       0                    0
##20           RENT           0              0       0                    0
##22           RENT           0              0       0                    0
##25           RENT           0              1       0                    0
##29       MORTGAGE           1              0       0                    0

#now apply random forest mode using the train data and evaluating 'is_bad' as response variable

rf <- randomForest(is_bad ~ home_ownership + delinq_2yrs + inq_last_6mths + pub_rec + pub_rec_bankruptcies, type="classification", data=train, importance=TRUE, na.action=na.omit, n.trees=1500)
rf
#now let's predict the testing set

predictions <- predict(rf, test)

#compare our predictions with the actual values

verify <- data.frame(predictions, actual)
colnames(verify) <- c('predicted value', 'actual value')

head(verify)

##> head(verify)
##  predicted value actual value
##1               0            1
##2               0            1
##3               0            0
##4               0            1
##5               0            1
##6               0            0

#the following list will tell me which predictions are correct and which ones are wrong
results <- ifelse(verify[,'predicted value'] == verify[,'actual value'],'correct','wrong')
#how many are correct and how many are wrong?
table(results)
##> table(results)
##results
##correct   wrong 
##   8864    1505

#I predicted correctly many of the samples in the testing set.
#However, in those which I didn't predict correctly I predicted many bad applicants as good. This is not good :)

incorrectly.predicted.as.good <- ifelse(verify[,'predicted value'] == 0 & verify[,'actual value'] == 1,1,0)
table(incorrectly.predicted.as.good)

##> table(incorrectly.predicted.as.good)
##incorrectly.predicted.as.good
##   0    1 
##9136 1500 

#So from the 1505 predicted incorrectly, there are 1500 predicted as good applicants but in fact they are bad.

#I should improve my model to solve this issue.

#To be continued...

 


