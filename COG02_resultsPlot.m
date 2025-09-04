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
Conditions   = {'stimTapODD'; 'syncTapODD';  'stimWalkODD'; 'syncWalkODD'};
xLabels      = { 'stimTap';    'syncTap';     'stimWalk';    'syncWalk'}; %'stimRest';   'stimRestODD'; 
Comparisons  = {'ODD'};

iPlot = 1;

% Preallocate matrix
Errors  = nan(length(Participants),length(Conditions));

for iCondition = 1:length(Conditions)

    for iParticipant = 1:length(Participants)

        pathImport = [pathData Participants{iParticipant} '/'];
        load([pathImport 'resultsOddball.mat']);

        Errors(iParticipant, iCondition) = resultsOddball.(Conditions{iCondition});

    end % End Participants

end % End Conditions

% Plot
plotScatter(Errors, Comparisons, xLabels, 'Number of Errors');

% Save
saveas(figure(1), [pathResults '/Cognition/fig_cogOddball.png'])
close all;

