%% runExperiment.m ---------------------------------------------------------
%
% Experiemt: contextual information
% Author:   Ante Odic
% Date:     2012-1-25
%


%% Add path ---------------------------------------------------------------
global settings_absoluteRootPath;

settings_absoluteRootPath = 'D:\00xBeds\13-ContextRelevanceAssessment';
addpath(fullfile(settings_absoluteRootPath, '03-Tools'));


%% DataSet
DataSetsPath =  '02-Data';

%% load data

% load data from xls file
dataAnswer = xlsread(fullfile(settings_absoluteRootPath,DataSetsPath, 'surveyData.xls') ,'Sheet1', 'B1:M72');
users = xlsread(fullfile(settings_absoluteRootPath,DataSetsPath, 'surveyData.xls') ,'Sheet1', 'A1:A72');

contextNames = {'time' 'day type' 'season' 'location' 'weather' 'social' 'end emotion' 'dom. emotion' 'mood' 'physical' 'decision' 'interaction'};

disp('Excel file loaded.')

%% prepare user group and nonUser group

userGroupAnswers = dataAnswer(find(users~=0),:);
nonUserGroupAnswers = dataAnswer(find(users==0),:);


%% Agreement calculation: Fleiss' kappa

 [fleissKappaAll] = fleissKappaAgreement( dataAnswer )
 [fleissKappaUsers] = fleissKappaAgreement( userGroupAnswers )
 [fleissKappaNonUsers] = fleissKappaAgreement( nonUserGroupAnswers )
 

 %% relevancy assessment

[relevancyFromAssessment] = assessRelevancy( dataAnswer )
[usersRelevancyFromAssessment] = assessRelevancy( userGroupAnswers )
[nonUsersRelevancyFromAssessment] = assessRelevancy( nonUserGroupAnswers )
    
    
%% How well do they match?
relevancyFromDetection = [1 2 1 2 1 1 2 2 2 2 2 2];

inputData = [relevancyFromAssessment; relevancyFromDetection];
[allJudgesVsDetection] = cohenKappaAgreement( inputData )

inputData = [usersRelevancyFromAssessment; nonUsersRelevancyFromAssessment];
[usersVsNonUsers] = cohenKappaAgreement( inputData )

inputData = [usersRelevancyFromAssessment; relevancyFromDetection];
[usersVsDetection] = cohenKappaAgreement( inputData )

inputData = [nonUsersRelevancyFromAssessment; relevancyFromDetection];
[nonUsersVsDetection] = cohenKappaAgreement( inputData )


%% How good is it?

% rmse results list from worst to best, numbers are context variables
% ordered as in the survey
rmseTopList = [5 6 3 9 1 4 2 11 10 8 12 7];

numberOfAssessmentFaliures = 0;
numberOfDetectionFaliures = 0;

for i = 1 : 12
    for j = i+1 : 12

        if relevancyFromAssessment(rmseTopList(i)) > relevancyFromAssessment(rmseTopList(j))
            numberOfAssessmentFaliures = numberOfAssessmentFaliures+1;
        end
        
        if relevancyFromDetection(rmseTopList(i)) > relevancyFromDetection(rmseTopList(j))
            numberOfDetectionFaliures = numberOfDetectionFaliures+1;
        end
                
    end
end

numOfAssessmentComb =  length(find(relevancyFromAssessment==1))* length(find(relevancyFromAssessment==2));
numOfDetectionComb =  length(find(relevancyFromDetection==1))* length(find(relevancyFromDetection==2));

assessmentQuality = 1 - numberOfAssessmentFaliures/numOfAssessmentComb
detectionQuality = 1 - numberOfDetectionFaliures/numOfDetectionComb

%% plot histograms

for i=1:12
    
    currentContext = dataAnswer(:,i);
    currentContext(find(currentContext==0)) = [];
    
    
    subplot(2,6,i)
    barh(hist(currentContext,5))
    axis([0 30 0 6])
    title( contextNames(i))
end



