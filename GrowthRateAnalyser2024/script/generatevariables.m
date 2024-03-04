N = 10;          % number of variables
%method 1
for k=1:N
    temp_var = strcat( 'variable_',num2str(k) );
    %eval(sprintf('%s = %g',temp_var,k*2));
end
%%
% method 2, more advisable
for k=1:N
    my_field = strcat('v',num2str(k));
    variable.(my_field) = k*2;
end
%%
for i=1:3
    eval(['A' num2str(i) '= i'])
end
%%
expN = 1; %%CHANGE
a = eval(['bkg' num2str(expN) '= 0'])