clear all;
close all;
clc;

% Declare paths
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
    'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
    'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};


effectListen     = {'none'; 'stim'; 'sync'}; 
effectMvt        = {'Tap'; 'Walk'}; 
effectDifficulty = {'ST'; 'ODD'; 'SUB'}; 

%Pre-allocating matrices
Subject        = [];
Age            = [];
Gender         = [];
Listen         = [];
Mvt            = [];
Difficulty     = [];
mvtVariability = [];
mvtIMI         = [];
oddballErrors       = [];
subtractionsErrors  = [];
subtractionsCorrect = [];

% Load demographic info
dataDemog = readtable('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/All/demographicInfo.xlsx');

for iParticipant = 1:length(Participants)
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/Events.mat'])
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/resultsOddball.mat'])
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/resultsSubtractions.mat'])
    
    for iMvt = 1:length(effectMvt)

        for iListen = 1:length(effectListen) 

            for iDifficulty = 1:length(effectDifficulty)

                if strcmpi(effectListen{iListen}, 'none') && strcmpi(effectDifficulty{iDifficulty}, 'ODD')
                elseif strcmpi(effectListen{iListen}, 'stim') && strcmpi(effectDifficulty{iDifficulty}, 'ST')
                elseif strcmpi(effectListen{iListen}, 'stim') && strcmpi(effectDifficulty{iDifficulty}, 'SUB')
                else

                    condition = strcat(effectListen(iListen), effectMvt(iMvt), effectDifficulty(iDifficulty));

                    Subject = [Subject ; {Participants{iParticipant}}];
                    for iLine = 1:size(dataDemog,1)
                        if strcmpi(dataDemog.ID{iLine}, Participants{iParticipant})
                            subjline = iLine;
                            break;
                        end
                    end
                    Age    = [Age; dataDemog.Age(subjline)];
                    Gender = [Gender; dataDemog.Genre(subjline)];


                    if strcmpi({effectListen{iListen}}, 'stim') || strcmpi({effectListen{iListen}}, 'none')
                        Listen     = [Listen; {'spontaneous'}];
                    elseif strcmpi({effectListen{iListen}}, 'sync') 
                        Listen     = [Listen; {'synchronize'}];
                    end

                    if strcmpi(effectMvt{iMvt,1}, 'Tap')
                        Mvt        = [Mvt; {'tapping'}];
                    elseif strcmpi(effectMvt{iMvt,1}, 'Walk')
                        Mvt        = [Mvt; {'walking'}];
                    end

                    if strcmpi({effectDifficulty{iDifficulty}}, 'ST')
                        Difficulty = [Difficulty; {'singleTask'}];
                        oddballErrors = [oddballErrors; NaN];
                        subtractionsErrors  = [subtractionsErrors; NaN];
                        subtractionsCorrect = [subtractionsCorrect; NaN];
                    elseif strcmpi({effectDifficulty{iDifficulty}}, 'ODD')
                        Difficulty = [Difficulty; {'oddball'}];
                        oddballErrors = [oddballErrors; resultsOddball.(condition{1,1})];
                        subtractionsErrors  = [subtractionsErrors; NaN];
                        subtractionsCorrect = [subtractionsCorrect; NaN];
                    elseif strcmpi({effectDifficulty{iDifficulty}}, 'SUB')
                        Difficulty = [Difficulty; {'subtractions'}];
                        oddballErrors = [oddballErrors; NaN];
                        subtractionsErrors  = [subtractionsErrors; resultsSubtractions.(condition{1,1}).nError];
                        subtractionsCorrect = [subtractionsCorrect; resultsSubtractions.(condition{1,1}).nCorrect];
                    end


                    % Participants with FSR issues
                    if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];                    
                    elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];                    
                    elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];
                    
                    % If too many NaN values
                    elseif sum(isnan(Events.(condition{1,1}).mvtOnsets)) >= length(Events.(condition{1,1}).mvtOnsets)/3
                        mvtVariability  = [mvtVariability; NaN];
                        mvtIMI          = [mvtIMI; NaN];

                    else
                        mvtVariability  = [mvtVariability; Events.(condition{1,1}).imiCV];
                        if strcmpi(effectMvt{iMvt}, 'Walk')
                            mvtIMI = [mvtIMI; nanmean(Events.(condition{1,1}).IMI)/2];

                        else
                            mvtIMI = [mvtIMI; nanmean(Events.(condition{1,1}).IMI)];
                        end
                    end

                end

            end

        end

    end

end

% Convert to table format
resultsTable = table(Subject, Age, Gender, Mvt, Listen, Difficulty, mvtIMI, mvtVariability, oddballErrors, subtractionsErrors, subtractionsCorrect,...
'VariableNames', {'Participant', 'Age', 'Gender', 'Movement', 'Instruction', 'Cognitive Load', 'Mean IMI (ms)', 'CV', 'Oddball Errors', 'Subtractions Errors', 'Subtractions Correct'});
writetable(resultsTable, '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Articles/articleBehavioural/SUBMITTED/PsyArXiv/dataTable_EXP2_IMI_CV_Cognition.csv')
