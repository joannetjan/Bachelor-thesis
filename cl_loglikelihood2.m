function[LL] = cl_loglikelihood2(parameters, a, b)
% parameters = estimates
% a = chosen alternatives per choicetask and per individual
% b = corresponding variables for each alternative

LL = 0;
logprobabilities = [];
totalalternatives = 2;

for i = 1:10320
    sub_b = b(1+totalalternatives*(i-1):totalalternatives*i,:);
   
    x1 = sub_b(1,1:21);
    x2 = sub_b(2,1:21);
    
    z1 = sub_b(1, 22:26);
    z2 = sub_b(2, 22:26);
    
    life_years1 = sub_b(1, end);
    life_years2 = sub_b(2, end);
    
    beta1 = parameters(1:21);
    gamma1 = parameters(22:26);
    
    mu1 = model2(beta1, x1, gamma1, z1);
    mu2 = model2(beta1, x2, gamma1, z2);
    
    numerator1 = exp(mu1*life_years1);
    numerator2 = exp(mu2*life_years2);
    denominator = numerator1+numerator2;
    
    probability1 = log(numerator1/denominator);
    probability2 = log(numerator2/denominator);
    
    logprobabilities = [logprobabilities; probability1; probability2];
end

LL = a'*-logprobabilities;

end