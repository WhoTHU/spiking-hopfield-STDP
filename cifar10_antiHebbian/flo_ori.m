function [neuron_P,neuron_V,chan,chan_Inv,pred]=flo(time,s0_P,s0_V,beta,ext,para,step)

global weight weight_Inv 
neuron_P=s0_P;
neuron_V=cell(size(neuron_P));
dt=para.dt;
window=para.window;
% neuron_V=s0_V;
for j=1:para.layer
    neuron_V{j}=random('uni',para.V_reset,para.V_th,size(s0_V{j}));
end;
chan=cell(para.layer-1,1);
chan_Inv=cell(para.layer-1,1);
u=cell(para.layer,1);
if step==0
%     his_V=cell(para.layer,1);
%     his_G=cell(para.layer,1);
%     for j=1:para.layer
%         his_V{j}=zeros([size(neuron_V{j}),time/dt+1]);
%         his_G{j}=zeros([size(neuron_P{j}),time/dt+1]);
%     end;
    count=0;
    for i=0:dt:time
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j});
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}=double(neuron_V{j}==para.spike);
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./dt+weight_Inv{j}*u{j+1}./dt)));
        end;
        j=para.layer;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./dt)));
        count=count+u{para.layer};
%         for j=2:para.layer
%             his_V{j}(:,:,int32(i/dt)+1)=neuron_V{j};
%             his_G{j}(:,:,int32(i/dt)+1)=neuron_P{j};
%         end;
    end;
    [~,pred]=max(count);
    %     [~,pred]=max(neuron_P{para.layer});
elseif step==1
    f_STDP=@(x) sin(pi*x/window);
    for j=1:para.layer-1
        chan{j}=zeros(size(weight{j}));
        chan_Inv{j}=zeros(size(weight_Inv{j}));
    end;
    pred=0;
    neuron_I=cell(para.layer,1);
    for j=1:para.layer-1
        neuron_I{j}=0;
    end;
    for j=1:para.layer
        u{j}=false([size(neuron_P{j}),(time+2*window)/dt]);
    end;
    neuron_I{para.layer}=beta*para.I0*(2*ext-1);
    %%%%%%%%%%%%%
    for iT=1:1:window/dt
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
            %             neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j}+para.Rm*neuron_I{j});
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j});
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}(:,:,iT)=neuron_V{j}==para.spike;
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt+weight_Inv{j}*u{j+1}(:,:,iT)./dt)));
        end;
        j=para.layer;
        %         u{j}=random('poisson',act(y*para.I0)*dt);
        %         neuron_P{j}=beta*para.I0*y;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt)));
    end;
    %%%%%%%%%%%%%
    for iT=window/dt+1:1:(time+2*window)/dt
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
            %             neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j}+para.Rm*neuron_I{j});
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*min(para.I0,max(0,neuron_P{j}+neuron_I{j})));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}(:,:,iT)=neuron_V{j}==para.spike;
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt+weight_Inv{j}*u{j+1}(:,:,iT)./dt)));
        end;
        j=para.layer;
        %         u{j}=random('poisson',act(y*para.I0)*dt);
        %         neuron_P{j}=beta*para.I0*y;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt)));
    end;
    %%%%%%%%%%%%%
    for iT=window/dt+1:1:(time+window)/dt
        for j=1:para.layer-1
            chan{j}=chan{j}+para.A_pos(j)*u{j}(:,:,iT)*(sum(u{j+1}(:,:,iT-window/dt:1:iT+window/dt).*permute(f_STDP(-window:dt:window),[1,3,2]),3))';
        end;
        for j=1:para.layer-1
            chan_Inv{j}=chan_Inv{j}+para.A_pos(j)*(sum(u{j}(:,:,iT-window/dt:1:iT+window/dt).*permute(f_STDP(-window:dt:window),[1,3,2]),3))*u{j+1}(:,:,iT)';
        end;
    end;
end;
end