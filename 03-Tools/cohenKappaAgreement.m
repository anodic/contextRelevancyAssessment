
function [cohenKappa] = cohenKappaAgreement( inputData )

tableDimension = max(max(inputData));

tableForKappa = zeros(tableDimension,tableDimension);

for i = 1 : size(inputData,2)
   
    tableForKappa(inputData(1,i), inputData(2,i)) = tableForKappa(inputData(1,i), inputData(2,i)) + 1;
        
end

disp('table done')
tableForKappa

% observed percentage agreement
Pra = (tableForKappa(1,1)+tableForKappa(2,2))/sum(sum(tableForKappa));

numOfRater1 = sum(tableForKappa,2);
rater1relevant = numOfRater1(1)/ sum(sum(tableForKappa,2));
rater1irrelevant = numOfRater1(2)/ sum(sum(tableForKappa,2));

numOfRater2 = sum(tableForKappa,1);
rater2relevant = numOfRater2(1)/ sum(sum(tableForKappa,1));
rater2irrelevant = numOfRater2(2)/ sum(sum(tableForKappa,1));

randomRelevantProb = rater1relevant* rater2relevant;
randomIrrelevantProb = rater1irrelevant* rater2irrelevant;

Pre = randomRelevantProb+randomIrrelevantProb;

cohenKappa = (Pra - Pre)/(1 - Pre);


end
