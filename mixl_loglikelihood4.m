function[X, Y] = mixl_loglikelihood4(parametershat)

global total_individuals
global DATA
global characteristics
global DISTRIBUTION1
global personIDS
global R

%hou voorlopig 21 parameters aan zonder alpha

beta3 = parametershat(1:21); % mean of all beta_j
sigma3 = abs(parametershat(22:42));

cd = diag(chol(diag(sigma3)));
c = repmat(beta3,[1,total_individuals,R])+repmat(cd, [1,total_individuals,R]).*DISTRIBUTION1;
c = permute(c, [3,1,2]);

% first estimate the expectation of beta_i given y_it
expectation_betai = zeros(total_individuals, 22);

for i = 1:total_individuals
    x_variables = DATA(DATA(:,1) == personIDS(i), 6:26);
    chosen = DATA(DATA(:,1) == personIDS(i), 5);
    lifeyears = DATA(DATA(:,1) == personIDS(i), 27);
    x_variables = x_variables.*lifeyears; %
    
    %     alpha1 = repmat([0;1;1;0], 12, 1);
    %     x_variables = [alpha1 x_variables]; 
    
    numerator = 0;
    denominator = 0;
    
    distribution_per_individual = c(:,:,i);
    for r = 1:R
        beta_im = distribution_per_individual(r,:);
        num = exp(x_variables*beta_im');
        
        denom = movsum(num,2);
        denom = denom(2:2:end);
        denom = repmat(denom', 2, 1); %check if this is possible
        denom = reshape(denom, 1, [])';    
        
        probabilities = num./denom;
        probabilities = probabilities .^chosen;
        prob = prod(probabilities);
        
        expect = beta_im .* prob;
        numerator = numerator + expect;
        denominator = denominator + prob;
    end
    
    numerator = numerator ./ R;
    denominator = denominator ./ R;
    
    expectations = numerator / denominator;
    expectation_betai(i,:) = [personIDS(i) expectations];
    
end

temp = zeros(total_individuals*21, 16);

% now perform univariate regression, expectation_betai = 430x22 matrix
% prepare data set for regression

for i = 1:total_individuals
    y = beta3'-expectation_betai(i,2:end);
    traits = characteristics(i,2:end);
    traits = repmat(traits, 21, 1);
    person = repmat(personIDS(i), 21, 1);
    temp((i-1)*21+1:i*21,:) = [person y' ones(21,1) traits];
end

% univariate regression
X = temp(:, 3:end);
Y = temp(:, 2);
% 
% [b, bint] = regress(Y,X);
% 
% results = [b bint];

% multivariate regression

end