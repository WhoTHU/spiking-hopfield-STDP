% close all;

initialize;
Sim;
if ~exist('result','dir')
    mkdir('result');
end;
save('result/result.mat');
