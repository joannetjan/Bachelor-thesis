function[finaldraws] = makedraws(number)
% Calculate draws of standardized random terms for random coefficients and save if specified
% Written by Kenneth Train, August 6, 2006.
 
% Array of draws has dimension NMEMxNPxNV.

global R
global total_individuals

finaldraws = zeros(R,total_individuals,number);
h=0:(R-1);
h=h'./R;

for p = 1:number
    for i = 1:total_individuals
        draws=h+rand(1,1)./R;
        rr=rand(R,1);
        [rr rrid]=sort(rr);
        draws=draws(rrid,1);
        draws=-sqrt(2).*erfcinv(2.*draws);
        finaldraws(:,i,p)=draws;
    end
end

end