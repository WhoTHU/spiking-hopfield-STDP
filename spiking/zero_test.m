clear;
Initialize;
train_num=1000;
test_num=1000;
load('C:\Users\lenovo\Desktop\result_full_firing_rate_biact_unchange_Inv');
Loaddata;

test_itr=200;
test_epo=50;

[neurno_P,neuron_V,pred]=quick(test_itr,neuron_P,neuron_V,para,20);
% [neuron_P,neuron_V,~,~,pred]= flo(test_itr,neuron_P,neuron_V,0,0,para,0);
quick_train=mean(pred-1~=train_label);

[neurno_P_t,neuron_V_t,pred]=quick(test_itr,neuron_P_t,neuron_V_t,para,5);
% [neuron_P_t,neuron_V_t,~,~,pred]= flo(test_itr,neuron_P_t,neuron_V_t,0,0,para,0);
quick_test=mean(pred-1~=test_label);

disp([quick_train,quick_test]);
disp([err_train(epo),err_test(epo)]);



% err_quick=zeros(test_epo,1);
% for i=1:test_epo
%     i
% %    [neurno_P,neuron_V,pred]=quick(test_itr,neuron_P,neuron_V,para,0);
%     [neuron_P,neuron_V,~,~,pred]=flo(test_itr,neuron_P,neuron_V,0,0,para,0);
%     err_quick(i)=mean(pred-1~=train_label);
% end;
% 
% figure;
% plot(1:test_epo,err_quick(:)*100);
% ylim([0,100]);

% 
% for i=1:para.layer
%     figure;
%     ind1=randi(size(his_P{i},1),10,1);
%     ind2=randi(1000,1);
%     subplot(2,1,1)
%     plot(0:test_itr,squeeze(his_P{i}(ind1,ind2,:)));
%     subplot(2,1,2)
%     plot(0:test_itr,squeeze(his_V{i}(ind1,ind2,:)));
% end;