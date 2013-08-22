%% runExperiment.m ---------------------------------------------------------
% 
% Experiemt: contextual information 
% Author:   Ante Odic
% Date:     2012-1-25
%


%% Add path ---------------------------------------------------------------
global settings_absoluteRootPath;

settings_absoluteRootPath = 'D:\00xBeds\13-ContextRelevanceAssessment';


%% DataSet
DataSetsPath =  '02-Data';
dataRange = 'B2:P73';
dataUsers = zeros();

%% load data

% load data from xls file
[~, dataAnswer] = xlsread(fullfile(settings_absoluteRootPath,DataSetsPath,'survey.xls'), dataRange);

dataUsers = zeros(1, size (dataAnswer,1));

disp('Excel file loaded.')


%% Data manipulation

%get answers
for i = 1: size (dataAnswer,1)
    for j = 1: (size (dataAnswer,2)-1)
        dataAnswer{i,j}
        if strcmp(dataAnswer{i,j},'No.')
            dataNumbers(i,j) = 1;
        elseif strcmp(dataAnswer{i,j},'Probably not.')
            dataNumbers(i,j)  = 2;
        elseif strcmp(dataAnswer{i,j},'Maybe. ')
            dataNumbers(i,j)  = 3;
        elseif strcmp(dataAnswer{i,j},'Probably yes.')
            dataNumbers(i,j)  = 4;
        elseif strcmp(dataAnswer{i,j},'Yes.')
            dataNumbers(i,j)  = 5;
        end
        
    end
end

%get users
for k = 1: size (dataAnswer,1)
    %k
    if ~isempty(str2num(dataAnswer{k, 14}(2:end)))
        dataUsers(k) = str2num(dataAnswer{k, 14}(2:end));
    end
    
end

finalData = [dataUsers' dataNumbers];

finalData(:,3)=[];

disp('Excel file parsed.')

xlswrite(fullfile(settings_absoluteRootPath,DataSetsPath, 'surveyData.xls'), finalData)




