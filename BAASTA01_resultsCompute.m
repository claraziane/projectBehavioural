clear all;
close all;
clc;

% Declare paths
pathData    = '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/';

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18'; 'P19';...
                'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29';...
                'P30'; 'P31'; 'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39';...
                'P40'; 'P41'; 'P44'};

testName      = { 'BAT'; 'pacedTap'}; %'Anisochrony'; ; 'Adaptive'
extensionName = {'itiCV'; 'itiMean'; 'Async'; 'Rayleigh'; 'asyncSEM'; 'vectorDir'; 'vectorLength'};
Tests         = {'BAT_fast_dprime'; 'Paced_music_ross_mean'}; %'XX'; ; 'Adaptive_short'
Extensions    = {'_CV_iti';...
                 '_mean_iti';...
                 '_mean_absolute_asynchrony'; ...
                 '_rayleigh';...
                 '_sem_absolute_asynchrony';...
                 '_vector_direction'; ...
                 '_vector_length'};

% Import test scores
Scores = readtable('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/All/BAASTA_all-scores.csv');

for iParticipant = 1:length(Participants)

        % Create folder for participant's results if does not exist
        pathParticipant = fullfile(pathData, Participants{iParticipant}, '/');
        if ~exist(pathParticipant, 'dir')
            mkdir(pathParticipant)
        end

        % Find participant line in CSV file
        participantLine = Scores.subject;
                                        
        for iLine = 1:length(participantLine)
            if strcmpi(Participants{iParticipant}, participantLine{iLine})
                participantIndex = iLine;
            end
        end

        for iTest = 1:length(Tests)

            if strcmpi(testName{iTest}, 'BAT')
                resultsBAASTA.([testName{iTest}]) = Scores.([Tests{iTest}])(participantIndex);
                BAT(iParticipant) = Scores.([Tests{iTest}])(participantIndex);
            else
                iExtension = length(Extensions);

                for iVariable = 1:iExtension
                    resultsBAASTA.([testName{iTest}]).([extensionName{iVariable}]) = Scores.([Tests{iTest} Extensions{iVariable}])(participantIndex);

                    if strcmpi(([Tests{iTest} Extensions{iVariable}]), 'Paced_music_ross_mean_vector_length')
                        pacedTap(iParticipant) = Scores.([Tests{iTest} Extensions{iVariable}])(participantIndex);
                    end

                end
            end

        end
        %% Save results
        save([pathParticipant '/resultsBAASTA.mat'], 'resultsBAASTA');

end

%% Compute Beat Tracking Index

% Z-score transform
zBAT = (BAT - mean(BAT))/std(BAT);
zTap = (pacedTap - mean(pacedTap))/std(pacedTap);

% Compute beat tracking index
BTI  = mean(vertcat(zBAT, zTap),1);

for iParticipant = 1:length(Participants)
    pathParticipant = fullfile(pathData, Participants{iParticipant}, '/');
    load([pathParticipant '/resultsBAASTA.mat'])

    % Store results in structure
    resultsBAASTA.BTI = BTI(iParticipant);

    %% Save results
    save([pathParticipant '/resultsBAASTA.mat'], 'resultsBAASTA');

end

