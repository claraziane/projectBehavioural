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

Conditions   = {'noneTap'; 'syncTap'; 'noneWalk'; 'syncWalk'};
Comparisons  = {'ST'; 'ODD'; 'SUB'};

iPlot = 1;

% Preallocate matrix
imiCV      = nan(length(Participants),length(Conditions)*length(Comparisons));
imiMean    = nan(length(Participants),length(Conditions)*length(Comparisons));
cadence    = nan(length(Participants),length(Conditions)*length(Comparisons));
autoCor    = nan(length(Participants),length(Conditions)*length(Comparisons));

for iCondition = 1:length(Conditions)

    for iParticipant = 1:length(Participants)

        % Load data
        pathImport = [pathResults Participants{iParticipant} '/'];
        load([pathData Participants{iParticipant}  '/Events.mat']);

        for iCompare = 1:length(Comparisons)
            condName = [Conditions{iCondition} Comparisons{iCompare}];
            if strcmpi(condName, 'noneTapODD') == 1
                condName = 'stimTapODD';
            elseif strcmpi(condName, 'noneWalkODD') == 1
                condName = 'stimWalkODD';
            end

            if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(Conditions{iCondition}, 'syncWalk')
            elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(Conditions{iCondition}, 'noneWalk')
            elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(Conditions{iCondition}, 'syncWalk')
            elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(Conditions{iCondition}, 'noneWalk')
            elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(Conditions{iCondition}, 'syncWalk')
            elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(Conditions{iCondition}, 'noneWalk')
            else

                if sum(isnan(Events.(condName).mvtOnsets)) >= length(Events.(condName).mvtOnsets)/3
                    imiCV(iParticipant, iPlot+iCompare-1) = NaN;
                    imiMean(iParticipant, iPlot+iCompare-1) = NaN;
                    cadence(iParticipant, iPlot+iCompare-1) = NaN;
                else
                    imiCV(iParticipant, iPlot+iCompare-1) = Events.(condName).imiCV;
                    imiMean(iParticipant, iPlot+iCompare-1) = nanmean(Events.(condName).IMI);
                    cadence(iParticipant, iPlot+iCompare-1) = Events.(condName).Cadence;
                    [acf,lags,bounds] = autocorr(Events.(condName).IMI, 'NumLags', 1);
                    autoCor(iParticipant, iPlot+iCompare-1) = acf(2);

                end

            end

        end % End Comparisons

        if iParticipant == length(Participants)
            iPlot = iPlot + length(Comparisons);
        end

    end % End Participants

end % End Conditions


% Plot
plotScatterUpdated(imiCV, Comparisons, Conditions, 'Coefficient of Variation_{Inter-Movement Interval}');
plotScatterUpdated(imiMean, Comparisons, Conditions, 'Inter-Movement Interval (ms)');
plotScatterUpdated(cadence, Comparisons, Conditions, 'Cadence (movements per minute)');
plotScatterUpdated(autoCor, Comparisons, Conditions, 'Lag-1 Autocorrelation');

% Save
saveas(figure(1), [pathResults 'Motor/fig_mvtCV.png'])
saveas(figure(2), [pathResults 'Motor/fig_mvtIMI.png'])
saveas(figure(3), [pathResults 'Motor/fig_mvtCadence.png'])

close all;