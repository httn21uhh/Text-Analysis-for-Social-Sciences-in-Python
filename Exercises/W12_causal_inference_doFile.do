*Preliminaries
//Install packages  
ssc install bnormpdf



//Question 2: Bad controls
//a) 
clear 
cd "Put your working directory here"

use bm, clear 
//b) 
summarize call if black ==1
//c) 
summarize call if black ==0

//(d)
tab call black,col /*compare the lower rows together, difference is roughly 0.03 (3 percentage point)

//(e) 
reg call black 

//(f)
reg call black female

//(g)
reg call black female ofjobs computerskills education yearsexp

*To do 
*generate regression from potential outcomes. 
*generate second set of potential outcomes. Can you do this using the first set treatment? 
*Show that the causal effect in the population is different from the causal effect for the second set of potential outcomes 
*The second set of potential outcomes should take on discrete values. 




//Question 3: Connecting potential outcomes and regression. 

clear /*clear all data*/
set obs 500 /*set the number of observations*/
matrix V = (1, .4 \ .4, 1) /*generate a variance-covariance matrix for potential outcomes*/
matrix list V /*inspect the matrix*/
drawnorm Y0 Y1, means(2,3) cov(V) /*draw potential outcomes from a bivariate normal distribution*/
bnormpdf Y0 Y1, m1(2) m2(3) s1(1) s2(1) rho(.2) dens(Density) /*calculate the bivariate normal density at each of the potential outcome pairs*/
label variable Y0 "Potential Outcome without treatment" 
label variable Y1 "Potential Outcome with treatment" 
label variable Density "Probability Density for Potential Outcomes" 
graph twoway contourline Density Y0 Y1, title("Contour Map for the Potential Outcomes Density") levels(4) || scatteri 2 3 "Peak" 
/*Notes: 1. The contours depict a hill; 2. The largest share of persons in our population have potential outcomes of 2,3. Each point in the space represents a potential outcome pair. People in
the top right have high potential outcome in the state where they are
treated and in the state where they are not. People on the bottom right
or top left have a high potenial outcome in one state but a low potential
outcome in the other. People on the bottom left have low potential
outcomes in both states. In the context of our gender example, these
would be people who earn little regardless of whether they are male
or female. The contours represent the levels of a hill. The hill is the
density. The most people in the population are at the peak. */  




generate byte D=uniform()<=0.5 /*generate a dummy variable that tells us which potential outcome is observed*/
summarize Y0 /*basic summary statistics for the potential outcome without treatment*/
generate Y = r(mean) + (Y1 - Y0)*D + (Y0-r(mean)) /*generate the observed outcome*/
regress Y D /*regress the ``observed'' outcome on the ``treatment assignment'' dummy*/
generate Causal = Y1 - Y0 /*generate the causal effects for each of the individuals in our sample*/
summarize Y0 Causal /*compare the means with the estimates from our regressions. What do you notice? ANSWER: The estimated coefficient is similar to the mean for “Causal”. The
estimated intercept is similar to the mean for Y0. This is what we
would expect, given the potential outcomes framework.*/


//Question 4: Bad controls. 
generate W = D 
replace W = 1 if D==0&Y>3 /*create a group of people who always end up with W=1, no matter D*/
replace W = 0 if D==1&Y<2 /*create a group of people who always end up with W=0, no matter D*/
/*for the group that is left over, W changes in response to the treatment*/
regress Y D W /*compare coefficient on D with the coefficient in the regression without W. LESSON: Outcomes as controls can generate misleading estimates of the treatment effect on Y*/






