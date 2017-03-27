function [neuron]=flo(time,para,beta,observe,s0)

global weight weight_Inv

neuron=s0;
for i=1:time
    for j=2:para.layer-1
        neuron{j}=min(para.I0,max(0,(1-para.eps).*neuron{j}+para.eps.*(weight{j-1}'*act(neuron{j-1})+weight_Inv{j}*act(neuron{j+1}))));
%         neuron{j}=(1-eps).*neuron{j}+eps.*(weight{j-1}'*act(neuron{j-1})+weight_Inv{j}*act(neuron{j+1}));
    end;
    j=para.layer;
    if beta==0
        neuron{j}=min(para.I0,max(0,(1-para.eps).*neuron{j}+para.eps.*(weight{j-1}'*act(neuron{j-1}))));
%         neuron{j}=(1-eps).*neuron{j}+eps.*(weight{j-1}'*act(neuron{j-1}));
    elseif beta==-1
        neuron{j}=para.I0*observe;
    else
%        neuron{j}=min(para.I0,max(0,(1-para.eps).*neuron{j}+para.eps.*(weight{j-1}'*act(neuron{j-1})+para.eps.*beta*(para.I0*observe-neuron{j}))));
%         neuron{j}=(1-eps).*neuron{j}+eps.*(weight{j-1}'*act(neuron{j-1})+eps.*beta*(observe-neuron{j}));
         neuron{j}=min(para.I0,max(0,(1-para.eps).*neuron{j}+para.eps.*(weight{j-1}'*act(neuron{j-1})+para.eps.*beta*para.I0*(2*observe-1))));
    end;
end;

end