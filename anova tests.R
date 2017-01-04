
#EXAMPLE 1: one-factor ANOVA 

#A hospital applies four diet plans (low calorie diet, low fat diet, low carbohydrate diet and a normal diet which is used as placebo effect) to 20 volunteers. Each diet is applied to 5 volunteers.
#The difference of weights before applying the diet and after the end of applying the diet is stored in the following table (positive difference means weight loss, and negative difference means weight gain).

low_calorie <- c(8,9,6,7,3)
low_fat<-c(2,4,3,5,1)
low_carbohydrate<-c(3,5,4,2,3)
control<-c(2,2,-1,0,3)

df <-data.frame(cbind(low_calorie,low_fat,low_carbohydrate,control))


##> df
##  low_calorie low_fat low_carbohydrate control
##1           8       2                3       2
##2           9       4                5       2
##3           6       3                4      -1
##4           7       5                2       0
##5           3       1                3       3

#is there a significant difference bewteen the mean weight loss among the four groups?

#I want to apply one-factor ANOVA to answer my question. 
#Before this, use Bartlett's test. This is a test to check homogeneity of variances which is required to apply ANOVA analysis 

datos <- c(low_calorie,low_fat,low_carbohydrate,control)
##> datos
## [1]  8  9  6  7  3  2  4  3  5  1  3  5  4  2  3  2  2 -1  0  3

groups <- factor(rep(letters[1:4],each=5))
##> groups
## [1] a a a a a b b b b b c c c c c d d d d d
##Levels: a b c d

bartlett.test(datos,groups)

##> bartlett.test(datos,groups)
##        Bartlett test of homogeneity of variances
##data:  datos and groups
##Bartlett's K-squared = 1.7664, df = 3, p-value = 0.6223

#null hypothesis: the variances of all the groups are equal
#alternative hypothesis: the variances of all the groups are not equal
#significance level:0.05

#the p-value is greater than 0.05, so reject the null hypothesis
#conclusion: the variances of all my groups are equal


#now apply anova()

model <- lm(datos ~ groups)
anova(model)

##> anova(model)
##Analysis of Variance Table
##Response: datos
##          Df Sum Sq Mean Sq F value   Pr(>F)   
##groups     3  75.75   25.25  8.5593 0.001278 **
##Residuals 16  47.20    2.95                    
##---
##Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#null hypothesis: the means of the groups are equal
#alternative hypothesis: the means of the groups are not equal
#significance level:0.05

#the p-value is less than 0.05, so rejet null hypothesis
#conclusion: there is a difference between the mean weight loss among the four diets



