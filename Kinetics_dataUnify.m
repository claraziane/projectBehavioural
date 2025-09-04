clear;
close all;
clc;

Participants = {'P44'};
% Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
%                 'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29';...
%                 'P30'; 'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'};
Conditions   = {'stimRestODD';
                 'noneWalkST'; 'noneWalkSUB'; 'stimWalkODD'; 'syncWalkST'; 'syncWalkSUB'; 'syncWalkODD';...
                  'noneTapST';  'noneTapSUB';  'stimTapODD';  'syncTapST';  'syncTapSUB'; 'syncTapODD'};

for iParticipant = 1:length(Participants)

    for iCondition = 1:length(Conditions)

        % Create path for cleaned data or load preexisting data
        pathExport = (['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/' Participants{iParticipant} '/']);
        if ~exist(pathExport, 'dir')
            mkdir(pathExport)
        elseif exist([pathExport 'Events.mat'], 'file')
            load([pathExport 'Events.mat'])
        end

        % Load results from .TXT file as table
        file = (['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/RAW/' Participants{iParticipant} '/Kinetics/' Conditions{iCondition} '.TXT']);
        Data = readtable(file);

        [startTime] = getTrialStartTime(file);
        endTime     = startTime + (1000*149);
        if strcmpi(Conditions{iCondition}, 'stimWalkODD') || strcmpi(Conditions{iCondition}, 'stimTapODD') % Beats start after 11 seconds in these conditions
            [startTime] = startTime+(11*1000);
        end
        
        if strcmpi(Conditions{iCondition}(5:8), 'Walk') || strcmpi(Conditions{iCondition}(5:7), 'Tap')
            Events.(Conditions{iCondition}).mvtOnsets(Events.(Conditions{iCondition}).mvtOnsets < startTime) = [];
            Events.(Conditions{iCondition}).mvtOnsets(Events.(Conditions{iCondition}).mvtOnsets > endTime) = [];
            if strcmpi(Conditions{iCondition}, 'stimWalkODD') || strcmpi(Conditions{iCondition}, 'stimTapODD') % Beats start after 11 seconds in these conditions
                Events.(Conditions{iCondition}).mvtOnsets(1:4) = [];
            end

            if strcmpi(Conditions{iCondition}(5:8), 'Walk')
                Events.(Conditions{iCondition}).Cadence = 2 * round((60000 / (Events.(Conditions{iCondition}).mvtOnsets(end)-1 - Events.(Conditions{iCondition}).mvtOnsets(1))) * (length(Events.(Conditions{iCondition}).mvtOnsets)-1));
            elseif strcmpi(Conditions{iCondition}(5:7), 'Tap')
                Events.(Conditions{iCondition}).Cadence = round((60000 / (Events.(Conditions{iCondition}).mvtOnsets(end)-1 - Events.(Conditions{iCondition}).mvtOnsets(1))) * (length(Events.(Conditions{iCondition}).mvtOnsets)-1));
            end

            Events.(Conditions{iCondition}).IMI = [];
            Events.(Conditions{iCondition}).IMI = diff(Events.(Conditions{iCondition}).mvtOnsets);
            imiStd = nanstd(Events.(Conditions{iCondition}).IMI);
            Events.(Conditions{iCondition}).imiCV = imiStd/nanmean(Events.(Conditions{iCondition}).IMI);
            Events.(Conditions{iCondition}).mvtFreq = Events.(Conditions{iCondition}).Cadence/60;
        end

        % Save structure of processed data
        save([pathExport '/Events'], 'Events');
        clear Data cadence step
        close all;

    end
    clear Events

end