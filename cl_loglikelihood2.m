function[LL] = cl_loglikelihood2(parameters)

global DATAGAMMA
global total_individuals
global personIDS

parameters_beta = parameters(1:21);
parameters_gamma = parameters(22:26);

logprobabilities = [];
chosen = DATAGAMMA(:,5);

for i = 1:total_individuals
    xmatrix = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i),:);
    lifeyears = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i),27);
    
    xmatrix(:,6:26) = xmatrix(:,6:26).*lifeyears;
%     alpha1 = repmat([0;1;1;0], 12, 1);
%     xmatrix = [xmatrix(:, 1:5) alpha1 xmatrix(:, 6:end)];
    xmatrix(:,27) = [];
    x_variables = xmatrix(:, 6:26);
    z_variables = xmatrix(:, 27:31);
    num = zeros(48,1);
    
    for t = 1:48
        x = x_variables(t,:);
        z = z_variables(t,:);
        num(t) = model2(parameters_beta, x, parameters_gamma, z);
        
    end
    
    num = exp(num);
    
    denom = movsum(num,2);
    denom = denom(2:2:end);
    denom = reshape(repmat(denom', 2, 1), 1, [])';
    probabilities = log(num./denom);
    logprobabilities = [logprobabilities; probabilities];
    
end

LL = chosen'*-logprobabilities;

end