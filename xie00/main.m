
para.C_m=1;
para.g_L=0.025;
para.V_L=-70;
para.V_I=-70;
para.V_E=0;
para.V_th=-52;
para.V_reset=-59;
para.alpha_S=1;
para.tau_syn=100;
para.A_STDP=1.5*10^-3.5;
para.tau=120;
para.lambda=120;
para.dW_range=0.003;

Intv_0=50;
Intv_p=12;
Intv_m=12;
last_p=96;
last_m=96;


T=7000;
dt=1;
para.T=T;
para.dt=dt;

if_cht=true(1,T/dt+1);
if_chf=false(1,T/dt+1);

S_0=zeros(1,T/dt+1);
S_p=zeros(1,T/dt+1);
S_m=zeros(1,T/dt+1);
S_0(1:Intv_0:T/dt+1)=1;
t_pb=[1000,2000,3000];
for i=1:length(t_pb)
    S_p((t_pb(i):Intv_p:t_pb(i)+last_p)/dt)=1;
    if_cht((t_pb(i)+para.lambda-para.tau:dt:t_pb(i)+last_p+para.lambda)/dt)=false;
end;
t_mb=[4000,5000,6000];
for i=1:length(t_mb)
    S_m((t_mb(i):Intv_m:t_mb(i)+last_m)/dt)=1;
    if_cht((t_mb(i)+para.lambda-para.tau:dt:t_mb(i)+last_p+para.lambda)/dt)=false;
end;
a=1/para.C_m/log((para.V_reset-para.V_E)/(para.V_th-para.V_E));
b=para.g_L/para.C_m/log((para.V_reset-para.V_E)/(para.V_th-para.V_E))*(1-((para.V_reset-para.V_L)/(para.V_reset-para.V_E)-(para.V_th-para.V_L)/(para.V_th-para.V_E))/log((para.V_reset-para.V_E)/(para.V_th-para.V_E)));
W_i=1/a;
W_i0=-b/a*Intv_0;
W_ip=0.1;
W_im=0.05;

[St,Vt,W,W_0]=fire(para,S_0,S_p,S_m,W_i,W_i0,W_ip,W_im,if_cht);
[Sf,Vf]=fire(para,S_0,S_p,S_m,W_i,W_i0,W_ip,W_im,if_chf);

close all;
figure;
subplot(5,1,1);
plot(1:T/dt+1,S_0);
subplot(5,1,2);
plot(1:T/dt+1,S_p);
subplot(5,1,3);
plot(1:T/dt+1,S_m);
subplot(5,1,4);
plot(1:T/dt+1,St);
subplot(5,1,5);
plot(1:T/dt+1,Sf);

figure;
subplot(2,1,1);
plot(1:T/dt+1,W);
subplot(2,1,2);
plot(1:T/dt+1,W_0);

% figure;
% plot(1:T/dt+1,V1);



