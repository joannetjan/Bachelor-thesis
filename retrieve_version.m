function[survey] = retrieve_version(enquete)

totalalternatives = 3;
enquete = enquete';
finalsurvey = [];

for i = 1:size(enquete,1) %version
    task = 1;
    for j = 1:size(enquete,2) %choice task alternatives
        num = enquete(i,j);
        num = arrayfun(@(x) mod(floor(num/10^x),10),floor(log10(num)):-1:0);
        temp1 = [];
        for k = 1:totalalternatives %three alternatives
            healthstate_per_option = num(1+((k-1)*5):5*k);
            temp1 = [temp1; i task k healthstate_per_option];
        end
        temp2 = temp1;
        temp2(:,2) = temp2(:,2)+1;
        
        temp1(end,:) = []; %uncomment this for three alternatives
        temp2(1,:) = [];
        
        finalsurvey = [finalsurvey; temp1; temp2];
        task = task+totalalternatives-1;
        
    end
end

survey = finalsurvey;

end