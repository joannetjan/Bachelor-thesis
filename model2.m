function[value] = model2(beta0, x, gamma0, z)
%calculate mu of model specification 2

value = 0;
z_fullformat = zeros(1,22);
gamma_fullformat = zeros(1,22);

gamma0 = repmat(gamma0, 4, 1);
z = repmat(z, 4, 1);

gamma_fullformat(3:end) = reshape(gamma0, 1, []);
z_fullformat(3:end) =  reshape(z, 1, []);

% value = sum(beta0' .* (ones(22,1) + z_fullformat'.*gamma_fullformat').*x');

for k = 1:length(x)
    value = value + (beta0(k)*(1+z_fullformat(k)*gamma_fullformat(k)))*x(k);
end

end