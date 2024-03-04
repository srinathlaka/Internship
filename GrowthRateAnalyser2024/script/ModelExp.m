function Xm = ModelExp(time,parameters)

%recover the parameters if needed
mu = parameters.mu;
x0 = parameters.x0;

%model function

Xm = x0.*(exp(mu.*time));

end
