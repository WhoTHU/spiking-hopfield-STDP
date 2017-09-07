function [ neuron_P,neuron_V,pred ] = quick(time,s0_P,s0_V,para,count_num)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

global weight weight_Inv his_V his_P
dt=para.dt;
if count_num==0
    count_num=time/dt+1;
end;
% neuron_V=s0_V;
neuron_V=s0_V;
neuron_P=s0_P;
u=cell(para.layer,1);
his_V=cell(para.layer,1);
his_P=cell(para.layer,1);
for j=1:para.layer
    his_V{j}=zeros([size(neuron_V{j}),time/dt+1]);
    his_P{j}=zeros([size(neuron_P{j}),time/dt+1]);
end;
count=0;
for i=0:dt:time
    for j=1:para.layer
        neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
        neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j});
        neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
        u{j}=double(neuron_V{j}==para.spike);
    end;
    for j=2:para.layer-1
        neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./dt+weight_Inv{j}*u{j+1}./dt)));
    end;
    j=para.layer;
    neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./dt)));
    count=count+u{para.layer};
    for j=1:para.layer
        his_V{j}(:,:,int32(i/dt)+1)=neuron_V{j};
        his_P{j}(:,:,int32(i/dt)+1)=neuron_P{j};
    end;
    if count<count_num
        continue;
    else
        break;
    end;
end;
[~,pred]=max(count);
%     [~,pred]=max(neuron_P{para.layer});
end

