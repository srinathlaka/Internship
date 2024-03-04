function Xm = ModelExpSaturation(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
k = parameters.k;

%model function

Xm = ((x0).*(exp(mu.*(time)))./(1+((x0)./k).*(exp(mu.*(time))-1)));

end
