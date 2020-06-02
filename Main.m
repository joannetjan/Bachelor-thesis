%% Main model to run

global DATA
global DATAGAMMA
global DISTRIBUTION1
global DISTRIBUTION2
global total_alternatives
global total_individuals
global personIDS
global R
global MAXITER
global SEED1
%%  Initialization
total_alternatives = 2;
total_individuals = 430;
R = 200;
MAXITER = 10;
SEED1 = 23; 
%% Retrieve data set

% version1 = csvread('enquete1.csv');
% version = retrieve_version(version1);
% version, lifeyears, healthstates, surveynumericalvalues, completedataset
% import
[DATA, survey, states] = retrieve_dataset(completedataset, version, lifeyears, healthstates);
DATAGAMMA = retrieve_gamma(DATA, states, surveynumericalvalues);
personIDS = unique(DATA(:,1));
%% Input initialization

initialization01 = zeros(1,21);
initialization02 = zeros(1,26);
initialization11 = [beta01 ones(1,21)*0.5];
initialization12 = [beta02 ones(1,26)*0.5];

% retrieve_gamma = for model 2, parameters = data, health state option and
% version
%% Conditional logit model
% % model 1
% XMATRIX01 = DATA(:, 6:end);
% CS01 = DATA(:, 5);
% 
% [parameters01, fval01, exitflag,output,grad,hessian01] = fminunc(@(parameters01) cl_loglikelihood(parameters01, CS01, XMATRIX01), beta01, options);
% % [parameters_model1, fval_model1] = fminunc(@(parameters) CL_LL(parameters,alldata3), [2 ones(1,20)*-0.5]);
% coefficients01 = parameters01';
% standard_errors01 = sqrt(diag(inv(hessian01)));
% 
% % model 2
% XMATRIX02 = [DATAGAMMA(:,6:26) DATAGAMMA(:, 28:32) DATAGAMMA(:,27 )];
% CS02 = DATAGAMMA(:,5);
% [parameters02, fval, exitflag,output,grad,hessian02] = fminunc(@(parameters02) cl_loglikelihood2(parameters02, CS02, XMATRIX02), beta02, options);
% beta02 = parameters02;
% [parameters02, fval, exitflag,output,grad,hessian02] = fminunc(@(parameters02) cl_loglikelihood2(parameters02, CS02, XMATRIX02), beta02, options);
% 
% coefficients02 = parameters02';
% standard_errors02 = sqrt(diag(inv(hessian02)));
% model 3
%% Mixed logit model
% write function to estimate the simulated log likelihood function
% apply fminunc to obtain estimates
% pray the parameters are negative

randn('state',SEED1)  %For draws from normal
rand('state',SEED1)   %For draws from uniform
DISTRIBUTION1 = makedraws(21); %make standard normal distribution draws
DISTRIBUTION1 = permute(DISTRIBUTION1, [3,2,1]); %rescaling

DISTRIBUTION2 = makedraws(26);
DISTRIBUTION2 = permute(DISTRIBUTION2, [3,2,1]);

% model 1
% tic;
% options = optimset('LargeScale','off','Display','iter',...
%     'MaxFunEvals',10000,'MaxIter',MAXITER,'TolX',0.000001,'TolFun',[],'DerivativeCheck','off');
% 
% [parameters11, fval, exitflag,output,grad,hessian11] = fminunc(@mixl_loglikelihood, initialization11, options);
% disp(' ');
% disp(['Estimation took ' num2str(toc./60) ' minutes.']);
% disp(' ');
% coefficients11 = parameters11';
% standard_errors11 = []; %discuss this with supervisor

% model 2
options = optimset('LargeScale','off','Display','iter',...
    'MaxFunEvals',10000,'MaxIter',2,'TolX',0.000001,'TolFun',[],'DerivativeCheck','off');

[parameters12, fval, exitflag,output,grad,hessian12] = fminunc(@mixl_loglikelihood2, initialization12, options);

