function [neuron_P,neuron_V,chan,chan_Inv,pred]=flo(time,s0_P,s0_V,beta,ext,para,step)

global weight weight_Inv
neuron_P=s0_P;
neuron_V=cell(size(neuron_P));
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
%         his_V{j}=zeros([size(neuron_V{j}),floor(time/para.dt)+1]);
%         his_G{j}=zeros([size(neuron_P{j}),floor(time/para.dt)+1]);
%     end;
    count=0;
    for i=0:para.dt:time
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
            neuron_V{j}=neuron_V{j}+para.dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j});
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}=double(neuron_V{j}==para.spike);
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt+weight_Inv{j}*u{j+1}./para.dt)));
        end;
        j=para.layer;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt)));
        count=count+u{para.layer};
%         for j=2:para.layer
%             his_V{j}(:,:,int32(i/para.dt)+1)=neuron_V{j};
%             his_G{j}(:,:,int32(i/para.dt)+1)=neuron_P{j};
%         end;
    end;
    [~,pred]=max(count);
%     [~,pred]=max(neuron_P{para.layer});
elseif step==1
    for j=1:para.layer-1
        chan{j}=zeros(size(weight{j}));
        chan_Inv{j}=zeros(size(weight_Inv{j}));
    end;
    pred=0;
    neuron_I=cell(para.layer,1);
    for j=1:para.layer-1
        neuron_I{j}=0;
    end;
    neuron_I{para.layer}=beta*para.I0*(2*ext-1);
    acc=cell(para.layer,1);
    acc_pre=cell(para.layer,1);
    for j=1:para.layer
        acc{j}=zeros(size(neuron_V{j}));
        acc_pre{j}=zeros(size(neuron_V{j}));
    end;
    for i=0:para.dt:para.window
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
            neuron_V{j}=neuron_V{j}+para.dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j});
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}=double(neuron_V{j}==para.spike);
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt+weight_Inv{j}*u{j+1}./para.dt)));
        end;
        j=para.layer;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt)));
        for j=1:para.layer
            acc_pre{j}=(1-1/para.tau_md*para.dt).*acc_pre{j}+u{j};
        end;
    end;
    %%%%%%%%%%%%%
    for i=0:para.dt:time
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
%             neuron_V{j}=neuron_V{j}+para.dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j}+para.Rm*neuron_I{j});
            neuron_V{j}=neuron_V{j}+para.dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*min(para.I0,max(0,neuron_P{j}+neuron_I{j})));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}=double(neuron_V{j}==para.spike);
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt+weight_Inv{j}*u{j+1}./para.dt)));
        end;
        j=para.layer;
%         u{j}=random('poisson',act(y*para.I0)*para.dt);
%         neuron_P{j}=beta*para.I0*y;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt)));
        for j=1:para.layer
            acc{j}=(1-1/para.tau_md*para.dt).*acc{j}+u{j};
            acc_pre{j}=(1-1/para.tau_md*para.dt).*acc_pre{j};
%             *exp(-i/para.tau_md)
        end;
        for j=1:para.layer-1
            chan{j}=chan{j}+para.A_pos(j)*acc{j}*u{j+1}'-para.A_neg(j)*u{j}*(acc{j+1}+acc_pre{j+1})';
            chan_Inv{j}=chan_Inv{j}+para.A_pos(j)*u{j}*acc{j+1}'-para.A_neg(j)*(acc{j}+acc_pre{j})*u{j+1}';
        end;
    end;
    %%%%%%%%%%%%%
    for i=0:para.dt:para.window
        for j=1:para.layer
            neuron_V{j}(neuron_V{j}>=para.spike)=para.V_reset;
%             neuron_V{j}=neuron_V{j}+para.dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*neuron_P{j}+para.Rm*neuron_I{j});
            neuron_V{j}=neuron_V{j}+para.dt./para.tau_V.*(para.E_L-neuron_V{j}+para.Rm.*min(para.I0,max(0,neuron_P{j}+neuron_I{j})));
            neuron_V{j}((neuron_V{j}>=para.V_th))=para.spike;
            u{j}=double(neuron_V{j}==para.spike);
        end;
        for j=2:para.layer-1
            neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt+weight_Inv{j}*u{j+1}./para.dt)));
        end;
        j=para.layer;
%         u{j}=random('poisson',act(y*para.I0)*para.dt);
%         neuron_P{j}=beta*para.I0*y;
        neuron_P{j}=min(para.I0,max(0,neuron_P{j}+para.dt./para.tau_I.*(-neuron_P{j}+weight{j-1}'*u{j-1}./para.dt)));
        for j=1:para.layer
            acc{j}=(1-1/para.tau_md*para.dt).*acc{j};
        end;
        for j=1:para.layer-1
            chan{j}=chan{j}+para.A_pos(j)*acc{j}*u{j+1}';
            chan_Inv{j}=chan_Inv{j}+para.A_pos(j)*u{j}*acc{j+1}';
        end;
    end;
end;
end