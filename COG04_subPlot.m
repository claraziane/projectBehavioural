clear all; 
close all;
clc;

% Declare paths
pathData    = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/projectFig/'); %Functions for figures

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
                'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};

Conditions   = {'noneRestSUB'; 'lastRestSUB'; 'noneTapSUB'; 'syncTapSUB'; 'noneWalkSUB';  'syncWalkSUB'}; %; 'lastRestSUB'
xLabels      = {  'noneRest'; 'lastRest' ; 'noneTap';    'syncTap';    'noneWalk';     'syncWalk'}; %'noneRest';    'lastRest';  ; 'noneRest'
Comparisons  = {'SUB'};

iPlot = 1;

% Preallocate matrix
nCorrect = nan(length(Participants),length(Conditions));
nError   = nan(length(Participants),length(Conditions));

for iCondition = 1:length(Conditions)

    for iParticipant = 1:length(Participants)

        pathImport = [pathData Participants{iParticipant} '/'];
        load([pathImport 'resultsSubtractions.mat']);

        nCorrect(iParticipant, iCondition) = resultsSubtractions.(Conditions{iCondition}).nCorrect;
        nError(iParticipant, iCondition)   = resultsSubtractions.(Conditions{iCondition}).nError;

    end % End Participants

end % End Conditions

% Plot
plotScatter(nCorrect, Comparisons, xLabels, 'Number of Correct Answers');
plotScatter(nError, Comparisons, xLabels, 'Number of Errors');


saveas(figure(1), [pathResults '/Cognition/fig_subCorrect.png'])
saveas(figure(2), [pathResults '/Cognition/fig_subError.png'])


% Z-score transformation
for iCondition = 1:length(Conditions)

    nCorrect(~isnan(nCorrect(:,iCondition)),iCondition) = zscore(nCorrect(~isnan(nCorrect(:,iCondition)), iCondition));
    nError(~isnan(nError(:,iCondition)),iCondition)     = -(zscore(nError(~isnan(nError(:,iCondition)), iCondition)));
    
    Score(:,iCondition) = (nCorrect(:,iCondition) + nError(:,iCondition)) /2;
end

% Plot
plotScatter(Score, Comparisons, xLabels, 'Performance (z-score)');

% Save
saveas(figure(3), [pathResults '/Cognition/fig_subTotal.png'])
close all;

