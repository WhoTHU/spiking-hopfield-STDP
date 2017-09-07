
load('../data/data_mnist.mat');	% load dataset

train_data=train_data(:,1:train_num);
train_label=train_label(:,1:train_num);
test_data=test_data(:,1:test_num);
test_label=test_label(:,1:test_num);

neuron_P=cell(para.layer,1);
neuron_P_t=cell(para.layer,1);
neuron_V=cell(para.layer,1);
neuron_V_t=cell(para.layer,1);
s0_P=cell(para.layer,1);
s0_V=cell(para.layer,1);
for j=1:layer
    neuron_P{j}=zeros(n_layer(j),train_num);
    neuron_P_t{j}=zeros(n_layer(j),test_num);
    neuron_V{j}=random('uni',para.V_reset,para.V_th,n_layer(j),train_num);
    neuron_V_t{j}=random('uni',para.V_reset,para.V_th,n_layer(j),test_num);
end;
neuron_P{1}=para.I0*train_data;
neuron_P_t{1}=para.I0*test_data;