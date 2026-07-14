clear all;
close all;
clc;

% Declare paths
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18'; 'P19';...
    'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29';...
    'P30'; 'P31'; 'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39';...
    'P40'; 'P41'; 'P44'};

effectListen     = {'sync'};
effectMvt        = {'Tap'; 'Walk'};
effectDifficulty = {'ST'; 'ODD'; 'SUB'};

%Pre-allocating matrices
Subject = [];
Age     = [];
Gender  = [];
Listen  = [];
Mvt     = [];
Difficulty      = [];
syncConsistency = [];

% Load demographic info
dataDemog = readtable('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/All/demographicInfo.xlsx');

for iParticipant = 1:length(Participants)
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/Events.mat'])
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/'  Participants{iParticipant} '/dataSync.mat'])

    for iListen = 1:length(effectListen)

        for iMvt = 1:length(effectMvt)

            for iDifficulty = 1:length(effectDifficulty)

                condition = strcat(effectListen(iListen), effectMvt(iMvt), effectDifficulty(iDifficulty));

                % Participants with FSR issues
                if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                    syncConsistency = [syncConsistency; NaN];
                elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                    syncConsistency = [syncConsistency; NaN];

                    % If too many NaN values
                elseif sum(isnan(Events.(condition{1,1}).mvtOnsets)) >= length(Events.(condition{1,1}).mvtOnsets)/3
                    syncConsistency = [syncConsistency; NaN];

                else
                    syncConsistency = [syncConsistency; log(dataSync.(condition{1,1}).resultantLength ./ (1-dataSync.(condition{1,1}).resultantLength))];
                end

                Subject = [Subject ; {Participants{iParticipant}}];
                for iLine = 1:size(dataDemog,1)
                    if strcmpi(dataDemog.ID{iLine}, Participants{iParticipant})
                        subjline = iLine;
                        break;
                    end
                end
                Age = [Age; dataDemog.Age(subjline)];
                Gender = [Gender; dataDemog.Genre(subjline)];

                Listen     = [Listen; {'synchronize'}];
                if strcmpi(effectMvt{iMvt,1}, 'Tap')
                    Mvt        = [Mvt; {'tapping'}];
                elseif strcmpi(effectMvt{iMvt,1}, 'Walk')
                    Mvt        = [Mvt; {'walking'}];
                end

                if strcmpi({effectDifficulty{iDifficulty}}, 'ST')
                    Difficulty = [Difficulty; {'singleTask'}];
                elseif strcmpi({effectDifficulty{iDifficulty}}, 'ODD')
                    Difficulty = [Difficulty; {'oddball'}];
                elseif strcmpi({effectDifficulty{iDifficulty}}, 'SUB')
                    Difficulty = [Difficulty; {'subtractions'}];
                end

            end

        end

    end

end

% Convert to table format
resultsTable = table(Subject, Age, Gender, Mvt, Listen, Difficulty, syncConsistency,...
    'VariableNames', {'Participant', 'Age', 'Gender', 'Movement', 'Instruction', 'Cognitive Load', 'Sync Consistency (logit)'});
writetable(resultsTable, '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Articles/articleBehavioural/SUBMITTED/PsyArXiv/dataTable_EXP2_syncConsistency.csv')
