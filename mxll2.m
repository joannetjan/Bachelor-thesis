function[p] = mxll2(beta1, sigma1)

global DISTRIBUTION2
global DATAGAMMA
global total_individuals
global personIDS
global R

cd = diag(chol(eye(26).*sigma1));
c = repmat(beta1',[1,total_individuals,R])+repmat(cd, [1,total_individuals,R]).*DISTRIBUTION2;
c = permute(c, [3,1,2]);

p = zeros(total_individuals, 1);

for i = 1:total_individuals
    xmatrix = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), :);
    lifeyears = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 27); %48x1 matrix
    chosen = DATAGAMMA(DATAGAMMA(:,1) == personIDS(i), 5); %48x1 matrix
    
    xmatrix(:,6:26) = xmatrix(:,6:26).*lifeyears;
%     alpha1 = repmat([0;1;1;0], 12, 1);
%     xmatrix = [xmatrix(:, 1:5) alpha1 xmatrix(:, 6:end)];
    xmatrix(:,27) = [];
    
    sum_per_i = 0;
    distribution_per_individual = c(:,:,i);
    x_variables = xmatrix(:, 6:26);
    z_variables = xmatrix(:, 27:31);
    
    for r = 1:R
        draw = distribution_per_individual(r,:);
        draw1 = repmat(draw(1:22), 48, 1);
        draw2 = repmat(draw(23:27), 48, 1);
        
        M = [draw1 x_variables draw2 z_variables];
        %         num = cellfun(@intermediate_step, num2cell(M,2));
        num = zeros(48,1);
        for t = 1:48
            b = M(t, 1:21);
            x = M(t, 22:42);
            g = M(t, 43:47);
            z = M(t, 48:52);
            %             num(t) = model2(b, x, g, z);
            
            value = 0;
            z_fullformat = zeros(1,22);
            gamma_fullformat = zeros(1,22);
            
            gamma0 = repmat(g, 4, 1);
            z = repmat(z, 4, 1);
            
            gamma_fullformat(3:end) = reshape(gamma0, 1, []);
            z_fullformat(3:end) =  reshape(z, 1, []);
            
            % value = sum(beta0' .* (ones(22,1) + z_fullformat'.*gamma_fullformat').*x');
            
            for k = 1:length(x)
                value = value + (b(k)*(1+z_fullformat(k)*gamma_fullformat(k)))*x(k);
            end
            num(t) = value;
        end
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