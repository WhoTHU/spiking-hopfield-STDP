
Initialize;
Loaddata;
% load('weight_ini.mat');

Sim;
if ~exist('result','dir')
    mkdir('result');
end;
save('result/result.mat','err_train','err_test','weight','weight_Inv','neuron_P','weight_his','weight_his_Inv');
