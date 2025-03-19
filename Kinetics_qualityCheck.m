clear;
close;
clc;

% Declare paths
addpath '/Users/claraziane/Documents/Académique/Informatique/projetDT'

Participants = {'P03'};
Conditions   = {'noneWalkST'; 'noneWalkSUB'; 'stimWalkODD'; 'syncWalkST'; 'syncWalkSUB'; 'syncWalkODD';...
                 'noneTapST';  'noneTapSUB';  'stimTapODD';  'syncTapST';  'syncTapSUB'; 'syncTapODD'};

for iParticipant = 1:length(Participants)

    for iCondition = 9:length(Conditions)

        % Load results from .TXT file as table
        Data = readtable(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/RAW/' Participants{iParticipant} '/Kinetics/' Conditions{iCondition} '.TXT']);
        Data = table(Data.Var1, Data.Var2, Data.Var3, Data.Var4, Data.Var5, Data.Var6, Data.Var7,'VariableNames', {'nStep', 'Movement', 'mvtOnset', 'mvtOffset', 'maxForceTime','maxForce', 'missedFrames'});

        % Extracting step onsets
        Onsets = [];
        Onsets = Data.mvtOnset;
        Onsets(Onsets == 0) = NaN;
        Onsets = Onsets(~isnan(Onsets));

        IMI = [];
        IMI = diff(Onsets(10:end-1));
        figure; plot(IMI);

        % Computing coefficient of variability of inter-mvt intervals
        imiStd = std(IMI);
        imiCV = imiStd/mean(IMI);

        [cadence, stepFreq] = getCadence(Onsets, 1000);
        if strcmpi(Conditions{iCondition}(5:8), 'Walk')
            cadence = cadence*2;
            stepFreq = stepFreq*2;
        end

        clear DATA
        close;

    end

end
