function[LL] = cl_loglikelihood4(parameters)
% estimation including interaction variables
% parameters 22 + 11 parameters

global DATA
global total_individuals
global characteristics
global personIDS

logprobabilities = [];
chosen = DATA(:,5);

for i = 1:total_individuals
    xmatrix = DATA(DATA(:,1) == personIDS(i),6:26);
    lifeyears = DATA(DATA(:,1) == personIDS(i),27);
%     AD2 = DATA(DATA(:,1) == personIDS(i), 23);
%     PD2 = DATA(DATA(:,1) == personIDS(i), 19);
%     UA2 = DATA(DATA(:,1) == personIDS(i), 15);
%     SC2 = DATA(DATA(:,1) == personIDS(i), 11);
%     MO2 = DATA(DATA(:,1) == personIDS(i), 7);
    interaction =  DATA(DATA(:,1) == personIDS(i), 6);%MO2+SC2+UA2+PD2+AD2;
    person_characteristics = characteristics(characteristics(:,1) == personIDS(i), 2:12);
    
    interaction = interaction .* repmat(person_characteristics, 48, 1);
    xmatrix = [xmatrix interaction];
    xmatrix = xmatrix .*lifeyears;
    alpha1 = repmat([0;1;1;0], 12, 1);
    xmatrix = [alpha1 xmatrix];
    
    numerators = exp(xmatrix*parameters');
    denominators = movsum(numerators,2);
    denominators = denominators(2:2:end);
    denominators = reshape(repmat(denominators', 2, 1), 1, [])';
    
    logprobabilities = [logprobabilities; log(numerators ./denominators)];
    
end

LL = chosen'*-logprobabilities;

end