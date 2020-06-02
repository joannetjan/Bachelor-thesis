function[p] = mxll(beta0, sigma0)
% beta0 = row vector
% sigma0 = row vector

global DISTRIBUTION1
global DATA
global total_individuals
global total_alternatives
global personIDS
global R

c = repmat(beta0',[1,total_individuals,R])+repmat(sigma0', [1,total_individuals,R]).*DISTRIBUTION1;
c = permute(c, [3,1,2]);

p = zeros(total_individuals, 1);

for i = 1:total_individuals
    
    x_variables = DATA(DATA(:,1) == personIDS(i), 6:26);
    chosen = DATA(DATA(:,1) == personIDS(i), 5);
    lifeyears = DATA(DATA(:,1) == personIDS(i), 27);

    sum_per_i = 0;
    
    distribution_per_individual = c(:,:,i);
    
    for r = 1:R
        draw = distribution_per_individual(r,:);
        l_ita = zeros(24,1);
        
        for t = 1:24
            probabilities = zeros(2,1);
            
            xx = x_variables(1+((t-1)*total_alternatives):t*total_alternatives,:);
            yy = chosen(1+((t-1)*total_alternatives):t*total_alternatives,:);
            zz = lifeyears(1+((t-1)*total_alternatives):t*total_alternatives,:);
            
            x1 = xx(1,1:21);
            x2 = xx(2,1:21);
            
            lifeyears1 = zz(1);
            lifeyears2 = zz(2);
            
            numerator1 = exp(draw*x1'*lifeyears1);
            numerator2 = exp(draw*x2'*lifeyears2);
            denominator = numerator1+numerator2;
            
            probabilities(1) = numerator1/denominator;
            probabilities(2) = numerator2/denominator;
            
            l_ita(t) = (probabilities(1)^yy(1))*(probabilities(2)^yy(2));
        end
        
        sum_per_i = sum_per_i+prod(l_ita);
        
    end
    p(i) = -log(sum_per_i/R);
end


end