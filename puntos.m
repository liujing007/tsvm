function solTsvm=puntos(C,Ctest)
load probe.mat
solTsvm=cosa(X,Y,Xtest,Ytest,C,Ctest,numPlus,epsilon,type_nummer,par);
time=cputime-t;
fprintf('The training needed %d',time),fprintf(' seconds.\n');

