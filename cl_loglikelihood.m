function [LL] = cl_loglikelihood(x, a, b)
% a = chosen alternative
% b = matrix including the parameters for all alternatives for each choice
% task
% x = beta
% this loglikelihood function uses data with two alternatives per choice
% task

logprobabilities = [];
totalalternatives = 2;
totalindividuals = 430;
ugh = x;

for i = 1:totalindividuals*24
    sub_b = b(1+totalalternatives*(i-1):totalalternatives*i,:);
    numerator1 = exp(x*sub_b(1,1:(end-1))'*sub_b(1,end));
    numerator2 = exp(x*sub_b(2,1:(end-1))'*sub_b(2,end));
    denominator = numerator1+numerator2;
    
    probability1 = log(numerator1/denominator);
    probability2 = log(numerator2/denominator);
    
    logprobabilities = [logprobabilities; probability1; probability2];
end

LL = a'*-logprobabilities;

end
