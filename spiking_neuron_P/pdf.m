tic
clear;
rho=0.4;
t_md=100;
t_w=50;
dt=1;
dx=0.1;
x_max=500;
x=0:dx:(x_max*dx);
x_pdf=zeros(size(x));
num=5000;
for i_num=1:num;
    s=0;
    for i_t=0:dt:t_w
        s=s+random('Poisson',dt*rho)*exp(-i_t/t_md);
    end;
    ind=min(x_max,floor(s/dx));
    x_pdf(ind)=x_pdf(ind)+1;
end;
x_pdf=x_pdf/num;
plot(x,x_pdf);

ti=toc