function[LL] = cl_loglikelihood3(parameters)
% estimates the parameters in which the  characteristics are included in
% the intercept to determine the different interpretation of full health

global DATA
global total_individuals
global characteristics
global personIDS


parameters_beta = parameters(1:21);
parameters_characteristics = parameters(22:end);
logprobabilities = [];
chosen = DATA(:,5);

for i = 1:total_individuals
    xmatrix = DATA(DATA(:,1) == personIDS(i),6:26);
    lifeyears = DATA(DATA(:,1) == personIDS(i),27);
    
    %  13:14 for N4 and N5 term
    person_characteristics = characteristics(characteristics(:,1) == personIDS(i),2:end);
    c = (person_characteristics * parameters_characteristics')+1;
    parameters_beta = parameters_beta.*c;
%     person_characteristics = repmat(person_characteristics, 48, 1);
%     xmatrix = [xmatrix person_characteristics];
    
    xmatrix = xmatrix.*lifeyears;
    
    numerators = exp(xmatrix*parameters_beta');
    denominators = movsum(numerators,2);
    denominators = denominators(2:2:end);
    denominators = reshape(repmat(denominators', 2, 1), 1, [])';

    logprobabilities = [logprobabilities; log(numerators ./denominators)];
    
end

LL = chosen'*-logprobabilities;

end