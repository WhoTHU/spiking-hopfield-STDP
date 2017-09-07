%font1=20;font2=30;set(gca,'FontSize',font1);set(get(gca,'XLabel'),'FontSize',font2);set(get(gca,'YLabel'),'FontSize',font2);

figure;
plot(1:epo,100*err_train(1:epo));
hold on;
plot(test_fre:test_fre:epo,100*err_test(test_fre:test_fre:epo),['b','--']);
legend('training','test');
ylim([0,100]);
xlabel('epoch');
ylabel('err rate/%');
title('traing and test err vs. traing epoch');

figure;
for j=1:para.layer-1
    subplot(para.layer-1,2,j*2-1);
    hist(weight{j}(:),gmin(j):(gmax(j)-gmin(j))/100:gmax(j));
    title(sprintf('layer%d to layer %d',j,j+1));
    subplot(para.layer-1,2,j*2);
    hist(weight_Inv{j}(:),gmin_Inv(j):(gmax_Inv(j)-gmin_Inv(j))/100:gmax_Inv(j));
    title(sprintf('layer%d to layer %d',j+1,j));
end;
suptitle('weight distribution of each layer');

figure;
title('traing and test err vs. traing epoch');
for j=1:para.layer
    subplot(para.layer,1,j);
    hist(neuron_P{j}(:),para.Imin:(para.Imax-para.Imin)/100:para.Imax);
end;
suptitle('activation distribution of neuron in each layer');


figure;
j=2;plot(1:epo,acos(sum(weight_his{j}.*weight_his_Inv{j},2)./sqrt(sum(weight_his{j}.^2,2).*sum(weight_his_Inv{j}.^2,2)))/pi*180);
xlabel('epoch')
ylabel('angle/^{\circ}')
title('the angle between bidirectional weights vs. epoch');

% The annotated code needs to activate the use of variable 'his_V' and
% 'his_P' in 'flo.m'. And minibatch size also needs to be reduced, and too
% large a minibatch size results in overflow

% cb=0:1/2:1;
% [a,b,c]=ndgrid(1:3);
% clr=cb([a(:),b(:),c(:)]);
% clr=clr(1:size(clr,1)-1,:);
% clr=clr(randperm(size(clr,1),10),:);
% 
% figure;
% hold on;
% num=1;
% for i=1:10
%     plot(para.dt*(0:size(his_V{3},3)-1),squeeze(his_V{3}(i,num,:)),'color',clr(i,:))
% end;
% xlabel('time/ms');
% ylabel('neuron voltage');
% legend('output1','output2','output3','output4','output5','output6','output7','output8','output9','output10');
% title('the neuron voltage behavior of the 10 output layer neuron in a specific example');
% figure;
% hold on;
% for i=1:10
%     plot(para.dt*(0:size(his_V{3},3)-1),squeeze(his_P{3}(i,num,:)),'color',clr(i,:))
% end;
% ylim([0,0.3])
% xlabel('time/ms');
% ylabel('input summation');
% legend('output1','output2','output3','output4','output5','output6','output7','output8','output9','output10');
% title('the input summation behavior of the 10 output layer neuron in a specific example');


% following plots are for debugging or other usage

% for i=1:layer-1
%     figure;
%     subplot(2,2,1);
%     scatter(weight_his{i}(1,:),weight_his{i}(epo,:))
%     subplot(2,2,2);
%     hist(weight_his{i}(epo,:)-weight_his{i}(1,:),100)
%     subplot(2,2,3);
%     scatter(weight_his_Inv{i}(1,:),weight_his_Inv{i}(epo,:))
%     subplot(2,2,4);
%     hist(weight_his_Inv{i}(epo,:)-weight_his_Inv{i}(1,:),100)
% end;
% 
% figure;
% coef=cell(layer-1,1);
% for i=2:layer-1
%     subplot(layer-1,1,i);
%     hist3([weight{i}(:),weight_Inv{i}(:)]);
% coef{i}=corrcoef(weight{i}(:),weight_Inv{i}(:));
% end;
% 
% i=2;
% hist3([weight{i}(:),weight_Inv{i}(:)],[10,10]);
% xlabel('layer 2 to layer 3')
% ylabel('layer 3 to layer 2');
% zlabel('counting')
% 
% plot(1:80,180/pi*acos(sum(weight_his{2}.*weight_his_Inv{2},2)./sqrt(sum(weight_his{2}.^2,2).*sum(weight_his_Inv{2}.^2,2))));
% xlabel('epoch');
% ylabel('angle \theta');
% 
% for i=1:para.layer-1
%     figure;
%     hist(weight{i}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
%     figure;
%     hist(weight_Inv{i}(:),gmin(1):(gmax(1)-gmin(1))/100:gmax(1));
% end;
% 
% for i=1:128
%     han=weight{1}(:,i);
%     imwrite(imresize(reshape((han-min(han))./(-min(han)+max(han)),28,28),5),sprintf('result/hidden_%-d.bmp',i));
% end;
% 
% for i=1:10
%     han=weight{1}*weight{2}(:,i);
%     imwrite(imresize(reshape((han-min(han))./(-min(han)+max(han)),28,28),5),sprintf('result/hidden_%-d.bmp',i));
% end;
% 
% 
% 
% figure;
% hist(std(weight_his{1}),100);
% figure;
% hist(std(weight_his{2}),100);
% 
% figure;hist(sum((weight_his_Inv{1}(2:end,:)-weight_his_Inv{1}(1:end-1,:)).^2,1),100);
% th=[0,0];
% w_f=cell(para.layer-1,2);
% figure;
% ind=1;
% for j=1:para.layer-1
%     w_f{j,ind}=zeros(epo,1);
%     k1=0;
%     for i=1:size(weight_his{j},2)
%         if sum((weight_his{j}(2:end,i)-weight_his{j}(1:end-1,i)).^2,1)>th(j)
%             k1=k1+1;
%             w_f{j,ind}(:,k1)=weight_his{j}(:,i);
%         end;
%     end;
%     subplot(2,para.layer-1,(ind-1)*(para.layer-1)+j);
%     plot(1:epo,w_f{j,ind}(:,random('unid',size(w_f{j},2),20,1)));
%     title(sprintf('layer%d to layer %d',j,j+1));
% end;
% ind=2;
% for j=1:para.layer-1
%     w_f{j,ind}=zeros(epo,1);
%     k1=0;
%     for i=1:size(weight_his_Inv{j},2)
%         if sum((weight_his_Inv{j}(2:end,i)-weight_his_Inv{j}(1:end-1,i)).^2,1)>th(j)
%             k1=k1+1;
%             w_f{j,ind}(:,k1)=weight_his_Inv{j}(:,i);
%         end;
%     end;
%     subplot(2,para.layer-1,(ind-1)*(para.layer-1)+j);
%     plot(1:epo,w_f{j,ind}(:,random('unid',size(w_f{j},2),20,1)));
%     title(sprintf('layer%d to layer %d',j+1,j));
% end;
% 
% figure;hist(sum(sign(filt1(2:end,:)-filt1(1:end-1,:)),1),-epo:2:epo);
% 
% hist(sum(neuron_P{2}>1,2),100)
% 
% neuron_stt=cell(layer);
% for j=1:layer
%     neuron_stt{j}=zeros(n_layer(j),n_layer(layer));
% end;
% for i=0:9
%     for j=1:layer
%         neuron_stt{j}(:,i+1)=mean(neuron_P{j}(:,train_label==i),2);
%     end;
% end;
% 
% for i=1:10 figure;j=3;plot(neuron_stt{j}(random('unid',n_layer(j)),:),'o');end;
% 
% 
% [~,pred]=max(neuron_P{3});
% aa=train_label~=pred-1;
% bb=find(aa);
% bad_P=neuron_P{3}(:,aa);
% bad_L=train_label(aa);
% figure;imshow(imresize(uint8(reshape(neuron_P{1}(:,bb(3)),28,28)/10*256),10));
% 
% th=1.6;100-sum(sum(neuron_P{3}>th,1)>0)/600