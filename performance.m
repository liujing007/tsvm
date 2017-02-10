misscla=zeros(501,2)
count=0;
for i=0:2:1000
    count=count+1;
    solTsvm=puntos(i,i)
    misscla(count,1)=solTsvm{1,7}
    misscla(count,2)=solTsvm{1,8}
end
x=0:2:1000
figure(3)
plot(x,misscla(:,1),'r+-');
hold;
plot(x,misscla(:,2),'bd:');
grid on;
xlabel(['Values of C and Ctest'])
ylabel(['Missclassificated points'])
title('| Dashed line= Training Set | - | Continuos line= Test Set |')
set(gca,'XTick', 0:100:1000)
