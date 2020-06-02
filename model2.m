function[value] = model2(beta0, x, gamma0, z)
%calculate mu of model specification 2

value = 0;
z_fullformat = 0;
gamma_fullformat = 0;
for j = 1:length(z)
    z_fullformat = [z_fullformat ones(1,4)*z(j)];
    gamma_fullformat = [gamma_fullformat ones(1,4)*gamma0(j)];
end

for k = 1:length(x)
    value = value + (beta0(k)*(1+z_fullformat(k)*gamma_fullformat(k)))*x(k);
end
end