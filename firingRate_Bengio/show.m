
figure;
plot(1:epo,err_train(1:epo));
hold on;
plot(test_fre:test_fre:epo,err_test(test_fre:test_fre:epo));
ylim([0,1]);
legend('train set','test set');


for i=1:layer-1
    figure;
    subplot(2,1,1);
    hist(weight{i}(:),gmin(i):(gmax(i)-gmin(i))/100:gmax(i));
    subplot(2,1,2);
    hist(weight_Inv{i}(:),gmin(i):(gmax_Inv(i)-gmin_Inv(i))/100:gmax_Inv(i));
end;

for i=1:layer-1
    figure;
    plot(1:epo,weight_his{i}(1:epo,randi(size(weight_his{i},2),1,10)));
end;

figure;
for i=1:layer
    subplot(layer,1,i);
    hist(neuron{i}(:),0:para.I0/10:para.I0);
end;


for i=1:para.layer-1
    figure;
    hist(weight{i}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
    figure;
    hist(weight_Inv{i}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
end;

for i=1:layer-1
    figure;
    subplot(2,2,1);
    scatter(weight_his{i}(1,:),weight_his{i}(epo,:))
    subplot(2,2,2);
    hist(weight_his{i}(epo,:)-weight_his{i}(1,:),100)
    subplot(2,2,3);
    scatter(weight_his_Inv{i}(1,:),weight_his_Inv{i}(epo,:))
    subplot(2,2,4);
    hist(weight_his_Inv{i}(epo,:)-weight_his_Inv{i}(1,:),100)
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

figure;hist(sum((weight_his_Inv{1}(2:end,:)-weight_his_Inv{1}(1:end-1,:)).^2,1),100);
th=0;
filt1=zeros(epo,1);
k1=0;
for i=1:size(weight_his_Inv{1},2)
    if sum((weight_his_Inv{1}(2:end,i)-weight_his_Inv{1}(1:end-1,i)).^2,1)>th
        k1=k1+1;
        filt1(:,k1)=weight_his_Inv{1}(:,i);
    end;
end;
figure;hist(sum(sign(filt1(2:end,:)-filt1(1:end-1,:)),1),-epo:2:epo);
figure;x=filt1;plot(1:epo,x(:,random('unid',size(x,2),20,1)));

hist(sum(neuron_P{2}>1,2),100)

neuron_stt=cell(layer);
for j=1:layer
    neuron_stt{j}=zeros(n_layer(j),n_layer(layer));
end;
for i=0:9
    for j=1:layer
        neuron_stt{j}(:,i+1)=mean(neuron_P{j}(:,train_label==i),2);
    end;
end;

for i=1:10 figure;j=3;plot(neuron_stt{j}(random('unid',n_layer(j)),:),'o');end;


[~,pred]=max(neuron_P{3});
aa=train_label~=pred-1;
bb=find(aa);
bad_P=neuron_P{3}(:,aa);
bad_L=train_label(aa);
figure;imshow(imresize(uint8(reshape(neuron_P{1}(:,bb(3)),28,28)/10*256),10));

th=1.6;100-sum(sum(neuron_P{3}>th,1)>0)/600
