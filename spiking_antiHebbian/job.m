
Initialize;
weight_dec=0;
para.n_layer=[28*28,500,10];
Loaddata;
Sym;
save(['result/result_H500_D0.mat']);

Initialize;
weight_dec=2;
para.n_layer=[28*28,500,10];
Loaddata;
Sym;
save(['result/result_H500_D2.mat']);


Initialize;
weight_dec=5;
para.n_layer=[28*28,500,10];
Loaddata;
Sym;
save(['result/result_H500_D5.mat']);

