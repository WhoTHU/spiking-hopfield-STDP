tic;

load('../data/data_cifar10.mat');
layer=length(n_layer);
train_data=train_data(:,1:train_num);
train_label=train_label(:,1:train_num);
test_data=test_data(:,1:test_num);
test_label=test_label(:,1:test_num);

neuron=cell(para.layer,1);
neuron_t=cell(para.layer,1);
s0=cell(para.layer,1);

neuron{1}=para.I0*train_data;
neuron_t{1}=para.I0*test_data;
for j=2:layer
%     neuron{j}=6*rand(n_layer(j),train_num)-3;
%     neuron_t{j}=6*rand(n_layer(j),test_num)-3;
    neuron{j}=zeros(n_layer(j),train_num);
    neuron_t{j}=zeros(n_layer(j),test_num);
end;


err_test=zeros(1,epo);
err_train=zeros(1,epo);
neg=cell(para.layer,1);
pos=cell(para.layer,1);

for iEpo=1:epo
%     if iEpo==floor(epo/2)
%         alpha=alpha*10;
%     end;
    disp(iEpo);
%     for j=1:layer-1
%         weight_his{j}(iEpo,:)=weight{j}(:);
%         weight_his_Inv{j}(iEpo,:)=weight_Inv{j}(:);
%     end;
    %train
    rm=randperm(train_num);
    for j=1:layer
        neuron{j}=neuron{j}(:,rm);
    end;
    train_label=train_label(:,rm);
    for iIm=1:ceil(train_num/batch_size)
        %negative
        for j=1:layer
            s0{j}=neuron{j}(:,1+(iIm-1)*batch_size:min(train_num,iIm*batch_size));
        end;
        [s0]=flo(itr(1),para,0,0,s0);
        for j=1:layer
            neuron{j}(:,1+(iIm-1)*batch_size:min(train_num,iIm*batch_size))=s0{j};
            neg{j}=s0{j};
        end;
        [~,Ind]=max(s0{layer});
        err_train(iEpo)=err_train(iEpo)+sum(Ind-1~=train_label(1+(iIm-1)*batch_size:min(train_num,iIm*batch_size)));
        %positive
        observe=full(sparse(train_label(1+(iIm-1)*batch_size:min(train_num,iIm*batch_size))+1,1:batch_size,1,10,batch_size));
        [s0]=flo(itr(2),para,beta,observe,s0);
        for j=1:layer
            pos{j}=s0{j};
        end;
        %modify
%         for i=1:layer-1
%             weight{i}=(1-alpha.*weight_dec)*weight{i}+alpha.*max(0,act(neg{i})+l_r*randn(size(neg{i})))*(pos{i+1}'-neg{i+1}');
%             weight_Inv{i}=(1-alpha.*weight_dec)*weight_Inv{i}+alpha.*(pos{i}-neg{i})*max(0,act(neg{i+1}')+l_r*randn(size(neg{i+1}')));
%             weiCh{i}(iEpo)=mean(mean((alpha.*act(neg{i})*(pos{i+1}'-neg{i+1}')).^2)).^0.5;
%             weiCh_Inv{i}(iEpo)=mean(mean((alpha.*(pos{i}-neg{i})*act(neg{i+1}')).^2)).^0.5;
%         end;
        for j=1:layer-1
            weight{j}=max(gmin(j),min(gmax(j),(1-alpha(j).*weight_dec)*weight{j}+alpha(j).*act(neg{j})*(pos{j+1}'-neg{j+1}')));
            weight_Inv{j}=max(gmin_Inv(j),min(gmax_Inv(j),(1-alpha_Inv(j).*weight_dec)*weight_Inv{j}+alpha_Inv(j).*(pos{j}-neg{j})*act(neg{j+1}')));
            weight{j}=(weight{j}+weight_Inv{j})/2;weight_Inv{j}=weight{j};
        end;
    end;
    err_train(iEpo)=err_train(iEpo)/train_num;
    % test
    if mod(iEpo,test_fre)==0
        [neuron_t]= flo(itr(3),para,0,0,neuron_t);
        [~,Ind]=max(neuron_t{layer});
        err_test(iEpo)=mean(Ind-1~=test_label);
        disp([err_train(iEpo),err_test(iEpo)]);
        disp([std(weight{1}(:)),std(weight{2}(:)),std(weight_Inv{1}(:)),std(weight_Inv{2}(:))]);
    end;
%    if mod(iEpo,10)==0
%        save(['epoch_',num2str(iEpo),'.mat'],'weight','weight_Inv','neuron');
%    end;
end;

ti=toc

