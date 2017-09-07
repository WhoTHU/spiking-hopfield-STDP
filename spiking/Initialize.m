global weight weight_Inv his_V his_P

para.E_L=-70;
para.E_s=0;
para.V_th=-54;
para.V_reset=-80;
para.Rm=10;
para.rm=10;
para.tau_V=20;
para.tau_P=10;
para.tau_md=20;
para.spike=0;
para.P_md=1;			%above, biological constant
para.wind=50;
para.dt=1;
para.I0=0.3;
para.Imax=para.I0;
para.Imin=0;
para.n_layer=[28*28,500,10];	%size of network
para.layer=length(para.n_layer);
para.A_pos=0.02*ones(1,para.layer);
para.A_pos=para.A_pos*1;
para.weight_dec=0;
% para.STDP_modi=0.1744;
para.STDP_modi=0;

ifreset=true;
layer=para.layer;
n_layer=para.n_layer;
gmax=0.10*ones(1,para.layer);
gmin=-gmax;
gmax_Inv=gmax;
gmin_Inv=-gmax_Inv;
train_num=60000;		%training data point amount
test_num=10000;			%test data point amount
batch_size=100;			%batch size
epo=80;				%total epochs for learing, each epoch goes through whole training set
itr=[50,20];
beta=1;
test_fre=1;

if ifreset			%initialize the weights of the network
    weight=cell(layer-1,1);
    weight_Inv=cell(layer-1,1);
    for j=1:layer-1
%         weight{i}=max(-gmax(i),min(gmax(i),random('norm',43/n_layer(i),43/n_layer(i),n_layer(i),n_layer(i+1))));
%         weight_Inv{i}=max(-gmax_Inv(i),min(gmax_Inv(i),random('norm',0.1,0.1,n_layer(i),n_layer(i+1))));
%         weight{j}=max(gmin(j),min(gmax(j),random('norm',0,1.2,n_layer(j),n_layer(j+1))));
%         weight_Inv{j}=max(gmin_Inv(j),min(gmax_Inv(j),random('norm',0,1.2,n_layer(j),n_layer(j+1))));
        weight{j}=max(gmin(j),min(gmax(j),random('norm',0,sqrt(1.5/(n_layer(j)+n_layer(j+1)))/1.24,n_layer(j),n_layer(j+1))));
        weight_Inv{j}=max(gmin(j),min(gmax(j),random('norm',0,sqrt(1.5/(n_layer(j)+n_layer(j+1)))/1.24,n_layer(j),n_layer(j+1))));
%         weight_Inv{i}=weight{i};
    end;
end;


