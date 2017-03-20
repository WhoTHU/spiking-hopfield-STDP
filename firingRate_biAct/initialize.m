clear;

global weight weight_Inv

E_L=-70;
V_th=-54;
V_reset=-80;
Rm=10;
tao=10;
dt=0.1;
spike=0;

para.I0=10;
para.layer=3;
para.eps=0.5;
para.m_f=0.37;

n_layer=[32*32*3,500,10];
gmax=[5,5];
gmin=-gmax;
gmax_Inv=gmax;
gmin_Inv=-gmax_Inv;
train_num=500;
test_num=100;
batch_size=100;
epo=800;
itr=[20,4,20];
beta=1;
alpha=[0.05,0.05];
alpha_Inv=alpha*0.1;
weight_dec=0.000001;
l_r=0;
test_fre=1;

weight=cell(para.layer-1,1);
weight_Inv=cell(para.layer-1,1);
for j=1:para.layer-1
    weight{j}=(random('norm',0,0.3,n_layer(j),n_layer(j+1)));
    weight_Inv{j}=(random('norm',0,0.3,n_layer(j),n_layer(j+1)));
    %     weight_Inv{i}=weight{i};
end;

weiCh=cell(para.layer-1,1);
weiCh_Inv=cell(para.layer-1,1);
for j=1:para.layer-1;
    weiCh{j}=zeros(epo,1);
    weiCh_Inv{j}=zeros(epo,1);
end;

% weight_his=cell(para.layer-1,1);
% weight_his_Inv=cell(para.layer-1,1);
% for j=1:para.layer-1;
%     weight_his{j}=zeros(epo,n_layer(j)*n_layer(j+1));
%     weight_his_Inv{j}=zeros(epo,n_layer(j)*n_layer(j+1));
% end;

