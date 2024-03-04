function Xm = ModelExponential(time,parameters)

%recover the parameters if needed
mu0 = parameters.mu0;
x0 = parameters.x0;

%model function
Xm = x0.*exp(mu0*time);

end
