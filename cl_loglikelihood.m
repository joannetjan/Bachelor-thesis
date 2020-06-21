function [LL] = cl_loglikelihood(parameters)

global DATA
global total_individuals
global personIDS

logprobabilities = [];
chosen = DATA(:,5);

for i = 1:total_individuals
    xmatrix = DATA(DATA(:,1) == personIDS(i),6:26);
    lifeyears = DATA(DATA(:,1) == personIDS(i),27);
    
    xmatrix = xmatrix.*lifeyears;
    alpha1 = repmat([0;1;1;0], 12, 1);
    
%     xmatrix = [alpha1 xmatrix];
    numerators = exp(xmatrix*parameters');
    denominators = zeros(48,1);
    
    for t = 1:2:47
        temp = numerators(t:t+1,:); %
        temp_denominator = sum(temp); %
        denominators(t:t+1) = ones(2,1)*temp_denominator; %
    end
    
    logprobabilities = [logprobabilities; log(numerators ./denominators)];
    
end

LL = chosen'*-logprobabilities;

end
