clear all;
close all;
clc;

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
                'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
                'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};
pathResults = '/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/';
for iParticipant = 1:length(Participants)
    load([pathResults Participants{iParticipant} '/01/resultsCog.mat'], 'resultsCog')

    Flexibility(iParticipant,1) = resultsCog.Flexibility;
    Inhibition(iParticipant,1)  = resultsCog.Inhibition;
    WM(iParticipant,1)          = resultsCog.workingMemory;

end