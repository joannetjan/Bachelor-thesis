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
    xmatrix(:,27) = [];
    x_variables = xmatrix(:, 6:26);
    z_variables = xmatrix(:, 27:31);
    
    temp1 = zeros(48,21); % tranform z matrix into longformat
    for number = 1:48
        z = z_variables(number,:);
        temp1(number,2:end) = repelem(z, 4);
    end
    
    temp2 = repelem(parameters_gamma, 4);
    temp2 = repmat(temp2, 48, 1); %gamma 48x21 matrix
    gamma1 = zeros(48,21);
    gamma1(:, 2:end) = temp2;
    
    rf = (temp1.*gamma1)+1;
    rf = rf.*parameters_beta;
    
    num = rf.*x_variables;
    num = sum(num,2);
    num = exp(num);
    
    denom = movsum(num,2);
    denom = denom(2:2:end);
    denom = reshape(repmat(denom', 2, 1), 1, [])';
    probabilities = log(num./denom);
    logprobabilities = [logprobabilities; probabilities];
    
end

LL = chosen'*-logprobabilities;

end