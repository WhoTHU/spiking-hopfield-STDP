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
para.wind=1000;
para.con=0.2;

Intv_0=50;
Intv_p=12;
Intv_m=12;
last_p=Intv_p*5;
last_m=Intv_m*5;


learn_time=2000;
wind=para.wind;
T=wind*learn_time;
dt=para.dt;

if_ch=false(1,T/dt+1);

S_0=zeros(1,T/dt+1);
S_p=zeros(1,T/dt+1);
S_m=zeros(1,T/dt+1);
S_0(1:Intv_0/dt:T/dt+1)=1;
for i=1:learn_time
    if rand>0.5
        S_p(1+((i-1)*wind:Intv_p:(i-1)*wind+last_p)/dt)=1;
    else
        S_m(1+((i-1)*wind:Intv_m:(i-1)*wind+last_m)/dt)=1;
    end;
    if_ch(2+((i-1)*wind+last_p+para.lambda+para.tau)/dt:1:(i*wind+para.lambda-para.tau)/dt-1)=true;
end;
a=1/para.C_m/log((para.V_reset-para.V_E)/(para.V_th-para.V_E));
b=para.g_L/para.C_m/log((para.V_reset-para.V_E)/(para.V_th-para.V_E))*(1-((para.V_reset-para.V_L)/(para.V_reset-para.V_E)-(para.V_th-para.V_L)/(para.V_th-para.V_E))/log((para.V_reset-para.V_E)/(para.V_th-para.V_E)));
% W_i=1/a;
% W_i0=-b/a*Intv_0;
W_i=0.10;
W_i0=0.3;
% W_i=0.1245;
% W_i0=0.35;
W_ip=0.1;
W_im=55.5/14.5*W_ip;

[S,V,W,W_0,g_E,g_I,Inp,r]=fire(para,S_0,S_p,S_m,W_i,W_i0,W_ip,W_im,if_ch);


test;
W_i=W(end)
W_i0=W_0(end)
test


figure;
subplot(5,1,1);
plot(1:T/dt+1,S_0);
subplot(5,1,2);
plot(1:T/dt+1,S_p);
subplot(5,1,3);
plot(1:T/dt+1,S_m);
subplot(5,1,4);
plot(1:T/dt+1,S);
subplot(5,1,5);
plot(1:T/dt+1,r);

figure;
subplot(2,1,1);
plot(1:T/dt+1,W);
legend('W');
subplot(2,1,2);
plot(1:T/dt+1,W_0);
legend('W_0')

% figure;
% plot(1:T/dt+1,V1);



