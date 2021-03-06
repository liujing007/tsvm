function solTsvm=cosa(X,Y,Xtest,Ytest,C,Ctest,numPlus,epsilon,type_nummer,par);

%Copying the original labeling of the Ytest
Yorig=Ytest;

%First that all we classify the test example with the ISVM method
solution=solve_svm_qp(X,Y,[],[],C,0,0,epsilon,type_nummer,par);

lalpha=solution{1,1};
lbias=solution{1,2}
lw=solution{1,3};
leslack=solution{1,4};
leslack2=solution{1,5};

figure(1)
[c,d]=meshgrid(-2:1:18);
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
idxtest=find(Ytest==1);
idxtest1=find(Ytest==-1);
plot(X(1,idx),X(2,idx),'co',X(1,idx1),X(2,idx1),'bs',Xtest(1,idxtest),Xtest(2,idxtest),'yo',Xtest(1,idxtest1),Xtest(2,idxtest1),'ks');  %Inserted to solve the absence of gplotmatrix



M=length(Xtest(1,:));%Capturing the lenght of the Test set  
N=length(X(1,:));%Capturing the lenght of the Training set 

Ytemp= zeros(M,1);

%Classifying the test set with the new b and w
%The numPlus examples with the highest value of w * Xtest +bias are
for i=1:M
    xi= Xtest(:,i);
    Ytemp(i,1) = lw' * xi + lbias;
end

%calculling for the trainig examples
for i=1:N
    xi= X(:,i);
    Ytempt(i,1) = lw' * xi + lbias;
end
%calculling the amount of missclasification in the test set:
count=length(find((Yorig+sign(Ytemp))==0));

%calculling the amount of missclasification in the trainig set:
countt=length(find((Y+sign(Ytempt))==0));

hold off
title('First classification with SVM')
ylabel(['There are ',num2str(countt),' points missclassified on Training set'])
xlabel(['There are ',num2str(count),' points missclassified on Test set'])
text(X(1,idx),X(2,idx),' +') 
text(X(1,idx1),X(2,idx1),'  -') 

%assigned to the class + (Ytest=1); the remaininig test examples are
%assigned to the class - (Ytest=-1)
%Relabeling according to the lust great values of the first evaluation
[Dummy,indexYtemp]=sort(Ytemp);
Ytest=ones(M,1);
Ytest(indexYtemp(1:M-numPlus),1)=-1;

%initizlize Cminus and Cplus with small numbers
Cminus=1e-5;
Cplus=1e-5 * numPlus/(M-numPlus);


k=0;
while ((Cminus < Ctest) | (Cplus < Ctest)),%OJO Quite una barra en el Or
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

    
    
    
figure(2)
[c,d]=meshgrid(-2:1:18);
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
idxtest=find(Yorig==1);%with original Labelling
idxtest1=find(Yorig==-1);
%idxtest=find(Ytest==1);%with the relabeling
%idxtest1=find(Ytest==-1);
plot(X(1,idx),X(2,idx),'co',X(1,idx1),X(2,idx1),'bs',Xtest(1,idxtest),Xtest(2,idxtest),'yo',Xtest(1,idxtest1),Xtest(2,idxtest1),'ks');  %Inserted to solve the absence of gplotmatrix


for i=1:M
    xi= Xtest(:,i);
    Ytemp(i,1) = lw' * xi + lbias;
end

%calculling for the trainig examples
for i=1:N
    xi= X(:,i);
    Ytempt(i,1) = lw' * xi + lbias;
end
%calculling the amount of missclasification in the test set:
count=length(find((Yorig+sign(Ytemp))==0));

%calculling the amount of missclasification in the trainig set:
countt=length(find((Y+sign(Ytempt))==0));

hold off
title('Classification by means of TSVM')
ylabel(['There are ',num2str(countt),' points missclassified on Training set'])
xlabel(['There are ',num2str(count),' points missclassified on Test set'])
text(X(1,idx),X(2,idx),' +') 
text(X(1,idx1),X(2,idx1),'  -') 


%Recopiling the solution...
solTsvm=cell(1,8);
solTsvm{1,1}=lalpha;
solTsvm{1,2}=lbias;
solTsvm{1,3}=lw;
solTsvm{1,4}=leslack;
solTsvm{1,5}=leslack2;
solTsvm{1,6}=Ytest;
solTsvm{1,7}=count;
solTsvm{1,8}=countt;