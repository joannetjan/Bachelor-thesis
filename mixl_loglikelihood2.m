function[LL] = mixl_loglikelihood2(parameters)

beta2 = parameters(1:26);
sigma2 = abs(parameters(27:52));

probabilities = mxll2(beta2, sigma2);

LL = sum(probabilities);

end