function[LL] = mixl_loglikelihood2(parameters)

beta1 = parameters(1:26);
sigma1 = parameters(27:52);

probabilities = mxll2(beta1, sigma1);

LL = sum(probabilities);

end