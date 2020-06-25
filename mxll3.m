function[p] = mxll3(beta3, sigma3)

global DISTRIBUTION3
global DATAGAMMA
global total_individuals
global characteristics
global personIDS
global R

cd = diag(chol(eye(86).*sigma3));
c = repmat(beta3',[1,total_individuals,R])+repmat(cd, [1,total_individuals,R]).*DISTRIBUTION3;
c = permute(c, [3,1,2]);

p = zeros(total_individuals, 1);

for i = 1:total_individuals
    xmatrix = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 6:26);
    lifeyears = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 27); %48x1 matrix
    chosen = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 5); %48x1 matrix
    xmatrix = xmatrix.*lifeyears;
    
    person_characteristics = characteristics(characteristics(:,1) == personIDS(i),2:end);
    person_characteristics = repmat(person_characteristics, 21, 1); %21x13 matrix
    
    sum_per_i = 0;
    distribution_per_individual = c(:,:,i);
    
    for r = 1:R
        draw = distribution_per_individual(r,:);
        draw1 = draw(1:21);
        draw2 = draw(22:86);
        draw2 = reshape(draw2, 5, 13);
        draw2 = repelem(draw2, 4, 1);
        characteristics1 = zeros(21,13);
        characteristics1(2:end, :) = draw2;

        
        pc = person_characteristics .* characteristics1;
        pc = sum(pc, 2) + 1;
        
        parameters_beta = draw1 .* pc';
        numerators = exp(xmatrix*parameters_beta');
        denominators = movsum(numerators,2);
        denominators = denominators(2:2:end);
        denominators = reshape(repmat(denominators', 2, 1), 1, [])';
        
        probabilities = numerators./denominators;
        probabilities = probabilities.^chosen;
        probabilities = log(probabilities);
        
        sum_per_i = sum_per_i+exp(sum(probabilities));
        
    end
    
    p(i) = -log(sum_per_i/R);
end

end