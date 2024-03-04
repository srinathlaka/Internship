function f = ThetaFunction(t1,t2)

f = zeros(size(t1,1),size(t1,2));
for i=1:size(t1,1)
    if t1(i)>=t2(i)
        f(i) = 1;
    else
        f(i) = 0;
    end
end

end