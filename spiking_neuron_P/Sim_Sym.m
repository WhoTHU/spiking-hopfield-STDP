tic;

weight_his=cell(layer-1,1);
weight_his_Inv=cell(layer-1,1);
for j=1:layer-1;
    weight_his{j}=zeros(epo,n_layer(j)*n_layer(j+1));
    weight_his_Inv{j}=zeros(epo,n_layer(j)*n_layer(j+1));
end;

err_test=zeros(1,epo);
err_train=zeros(1,epo);
% count=0;
for iEpo=1:epo
    disp(iEpo);
    for j=1:layer-1
        weight_his{j}(iEpo,:)=weight{j}(:);
        weight_his_Inv{j}(iEpo,:)=weight_Inv{j}(:);
    end;
    %train
    rm=randperm(train_num);
    for j=1:layer
        neuron_P{j}=neuron_P{j}(:,rm);
        neuron_V{j}=neuron_V{j}(:,rm);
    end;
    train_label=train_label(:,rm);
    for iIm=1:ceil(train_num/batch_size)
        last_ind=min(train_num,iIm*batch_size);
        %negative
        for j=1:layer
            s0_P{j}=neuron_P{j}(:,1+(iIm-1)*batch_size:last_ind);
            s0_V{j}=neuron_V{j}(:,1+(iIm-1)*batch_size:last_ind);
        end;
        [s0_P,s0_V,~,~,pred]=flo(itr(1),s0_P,s0_V,0,0,para,0);
        for j=2:layer
            neuron_P{j}(:,1+(iIm-1)*batch_size:last_ind)=s0_P{j};
            neuron_V{j}(:,1+(iIm-1)*batch_size:last_ind)=s0_V{j};
        end;
        err_train(iEpo)=err_train(iEpo)+sum(pred-1~=train_label(1+(iIm-1)*batch_size:last_ind));
        %positive
        ext=full(sparse(train_label(1+(iIm-1)*batch_size:last_ind)+1,1:batch_size,1,10,batch_size));
        [~,~,chan,chan_Inv,~]=flo(itr(2),s0_P,s0_V,beta,ext,para,1);
        
        %modify
        j=1;
        weight{j}=max(gmin(j),min(gmax(j),(1-para.A_pos(j)*para.weight_dec)*weight{j}+chan{j}));
        weight_Inv{j}=max(gmin_Inv(j),min(gmax_Inv(j),(1-para.A_pos(j)*para.weight_dec)*weight_Inv{j}+chan_Inv{j}));
        j=2;
        weight{j}=max(gmin(j),min(gmax(j),(1-para.A_pos(j)*para.weight_dec)*weight{j}+chan{j}+chan_Inv{j}));
        weight_Inv{j}=weight{j};
    end;
    err_train(iEpo)=err_train(iEpo)/train_num;
    %test on test
    if mod(iEpo,test_fre)==0
        [neuron_P_t,neuron_V_t,~,~,pred]=flo(itr(1),neuron_P_t,neuron_V_t,0,0,para,0);
        err_test(iEpo)=mean(pred-1~=test_label);
        %         figure;
        %         scatter(weight{2}(:),weight_Inv{2}(:));
        disp([err_train(iEpo), err_test(iEpo)]);
        disp([mean(act(neuron_P{1}(:))),mean(act(neuron_P{2}(:))),mean(act(neuron_P{3}(:)))])
    end;
%    if mod(iEpo,10)==0
%        save(['epoch_',num2str(iEpo),'.mat'],'weight','weight_Inv','neuron_P');
%    end;
end;

ti=toc

