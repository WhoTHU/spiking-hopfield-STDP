
figure;
plot(1:epo,err_train);
hold on;
plot(test_fre:test_fre:epo,err_test(test_fre:test_fre:epo));
legend('train set','test set');

for i=1:para.layer-1
    figure;
    hist(weight{i}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
    figure;
    hist(weight_Inv{i}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
end;

for i=1:para.layer
    figure;
    hist(neuron{i}(:),100);
end;

for iEpo=10:10:epo
    load(['epoch_',num2str(iEpo),'.mat'])
    figure;
    hist(weight{2}(:),100);
end;

for iEpo=10:10:epo
    load(['epoch_',num2str(iEpo),'.mat']);
    [std(weight{1}(:)),std(weight{2}(:)),std(weight_Inv{1}(:)),std(weight_Inv{2}(:))]
end;

for iEpo=10:10:epo
    load(['epoch_',num2str(iEpo),'.mat']);
    figure;
    subplot(2,1,1);
    hist(weight{1}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
    subplot(2,1,2);
    hist(weight{2}(:),gmin(2):(gmax(2)-gmin(2))/100:gmax(2));
end;

for i=1:layer-1
    figure;
    plot(1:epo,weiCh{i});
    figure;
    plot(1:epo,weiCh_Inv{i});
end;

for i=1:128
    han=weight{1}(:,i);
    imwrite(imresize(reshape((han-min(han))./(-min(han)+max(han)),28,28),5),sprintf('result/hidden_%-d.bmp',i));
end;

for i=1:10
    han=weight{1}*weight{2}(:,i);
    imwrite(imresize(reshape((han-min(han))./(-min(han)+max(han)),28,28),5),sprintf('result/hidden_%-d.bmp',i));
end;


figure;
hist(std(weight_his{1}),100);
figure;
hist(std(weight_his{2}),100);

filt1=zeros(epo,1);
k1=0;
for i=1:size(weight_his{2},2)
if std(weight_his{2}(:,i))>0.1
k1=k1+1;
filt1(:,k1)=weight_his{2}(:,i);
end;
end;

filt2=zeros(epo,1);
k2=0;
for i=1:size(weight_his{2},2)
if std(weight_his{2}(:,i))>0.1
k2=k2+1;
filt2(:,k2)=weight_his{2}(:,i);
end;
end;

hist(sum(neuron{2}>1,2),100)
