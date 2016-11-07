#import pandas
#1
import pandas as pd
#import numpy
#2
import numpy as np

# I replaced dtype=str by low_memory=False to keep types as done in R
#3
df = pd.read_csv(r"C:\Users\Alcatraz\Documents\LoanStats3a.csv", low_memory=False, skiprows=0, header=1)

#have a look

df.head()

#how many rows and columns?
df.shape
#check the types to be correct
df.dtypes

#Now I find how many NA's are for each column
df.isnull().sum(axis=0)

#now I will drop those columns having at least 80% of NaN values
filt = df.isnull().sum()/len(df) < 0.8
df = df.loc[:, filt]

#check NaN's again

df.isnull().sum(axis=0)

df.shape

#get rid of columns that I consider not important for random forest analysis

df=df.drop(['desc','url','zip_code','addr_state','purpose','member_id','title'],1)

df.shape        

#Now the objective is create a nuew column based on labels that we consider bad indicators.

#first check its distinct values,
#then check number of nan's and then apply function        
df['loan_status'].unique()
df['loan_status'].isnull().sum()

#now substitute NA'S by 0's in the same column. 
df['loan_status']=df['loan_status'].fillna(0)

#Now I create a dataframe to store the labels (which belong to the status column)
# indicating bad status, 1 means bad, 0 means good
is_bad = []

for i in df['loan_status']: 
    is_bad.append(1 if i in ['Late (16-30 days)', 'Late (31-130 days)', 'Default', 'Charged Off','Does not meet the credit policy. Status:Charged Off'] else 0)
print(is_bad)


#now I will add the dataframe is_bad to my dataframe df

df['is_bad'] = is_bad

df['is_bad'].unique()

#view inside
df.ix[:,25:40].head()

# The column 'revol_util' should be numeric but it has a percentage symbol,
df['revol_util'].unique()

#so I remove them. The symbol % is on the right, so to remove them we
#use rstrip

df['revol_util']=df['revol_util'].str.rstrip('%')

#have a look at the result

df['revol_util'].head()

#now convert 'revol_util' to numeric as desired

df['revol_util']=pd.to_numeric(df['revol_util'])

#same procedure with 'int_rate'
df['int_rate'].unique()
df['int_rate']=df['int_rate'].str.rstrip('%')
df['int_rate'].head()
df['int_rate']=pd.to_numeric(df['int_rate'])

#now I check the types of df again to see the type of 'issue_d'. If it's
#not date, I have to convert it.

df.dtypes

#it's object, so convert it to date

df['issue_d']=pd.to_datetime(df['issue_d'],format="%b-%Y")        

#check the converted type

df.dtypes

#it's fine, now extract the month and the year as distinct (new) columns

df['month_issued']=df['issue_d'].dt.month

df['year_issued']=df['issue_d'].dt.year

df.head()
#paso problemas
from sklearn import preprocessing
le = preprocessing.LabelEncoder()

df['grade'].unique()
le.fit(df['grade'])
df['grade']=le.transform(df['grade'])
df['grade'].unique()

le.fit(df['sub_grade'])
df['subgrade']=le.transform(df['sub_grade'])
df['sub_grade'].unique()

df['sub_grade'].unique()
df['term'].unique()
df['emp_length'].unique()
df['home_ownership'].unique()

df.ix[:, 0:15].head()
df.ix[:,15:30].head()
df.ix[:, 30:].head()
#convert to date the remaining columns which require it

df['earliest_cr_line']=pd.to_datetime(df['earliest_cr_line'],format="%b-%Y")
#the next shows an error but I don't know why
df['next_pymnt_d']=pd.to_datetime(df['next_pymnt_d'],format="%b-%Y")

#remaining ones
df['last_pymnt_d']=pd.to_datetime(df['last_pymnt_d'],format="%b-%Y")
df['last_credit_pull_d']=pd.to_datetime(df['last_credit_pull_d'],format="%b-%Y")

#check again
df.dtypes

#Now I want to imitate the following code in R
#outcomes<- ddply(df, .('year_issued','month_issued'), function(x):
#{c("percent_bad"=sum(x$is_bad)/nrow(x), "n_loans"=nrow(x))})
#this code yields a dataframe with four features
# I think x$is_bad refers to the subset of the column is_bad corresponding
#to the grouping in year-month (for example, for year 2014, month 2, 
#I think x$is_df will consider the number of applicants in year 2014, month
#2). 

####################################

# the following is, I hope, the equivalent of ddply(df,.('year_issued',
#'month_issued'), function(x){sum(x$is_bad)}), i.e., computing and show
#in a dataframe the number of bad loans (1's) for each year-month group, for example 2014, month 1

df_1  = pd.DataFrame(df.groupby(['year_issued','month_issued'])['is_bad'].sum())
print(df_1)

#The following is, I hope, the equivalent of ddply(df,.('year_issued',
#'month_issued'),function(x):nrow(x)), i.e. counting how many applicants
#are for each grouping year-month
df_2 = pd.DataFrame(df.groupby(['year_issued','month_issued'])['is_bad'].count())
print(df_2)

#I will get the column names from df_1 and df_2
list(df_1.columns.values)
list(df_2.columns.values)

#Now I will join df_1 and df_2 into a single dataframe 
df_3=pd.concat([df_1,df_2],axis=1)
print(df_3)

#change name of columns because they're the same
df_3.columns=['yes_is_bad','n_loans_is_bad']
print(df_3)

#Now I create the dataframe obtained by dividing 'yes_is_bad' by 'n_loans_is_bad'
df_4=pd.DataFrame(df_3['yes_is_bad']/df_3['n_loans_is_bad'])
print(df_4)

#put name to the unique column of df_4
df_4.columns=['percentage_bad']

#Finally I can create outcomes by joining df_4 and df_3['n_loans_is_bad']

df_5=pd.DataFrame(df_3['n_loans_is_bad'])
print(df_5)

df_5.columns=['n_loans']

outcomes = pd.concat([df_4,df_5],axis=1)
print(outcomes)

#warning:it does not coincide with the outcomes in R 

#get columns of outcomes
list(outcomes.columns.values)



#now plot outcomes, the graph is similar to the one in R

outcomes.plot(kind='line', y='percentage_bad',title = "Bad Rate" )

#the plot obtained before is similar to the one in R though..,

#also the previous plot intuitevely tells me that the percentage of bad applicants increases as the time is passing

###########################################################

#delete extra useless columns
#paso
df['issue_d'].unique()
df['application_type'].unique()
df = df.drop(['id','emp_title','application_type'],1)
df['verification_status'].unique()
df['pymnt_plan'].unique()
df['initial_list_status'].unique()
df =df.drop(['verification_status','pymnt_plan','initial_list_status'],1)

#have a look again
df.shape
df.ix[:,0:5].head()
df.ix[:,5:25].head()
df.ix[:,25:35].head()
df.ix[:,35:44].head()

# the next is to check which columns are numeric
list(df.select_dtypes(include=[np.number]).columns.values)

#paso
numeric_cols = df._get_numeric_data()

#check numeric_cols dataframe and its types
numeric_cols.head()
numeric_cols.dtypes

#Now use melt function with respect to 'is_bad'
#paso
df_lng = pd.melt(numeric_cols,id_vars ='is_bad')

#have a look

df_lng.head()

df_lng.ix[20:100,0:3]
df_lng.ix[100000:100050,0:3]

#note that there are two new columns: 'variable' and 'value'.
#I will count how many rows in those columns are, and the unique values in list form 
df_lng['variable'].count()
df_lng['value'].count()
df_lng['variable'].unique()
df_lng['value'].unique()

#count nan's in df_lng
df_lng.isnull().sum()
#paso
df_lng1 = df_lng.dropna(axis=0)
df_lng1 = df_lng1.reset_index(drop=True)
df_lng1.isnull().sum()

#now plot as density to check distribution and hence which features (variables) have a big difference
#between the good and bad applicants

#I think ggplot is already imported, so from ggplot import * yields a warning
#No, I actually have to import it
import ggplot
from ggplot import *

#problems here

p=ggplot(aes(x='value', group='is_bad',color='is_bad'), data=df_lng)
p + geom_density()+ facet_wrap('variable')

#convert the column 'home_ownership' into categorical
df['home_ownership']= pd.Series(df['home_ownership']).astype("category")

df.dtypes

#define a new column for df consisting of False or True according to
#whether 'home_ownership' is 'RENT' or not

df['is_rent']=pd.DataFrame(df.home_ownership =='RENT')
print(df['is_rent'])

#so basically I need to choose a few features from the plots and a few from
#the non-numeric features. For the latter, I only choose the rent one and 
#adjoined it as a column


#now define train and test using train_test_split
#paso
import sklearn
from sklearn import cross_validation
from sklearn.cross_validation import train_test_split
#
data=df[['pub_rec_bankruptcies','revol_util','inq_last_6mths','is_rent']]
labels=df['is_bad']
data_train, data_test, labels_train, label_test = train_test_split(data, labels, test_size=0.75, random_state=len(df))

#paso provisional
numeric_cols.isnull().sum()
df2 = numeric_cols.dropna(axis=0)
df_numeric=df2.reset_index(drop=True)
data= df_numeric.drop(['is_bad'],axis=1)
labels=df_numeric['is_bad']
data_train, data_test, labels_train, labels_test = train_test_split(data, labels, test_size=0.75, random_state=len(numeric_cols))

#now apply randomforestclassifier
#paso
from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier()

#problem now "Input contains NaN, infinity or a value too large for dtype('float32')."
#paso
rf.fit(data_train, labels_train)

#to solve nan's problem "Input contains NaN, infinity or a value too large for dtype('float32')."
from sklearn.preprocessing import Imputer

data_train=Imputer().fit_transform(data_train)
data_test=Imputer().fit_transform(data_train)

#now try again .fit

rf.fit(data_train, labels_train)
#now this is it
data.head()
data.ix[:,9:25].head()
data.ix[:,25:].head()
list(df_numeric.columns.names)
#paso
d = {'loan_amnt':[1234.5],'funded_amnt':[1233.2],'funded_amnt_inv':[1236.7],'int_rate':[11.2],'installment':[50.0],'annual_inc':[20345.5],'dti':[18.7],'delinq_2yrs':[6.0], 'inq_last_6mths':[5.0], 'mths_since_last_delinq':[3.0],'open_acc':[3.0], 'pub_rec':[1.0], 'revol_bal':[3245.0], 'revol_util':[21.7], 'total_acc':[17.0], 'out_prncp':[117.9], 'out_prncp_inv':[116.8], 'total_pymnt':[6534.7], 'total_pymnt_inv':[2354.7], 'total_rec_prncp':[4876.9], 'total_rec_int':[7000.0], 'total_rec_late_fee':[0.0] , 'recoveries':[234.7], 'collection_recovery_fee':[0.0], 'last_pymnt_amnt':[345.8], 'collections_12_mths_ex_med':[0.0], 'policy_code':[1.0], 'acc_now_delinq':[0.0], 'chargeoff_within_12_mths':[0.0], 'delinq_amnt':[0.0], 'pub_rec_bankruptcies':[0.0], 'tax_liens':[0.0]}
new_applicant = pd.DataFrame(d)
good_or_bad = rf.predict(new_applicant)
good_or_bad

#test my data
#paso
from sklearn.metrics import accuracy_score
good_or_bad_prediction = rf.predict(data_test)
good_or_bad_prediction
labels_test
accuracy_score(labels_test, good_or_bad_prediction)


print(final_result)
#now, if I want to predict something, I need to input the sample in rf.predict(sample) to know if the loan application is good or bad

