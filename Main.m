%% Main model to run

global DATA
global DATAGAMMA
global DISTRIBUTION1
global DISTRIBUTION2
global total_alternatives
global total_individuals
global total_characteristics
global impaired_healthstates
global personIDS
global characteristics
global R
global MAXITER
global SEED1

%%  Initialization
total_alternatives = 2;
total_individuals = 430;
total_characteristics = 13; %including imp aired health states
impaired_healthstates = 2;
R = 10;
MAXITER = 10;
SEED1 = 23;

%% Retrieve data set

% version1 = csvread('enquete1.csv');
% version = retrieve_version(version1);
% version, lifeyears, healthstates, surveynumericalvalues, completedataset
% import
disp(' ');
disp('Start retrieving the required data set for estimation');

% [DATA, survey, states, characteristics] = retrieve_dataset(datasetextracharacteristics, version, lifeyears, healthstates);
% personIDS = unique(DATA(:,1));
% DATAGAMMA = retrieve_gamma(states, surveynumericalvalues);


disp('Data retrieval is completed');
disp(' ');
%% Input initialization

disp('Setting up parameters for initialization');

initialization01 = zeros(1,21); %option B is zero for identification
initialization02 = zeros(1,26);
initialization03 = zeros(1,21+total_characteristics);% zeros(1,22+impaired_healthstates);

initialization11 = [ones(1,1) ones(1,20)*-0.5 ones(1,21)*0.5];
initialization12 = [ones(1,1) ones(1,20)*-0.5 ones(1,31)*0.5];
initialization13 = ones(1,14);

%% Lower and upperbound initialization
disp('Setting boundaries for minimzation (only for fmincon)');

upperbound01 = [ones(1,2)*Inf zeros(1,20)];
lowerbound01 = [-Inf zeros(1,1) ones(1,20)*-Inf];

upperbound02 = [ones(1,1)*Inf zeros(1,20) ones(1,5)*Inf];
lowerbound02 = [0 ones(1,20)*-Inf ones(1,5)*-Inf];

upperbound03 = [Inf zeros(1,20) ones(1,total_characteristics)*Inf];
lowerbound03 = [0 ones(1,20)*-Inf ones(1,total_characteristics)*-Inf];

upperbound11 = [ones(1,2)*Inf zeros(1,20) ones(1,22)*Inf];
lowerbound11 = [ones(1,1)-Inf zeros(1,1) ones(1,20)*-Inf zeros(1,22)];

upperbound12 = [Inf zeros(1,20) ones(1,31)*Inf];
lowerbound12 = [0 ones(1,20)*-Inf ones(1,5)*-Inf zeros(1,26)];

%% Distribution setup for mixed logit model
disp('Making draws from a standard normal distribution');

randn('state',SEED1)  %For draws from normal
rand('state',SEED1)   %For draws from uniform
DISTRIBUTION1 = makedraws(21); %make standard normal distribution draws
DISTRIBUTION1 = permute(DISTRIBUTION1, [3,2,1]); %rescaling

DISTRIBUTION2 = makedraws(26);
DISTRIBUTION2 = permute(DISTRIBUTION2, [3,2,1]);

%% Conditional logit model
disp(' ');
disp('Next step is parameter estimation using the conditional logit model.');

% % model 1
% disp('Start estimation standard model with main effects.');
% tic;
% % options = optimoptions('fmincon','Display','iter','MaxFunEvals',10000,...
% %     'TolX',0.000001);
% options = optimoptions('fminunc','Display','iter','MaxFunEvals',10000,...
%     'TolX',0.000001, 'DerivativeCheck','off');
% 
% % [parameters01, fval01, exitflag01, output01,lambda01, grad01, hessian01] = fmincon(@cl_loglikelihood, initialization01, [],[],[],[], lowerbound01, upperbound01, [], options1);
% [parameters01, fval01, exitflag01, output01, grad01, hessian01] = fminunc(@cl_loglikelihood, initialization01, options);
% 
% disp(' ');
% disp(['Estimation took for model 1 conditional logit model ' num2str(toc./60) ' minutes.']);
% disp(' ');
% parameters01 = parameters01';
% 
% % model 2
% disp('Start estimation model with reference dummies');
% tic;
% % options = optimoptions('fmincon','Display','iter','MaxFunEvals',10000,...
% %     'TolX',0.000001, 'DerivativeCheck','off');
% options = optimoptions('fminunc','Display','iter','MaxFunEvals',10000,...
%     'TolX',0.000001, 'DerivativeCheck','off');
% 
% % [parameters02, fval02, exitflag02, output02, lambda02, grad02, hessian02] = fmincon(@cl_loglikelihood2, initialization02, [],[],[],[], lowerbound02, upperbound02, [], options);
% [parameters02, fval02, exitflag02, output02, grad02, hessian02] = fminunc(@cl_loglikelihood2, initialization02,  options);
% 
% disp(' ');
% disp(['Estimation took for model 2 conditional logit model ' num2str(toc./60) ' minutes.']);
% disp(' ');
% parameters02 = parameters02';
% 
% % model 3
% disp('Start estimation model with characteristics in full health');
% 
% tic;
% % options = optimset('LargeScale','off','Display','iter',...
% %     'MaxFunEvals',10000, 'TolX',0.000001,'TolFun',[],'DerivativeCheck','off');
% options = optimoptions('fminunc','Display','iter','MaxFunEvals',10000,...
%     'TolX',0.000001, 'DerivativeCheck','off');
% [parameters03, fval03, exitflag03, output03, grad03, hessian03] = fminunc(@cl_loglikelihood3, initialization03, options);
% disp(' ');
% disp(['Estimation took for model 3 conditional logit model ' num2str(toc./60) ' minutes.']);
% disp(' ');

parameters03 = parameters03';

% model 4
% disp('Start estimation model with interaction variables');
% 
% tic;
% % options = optimset('LargeScale','off','Display','iter',...
% %     'MaxFunEvals',10000, 'TolX',0.000001,'TolFun',[],'DerivativeCheck','off');
% options = optimoptions('fminunc','Display','iter','MaxFunEvals',10000,...
%     'TolX',0.000001, 'DerivativeCheck','off');
% [parameters04, fval04, exitflag04, output04, grad04, hessian04] = fminunc(@cl_loglikelihood4, initialization04, options);
% disp(' ');
% disp(['Estimation took for model 4 conditional logit model ' num2str(toc./60) ' minutes.']);
% disp(' ');
% 
% parameters04 = parameters04';


%% Mixed logit model
disp(' ');
disp('Next step is parameter estimation using the mixed logit model.');

% % model 1
% disp('Start estimation standard model:');
% tic;
% % options = optimset('LargeScale','off','Display','iter',...
% %     'MaxFunEvals',10000,'MaxIter',MAXITER,'TolX',0.000001,...
% %     'TolFun',[],'DerivativeCheck','off');
% options = optimoptions('fminunc','Display','iter','MaxFunEvals',100000,...
%     'TolX',0.000001, 'DerivativeCheck','off');
% 
% [parameters11, fval11, exitflag11, output11, grad11, hessian11] = fminunc(@mixl_loglikelihood, initialization11, options);
% % [parameters11, fval11, exitflag11, output11, lambda11, grad11, hessian11] = fmincon(@mixl_loglikelihood, initialization11, [], [], [], [], [], [], [], options);
% 
% disp(' ');
% disp(['Estimation took for model 1 mixed logit model ' num2str(toc./60) ' minutes.']);
% disp(' ');
% parameters11 = parameters11';

% % model 2
disp('Start estimation model with references dummies.');
tic;
% options = optimset('LargeScale','off','Display','iter',...
%     'MaxFunEvals',10000,'MaxIter',MAXITER,'TolX',0.000001,'TolFun',[],'DerivativeCheck','off');
options = optimoptions('fminunc','Display','iter','MaxFunEvals',100000,...
    'TolX',0.000001,'MaxIter', MAXITER, 'DerivativeCheck','off');

% [parameters12, fval12, exitflag12, output12, lambda12, grad12, hessian12] = fmincon(@mixl_loglikelihood2, initialization12, [],[],[],[], lowerbound12, upperbound12, [], options);
[parameters12, fval12, exitflag12, output12, grad12, hessian12] = fminunc(@mixl_loglikelihood2, initialization12, options);
parameters12 = parameters12';
% 20 hours for 140 iterations, 9955 function founts and no convergence
disp(' ');
disp(['Estimation for model 2 mixed logit model took ' num2str(toc./60) ' minutes.']);
disp(' ');

% % model 3
% disp('Start estimation model with individual-specific data.');
% tic;
% 
% % options = optimset('LargeScale','off','Display','iter',...
% %     'MaxFunEvals',10000,'MaxIter',MAXITER,'TolX',0.000001,'TolFun',[],'DerivativeCheck','off');
% options = optimoptions('fminunc','Display','iter','MaxFunEvals',100000,...
%     'TolX',0.000001,'MaxIter', MAXITER, 'DerivativeCheck','off');
% 
% % [parameters12, fval12, exitflag12, output12, lambda12, grad12, hessian12] = fmincon(@mixl_loglikelihood2, initialization12, [],[],[],[], lowerbound12, upperbound12, [], options);
% [X, Y] = mixl_loglikelihood3(pylogit21);
% 
% disp(' ');
% disp(['Estimation for model 3 mixed logit model took ' num2str(toc./60) ' minutes.']);
% disp(' ');

