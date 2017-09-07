% initialize;
% load('epoch_80.mat','weight','weight_Inv')
[neuron_P_t,~,~,~,pred]=flo_test(20,neuron_P_t,0,0,0,para,0);
err_t=mean(pred-1~=test_label)