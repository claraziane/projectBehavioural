clear all;
close all;
clc;

% Declare paths
pathImport    = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');

% Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
%                 'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30';...
%                 'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'};
Participants = {'P44'};

Conditions   = {'stimWalkODD'; 'syncWalkST'; 'syncWalkSUB'; 'syncWalkODD';...
                 'stimTapODD';  'syncTapST';  'syncTapSUB'; 'syncTapODD'};
     
for iParticipant = 1:length(Participants)

        pathData = [pathImport Participants{iParticipant} '/'];

        % Load behavioural data
        load([pathImport Participants{iParticipant}  '/Events.mat']);

        for iCondition = 1:length(Conditions)

            % Extract acquisition frequency
            sampFreq  = Events.([Conditions{iCondition}]).sampFreq;

            % Extracting beat onsets
            beatOnset = [];
            beatOnset = Events.([Conditions{iCondition}]).beatOnsets;
            IOI = Events.([Conditions{iCondition}]).IBI;

            % Extracting movement onsets
            mvtOnset = [];                
            mvtOnset = Events.([Conditions{iCondition}]).mvtOnsets;

            if sum(isnan(mvtOnset)) >= length(mvtOnset)/3
                
                dataSync.([Conditions{iCondition}]).IBIDeviation = NaN;
                dataSync.([Conditions{iCondition}]).Asynchrony = NaN;
                dataSync.([Conditions{iCondition}]).circularAsynchrony = NaN;
                dataSync.([Conditions{iCondition}]).asynchronyMean = NaN;
                dataSync.([Conditions{iCondition}]).circularVariance = NaN;
                dataSync.([Conditions{iCondition}]).pRaleigh = NaN;
                dataSync.([Conditions{iCondition}]).phaseAngle = NaN;
                dataSync.([Conditions{iCondition}]).phaseError = NaN;
                dataSync.([Conditions{iCondition}]).phaseErrorMean = NaN;
                dataSync.([Conditions{iCondition}]).phaseAngleMean = NaN;
                dataSync.([Conditions{iCondition}]).resultantLength = NaN;

            else
                mvtOnset = mvtOnset(~isnan(mvtOnset));
               
                %% Estimating period-matching accuracy (i.e., extent to which step tempo matches stimulus tempo) using IBI deviation

                % Matching step onsets to closest beat
                beatMatched = [];
                for iMvt = 1:length(mvtOnset)
                    [minValue matchIndex] = min(abs(beatOnset-mvtOnset(iMvt)));
                    beatMatched(iMvt,1) = beatOnset(matchIndex);
                end

                % Calculating interstep interval
                mvtInterval = [];
                mvtInterval = diff(mvtOnset);

                % Calculating interbeat interval
                racInterval = [];
                racInterval = diff(beatMatched);

                % Calculating IBI deviation
                IBI = [];
                IBI = mean(abs(mvtInterval - racInterval))/mean(racInterval);

                %% Estimating phase-matching accuracy (i.e., the difference between step onset times and beat onset times) using circular asynchronies
                asynchrony           = [];
                asynchronyNormalized = [];
                asynchronyCircular   = [];
                asynchronyRad        = [];

                asynchrony           = mvtOnset - beatMatched;
                asynchronyNormalized = asynchrony(1:end-1)./mvtInterval;
                asynchronyCircular   = asynchronyNormalized * 360;
                asynchronyRad        = asynchronyCircular * pi/180;
                asynchronyMean       = circ_mean(asynchronyRad, [], 1);
%             figure; scatter(1,asynchronyCircular)

                % Calculating circular variance
                [varianceCircular varianceAngular] = circ_var(asynchronyRad);

                % Calculating phase angles (error measure of synchronization based on the phase difference between two oscillators)
                phaseAngle     = [];
                phaseAngle     = 360*(asynchrony(1:end-1)/IOI);

                phaseError     = [];
                phaseError     = abs(phaseAngle);
                phaseErrorRad  = deg2rad(phaseError);
                phaseErrorMean = circ_mean(phaseErrorRad(phaseErrorRad ~=0), [], 1);

                phaseRad       = [];
                phaseRad       = deg2rad(phaseAngle);
                phaseAngleMean = circ_mean(phaseRad(phaseRad ~=0), [], 1);

                % Running Raleigh's test (a not-significant test means participant failed to synchronize)
                [pRaleigh] = circ_rtest(phaseRad);

                % Calculating resultant vector length (expresses the stability of the relative phase angles over time)
                resultantLength = circ_r(phaseRad, [], [], 1);

                % Storing results in structure
                dataSync.([Conditions{iCondition}]).IBIDeviation = IBI;
                dataSync.([Conditions{iCondition}]).Asynchrony = asynchrony;
                dataSync.([Conditions{iCondition}]).circularAsynchrony = asynchronyCircular;
                dataSync.([Conditions{iCondition}]).asynchronyMean = asynchronyMean;
                dataSync.([Conditions{iCondition}]).circularVariance = varianceCircular;
                dataSync.([Conditions{iCondition}]).pRaleigh = pRaleigh;
                dataSync.([Conditions{iCondition}]).phaseAngle = phaseAngle;
                dataSync.([Conditions{iCondition}]).phaseError = phaseError;
                dataSync.([Conditions{iCondition}]).phaseErrorMean = phaseErrorMean;
                dataSync.([Conditions{iCondition}]).phaseAngleMean = phaseAngleMean;
                dataSync.([Conditions{iCondition}]).resultantLength = resultantLength;
            end

        end % End Conditions

        % Save results
        save([pathData 'dataSync.mat'], 'dataSync');

end % End Participants