function [s] = act(x,id)
% active function

% a=-0.1;
% b=a+1;
% c=1;
r_m=10;
th=1.6/5.4/r_m;

if nargin==1
    id=0;
end;
if id==0
%     s=min(b,max(a,x))-a;
%     s=min(1,max(0,x));
%     s=1./(1+exp(c*(1-2*x)));
%     s=10*max(0,x-th);
%     s=max(0,x-th)+th;
%     s=1/10./log((s+1)./(s-1.6));
    s=(1+r_m*x)/20./log((1+8*r_m*x)./(-1.6+5.4*r_m*x));
    s(x<th)=0;
elseif id==1;
%     s=double(x<=b & x>=a);
%     s=double(x<=1 & x>=0);
%     s=2*c*exp(c*(1-2*x))./(1+exp(c*(1-2*x))).^2;
    s=ones(size(x));
end;

end