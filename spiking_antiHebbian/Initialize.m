global weight weight_Inv his_V his_I

para.E_L=-70;
para.V_th=-54;
para.V_reset=-80;
para.Rm=10;
para.tau_V=10;
para.tau_I=10;
para.tau_md=20;
para.window=50;
para.dt=1;
para.spike=0;
para.I0=10;
para.A_pos=[0.002,0.002];para.A_neg=para.A_pos.*1.012;
para.layer=3;
para.n_layer=[28*28,500,10];
para.weight_dec=0;

ifreset=true;
layer=para.layer;
n_layer=para.n_layer;
gmax=[5,5];
gmin=-gmax;
gmax_Inv=gmax;
gmin_Inv=-gmax_Inv;
train_num=600;
test_num=100;
batch_size=100;
epo=100;
itr=[20,10];
beta=1;
test_fre=1;

if ifreset
    weight=cell(layer-1,1);
    weight_Inv=cell(layer-1,1);
    for i=1:layer-1
%         weight{i}=max(-gmax(i),min(gmax(i),random('norm',43/n_layer(i),43/n_layer(i),n_layer(i),n_layer(i+1))));
%         weight_Inv{i}=max(-gmax_Inv(i),min(gmax_Inv(i),random('norm',0.1,0.1,n_layer(i),n_layer(i+1))));
        weight{i}=max(gmin(i),min(gmax(i),random('norm',0,1.2,n_layer(i),n_layer(i+1))));
        weight_Inv{i}=max(gmin_Inv(i),min(gmax_Inv(i),random('norm',0,1.2,n_layer(i),n_layer(i+1))));
%         weight_Inv{i}=weight{i};
    end;
end;

