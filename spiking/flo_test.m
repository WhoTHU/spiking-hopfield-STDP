function [neuron_P,neuron_V,chan,chan_Inv,pred]=flo(time,s0_P,s0_V,beta,ext,para,step)

global weight weight_Inv his_V his_P
dt=para.dt;
wind=para.wind;
neuron_P=s0_P;
% neuron_V=s0_V;
neuron_V=cell(size(neuron_P));
for j=1:para.layer
    neuron_V{j}=random('uni',para.V_reset,para.V_th,size(neuron_P{j}));
end;
chan=cell(para.layer-1,1);
chan_Inv=cell(para.layer-1,1);
u=cell(para.layer,1);
if step==0
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
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}-para.rm.*neuron_P{j}.*(neuron_V{j}-para.E_s));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}=neuron_V{j}==para.spike;
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*u{j-1}./dt+weight_Inv{j}*u{j+1}./dt)));
        end;
        j=para.layer;
        neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*u{j-1}./dt)));
        count=count+u{para.layer};
        for j=1:para.layer
            his_V{j}(:,:,int32(i/dt)+1)=neuron_V{j};
            his_P{j}(:,:,int32(i/dt)+1)=neuron_P{j};
        end;
    end;
    [~,pred]=max(count);
    %     [~,pred]=max(neuron_P{para.layer});
elseif step==1
%     f_STDP=@(x) sin(pi*x/wind).*(abs(x)>5);
%     f_STDP=@(x) 0.1*sign(x);
    f_STDP=@(x) sin(pi*x/wind);
%     f_STDP=@(x) sign(x).*exp(-abs(x)/para.tau_md);
    for j=1:para.layer-1
        chan{j}=zeros(size(weight{j}));
        chan_Inv{j}=zeros(size(weight_Inv{j}));
    end;
    pred=0;
    for j=1:para.layer
        u{j}=false([size(neuron_P{j}),(time+2*wind)/dt]);
    end;
    %%%%%%%%%%%%%
    ui=cell(size(neuron_V));
    for iT=1:1:wind/dt
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
%             neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j}+para.Rm*neuron_I{j});
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}-para.rm.*neuron_P{j}.*(neuron_V{j}-para.E_s));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            ui{j}=neuron_V{j}==para.spike;
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*ui{j-1}./dt+weight_Inv{j}*ui{j+1}./dt)));
        end;
        j=para.layer;
        neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*ui{j-1}./dt)));
    end;
    
    %%%%%%%%%%%%%
    for iT=1:1:wind/dt
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}-para.rm.*neuron_P{j}.*(neuron_V{j}-para.E_s));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}(:,:,iT)=neuron_V{j}==para.spike;
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt+weight_Inv{j}*u{j+1}(:,:,iT)./dt)));
        end;
        j=para.layer;
        %         u{j}=random('poisson',act(y*para.I0)*dt);
        neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt)));
    end;
    %%%%%%%%%%%%%
    for iT=wind/dt+1:1:(time+2*wind)/dt
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
%             neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j}+para.Rm*neuron_I{j});
%             neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*min(para.Imax,max(0,neuron_P{j}+neuron_I{j})));
            neuron_V{j}=neuron_V{j}+dt./para.tau_V.*(para.E_L-neuron_V{j}-para.rm.*neuron_P{j}.*(neuron_V{j}-para.E_s));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}(:,:,iT)=neuron_V{j}==para.spike;
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt+weight_Inv{j}*u{j+1}(:,:,iT)./dt)));
        end;
        j=para.layer;
%         u{j}=random('poisson',act(y*para.I0)*dt);
%         neuron_P{j}=para.I0*ext;
        neuron_P{j}=min(para.Imax,max(para.Imin,neuron_P{j}+dt./para.tau_P.*(-neuron_P{j}+weight{j-1}'*u{j-1}(:,:,iT)./dt+beta*(para.I0*ext-neuron_P{j}))));
    end;
    %%%%%%%%%%%%%
    for iT=wind/dt+1:1:(time+wind)/dt
        for j=1:para.layer-1
            chan{j}=chan{j}+u{j}(:,:,iT)*(sum(u{j+1}(:,:,iT-wind/dt:1:iT+wind/dt).*permute(f_STDP(-wind:dt:wind),[1,3,2]),3))';
        end;
        for j=1:para.layer-1
            chan_Inv{j}=chan_Inv{j}+(sum(u{j}(:,:,iT-wind/dt:1:iT+wind/dt).*permute(f_STDP(-wind:dt:wind),[1,3,2]),3))*u{j+1}(:,:,iT)';
        end;
    end;
%     for j=1:para.layer-1
%         chan{j}=chan{j}-para.A_pos(j)*para.STDP_modi*sum(sum(u{j}(:,:,window/dt+1:1:(time+window)/dt),3),2).*weight{j};
%         chan_Inv{j}=chan_Inv{j}-para.A_pos(j)*para.STDP_modi*sum(sum(u{j+1}(:,:,window/dt+1:1:(time+window)/dt),3),2)'.*weight_Inv{j};
%     end;
end;
end