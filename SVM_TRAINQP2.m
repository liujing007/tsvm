
function  oplossing =SVM_TRAINQP2(X,Y,epsilon,type_nummer,C,par)

% De trainingsmodule van de Vapnik SVM.

% De parameters:
% x is de matrix van de trainingssamples als kolommen van X
% y zijn de labels is van de inputvectoren in een kolom
% alpha zijn de Langrange multiplicatoren
% bias
% test arguments

tekstuitvoer=0;%imprimir


if tekstuitvoer
   fprintf('Training of the SVM...\n')
   fprintf('type: %s \n',type)
   fprintf('de kost C %d \n',C)
   switch type
   case 'gaussian_rbf'
      fprintf('sigma= %d \n',par1)
   case 'exponential_rbf'
      fprintf('sigma= %d \n',par1)
   case 'polynomial'
      fprintf('degree of polynomial= %d \n',par1)
   end
end
      

   
      
      
N=length(X(1,:));
Aeq=Y';
beq=[0];
lb=zeros(N,1);
if C==inf
   C=[];
else
   ub=C*ones(N,1);
end
f=-1*ones(N,1);

% Bepaling H:
K=full(kernel2(X,[],type_nummer,par));
H=diag(Y)*K*diag(Y);

% subplot(1,2,1),contourf(K)
% colorbar
% title('Strucuur in K');

options=optimset('MaxIter',1000,'LargeScale','off');
alpha=quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options);
save alpha;
figure(10),plot(sort(alpha)),ylabel('\alpha')

% bepalen van de bias
%********************

svi=find(abs(alpha)>epsilon);
aantalsup=length(svi);

if tekstuitvoer
   fprintf('Support Vectors : %d (%3.1f%%)\n\n',aantalsup,100*aantalsup/N);
end

%obtaining W
w= zeros(2,1);

for i=1:N
    xi= X(:,i);
    yi= Y(i,1);
    v = alpha(i,1) * xi * yi;
    w = w + v;
end
    

bias=bias_B(alpha,K,X,Y,epsilon);
eslack=eslack_E(w,X,Y,bias);
clear H K;
oplossing=cell(1,4);
oplossing{1,1}=alpha;
oplossing{1,2}=bias;
oplossing{1,3}=w;
oplossing{1,4}=eslack;
