%the task is to learn which Reuters articles are about "corporate acquisitions". 
% (http://svmlight.joachims.org/).  The training set contains 610 examples, with only 10 labeled, 
% and in the test examples there are 600 ex amples 300 positives an 300 negatives. 
% Each of the examples with 9947 possible features. 
load sista0705.mat%loading the file of reuters
C=9947;%setting with the same number of features the C
Ctest=12334;
epsilon=0.001;%given the scale to compare the equality
type_nummer=0;%Linear Kernel
par=[];%Without parameters
Ytest=[];
numPlus=704;%numplus is setting to the half of the test samples
%solTsvm=tsvm(X,Y,Xtest,C,Ctest,numPlus,epsilon,type_nummer,par)%call the function
t = cputime;
solTsvm=tsvmR(X,Y,Xtest,C,Ctest,numPlus,epsilon,type_nummer,par);
time=cputime-t;
fprintf('The training needed %d',time),fprintf(' seconds.\n');
% I employ the training set to generate the model and to evaluate the test set. 
% (That is the hard job) After of compare the results with the SVM light (http://svmlight.joachims.org/) 
% my algorithm perform well and produce almost the same results that the SVM light program. 
% With only 22 errors over 600 examples (3.66 % errors) that is with a 96.33% of accuracy.

