function[p] = mxll(beta1, sigma1)

global DISTRIBUTION1
global DATA
global total_individuals
global personIDS
global R

% sigma0 = exp(sigma0);
cd = diag(chol(eye(21).*sigma1));
c = repmat(beta1',[1,total_individuals,R])+repmat(cd, [1,total_individuals,R]).*DISTRIBUTION1;
c = permute(c, [3,1,2]);

p = zeros(total_individuals, 1);

for i = 1:total_individuals
    x_variables = DATA(DATA(:,1) == personIDS(i), 6:26);
    chosen = DATA(DATA(:,1) == personIDS(i), 5);
    lifeyears = DATA(DATA(:,1) == personIDS(i), 27);
    
    sum_per_i = 0;
    distribution_per_individual = c(:,:,i);
    x_variables = x_variables.*lifeyears; %
    
    for r = 1:R
        draw = distribution_per_individual(r,:);
        num = exp(x_variables*draw'); %

        denom = movsum(num,2);
        denom = denom(2:2:end);
        denom = reshape(repmat(denom', 2, 1), 1, [])';
        
        prob = num ./denom;
        prob = prob.^chosen;
        prob = log(prob);
        
        sum_per_i = sum_per_i+exp(sum(prob));
        
    end
    p(i) = sum_per_i/R;
end


end