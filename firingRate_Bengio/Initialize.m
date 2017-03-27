global weight weight_Inv

E_L=-70;
V_th=-54;
V_reset=-80;
Rm=10;
tao=10;
dt=0.1;
spike=0;

para.I0=1;
para.layer=4;
para.eps=0.5;
para.m_f=0.37;

layer=para.layer;
n_layer=[28*28,500,500,10];
gmax=[0.3,0.3,0.3];
gmin=-gmax;
gmax_Inv=gmax;
gmin_Inv=-gmax_Inv;
train_num=6000;
test_num=1000;
batch_size=100;
epo=100;
itr=[100,6,100];
beta=-1;
alpha=[0.4,0.1,0.01];
alpha=alpha*0;
alpha_Inv=alpha*1;
weight_dec=0.000000;
l_r=0;
test_fre=1;

weight=cell(para.layer-1,1);
weight_Inv=cell(para.layer-1,1);
for j=1:para.layer-1
    %     weight{j}=(random('norm',0,0.3,n_layer(j),n_layer(j+1)));
    %     weight_Inv{j}=(random('norm',0,0.3,n_layer(j),n_layer(j+1)));
    weight{j}=max(gmin(j),min(gmax(j),random('norm',0,sqrt(0.8/(n_layer(j)+n_layer(j+1))),n_layer(j),n_layer(j+1))));
    weight_Inv{j}=max(gmin(j),min(gmax(j),random('norm',0,sqrt(0.8/(n_layer(j)+n_layer(j+1))),n_layer(j),n_layer(j+1))));
        weight_Inv{j}=weight{j};
end;

% weiCh=cell(para.layer-1,1);
% weiCh_Inv=cell(para.layer-1,1);
% for j=1:para.layer-1;
%     weiCh{j}=zeros(epo,1);
%     weiCh_Inv{j}=zeros(epo,1);
% end;

weight_his=cell(para.layer-1,1);
weight_his_Inv=cell(para.layer-1,1);
for j=1:para.layer-1
    weight_his{j}=zeros(epo,n_layer(j)*n_layer(j+1));
    weight_his_Inv{j}=zeros(epo,n_layer(j)*n_layer(j+1));
end;

