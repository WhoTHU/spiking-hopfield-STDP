function [ neuron,otpt_nr ] = flo( neuron,ipt,time,eps)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

global weight b ipt_weight otpt_weight

for iTi=1:time
    neuron=(1-eps)*neuron+eps*(weight*act(neuron)+repmat(b,1,size(neuron,2))+ipt_weight*ipt);
end;

otpt_nr=otpt_weight'*neuron;

end