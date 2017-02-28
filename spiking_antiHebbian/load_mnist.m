function [ train_data,train_label,test_data,test_label] = load_mnist( path )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
filename={'train-images.idx3-ubyte','train-labels.idx1-ubyte','t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte'};
data=cell(4,1);
for i=1:4
    fi=fopen([path,'/',filename{i}],'r');
    a=fread(fi,4,'uint8');magic=(a(1)*256+a(2))*256+a(3)*256+a(4);
    if magic~=2049+2*mod(i,2)
        disp('wrong');
    else
        disp([filename{i},' loaded']);
    end;
    a=fread(fi,4,'uint8');n=(a(1)*256+a(2))*256+a(3)*256+a(4);
    if mod(i,2)==1
        a=fread(fi,4,'uint8');x=(a(1)*256+a(2))*256+a(3)*256+a(4);
        a=fread(fi,4,'uint8');y=(a(1)*256+a(2))*256+a(3)*256+a(4);
        data{i}=cell(n,1);
        for j=1:n
            data{i}{j}=reshape(fread(fi,x*y,'uint8'),x,y)';
        end;
    else
        data{i}=fread(fi,n,'uint8');
    end;
    fclose(fi);
end;
train_data=data{1};
train_label=data{2};
test_data=data{3};
test_label=data{4};
end

