clear;

tic

num=20;
dt=1;
tau=20;
l_rate=0.05;
time=[500,500,3000,500,200];
t_name={'initial','f1','intval1','f2','intval2'};
epo=100;
train_num=100;

ipt_weight=random('norm',0,0.1,num,1);
weight=random('norm',0,0.1,num);
weight=weight-diag(diag(weight));
b=random('norm',0,0.1,num,1);
neuron=zeros(num,1);
train_data=random('unif',0.1,1,2,train_num);

weight_his=zeros([size(weight),epo+1]);
weight_his(:,:,1)=weight;
for iEp=1:epo
    for iTr=1:train_num
        for iTi=1:time(1)/dt
            neuron=(1-dt/tau)*neuron+dt/tau*(weight*act(neuron)+b);
        end;
        ipt=train_data(1,iTr);
        for iTi=1:time(2)/dt
            neuron=(1-dt/tau)*neuron+dt/tau*(weight*act(neuron)+b+ipt*ipt_weight);
        end;
        pre=neuron;
        ipt=train_data(2,iTr);
        for iTi=1:time(4)/dt
            neuron=(1-dt/tau)*neuron+dt/tau*(weight*act(neuron)+b+ipt*ipt_weight);
        end;
        post=neuron;
        %weight change
        weight=weight+l_rate*(post-pre)*((act(pre)+act(post))/2)';
        weight=weight-diag(diag(weight));
    end;
    weight_his(:,:,iEp+1)=weight;
end;



ti=toc
