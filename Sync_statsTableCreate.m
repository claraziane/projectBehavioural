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

effectListen     = {'sync'}; %'none'; 'stim'; 'sync'
effectMvt        = {'Tap'; 'Walk'}; %'Rest'; 'Tap'; 'Walk'
effectDifficulty = {'ST'; 'ODD'; 'SUB'}; %'ST'; 'DT'

%Pre-allocating matrices
Subject = [];
Class   = [];
yearsPractice   = [];
Listen = [];
Mvt   = [];
Difficulty = [];
% Sync = [];
syncAccuracy = [];
syncConsistency = [];
Flexibility = [];
Inhibition  = [];
workingMemory = [];
BAT = [];
BTI = [];

% Load demographic info
dataDemog = readtable('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/All/demographicInfo.xlsx');

for iParticipant = 1:length(Participants)
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/Events.mat'])
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/'  Participants{iParticipant} '/dataSync.mat'])
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/' Participants{iParticipant} '/01/resultsCog.mat'])

    for iListen = 1:length(effectListen)

        for iMvt = 1:length(effectMvt)

            for iDifficulty = 1:length(effectDifficulty)

                if strcmpi(effectListen{iListen}, 'none') && strcmpi(effectDifficulty{iDifficulty}, 'ODD')
                elseif strcmpi(effectListen{iListen}, 'stim') && strcmpi(effectDifficulty{iDifficulty}, 'ST')
                elseif strcmpi(effectListen{iListen}, 'stim') && strcmpi(effectDifficulty{iDifficulty}, 'SUB')
                else

                    condition = strcat(effectListen(iListen), effectMvt(iMvt), effectDifficulty(iDifficulty));

                    % Participants with FSR issues
                    if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P04') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'syncWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'noneWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];
                    elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(condition{1,1}(1:8), 'stimWalk')
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];

                        % If too many NaN values
                    elseif sum(isnan(Events.(condition{1,1}).mvtOnsets)) >= length(Events.(condition{1,1}).mvtOnsets)/3
                        syncConsistency = [syncConsistency; NaN];
                        syncAccuracy    = [syncAccuracy; NaN];

                    else
                        syncConsistency = [syncConsistency; log(dataSync.(condition{1,1}).resultantLength ./ (1-dataSync.(condition{1,1}).resultantLength))];
                        [p] = circ_rtest(deg2rad(dataSync.(condition{1,1}).phaseAngle));
                        if p >= 0.05
                            %                             Sync            = [Sync; 'unsync'];
                            syncAccuracy    = [syncAccuracy; NaN];
                        else
                            %                             Sync            = [Sync; 'issync'];
                            syncAccuracy    = [syncAccuracy; rad2deg(dataSync.(condition{1,1}).phaseAngleMean)];
                        end

                    end

                    Subject = [Subject ; {Participants{iParticipant}}];
                    for iLine = 1:size(dataDemog,1)
                        if strcmpi(dataDemog.ID{iLine}, Participants{iParticipant})
                            subjline = iLine;
                            break;
                        end
                    end
                    Class = [Class; dataDemog.Classification(subjline)];
                    yearsPractice = [yearsPractice; dataDemog.YearsOfMusicPractice(subjline)];

                    if strcmpi(condition, 'stimTapODD') || strcmpi(condition, 'stimWalkODD')
                        Listen     = [Listen; 'none'];
                    else
                        Listen     = [Listen; {effectListen{iListen}}];
                    end
                    Mvt        = [Mvt; {effectMvt(iMvt)}];
                    Difficulty = [Difficulty; {effectDifficulty{iDifficulty}}];

                    % Cognitive functions
                    Flexibility   = [Flexibility; resultsCog.Flexibility];
                    Inhibition    = [Inhibition; resultsCog.Inhibition];
                    workingMemory = [workingMemory; resultsCog.workingMemory];

                    % Rhythmic Abilities
                    if strcmpi(Participants{iParticipant}, 'P44')
                        BAT   = [BAT; NaN];
                        BTI   = [BTI; NaN];

                    else
                        load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/'  Participants{iParticipant} '/resultsBAASTA.mat'])
                        BAT   = [BAT; resultsBAASTA.BAT];
                        BTI   = [BTI; resultsBAASTA.BTI];
                    end

                end

            end

        end

    end

end

% Convert to table format
resultsTable = table(Subject, Class, yearsPractice, Listen, Mvt, Difficulty, syncAccuracy, syncConsistency, Flexibility, Inhibition, workingMemory, BAT, BTI, 'VariableNames', {'Participants', 'Musicians', 'YearsOfMusicPractice', 'Instruction', 'Movement', 'Complexity', 'syncAccuracy', 'syncConsistency', 'Flexibility', 'Inhibition', 'workingMemory', 'BAT', 'BTI'});
writetable(resultsTable, [pathResults 'Sync/statsTable.csv'])