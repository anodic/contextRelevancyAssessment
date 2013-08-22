function [fleissKappa] = fleissKappaAgreement( inputData )


tableForFleiss = zeros(12,5);

for i = 1:size(inputData,1)
    
    for j= 1: size(inputData,2)
        
        if inputData(i,j)==0
            continue;
        end
        
        tableForFleiss(j,inputData(i,j))=tableForFleiss(j,inputData(i,j))+1;
        
        
    end
end

% number of raters
n = size(inputData,1);

% number of categories
k = 5;

% number of subjects
N = size(inputData,2);

p = (1/(n*N))*sum(tableForFleiss);

P = (1/(n*(n-1)))*(sum(tableForFleiss.^2,2) - n);

Pmean = (1/N)*sum(P);

PeMean = sum(p.^2);

fleissKappa = (Pmean - PeMean)/(1 - PeMean);
end