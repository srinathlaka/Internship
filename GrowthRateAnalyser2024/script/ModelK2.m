function Xm = ModelK2(time,parameters0)

%recover the parameters if needed
a0 = parameters0.a0;
b0 = parameters0.b0;
k0 = parameters0.k0;

%model function
Xm = a0.*((time)./(time+k0)) + b0;

end
