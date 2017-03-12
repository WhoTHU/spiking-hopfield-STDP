close all;
clear;


para.C_m=1;
para.g_L=0.025;
para.V_L=-70;
para.V_I=-70;
para.V_E=0;
para.V_th=-52;
para.V_reset=-59;
para.alpha_S=1;
para.tau_s0=100;
para.tau_sp=5;
para.tau_sm=5;
para.A_STDP=1.5*10^-3;
para.tau=120;
para.lambda=120;
para.dW_range=0.003;
para.dt=0.1;
para.con=0.2;
para.num=2;
para.Intv_0=50;
para.Intv_p=12;
para.Intv_m=12;
para.rep=5;

learn_time=200;
learn_Intv=1000;

weit=random('uniform',0,1,para.num);
weit0=random('uniform',0,1,para.num,1);
weit_p=0.1;
weits_m=55.5/14.5*W_ip;

multy_fire(para,weit,weit0,weit_p,weit_m,learn_time,learn_Intv);


