clear all;
close all;
clc;

% Declare paths
pathData    = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');
addpath('/Users/claraziane/Documents/Académique/Informatique/projectFig/'); %Functions for figures


Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30';...
                'P31'; 'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39';...
                'P40'; 'P41'; 'P44'};

Conditions   = {'syncTap'; 'syncWalk'};
Comparisons  = {'ST'; 'ODD'; 'SUB';};

% Preallocate matrix
RVL            = nan(length(Participants),length(Conditions)*length(Comparisons));
IBI            = nan(length(Participants),length(Conditions)*length(Comparisons));
asyncMean      = nan(length(Participants),length(Conditions)*length(Comparisons));
asyncCI        = nan(length(Participants), 2, length(Conditions)*length(Comparisons));
phaseMean      = nan(length(Participants),length(Conditions)*length(Comparisons));
phaseCI        = nan(length(Participants), 2, length(Conditions)*length(Comparisons));
noSyncPhase    = nan(length(Participants),length(Conditions)*length(Comparisons));
noSyncError    = nan(length(Participants),length(Conditions)*length(Comparisons));
phaseErrorMean = nan(length(Participants),length(Conditions)*length(Comparisons));

iPlot = 1;
for iCondition = 1:length(Conditions)

    for iParticipant = 1:length(Participants)

        pathImport = [pathData Participants{iParticipant} '/'];
        load([pathImport 'dataSync.mat']);
        load([pathImport '/Events.mat']);

        for iCompare = 1:length(Comparisons)
            condName = [Conditions{iCondition} Comparisons{iCompare}];

            if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(Conditions{iCondition}, 'syncWalk')
            elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(Conditions{iCondition}, 'syncWalk')
            elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(Conditions{iCondition}, 'syncWalk')
            elseif sum(isnan(Events.(condName).mvtOnsets)) >= length(Events.(condName).mvtOnsets)/3

            else

                % Asynchronies
                Asynchrony = [];
                Asynchrony = dataSync.(condName).Asynchrony;
                asyncMean(iParticipant, iPlot+iCompare-1) = mean(Asynchrony);
                SEM = std(Asynchrony) / sqrt(length(Asynchrony));
                t = tinv([0.025 0.975], length(Asynchrony)-1);
                asyncCI(iParticipant, :, iPlot+iCompare-1) = mean(Asynchrony) + t * SEM;

                % Phase angles (in rad)
                phaseAngle = [];
                phaseAngle = deg2rad(dataSync.(condName).phaseAngle);
                phaseMean(iParticipant, iPlot+iCompare-1) = circ_mean(phaseAngle(phaseAngle ~=0), [], 1);
                pRaleigh = dataSync.(condName).pRaleigh; % Check if uniformly distributed
                if pRaleigh >= 0.05  % When participants do not synchronize, accuracy value is replaced by NaN
                    noSyncPhase(iParticipant, iPlot+iCompare-1) = rad2deg(phaseMean(iParticipant, iPlot+iCompare-1));
                    phaseMean(iParticipant, iPlot+iCompare-1)   = NaN;
                    phaseCI(iParticipant, : , iPlot+iCompare-1) = NaN;
                else
                    phaseMean(iParticipant, iPlot+iCompare-1) = rad2deg(phaseMean(iParticipant, iPlot+iCompare-1));
                    SEM = circ_std(phaseAngle(phaseAngle ~=0)) / sqrt(length(phaseAngle));
                    t = tinv([0.025 0.975], length(phaseAngle(phaseAngle ~=0))-1);
                    phaseCI(iParticipant, : , iPlot+iCompare-1) = rad2deg(circ_mean(phaseAngle(phaseAngle ~=0), [], 1) + t * SEM);
                    noSyncPhase(iParticipant, iPlot+iCompare-1) = NaN;
                end

                % Phase errors (in rad)
                phaseError = [];
                phaseError = deg2rad(dataSync.(condName).phaseError);
                phaseErrorMean(iParticipant, iPlot+iCompare-1) = circ_mean(phaseError(phaseError ~=0), [], 1);
                if pRaleigh >= 0.05  % When participants do not synchronize, error value is replaced by NaN
                    noSyncError(iParticipant, iPlot+iCompare-1) = rad2deg(phaseErrorMean(iParticipant, iPlot+iCompare-1));
                    phaseErrorMean(iParticipant, iPlot+iCompare-1) = NaN;
                    phaseErrorCI(iParticipant, : , iPlot+iCompare-1) = NaN;
                else
                    phaseErrorMean(iParticipant, iPlot+iCompare-1) = rad2deg(phaseErrorMean(iParticipant, iPlot+iCompare-1));
                    SEM = circ_std(phaseError(phaseError ~=0)) / sqrt(length(phaseError(phaseError ~=0)));
                    t = tinv([0.025 0.975], length(phaseError(phaseError ~=0))-1);
                    phaseErrorCI(iParticipant, : , iPlot+iCompare-1) = rad2deg(circ_mean(phaseError(phaseError ~=0), [], 1) + t * SEM);
                    noSyncError(iParticipant, iPlot+iCompare-1) = NaN;
                end

                % Resultant vector lengths
                RVL(iParticipant, iPlot+iCompare-1) = log(dataSync.(condName).resultantLength ./ (1-dataSync.(condName).resultantLength));
                %                 RVL(iParticipant, iPlot+iCompare-1) = dataSync.(condName).resultantLength;

                % Inter-beat interval deviations
                IBI(iParticipant, iPlot+iCompare-1) = dataSync.(condName).IBIDeviation;

            end

        end % End Comparisons

        if iParticipant == length(Participants)
            iPlot = iPlot + length(Comparisons);
        end

    end % End Participants

end % End Conditions

%% Plot
plotScatterUpdated(RVL, Comparisons, Conditions, 'Synchronization Consistency (logit)');
plotScatterUpdated(phaseMean, Comparisons, Conditions, 'Synchronization Accuracy (°)'); %, noSyncPhase
plotScatterUpdated(IBI, Comparisons, Conditions, 'Interbeat Interval Deviations');
plotScatterUpdated(phaseErrorMean, Comparisons, Conditions, 'Synchronization Error (°)'); %, noSyncError

% Save
saveas(figure(1), [pathResults '/Sync/fig_syncConsistency.png'])
saveas(figure(2), [pathResults '/Sync/fig_syncAccuracy.png'])
saveas(figure(3), [pathResults '/Sync/fig_syncIBI.png'])
saveas(figure(4), [pathResults '/Sync/fig_syncError.png'])

close all;