function[gamma_parameters] = retrieve_gamma(personalhealthstates, healthstateperchoicetask)
% data: individuals responses for each choice task
% healthstates: self-assessed health states provided by the individuals
% 2 alternatives per choice task

global total_alternatives
global total_individuals
global DATA
global personIDS

% gamma0 = zeros(total_alternatives*24*total_individuals,49);
gamma0 = zeros(total_alternatives*24*total_individuals, 32);

for i = 1:total_individuals
    own_healthstate = personalhealthstates(i,2:6);
    %     gammatemp = zeros(total_alternatives*24, 22);
    gammatemp = zeros(total_alternatives*24, 5);
    
    version_number = DATA(i,2);
    subsurvey = healthstateperchoicetask(healthstateperchoicetask(:,1) == version_number, :);
    subdata = DATA(DATA(:,1) == personIDS(i), :);
    
    for j = 1:total_alternatives*24
        healthstate_option = subsurvey(j,4:8);
        gamma_option = healthstate_option >= own_healthstate;
        %         gammatemp(j,:) = [zeros(1,2) reshape(repmat(gamma_option, 4, 1), 1, [])];
        gammatemp(j,:) = gamma_option;
    end
    
    gamma0((total_alternatives*24)*(i-1)+1:(total_alternatives*24)*i,:) = [subdata gammatemp];
    
end

gamma_parameters = gamma0;

end