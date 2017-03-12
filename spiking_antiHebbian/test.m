% initialize;
% load('epoch_80.mat','weight','weight_Inv')
[neuron_P,~,~,~]=flo(50,neuron_P,0,0,para,0);
[~,~,~,pred]=flo(20,neuron_P,0,0,para,0);
err_tr=mean(pred-1~=train_label)