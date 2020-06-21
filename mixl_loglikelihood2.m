function[LL] = mixl_loglikelihood2(parameters)

beta1 = parameters(1:27);
sigma1 = abs(parameters(28:54));

probabilities = mxll2(beta1, sigma1);

LL = sum(probabilities);

end