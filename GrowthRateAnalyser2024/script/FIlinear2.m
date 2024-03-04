function Xm = FIlinear2(time,parameters)

%recover the parameters if needed
m1 = parameters.p(1);
q1 = parameters.p(2);
T1t = parameters.p(3);
m2 = parameters.p(4);

T1 = T1t.*ones(size(time,1),size(time,2));

%model function

Xm = (m1.*time + q1).*heaviside(T1-time) + (m2.*(time-T1) +m1.*T1 + q1).*heaviside(time-T1);

end
