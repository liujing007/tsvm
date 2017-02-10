function eslack=eslack(w,X,Y,b)

N=length(X(1,:));
eslack= zeros(N,1);

for i=1:N
    xi= X(:,i);
    yi= Y(i,1);
    eslack(i,1)=1-(yi*(w' * xi + b )) ;
end

