function Xm = ModelLagExp(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;
q0 = parameters.q0;

%model function
Xm = (x0.*(1 + q0.*exp(mu.*time))./(1 + q0));

end
