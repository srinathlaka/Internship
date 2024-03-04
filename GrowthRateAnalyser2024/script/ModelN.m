function Xm = ModelN(time,parameters0)

%recover the parameters if needed
a0 = parameters0.a0;
b0 = parameters0.b0;
n = parameters0.n;

%model function
Xm = a0.*(time).^n + b0;

end
