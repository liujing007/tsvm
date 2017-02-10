load trainReuters.mat %load the model generate by the training set of Reuters
load reuterstest.mat%load the test set to prove aginst the generazted model
Yeval=zeros(600,1);%to store the evaluation of the model
bias=solTsvm{1,2};%retrieving the bias of the model generated
W=solTsvm{1,3};%retrieving the W vector of the model generated
count=0;
for i=1:600
    Yeval(i,1)=W'*X(:,i)+bias;%evaluating in each point
end

Signo=sign(Yeval);%taking the sign of the results
eval=Y-Signo;%storing the diferences between the results vectors
for i=1:600
    if(eval(i,1)==2)
        count=count+1;
    else if (eval(i,1)==-2)   
            count=count+1;
    end
end
end

count

Porcentaje=100-((count*100)/600);

fprintf('Accuracy on the test set %s \n',Porcentaje);
fprintf('Number of miss classificates %s \n',count);

