function [S,V,W,W_0,g_E,g_I,Inp,r] = fire( para,S_0,S_p,S_m,W_i,W_i0,W_ip,W_im,if_ch)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
dt=para.dt;
T=dt*(length(S_0)-1);
tau=para.tau;
lambda=para.lambda;

V=zeros(1,T/dt+1);
V(1)=para.V_reset;

S=zeros(1,T/dt+1);

r=zeros(1,T/dt+1);
r_0=zeros(1,T/dt+1);
r_p=zeros(1,T/dt+1);
r_m=zeros(1,T/dt+1);
g_E=zeros(1,T/dt+1);
g_I=zeros(1,T/dt+1);    
Inp=zeros(1,T/dt+1);

W=zeros(1,T/dt+1);
W_0=zeros(1,T/dt+1);
W(1)=W_i;
W_0(1)=W_i0;
W_p=W_ip*ones(1,T/dt+1);
W_m=W_im*ones(1,T/dt+1);
dW_0=0;
dW=0;

for It=1:T/dt
    if mod(It-1,int32(para.wind/dt))==0
        if r(It)>0.3
            r(It)=0.1;
        elseif r(It)<0.01
            r(It)=0.1;
            V(It)=para.V_reset;
        end;
%     W_0(It+1)=W_0(It)+sigmoid(dW_0,para.dW_range);
%     W(It+1)=W(It)+sigmoid(dW,para.dW_range);
%     W_0(It+1:It+para.wind/dt)=W_0(It)+min(para.con*W_0(It),max(-para.con*W_0(It),dW_0));
%     W(It+1:It+para.wind/dt)=W(It)+min(para.con*W_0(It),max(-para.con*W_0(It),dW));
%     dW_0=0;
%     dW=0;
    end;
    if V(It)>=para.V_th
        V(It)=para.V_reset;
        S(It)=1;
    end;
    g_E(It)=W(It)*r(It)+W_0(It)*r_0(It)+W_p(It)*r_p(It);
    g_I(It)=W_m(It)*r_m(It);
    Inp(It)=-(g_E(It)*(V(It)-para.V_E)+g_I(It)*(V(It)-para.V_I));
    V(It+1)=V(It)-dt/para.C_m*(para.g_L*(V(It)-para.V_L)+g_E(It)*(V(It)-para.V_E)+g_I(It)*(V(It)-para.V_I));
    r(It+1)=r(It)+dt/para.tau_s0*(S(It)/dt-r(It));
    r_0(It+1)=r_0(It)+dt/para.tau_s0*(S_0(It)/dt-r_0(It));
    r_p(It+1)=r_p(It)+dt/para.tau_sp*(S_p(It)/dt-r_p(It));
    r_m(It+1)=r_m(It)+dt/para.tau_sm*(S_m(It)/dt-r_m(It));
    dW_0=0;
    dW=0;
    if if_ch(It) && It>(lambda+tau)/dt
        if S_0(It-lambda/dt)
            dW_0=dW_0-dt*para.A_STDP*sum(S(It-(lambda+tau)/dt:1:It-(lambda-tau)/dt).*sin(pi/tau*(-tau:dt:tau)));
        end;
        if S(It-lambda/dt)
            dW=dW-dt*para.A_STDP*sum(S(It-(lambda+tau)/dt:1:It-(lambda-tau)/dt).*sin(pi/tau*(-tau:dt:tau)));
        end;
    end;
    W_0(It+1)=W_0(It)+dW_0;
    W(It+1)=W(It)+dW;
end;

end

