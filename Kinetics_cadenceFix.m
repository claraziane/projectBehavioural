clear;
close all;
clc;

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29';...
                'P30'; 'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'; 'P31'};
Conditions   = {'noneWalkST'; 'noneWalkSUB'; 'stimWalkODD'; 'syncWalkST'; 'syncWalkSUB'; 'syncWalkODD';...
                 'noneTapST';  'noneTapSUB';  'stimTapODD';  'syncTapST';  'syncTapSUB'; 'syncTapODD'};

for iParticipant = length(Participants)

    for iCondition = 1:length(Conditions)

        % Create path for cleaned data or load preexisting data
        pathExport = (['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/']);
        load([pathExport 'Events.mat'])

        Onsets = Events.(Conditions{iCondition}).mvtOnsets;
        Onsets(isnan(Onsets)) = [];

        if ~isempty(Onsets)

            if strcmpi(Conditions{iCondition}(5:8), 'Walk')
                cadence = 2 * round((60000 / (Onsets(end)-1 - Onsets(1))) * (length(Onsets)-1));
            elseif strcmpi(Conditions{iCondition}(5:7), 'Tap')
                cadence = round((60000 / (Onsets(end)-1 - Onsets(1))) * (length((Onsets))-1));
            end
            Events.(Conditions{iCondition}).Cadence = cadence;
            Events.(Conditions{iCondition}).mvtFreq = cadence/60;

        else
            Events.(Conditions{iCondition}).mvtOnsets = NaN;
            Events.(Conditions{iCondition}).Cadence = NaN;
            Events.(Conditions{iCondition}).mvtFreq = NaN;
            Events.(Conditions{iCondition}).IMI = NaN;
            Events.(Conditions{iCondition}).imiCV = NaN;
        end
            

        clear cadence Onsets

    end
    save([pathExport '/Events'], 'Events');

    clear Events

end