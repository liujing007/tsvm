function esl=eslack_E(w,X,Y,b)

N=size(X,2);
esl= zeros(N,1);
c = zeros(N,1);
for i=1:N
    xi= X(:,i);
    yi= Y(i,1);
    c(i) = (yi*(w' * xi + b )) ;
end

idx=find(c<1);

esl(idx)=1- c(idx);