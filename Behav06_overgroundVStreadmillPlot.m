clear all;
close all;
clc;

% Declare paths
pathEEG     = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/DATA/Processed/');
pathTeensy  = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/projectFig/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');

Participants = {'P02'; 'P03'; 'P10'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
                'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};
Conditions    = { 'stim'; 'sync'; 'sync'}; %'none';
CompareTeensy = {  'ODD';   'ST';  'ODD'}; %   'ST'; 
CompareEEG    = {     'DT';   'ST';   'DT'}; % 'ST';

var = {'IMI'; 'imiCV'; 'phaseAngleMean'; 'resultantLength'}; %{'imiMean'; 'imiCV'; 'cadence'}; 
figTitles = {'Inter-Movement Interval'; 'Variability of Inter-Movement Interval'; 'Synchronization Accuracy'; 'Synchronization Consistency'}; %{'imiMean'; 'imiCV'; 'cadence'}; 

xLabel = {'Overground'};
yLabel = {'Treadmill'};
Titles  = { 'Ignore (ODD)'; 'Sync (ST)'; 'Sync (ODD)'}; %'Silence (ST)'; 
corrType = 'Spearman';

iFig = 1;
for iVar = 1%:length(var)

    for iCondition = 1:length(Conditions)
        condX = strcat(Conditions{iCondition}, 'Walk', CompareTeensy{iCondition});
        condY = strcat(Conditions{iCondition}, 'Walk', CompareEEG{iCondition});

        for iParticipant = 1:length(Participants)

            if strcmpi(var{iVar}, 'IMI')
                % Load data
%                 load([pathEEG Participants{iParticipant} '/01/Behavioural/dataStep.mat']);
                load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/' Participants{iParticipant} '/01/resultsBehav.mat'])
                load([pathTeensy Participants{iParticipant} '/Events.mat']);

                dataX(iParticipant,iCondition) = mean(Events.(condX).(var{iVar}))/2;
                dataY(iParticipant,iCondition) = resultsBehav.(condY).imiMean;

            elseif strcmpi(var{iVar}, 'imiCV')
                % Load data
                load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/' Participants{iParticipant} '/01/resultsBehav.mat'])
                load([pathTeensy Participants{iParticipant} '/Events.mat']);

                dataX(iParticipant,iCondition) = Events.(condX).(var{iVar});
                dataY(iParticipant,iCondition) = resultsBehav.(condY).(var{iVar}); 

            elseif strcmpi(var{iVar}, 'resultantLength')
                % Load data
                load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/' Participants{iParticipant} '/01/resultsSync.mat'])
                load([pathTeensy Participants{iParticipant} '/dataSync.mat']);

                dataX(iParticipant,iCondition) = log(dataSync.(condX).(var{iVar}) ./ (1-dataSync.(condX).(var{iVar})));
                dataY(iParticipant,iCondition) = log(resultsSync.(condY).(var{iVar}) ./ (1-resultsSync.(condY).(var{iVar}))); 
            end

        end

    end

    % Plot
    plotCorrel(dataX, dataY, xLabel, yLabel, Titles, corrType)
    sgtitle([figTitles{iVar}], 'FontSize', 20, 'FontWeight', 'bold')
    saveas(figure(iFig), [pathResults '/overgroundVStreadmill/' corrType 'fig_' var{iVar} '_tapVSwalk.png']);

    clear dataX dataY
    iFig = iFig+1;


end
close all;