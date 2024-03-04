function i = findTimeDeath(X,tdrug,tfin)
n=20;
[Vmin,imin] = min(X(tdrug+n:tfin ));
[Vmax,imax] = max(X(tdrug+n:tfin ));

if imax<imin
    i=n+tdrug+imax-1;
else
    i=n+tdrug+imin-1;
end

end