
Initialize;
Loaddata;
% load('weight_ini.mat');

Sim;
if ~exist('result','dir')
    mkdir('result');
end;
save('result/result.mat');
