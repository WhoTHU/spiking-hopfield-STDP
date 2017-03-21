% neuron{1}=para.I0*train_data;
for i=2:layer
    neuron{i}=zeros(n_layer(i),train_num);
end;
[neuron]=flo(50,para,0,0,neuron);
[~,Ind]=max(neuron{layer});
mean(Ind-1~=train_label)

% for i=1:layer-1
%     figure;
%     hist(weight{i}(:),100);
%     figure;
%     hist(weight_Inv{i}(:),100);
% end;

% for i=1:layer
%     mean(mean(act(neuron{i})))
% end;