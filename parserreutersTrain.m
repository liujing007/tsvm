filename = 'test.dat'%Identify the original file name
fid = fopen(filename,'r'); %Open this file only to read
xe = zeros(9947,1); %Initialize a vector of 9947 rows times 1 Column
Xtest = zeros(9947,600);%Initialize a vector of 9947 rows times 600 Column
Xtest=sparse(Xtest); %Declare Sparse Xtest to improve his manage
Y =[];
X =[];
linenumber = 0;
linetest = 0;
while (~feof(fid)), %While no end of file
    linet = fgetl(fid);%Extract line by line
    linenumber = linenumber + 1
    if (length(linet)>0)
        if (linet(1) ~= '#')%If is no comment
            s = linet; 
            [token,s] = strtok(s);%Colect the first part before a blank space and leave the remainder in s
            yy = str2num(token);%translate to number
            if yy ~= 0%Identifying the trainig set which have a value different of zero 
                Y = [Y;yy];%Add to the Y vector
                test = false;%then no is part of the test set
            else
                test = true;%
                linetest = linetest +1;
            end
            xx = xe;
            while (length(s)>0),%while the remainer of the line is no finish
                [token,s] = strtok(s);%again we colect first part before a blank space store it in token and leave the remainder in s
                if (length(token)>0)%if this token have elements
                    [stridx,strvalue] = strtok(token,':');%Colect the value before the ':' in token a store it in stridx the ramainder is store in strvalue
                    strvalue = strvalue(2:end);%Drop the ':' in strvalue
                    idx = str2num(stridx);%Convert this stridx (column or feature)in a number
                    value = str2num(strvalue);%Convert this strvalue (the weight of the feature)in a number
                    xx(idx) = value;%Insert in the Vector in this position(feature) the weight
                end
            end    
            if test
                Xtest(:,linetest)=xx;%if is part of the test example is stored in his matrix
            else
                X=[X xx];%otherwise is stored in the Matrix of training examples
            end
        end
    end
end