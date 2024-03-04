function Xm = ModelK(time,parameters0)

%recover the parameters if needed
a0 = parameters0.a0;
b0 = parameters0.b0;
k0 = parameters0.k0;

%model function
Xm = k0.*((time)./(time+a0)) + b0;

end
