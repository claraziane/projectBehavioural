clear all;
close all;
clc;

% Declare paths
pathData    = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Results/');

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18'; 'P19';...
                'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P32';...
                'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};
Conditions   = {'noneWalkST'; 'noneWalkSUB'; 'stimWalkODD'; 'syncWalkST'; 'syncWalkSUB'; 'syncWalkODD';...
                 'noneTapST';  'noneTapSUB';  'stimTapODD';  'syncTapST';  'syncTapSUB'; 'syncTapODD'};
    
iPlot = 1;

% Preallocate matrix
% imiCV      = nan(length(Participants),length(Conditions)*length(Comparisons));
% imiMean    = nan(length(Participants),length(Conditions)*length(Comparisons));
% cadence    = nan(length(Participants),length(Conditions)*length(Comparisons));

for iCondition = 1:length(Conditions)

        pathExport = [pathResults Participants{iParticipant} '/'];
        if ~exist(pathExport, 'dir')
            mkdir(pathExport)
        end

        % Load behavioural data
        load([pathData Participants{iParticipant}  '/Events.mat']);

        for iParticipant = length(Participants)
            IMI = [];

            % Tapping conditions
            if strcmpi(Conditions{iCondition}(5:7), 'Tap')

                % Extract acquisition frequency
                Freq = Taps.([Conditions{iCondition}]).sampFreq;

                % Extracting inter-tap intervals
                IMI = Taps.([Conditions{iCondition}]).ITI;

            % Gait conditions
            else

                % Extract acquisition frequency
                Freq = Steps.([Conditions{iCondition}]).sampFreq;

                % Extracting step onsets   
                Onsets = [];
                Onsets = Steps.([Conditions{iCondition}]).stepOnsets;
                IMI = diff(Onsets); 
            end

            % Convert frames to ms                  
            IMI = (IMI / Freq) * 1000; 

            % Computing coefficient of variability of inter-mvt intervals
            imiStd = std(IMI);
            imiCV = imiStd/mean(IMI);

            % Storing results in structure
            resultsBehav.([Conditions{iCondition}]).IMI     = IMI;
            resultsBehav.([Conditions{iCondition}]).imiMean = mean(IMI);
            resultsBehav.([Conditions{iCondition}]).imiCV   = imiCV;

        end % End Conditions

        % Save results
        save([pathExport 'resultsBehav.mat'], 'resultsBehav');

        clear resultsBehav Steps Taps

end % End Participants
