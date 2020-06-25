function[LL] = mixl_loglikelihood(parameters)

beta1 = parameters(1:21);
sigma1 = abs(parameters(22:42));

probabilities = mxll(beta1, sigma1);

LL = -sum(log(probabilities));

end