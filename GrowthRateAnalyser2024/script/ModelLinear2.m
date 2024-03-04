function Xm = ModelLinear2(time,parameters)

%recover the parameters if needed
x0 = parameters.x0;
klag = parameters.klag;

%model function


Xm = ((klag.*time)+x0);


end
