function [condition,i,j]=checkSwitchCondition(Ytest,leslack2)
condition=false;
M=size(Ytest,1);
for i=1:M
        for j=1:M
            
            if(Ytest(i,1) * Ytest(j,1) < 0) && (leslack2(i,1) > 0)&&(leslack2(j,1) > 0)&&(leslack2(i,1)+leslack2(j,1)>2)
                condition=true;    
                return;
            end
       end
end