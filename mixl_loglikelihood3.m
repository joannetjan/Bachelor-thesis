function[LL] = mixl_loglikelihood3(parameters)

beta3 = parameters(1:86);
sigma3 = abs(parameters(87:172));

probabilities = mxll3(beta3, sigma3);

LL = sum(probabilities);

end