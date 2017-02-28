function [varargout] = fire( para,S_0,S_p,S_m,W_i,W_i0,W_ip,W_im,if_ch)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
T=para.T;
dt=para.dt;
tau=para.tau;
lambda=para.lambda;

V=zeros(1,T/dt+1);
V(1)=para.V_reset;

S=zeros(1,T/dt+1);

r=zeros(1,T/dt+1);
r_0=zeros(1,T/dt+1);
r_p=zeros(1,T/dt+1);
r_m=zeros(1,T/dt+1);

W=zeros(1,T/dt+1);
W_0=zeros(1,T/dt+1);
W(1)=W_i;
W_0(1)=W_i0;
W_p=W_ip*ones(1,T/dt+1);
W_m=W_im*ones(1,T/dt+1);

for It=1:T/dt
    if V(It)>=para.V_th
        V(It)=para.V_reset;
        S(It)=1;
    end;
    g_E=W(It)*r(It)+W_0(It)*r_0(It)+W_p(It)*r_p(It);
    g_I=W_m(It)*r_m(It);
    V(It+1)=V(It)-dt/para.C_m*(para.g_L*(V(It)-para.V_L)+g_E*(V(It)-para.V_E)+g_I*(V(It)-para.V_I));
    r(It+1)=r(It)+dt/para.tau_syn*(S(It)/dt-r(It));
    r_0(It+1)=r_0(It)+dt/para.tau_syn*(S_0(It)/dt-r_0(It));
    r_p(It+1)=r_p(It)+dt/para.tau_syn*(S_p(It)/dt-r_p(It));
    r_m(It+1)=r_m(It)+dt/para.tau_syn*(S_m(It)/dt-r_m(It));
    dW_0=0;
    dW=0;
    if if_ch(It) && It>(lambda+tau)/dt
        if S_0(It-lambda/dt)
            dW_0=dW_0-para.A_STDP*sum(S(It-(lambda+tau)/dt:1:It-(lambda-tau)/dt).*sin(pi/tau*(-tau:dt:tau)));
        end;
        if S(It-lambda/dt)
            dW=dW-para.A_STDP*sum(S(It-(lambda+tau)/dt:1:It-(lambda-tau)/dt).*sin(pi/tau*(-tau:dt:tau)));
        end;
    end;
    W_0(It+1)=W_0(It)+sigmoid(dW_0,para.dW_range);
    W(It+1)=W(It)+sigmoid(dW,para.dW_range);
end;

if nargout==2
    varargout={S,V};
elseif nargout==4
    varargout={S,V,W,W_0};
end;

end

