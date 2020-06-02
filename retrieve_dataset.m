function [results, completesurvey, states] = retrieve_dataset(data, choicetask, lifeyears, health_states)
global total_alternatives
survey = [];
dataset = [];
healthstates = [];
choicetask = choicetask';

for i = 1:size(choicetask,1) %version
    task = 1;
    for j = 1:size(choicetask,2) %choice task alternatives
        num = choicetask(i,j);
        num = arrayfun(@(x) mod(floor(num/10^x),10),floor(log10(num)):-1:0);
        
        temp1 = [];
        for k = 1:3 %three alternatives
            %             if k == 2 %intercept initialization
            %                 parameters = 1;
            %             else
            %                 parameters = 0;
            %             end
            parameters = 1;
            %             parameters = [];
            
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
        %         subsub_survey = sub_survey(task:task+total_alternatives-1,:); % uncomment section below for three alternatives
        %         choice_task = subsub_survey(1,2);
        %         if strcmp(option, '<undefined>') == 0
        %             chosen_alternative = zeros(3,1);
        %             if strcmp(option, 'option A') == 1
        %                 chosen_alternative(1,1) = 1;
        %             elseif strcmp(option, 'option B') == 1
        %                 chosen_alternative(2,1) = 1;
        %             else
        %                 chosen_alternative(3,1) = 1;
        %             end
        %
        %             dataset = [dataset; ones(3,1)*personid subsub_survey(:,1:3) chosen_alternative subsub_survey(:,4:end)];
        %
        %         else
        %             break
        %         end
        %         task = task+total_alternatives;
        
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
end

completesurvey = survey;
results = dataset;
states = healthstates;
end