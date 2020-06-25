function[p] = mxll2(beta2, sigma2)

global DISTRIBUTION2
global DATAGAMMA
global total_individuals
global personIDS
global R

cd = diag(chol(eye(26).*sigma2));
c = repmat(beta2',[1,total_individuals,R])+repmat(cd, [1,total_individuals,R]).*DISTRIBUTION2;
c = permute(c, [3,1,2]);

p = zeros(total_individuals, 1);

for i = 1:total_individuals
    xmatrix = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), :);
    lifeyears = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 27); %48x1 matrix
    chosen = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 5); %48x1 matrix
    
    xmatrix(:,6:26) = xmatrix(:,6:26).*lifeyears;
    xmatrix(:,27) = [];
    
    sum_per_i = 0;
    distribution_per_individual = c(:,:,i);
    x_variables = xmatrix(:, 6:26); %48x21 matrix
    z_variables = xmatrix(:, 27:31); %48x5 matrix
    
    temp1 = zeros(48,21); % tranform z matrix into longformat
    for number = 1:48
        z = z_variables(number,:);
        temp1(number,2:end) = repelem(z, 4);
    end
    
    for r = 1:R
        draw = distribution_per_individual(r,:);
        draw1 = repmat(draw(1:21), 48, 1);
        
        %transform gamma to gamma matrix long format
        draw2 = repelem(draw(22:26), 4);
        draw2 = repmat(draw2, 48, 1); %48x20 matrix
        
        gamma1 = zeros(48,21);
        gamma1(:, 2:end) = draw2;
        
        rf = (temp1.*gamma1)+1;
        rf = rf.*draw1;
        
        num = rf.*x_variables;
        num = sum(num,2); % 48x1 vector
        num = exp(num);
        
        denom = movsum(num,2);
        denom = denom(2:2:end);
        denom = reshape(repmat(denom', 2, 1), 1, [])';
        
        probabilities = num./denom;
        probabilities = probabilities.^chosen;
        probabilities = log(probabilities);
        
        sum_per_i = sum_per_i+exp(sum(probabilities));
    end
    
    p(i) = -log(sum_per_i/R);
end

end