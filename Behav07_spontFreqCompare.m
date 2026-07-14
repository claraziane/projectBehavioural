clear all;
close all;
clc;

% Declare paths
pathEEG     = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/DATA/Processed/');
pathTeensy  = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/projectFig/');
addpath('/Users/claraziane/Documents/Académique/Informatique/Toolbox/CircStat2012a/');

Participants = {'P02'; 'P03'; 'P10'; 'P16'; 'P17'; 'P18';...
    'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
    'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};

Conditions   = {'Session1_ST'; 'Session_ST'; 'Session_ST'; 'Session1_ST'; 'Session_ST'; 'Session_ST'}; 
xLabels      = {'Session 1'; 'Session 2'; 'Session 3'; 'Session 1'; 'Session 2'; 'Session 3'}; 

Comparisons  = {'ST'};

condA = 'testTap';
condBC = 'noneTapST';

condX = 'testWalk';
condYZ = 'noneWalkST';

for iParticipant = 1:length(Participants)

    % Load data
    load([pathEEG Participants{iParticipant} '/01/Behavioural/dataStep.mat']);
    load([pathEEG Participants{iParticipant} '/01/Behavioural/dataRAC.mat']);
    load([pathEEG Participants{iParticipant} '/01/Behavioural/dataTap.mat']);
    load(['/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Results/' Participants{iParticipant} '/01/resultsBehav.mat'])
    load([pathTeensy Participants{iParticipant} '/Events.mat']);

    if iParticipant == 1 || iParticipant == 2 
            dataA(iParticipant,1) = RAC.syncTapST.beatFrequency;
    else
            dataA(iParticipant,1) = Taps.(condA).tapFreq;
    end 

    dataB(iParticipant,1) = 1000/(resultsBehav.(condBC).imiMean);
    dataC(iParticipant,1) = Events.(condBC).mvtFreq;

    dataX(iParticipant,1) = Steps.(condX).stepFreq;
    dataY(iParticipant,1) = 1000/(resultsBehav.(condYZ).imiMean);
    dataZ(iParticipant,1) = Events.(condYZ).mvtFreq;


end
DATA = horzcat(dataA, dataB, dataC, dataX, dataY, dataZ);


% Plot
plotScatter(DATA, Comparisons, xLabels, 'Fréquence Spontanée (Hz)');
saveas(figure(1), [pathResults '/overgroundVStreadmill/fig_gaitSpontFreq.png']);
