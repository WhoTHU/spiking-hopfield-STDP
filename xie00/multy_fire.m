function [ weit,weit0,S_0,S_p,S_m,S,g_E,r] = multy_fire( para,weit_ini,weit0_ini,weit_p,weit_m,learn_time,learn_Intv,if_learn )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
dt=para.dt;
tau=para.lambda;
lambda=para.lambda;

S_0=zeros(para.num,learn_time*learn_Intv/dt+1);
S_p=zeros(para.num,learn_time*learn_Intv/dt+1);
S_m=zeros(para.num,learn_time*learn_Intv/dt+1);
S=zeros(para.num,learn_time*learn_Intv/dt+1);
weit=zeros(para.num,para.num,learn_time*learn_Intv/dt+1);
weit0=zeros(para.num,learn_time*learn_Intv/dt+1);
weit(:,:,1)=weit_ini;
weit0(:,1)=weit0_ini;

r=zeros(para.num,learn_time*learn_Intv/dt+1);
r_0=zeros(para.num,learn_time*learn_Intv/dt+1);
r_p=zeros(para.num,learn_time*learn_Intv/dt+1);
r_m=zeros(para.num,learn_time*learn_Intv/dt+1);
g_E=zeros(para.num,learn_time*learn_Intv/dt+1);
g_I=zeros(para.num,learn_time*learn_Intv/dt+1);
V=zeros(para.num,learn_time*learn_Intv/dt+1);
V(1)=para.V_reset;

for i=1:learn_time*learn_Intv/dt+1
    if mod(i-1,int32(para.Intv_0/dt))==0
        S_0(:,i)=1;
    end;
end;

for i=1:learn_time
    sti=logical(random('bino',1,0.5,1,1)*ones(1,para.num));
    T0=(i-1)*learn_Intv;
    for j=1:para.rep
        S_p(sti,T0/dt+(j-1)*para.Intv_p/dt+1)=1;
        S_m(~sti,T0/dt+(j-1)*para.Intv_m/dt+1)=1;
    end;
    r(r(:,T0/dt+1)>0.3 | r(:,T0/dt+1)<0.01,T0/dt+1)=0.1;
    for iT=T0/dt+1:T0/dt+learn_Intv/dt
        V(V(:,iT)>=para.V_th,iT)=para.V_reset;
        S(V(:,iT)>=para.V_th,iT)=1;
        g_E(:,iT)=weit(:,:,iT)*r(:,iT)+weit0(:,iT).*r_0(:,iT)+weit_p.*r_p(:,iT);
        g_I(:,iT)=weit_m.*r_m(:,iT);
        V(:,iT+1)=V(:,iT)-dt/para.C_m.*(para.g_L.*(V(:,iT)-para.V_L)+g_E(:,iT).*(V(:,iT)-para.V_E)+g_I(:,iT).*(V(:,iT)-para.V_I));
        r(:,iT+1)=r(:,iT)+dt/para.tau_s0.*(S(:,iT)/dt-r(:,iT));
        r_0(:,iT+1)=r_0(:,iT)+dt/para.tau_s0.*(S_0(:,iT)/dt-r_0(:,iT));
        r_p(:,iT+1)=r_p(:,iT)+dt/para.tau_sp.*(S_p(:,iT)/dt-r_p(:,iT));
        r_m(:,iT+1)=r_m(:,iT)+dt/para.tau_sm.*(S_m(:,iT)/dt-r_m(:,iT));
        dW_0=zeros(para.num,1);
        dW=zeros(para.num);
        if if_learn && iT-T0/dt>(para.Intv_p*para.rep+lambda+tau)/dt+1 && iT-T0/dt<learn_Intv/dt+(lambda-tau)/dt
            dW_0=dW_0-para.A_STDP*S_0(:,iT-lambda/dt).*(sum(S(:,iT-(lambda+tau)/dt:1:iT-(lambda-tau)/dt)*sin(pi/tau*(-tau:dt:tau)')));
            dW=dW-para.A_STDP*S(:,iT-lambda/dt)*(sum(S(:,iT-(lambda+tau)/dt:1:iT-(lambda-tau)/dt)*sin(pi/tau*(-tau:dt:tau)')))';
        end;
        weit0(:,iT+1)=weit0(:,iT)+dW_0;
        weit(:,:,iT+1)=weit(:,iT)+dW;
    end;
end;

end
