function[LL] = cl_loglikelihood4(parameters)
% estimation including interaction variables
% parameters 22 + 11 parameters

global DATA
global total_individuals
global characteristics
global personIDS

parameters_beta = parameters(1:21); % 1x21 vector
parameters_characteristics = parameters(22:end); %1x65 vector
parameters_characteristics = reshape(parameters_characteristics, 5, 13);
parameters_characteristics = repelem(parameters_characteristics, 4, 1);
characteristics1 = zeros(21,13);
characteristics1(2:end, :) = parameters_characteristics;

logprobabilities = [];
chosen = DATA(:,5);

for i = 1:total_individuals
    xmatrix = DATA(DATA(:,1) == personIDS(i),6:26);
    lifeyears = DATA(DATA(:,1) == personIDS(i),27);
    xmatrix = xmatrix.*lifeyears;
    
    person_characteristics = characteristics(characteristics(:,1) == personIDS(i),2:end);
    person_characteristics = repmat(person_characteristics, 21, 1); %20x13 matrix
    
    pc = person_characteristics .* characteristics1;
    pc = sum(pc, 2) + 1;
    
    parameters_beta = parameters_beta .* pc';
    
    numerators = exp(xmatrix*parameters_beta');
    denominators = movsum(numerators,2);
    denominators = denominators(2:2:end);
    denominators = reshape(repmat(denominators', 2, 1), 1, [])';
    
    logprobabilities = [logprobabilities; log(numerators ./denominators)];
    
end

LL = chosen'*-logprobabilities;

end