function [ neuron,otpt_nr ] = flo( neuron,ipt,time,eps)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

global weight b ipt_weight otpt_weight

for iTi=1:time
    neuron=(1-eps)*neuron+eps*(weight*act(neuron)+repmat(b,1,size(neuron,2))+ipt_weight*ipt);
end;

otpt_nr=otpt_weight'*neuron;

end