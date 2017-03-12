L=20;
g=zeros(L,1);
g(1)=0.5;
A=12;
B=0.2;
for i=2:L
g(i)=A*g(i-1)+B;
end;
plot(1:L,g(1:L));