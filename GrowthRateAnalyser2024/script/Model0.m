function Xm = Model0(time,parameters0)

%recover the parameters if needed
a0 = parameters0.a0;
b0 = parameters0.b0;
k0 = parameters0.k0;

%model function
%Xm = -(a0.*time)./(time+k0);
%Xm = -a0.*nthroot(time,k0)+b0;
Xm = -k0.*((time)./(time+a0)) + b0;

end
