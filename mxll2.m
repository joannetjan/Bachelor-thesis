function[p] = mxll2(beta1, sigma1)

global DISTRIBUTION2
global DATAGAMMA
global total_individuals
global total_alternatives
global personIDS
global R

c = repmat(beta1',[1,total_individuals,R])+repmat(sigma1', [1,total_individuals,R]).*DISTRIBUTION2;
c = permute(c, [3,1,2]);

p = zeros(total_individuals, 1);

for i = 1:total_individuals
    
    x_variables = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 6:26);
    z_variables = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 28:32);
    chosen = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 5);
    lifeyears = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 27);
    
    sum_per_i = 0;
    
    distribution_per_individual = c(:,:,i);
    
    for r = 1:R
        draw = distribution_per_individual(r,:);
        draw1 = draw(1:21);
        draw2 = draw(22:26);
        l_ita = zeros(24,1);
        
        for t = 1:24
            probabilities = zeros(2,1);
            
            xx = x_variables(1+((t-1)*total_alternatives):t*total_alternatives,:);
            gg = z_variables(1+((t-1)*total_alternatives):t*total_alternatives,:);
            yy = chosen(1+((t-1)*total_alternatives):t*total_alternatives,:);
            zz = lifeyears(1+((t-1)*total_alternatives):t*total_alternatives,:);
            
            x1 = xx(1,1:21);
            x2 = xx(2,1:21);
            
            z1 = gg(1,:);
            z2 = gg(2,:);
            
            mu1 = model2(draw1, x1, draw2, z1);
            mu2 = model2(draw1, x2, draw2, z2);
            
            lifeyears1 = zz(1);
            lifeyears2 = zz(2);
            
            numerator1 = exp(mu1*lifeyears1);
            numerator2 = exp(mu2'*lifeyears2);
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