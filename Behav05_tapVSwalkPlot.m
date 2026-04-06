clear all;
close all;
clc;

% Declare paths
pathData    = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults  = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/projectFig/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
                'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};

% Conditions   = {'none'; 'sync'; 'stim'; 'sync'; 'none'; 'sync'}; 
% Compare      = {  'ST';   'ST';  'ODD';  'ODD';  'SUB';  'SUB'};       
% Titles  = {'Spontaneous (Single task)'; 'Sync (Single task)'; 'Spontaneous (Oddball)'; 'Sync (Oddball)'; 'Spontaneous (Subtractions)'; 'Sync (Subtractions)'}; % 'Silence (ST)'; 'Silence (SUB)'; 

Conditions   = { 'sync'; 'sync'; 'sync'}; 
Compare      = {   'ST';   'ODD';  'SUB'};       
Titles  = { 'Sync (Single task)'; 'Sync (Oddball)'; 'Sync (Subtractions)'}; % 'Silence (ST)'; 'Silence (SUB)'; 

var = {'IMI'; 'imiCV'; 'phaseAngleMean'; 'resultantLength'}; %{'imiMean'; 'imiCV'; 'cadence'}; 
figTitles = {'Inter-Movement Interval'; 'Variability of Inter-Movement Interval'; 'Synchronization Accuracy'; 'Synchronization Consistency'}; %{'imiMean'; 'imiCV'; 'cadence'}; 

xLabels = {'Tap'};
yLabels = {'Walk'};
corrType = 'Spearman';

iFig = 1;
for iVar = 3:length(var)
    xLabel = (xLabels{1});
    yLabel = (yLabels{1});

    for iCondition = 1:length(Conditions)
        condX = strcat(Conditions{iCondition}, 'Tap', Compare{iCondition});
        condY = strcat(Conditions{iCondition}, 'Walk', Compare{iCondition});


        for iParticipant = 1:length(Participants)

            if strcmpi(var{iVar}, 'cadence')
                % Load data
                load([pathData Participants{iParticipant} '/Events.mat']);

                dataX(iParticipant,iCondition) = Events.(condX).(var{iVar});
                dataY(iParticipant,iCondition) = Events.(condY).(var{iVar});
           
            elseif strcmpi(var{iVar}, 'IMI')
                % Load data
                load([pathData Participants{iParticipant} '/Events.mat']);

                dataX(iParticipant,iCondition) = mean(Events.(condX).(var{iVar}));
                dataY(iParticipant,iCondition) = mean(Events.(condY).(var{iVar}));

            elseif strcmpi(var{iVar}, 'phaseErrorMean') || strcmpi(var{iVar}, 'phaseAngleMean')
                % Load data
                load([pathData Participants{iParticipant} '/dataSync.mat']);
                [p] = circ_rtest(deg2rad(dataSync.(condX).phaseAngle));
                if p >= .05
                    dataX(iParticipant,iCondition) = NaN;
                    dataY(iParticipant,iCondition) = NaN;

                else
                    dataX(iParticipant,iCondition) = rad2deg(dataSync.(condX).(var{iVar}));
                    dataY(iParticipant,iCondition) = rad2deg(dataSync.(condY).(var{iVar}));
                end

            elseif strcmpi(var{iVar}, 'resultantLength')
                % Load data
                load([pathData Participants{iParticipant} '/dataSync.mat']);
                dataX(iParticipant,iCondition) = log(dataSync.(condX).(var{iVar}) ./ (1-dataSync.(condX).(var{iVar})));
                dataY(iParticipant,iCondition) = log(dataSync.(condY).(var{iVar}) ./ (1-dataSync.(condY).(var{iVar})));

            else
                % Load data
                load([pathData Participants{iParticipant} '/Events.mat']);
                dataX(iParticipant,iCondition) = Events.(condX).(var{iVar});
                dataY(iParticipant,iCondition) = Events.(condY).(var{iVar});

            end

        end

    end

    % Plot
    plotCorrel(dataX, dataY, xLabel, yLabel, Titles, corrType)
    sgtitle([figTitles{iVar}], 'FontSize', 20, 'FontWeight', 'bold')
    saveas(figure(iFig), [pathResults '/tapVSwalk/' corrType 'fig_' var{iVar} '_tapVSwalk.png']);

    clear dataX dataY
    iFig = iFig+1;

end
close all;