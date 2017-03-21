clear;
close all;

tic

global weight b ipt_weight otpt_weight

num=200;
dt=500/5;
% tau=20;
eps=0.5;
l_rate=0.02;
beta=1;
time=[500,500,3000,500,200];
t_name={'initial','f1','intval1','f2','intval2'};
train_num=10000;
test_num=100;
test_fre=500;
weight_max=sqrt(6/num);
weight_min=-sqrt(6/num);
% weight_max=1;
% weight_min=-1;

ipt_weight=random('norm',0,0.3,num,1);
otpt_weight=random('norm',0,1/num,num,2);
weight=random('norm',0,sqrt(0.3/num),num);
% weight=weight-diag(diag(weight));
% weight=weight-diag(diag(weight))+diag(ones(num,1));
b=random('norm',0,0.1,num,1);
% neuron=zeros(num,1);
train_data=random('unif',0.1,1,2,train_num);
[~,train_label]=max(train_data);
test_data=random('unif',0.1,1,2,test_num);
[~,test_label]=max(test_data);

weight_his=zeros([size(weight),train_num/test_fre+1]);
weight_his(:,:,1)=weight;
diag_his=zeros([size(weight,1),train_num/test_fre+1]);
diag_his(:,1)=diag(weight);
otpt_his=zeros([size(otpt_weight),train_num/test_fre+1]);
otpt_his(:,:,1)=otpt_weight;

err=zeros(1,train_num/test_fre+1);
%test
[neuron,~]=flo(zeros(num,test_num),0,time(1)/dt,eps);
[neuron,~]=flo(neuron,test_data(1,:),time(2)/dt,eps);
[~,otpt_nr]=flo(neuron,test_data(2,:),time(4)/dt,eps);
[~,Ind]=max(otpt_nr);
err(1)=mean(Ind~=test_label);

for iTr=1:train_num
    %ini
    [neuron,~]=flo(zeros(num,1),0,time(1)/dt,eps);
    %f1
    [neuron,~]=flo(neuron,train_data(1,iTr),time(2)/dt,eps);
    pre=neuron;
    %f2
    [neuron,otpt_nr]=flo(neuron,train_data(2,iTr),time(4)/dt,eps);
    post=neuron;
    %weight change
%     weight=max(weight_min,min(weight_max,weight+l_rate*(post-pre)*((act(pre)+act(post))/2)'));
%     weight=weight-diag(diag(weight));
%     weight=weight-diag(diag(weight))+diag(ones(num,1));
    %         ipt_weight=ipt_weight+l_rate*(act(post)-act(pre));
    label=train_label(iTr);
    otpt=full(sparse(label,1,1,2,1));
    otpt_weight=max(weight_min,min(weight_max,otpt_weight+l_rate*beta*act(post)*(otpt-act(otpt_nr))'));
    if mod(iTr,test_fre)==0
        epo=iTr/test_fre
        weight_his(:,:,iTr/test_fre+1)=weight;
        otpt_his(:,:,iTr/test_fre+1)=otpt_weight;
        diag_his(:,iTr/test_fre+1)=diag(weight);
        %test
        [neuron,~]=flo(zeros(num,test_num),0,time(1)/dt,eps);
        [neuron,~]=flo(neuron,test_data(1,:),time(2)/dt,eps);
        [neuron,otpt_nr]=flo(neuron,test_data(2,:),time(4)/dt,eps);
        [~,Ind]=max(otpt_nr);
        err(iTr/test_fre+1)=mean(Ind~=test_label);
    end;
end;
figure;
subplot(2,1,1);
plot(0:train_num/test_fre,reshape(weight_his(randi(num,10,1),randi(num,10,1),:),100,train_num/test_fre+1));
subplot(2,1,2);
plot(0:train_num/test_fre,diag_his);
figure;
subplot(2,1,1);
plot(0:train_num/test_fre,reshape(otpt_his(:,1,:),num,train_num/test_fre+1));
subplot(2,1,2);
plot(0:train_num/test_fre,reshape(otpt_his(:,2,:),num,train_num/test_fre+1));
figure;
plot(0:train_num/test_fre,err);

ti=toc
