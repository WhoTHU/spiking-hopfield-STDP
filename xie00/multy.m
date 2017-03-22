close all;
clear;

tic
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
para.A_STDP=1.5*10^-5;
para.tau=120;
para.lambda=120;
para.dW_range=0.005;
para.dt=0.5;
para.con=0.2;
para.num=5;
para.Intv_0=50;
para.Intv_p=12;
para.Intv_m=12;
para.rep=5;

learn_time=200;
learn_Intv=1000;

weit_ini=random('uniform',0.1/(para.num-1),0.3/(para.num-1),para.num)/para.num;
weit_ini=weit_ini-diag(diag(weit_ini));
weit0_ini=random('uniform',0.3,0.5,para.num,1);
weit_p=0.1;
weit_m=55.5/14.5*weit_p;

[ weit,weit0,S_0,S_p,S_m,S,g_E,r]=multy_fire(para,weit_ini,weit0_ini,weit_p,weit_m,learn_time,learn_Intv,true,1);

% figure;
% subplot(5,1,1);
% plot(1:length(S_0),S_0);
% subplot(5,1,2);
% plot(1:length(S_0),S_p);
% subplot(5,1,3);
% plot(1:length(S_0),S_m);
% subplot(5,1,4);
% plot(1:length(S_0),S);
% subplot(5,1,5);
% plot(1:length(S_0),r);

show_num=4;
figure;
subplot(5,1,1);
plot(para.dt:para.dt:learn_Intv*show_num,S_0(:,1:learn_Intv/para.dt*show_num));
subplot(5,1,2);
plot(para.dt:para.dt:learn_Intv*show_num,S_p(:,1:learn_Intv/para.dt*show_num));
subplot(5,1,3);
plot(para.dt:para.dt:learn_Intv*show_num,S_m(:,1:learn_Intv/para.dt*show_num));
subplot(5,1,4);
plot(para.dt:para.dt:learn_Intv*show_num,S(:,1:learn_Intv/para.dt*show_num));
subplot(5,1,5);
plot(para.dt:para.dt:learn_Intv*show_num,r(:,1:learn_Intv/para.dt*show_num));

figure;
subplot(5,1,1);
plot(para.dt:para.dt:learn_Intv*show_num,S_0(:,end-learn_Intv/para.dt*show_num+1:end));
subplot(5,1,2);
plot(para.dt:para.dt:learn_Intv*show_num,S_p(:,end-learn_Intv/para.dt*show_num+1:end));
subplot(5,1,3);
plot(para.dt:para.dt:learn_Intv*show_num,S_m(:,end-learn_Intv/para.dt*show_num+1:end));
subplot(5,1,4);
plot(para.dt:para.dt:learn_Intv*show_num,S(:,end-learn_Intv/para.dt*show_num+1:end));
subplot(5,1,5);
plot(para.dt:para.dt:learn_Intv*show_num,r(:,end-learn_Intv/para.dt*show_num+1:end));

figure;
for i=1:para.num
    subplot(para.num,1,i);
    plot(para.dt:para.dt:learn_Intv*show_num,S(i,end-learn_Intv/para.dt*show_num+1:end));
end;

figure;
subplot(2,1,1);
plot(1:length(S_0),reshape(weit,para.num.^2,size(weit,3)));
legend('W');
subplot(2,1,2);
plot(1:length(S_0),weit0);
legend('W_0')

ti=toc
