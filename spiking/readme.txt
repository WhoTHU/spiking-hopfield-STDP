You only need to use these:

main.m		main program
Sim.m
flo.m		
Initialize.m
Loaddata.m
show.m		show result

And others are for debugging. If you want to change the size of the network or other parameter, change the corresponding variables defined in the 'Initialize.m'.

The default dataset is MNIST, and if you want to test another dataset, please modify the path definded in 'Loaddata.m'. The format of dataset file should be regularized as follows:

'test_data'	(length of input vector)*(example amount)	% a single example should be reshaped as a line vector
'test_lable'	(1)*(example amount)				% each represent a label index \in {0,1,2,...} the size of this set should be identified with the size of last layer neurons of the network
'train_data'	(length of input vector)*(example amount)
'train_lable'	(1)*(example amount)

