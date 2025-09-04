clear;
close all;
clc;

% Declare paths
pathData       = '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/RAW/';
pathProcesssed = '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/';

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
                'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};
Conditions   = {'stimRestODD'; 'stimTapODD'; 'stimWalkODD'; 'syncTapODD'; 'syncWalkODD'};

for iParticipant = length(Participants)

    load([pathProcesssed Participants{iParticipant} '/Events.mat'])
    dataCog = readtable([pathData Participants{iParticipant} '/Cognition/oddball.xlsx']);

    for iCondition = 1:length(Conditions)

        for iLine = 1:size(dataCog,1)
            if strcmpi(dataCog.Var1{iLine}, Conditions{iCondition})
                Condline = iLine;
            end
        end

        nTargetsLow = sum(Events.(Conditions{iCondition}).Oddball == 2);
        nTargetHigh = sum(Events.(Conditions{iCondition}).Oddball == 3);

        lowError  = abs(nTargetsLow - dataCog.Counted(Condline));
        highError = abs(nTargetHigh - dataCog.Counted_1(Condline));


        resultsOddball.(Conditions{iCondition}) = lowError + highError;

    end
    save([pathProcesssed Participants{iParticipant} '/resultsOddball.mat'], 'resultsOddball');
    clear resultsOddball Events dataCog

end
