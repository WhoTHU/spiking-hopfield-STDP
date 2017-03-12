
test_T=7000;
test_if_ch=false(1,test_T/dt+1);

test_S_0=zeros(1,test_T/dt+1);
test_S_p=zeros(1,test_T/dt+1);
test_S_m=zeros(1,test_T/dt+1);
test_S_0(1:Intv_0/dt:test_T/dt+1)=1;
t_pb=[1000,2000,3000];
for i=1:length(t_pb)
    test_S_p(1+(t_pb(i):Intv_p:t_pb(i)+last_p)/dt)=1;
end;
t_mb=[4000,5000,6000];
for i=1:length(t_mb)
    test_S_m(1+(t_mb(i):Intv_m:t_mb(i)+last_m)/dt)=1;
end;

% (W_i*b+W_i0/Intv_0)/(1-a*W_i)
[Sf,Vf,Wf,Wf_0,g_Ef,g_If,Inpf,rf]=fire(para,test_S_0,test_S_p,test_S_m,W_i,W_i0,W_ip,W_im,test_if_ch);

figure;
subplot(5,1,1);
plot(1:test_T/dt+1,test_S_0);
subplot(5,1,2);
plot(1:test_T/dt+1,test_S_p);
subplot(5,1,3);
plot(1:test_T/dt+1,test_S_m);
subplot(5,1,4);
plot(1:test_T/dt+1,Sf);
subplot(5,1,5);
plot(1:test_T/dt+1,rf);

% figure;
% plot(1:T/dt+1,V1);

