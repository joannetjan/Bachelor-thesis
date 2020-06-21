function [results, completesurvey, states, characteristics] = retrieve_dataset(data, choicetask, lifeyears, health_states)
global total_alternatives
global total_individuals
global total_characteristics
survey = [];
dataset = [];
healthstates = [];
choicetask = choicetask';
characteristics = zeros(total_individuals+6, 1+total_characteristics);


for i = 1:size(choicetask,1) %version
    task = 1;
    for j = 1:size(choicetask,2) %choice task alternatives
        num = choicetask(i,j);
        num = arrayfun(@(x) mod(floor(num/10^x),10),floor(log10(num)):-1:0);
        
        temp1 = [];
        for k = 1:3 %three alternatives
            parameters = 1;
            for l = 1+((k-1)*5):5*k
                attributes = zeros(1,4);
                %                 attributes(1,num(1,l)) = 1;
                if num(1,l) > 1
                    %                                     attributes(1:num(1,l)-1) = ones(1,num(1,l)-1);
                    attributes(1,num(1,l)-1) = 1;
                end
                parameters = [parameters attributes];
            end
            temp1 = [temp1; i task k parameters];
        end
        temp2 = temp1; %include all alternatives to each choice task
        temp2(:,2) = temp2(:,2)+1;
        
        temp1(end,:) = []; %uncomment this for three alternatives
        temp2(1,:) = [];
        
        survey = [survey; temp1; temp2];
        task = task+2;
    end
end
survey = [survey lifeyears];

%Explicit self-assessed health states per individual

for i = 1:size(data,1) %assign the chosen alternatives per individual
    version_number = table2array(data(i,5));
    personid = table2array(data(i,1));
    sub_survey = survey(((version_number-1)*(total_alternatives*24))+1:version_number*(total_alternatives*24),:);
    task = 1;
    
    personal_healthstate = table2array(data(i,13:17));
    selfassessed_healthstate = zeros(1,5);
    
    full_health = 0;
    
    if strcmp(char(table2array(data(i,22))),'<undefined>') == 0
        for k = 1:length(personal_healthstate)
            health_level = char(personal_healthstate(k));
            subhealthstate = health_states(:,1+(2*(k-1)):2*k);
            for l = 1:size(subhealthstate,1)
                level = char(table2array(subhealthstate(l,1)));
                if strcmp(health_level, level) == 1
                    selfassessed_healthstate(k) = table2array(subhealthstate(l,2));
                    break
                end
            end
        end
        if isequal(selfassessed_healthstate, [1 1 1 1 1]) == 1
            full_health = 1;
        end
        healthstates = [healthstates; personid selfassessed_healthstate full_health];
        
    end
    
    
    
    for j = 22:45 %indicate chosen alternative per individual
        option = char(table2array(data(i,j)));
        subsub_survey = sub_survey(task:task+1,:); % uncomment section below for two alternatives
        choice_task = subsub_survey(1,2);
        if strcmp(option, '<undefined>') == 0
            chosen_alternative = zeros(total_alternatives,1);
            if mod(choice_task,2) == 1
                if strcmp(option, 'option A') == 1
                    chosen_alternative(1,1) = 1;
                else
                    chosen_alternative(2,1) = 1;
                end
            else
                if strcmp(option, 'option B') == 1
                    chosen_alternative(1,1) = 1;
                else
                    chosen_alternative(2,1) = 1;
                end
            end
            
            dataset = [dataset; ones(total_alternatives,1)*personid subsub_survey(:,1:3) chosen_alternative  subsub_survey(:,4:end)];
            %             ones(total_alternatives,1)*choice, ones(total_alternatives,1)*full_health
        else
            break
        end
        task = task+total_alternatives;
    end
    
    % add characteristics to data set
    
    temp_characteristics = zeros(1,total_characteristics);
    
    % man or woman (1 in total)
    if strcmp(char(table2array(data(i,121))),'Female') == 1
        temp_characteristics(1) = 1;
    end
    % age category (5 in total)
    
    if strcmp(char(table2array(data(i,125))), '25 - 34 years') == 1
        temp_characteristics(2) = 1;
    elseif strcmp(char(table2array(data(i,125))), '35 - 44 years') == 1
        temp_characteristics(3) = 1;
    elseif strcmp(char(table2array(data(i,125))), '45 - 54 years') == 1
        temp_characteristics(4) = 1;
    elseif strcmp(char(table2array(data(i,125))), '55 - 64 years') == 1
        temp_characteristics(5) = 1;
    elseif strcmp(char(table2array(data(i,125))), '65 years and older') == 1
        temp_characteristics(6) = 1;
    end
    
    % %     group 1 or group 2 for color coding (2 in total)
    % education category (6 in total)
    
    if strcmp(char(table2array(data(i,146))), 'vmbo (intermediate secondary education, US: junior high school)') == 1
        temp_characteristics(7) = 1;
    elseif strcmp(char(table2array(data(i,146))), 'havo/vwo (higher secondary education/preparatory university education, US: senio') == 1
        temp_characteristics(8) = 1;
    elseif strcmp(char(table2array(data(i,146))), 'mbo (intermediate vocational education, US: junior college)') == 1
        temp_characteristics(9) = 1;
    elseif strcmp(char(table2array(data(i,146))), 'hbo (higher vocational education, US: college)') == 1
        temp_characteristics(10) = 1;
    elseif strcmp(char(table2array(data(i,146))), 'wo (university)') == 1
        temp_characteristics(11) = 1;
    end
    
    % when self-assessed health state is above level 4
    if sum(selfassessed_healthstate == ones(1,5)*4) >= 1
        temp_characteristics(12) = 1;
    end
    
    % when self-assessed health state above level 5
    if sum(selfassessed_healthstate == ones(1,5)*5) >= 1
        temp_characteristics(13) = 1;
    end
    
    characteristics(i,:) = [personid temp_characteristics];
    % living situation maybe
end

completesurvey = survey;
results = dataset;
states = healthstates;
end