% close all;

Initialize;
Sim;
if ~exist('result','dir')
    mkdir('result');
end;

save('result/result.mat','err_train','err_test','weight','weight_Inv','neuron','weight_his','weight_his_Inv');

