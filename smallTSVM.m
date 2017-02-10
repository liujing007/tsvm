function sol=smallTsvm(C,Ctest)
%clear all;

fprintf('Support Vector Classification\n')
fprintf('_____________________________\n')



fig=1;

% Making X and Y
% %*******************
if 1
    N=1000;
    %load dataset.mat
    sol=classification_dataset(N,'jorge');
    X=sol{1,1};
    Y=sol{1,2};
    Xtest=sol{1,3};
    Ytest=sol{1,4};
    gam=sol{1,5};
    %sigma=sol{1,6};
    sigma=50;%If the sigma very small this lead to overfitting
end
 
% Dimension of the invoer:
 %************************
 [d N]=size(X);%rows and Columns

% Parameters
%************
% Type of kernels: linear, polynomial, , gaussian_rbf, 
%type='linear';
type='gaussian_rbf';
%type='exponential_rbf';

fprintf('Type of kernel %s \n',type)

epsilon=1e-20;%precision numerica de la maquina (aqui n o puede)


% Penalty factor for missclassification:
%C=C;

% Penalty factor for missclassification, to the Test examples
%Ctest=Ctest;



%Number of Positive examples
idy=find(Y==1);
[ST dummy]=size(idy);
[ST2 dummy]=size(Y);
porcent=(ST*100)/ST2;
[ST dummy]=size(Ytest);
numPlus=ceil(ST*(porcent/100));

% For the polynomial kernel :
dp=2;%Grado del polinomio (ver pagina 97)
%gaussianse of exponentiele  RBF kernel:
%sigma=1;

% for the MLP kernel:
scale=1;
offset=1;
% for the B-spline kernel
ds=7;



% parameters:
%************

switch type
case 'linear'
    par=[];%parametros del Kernel
    type_nummer=0;
case 'polynomial'
    % the dimension of the polynomial is given in the variable par
    fprintf('the order is: %d \n',dp)
    par=[dp];%parametros del Kernel(Aqui es el grado del polimonio)
    type_nummer=1;
case 'gaussian_rbf'
    % the sigma value of the rbf is given in par
    % By means of crossvalidation
    fprintf('sigma is:  %d \n',sigma)
    type_nummer=2;
    
    par=[sigma];%parametros del Kernel(Aqui es la desviacion)
    
case 'exponential_rbf'  
    % the sigma value of the rbf is given in par
     fprintf('sigma is:  %d \n',sigma)
    par=[sigma];
    type_nummer=3;
case 'mlp'
    % the w and bias value of the tanh  is given in par
    par=[scale offset];
    type_nummer=4;%numero del Kernel para la funcion.
    
case 'Bspline'
    % the order of the B-spline is given in par
    par=[ds];
    type_nummer=6;
case 'Local RBF' %'locale gaussian_rbf' 
    % the sigma value of the rbf is given in par
    % By means of crossvalidation
    fprintf('sigma is:  %d \n',sigma)
    type_nummer=7;
    
    par=[sigma];
end



% training the QP-svm:
% *********************
t=cputime;

              
solTsvm=cosa(X,Y,Xtest,Ytest,C,Ctest,numPlus,epsilon,type_nummer,par);
    

       
time=cputime-t;
fprintf('The training needed %d',time),fprintf(' seconds.\n');



%from TSVM
% tsvmalpha=solTsvm{1,1};
% tsvmbias=solTsvm{1,2};
% tsvmw=solTsvm{1,3};
% tsvmeslack=solTsvm{1,4};
% tsvmeslack2=solTsvm{1,5};
% tsvmtest=solTsvm{1,6};