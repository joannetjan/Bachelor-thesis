function[LL] = mixl_loglikelihood(parameters)

beta0 = parameters(1:21);
sigma0 = abs(parameters(22:42));

probabilities = mxll(beta0, sigma0);

LL = -sum(log(probabilities));

end