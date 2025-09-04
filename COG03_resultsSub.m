clear;
close all;
clc;

% Declare paths
pathData       = '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/RAW/';
pathProcesssed = '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/';

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
                'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};
Conditions   = {'noneTapSUB'; 'noneWalkSUB'; 'syncTapSUB'; 'syncWalkSUB'}; % 'noneRestSUB'; 'lastRestSUB'

for iParticipant = 1:length(Participants)
   
    for iCondition = 1:length(Conditions)
        dataCog = xlsread([pathData Participants{iParticipant} '/Cognition/substractions.xlsx'], Conditions{iCondition});
     
        resultsSubtractions.(Conditions{iCondition}).nCorrect = dataCog(end,2);
        resultsSubtractions.(Conditions{iCondition}).nError   = dataCog(end,3);

%         % If lastRestSUB was not conducted
%         resultsSubtractions.(Conditions{iCondition}).nCorrect = NaN;
%         resultsSubtractions.(Conditions{iCondition}).nError = NaN;

        clear dataCog
    end
    save([pathProcesssed Participants{iParticipant} '/resultsSubtractions.mat'], 'resultsSubtractions');
    clear resultsSubtractions

end