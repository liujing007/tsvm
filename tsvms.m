function solTsvm=tsvms(X,Y,Xtest,C,Ctest,numPlus,epsilon,type_nummer,par);

%First that all we classify the test example with the ISVM method
solution=solve_svm_qp(X,Y,[],[],C,0,0,epsilon,type_nummer,par);

lalpha=solution{1,1};
lbias=solution{1,2}
lw=solution{1,3};
leslack=solution{1,4};
leslack2=solution{1,5};

figure(1)
[c,d]=meshgrid(-10:1:15)
[m,n]=size(c);
array=zeros(m,n);

for i=1:m
    for j=1:n
            array(i,j) =(lw'*[c(i,j),d(i,j)]')+lbias;
        end
end


[label,h] = contourf(c,d,array);%drawing the contour of the hyperplane with the data points 
clabel(label,h);
colormap autumn
hold on;
idx=find(Y==1);
idx1=find(Y==-1);
plot(X(1,idx),X(2,idx),'co',X(1,idx1),X(2,idx1),'b+',Xtest(1,:),Xtest(2,:),'md');  %Inserted to solve the absence of gplotmatrix
hold off
title('Scatter plot of the input')

M=length(Xtest(1,:));%Capturing the lenght of the Training set  
N=length(X(1,:));

Ytemp= zeros(M,1);

%Classifying the test set with the new b and w
%The numPlus examples with the highest value of w * Xtest +bias are
%assigned to the class + (Ytest=1); the remaininig test examples are
%assigned to the class - (Ytest=-1)
for i=1:M
    xi= Xtest(:,i);
    Ytemp(i,1) = lw' * xi + lbias;
    % Ytemp(i,1) = lw' *  Xtest(:,i) + lbias;
end

[Dummy,indexYtemp]=sort(Ytemp);
Ytest=ones(M,1);
Ytest(indexYtemp(1:M-numPlus),1)=-1;

%initizlize Cminus and Cplus with small numbers
Cminus=1e-5;
Cplus=1e-5 * numPlus/(M-numPlus);


k=0;
while ((Cminus < Ctest) || (Cplus < Ctest)),
    solution=solve_svm_qp(X,Y,Xtest,Ytest,C,Cminus,Cplus,epsilon,type_nummer,par);
    lalpha=solution{1,1};
    lbias=solution{1,2};
    lw=solution{1,3};
    leslack=solution{1,4};
    leslack2=solution{1,5}; 
    l=0;
        [condition,i,j]=checkSwitchCondition(Ytest,leslack2);
         while(condition)
               Ytest(i,1)=Ytest(i,1)*-1; 
               Ytest(j,1)=Ytest(j,1)*-1;
                solution=solve_svm_qp(X,Y,Xtest,Ytest,C,Cminus,Cplus,epsilon,type_nummer,par);
                leslack2=solution{1,5};     
                l=l+1;
                fprintf(1,'Iteracion %d %d Intercambiando %d %d \n',k,l,i,j);
                [condition,i,j]=checkSwitchCondition(Ytest,leslack2)
         end
    k=k+1;     
    Cminus=min(Cminus*2,Ctest); 
    Cplus=min(Cplus*2,Ctest);
    fprintf(1,'Iteracion %d Ctest =%g Cmin= %g Cplus=%g \n',k,Ctest,Cminus,Cplus);
end
    lalpha=solution{1,1};
    lbias=solution{1,2};
    lw=solution{1,3};
    leslack=solution{1,4};
    leslack2=solution{1,5}; 


%Recopiling the solution...
solTsvm=cell(1,6);
solTsvm{1,1}=lalpha;
solTsvm{1,2}=lbias;
solTsvm{1,3}=lw;
solTsvm{1,4}=leslack;
solTsvm{1,5}=leslack2;
solTsvm{1,6}=Ytest;


%visialisation of the input data:
%*******************************
