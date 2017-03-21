for i=1:10
    figure;
    subplot(3,1,1);
    scatter(test_data(1,:),neuron(i,:));
    subplot(3,1,2);
    scatter(test_data(2,:),neuron(i,:));
    subplot(3,1,3);
    scatter(test_data(1,:)-test_data(2,:),neuron(i,:));
end;