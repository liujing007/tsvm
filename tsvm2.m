function solTsvm=tsvm(X,Y,Xtest,Ytest,C,Ctest,Cminus,Cplus,numPlus,epsilon,type_nummer,par);


solution=solve_svm_qp(X,Y,[],[],C,Cminus,Cplus,epsilon,type_nummer,par);

lalpha=solution{1,1};
lbias=solution{1,2};
lw=solution{1,3};
leslack=solution{1,4};
leslack2=solution{1,5};

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
end

[Dummy,indexYtemp]=sort(Ytemp);
Ytest=ones(M,1);
Ytest(indexYtemp(1:M-numPlus),1)=-1;


%initizlize Cminus and Cplus with small numbers
%Cminus=10e-5;
%Cplus=10e-5 * numPlus/M-numPlus;

Cminus=0.55;
Cplus=0.5;
k=0;
while ((Cminus < Ctest) || (Cplus < Ctest)),
    solution=solve_svm_qp(X,Y,Xtest,Ytest,C,Cminus,Cplus,epsilon,type_nummer,par);
    lalpha=solution{1,1};
    lbias=solution{1,2};
    lw=solution{1,3};
    leslack=solution{1,4};
    leslack2=solution{1,5}; 
    
         while(checkSwitchCondition(Ytest,leslack2))
               Ytest(i,1)=Ytest(i,1)*-1; 
               Ytest(j,1)=Ytest(j,1)*-1
                solution=solve_svm_qp(X,Y,Xtest,Ytest,C,Cminus,Cplus,epsilon,type_nummer,par);
                leslack2=solution{1,5};
                k = k+1;
                if k == 10
                    break
                end
         end
    Cminus=min(Cminus*2,Ctest); 
    Cplus=min(Cplus*2,Ctest); 
end



%Recopiling the solution...
solTsvm=cell(1,1);
solTsvm{1,1}=Ytest;