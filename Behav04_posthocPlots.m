clear all;
close all;
clc;

% Declare paths
pathData    = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/DATA/Processed/');
pathResults = ('/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projectBehavioural/Results/');
addpath('/Users/claraziane/Documents/Académique/Informatique/projectFig/'); %Functions for figures

Participants = {'P02'; 'P03'; 'P04'; 'P08'; 'P10'; 'P13'; 'P16'; 'P17'; 'P18';...
    'P19'; 'P21'; 'P23'; 'P24'; 'P25'; 'P26'; 'P27'; 'P29'; 'P30'; 'P31';...
    'P32'; 'P33'; 'P34'; 'P35'; 'P36'; 'P37'; 'P38'; 'P39'; 'P40'; 'P41'; 'P44'};

Mvt         = {'Tap'; 'Walk'};
Instruction = {'none'; 'sync'};
Difficulty  = {'ST'; 'ODD'; 'SUB'};

variables = {'imiCV'; 'IMI'; 'resultantLength'};
yLabels   = {'Coefficient of Variation_{Inter-Movement Interval}'; 'Inter-Movement Interval (ms)'; 'Synchronization Consistency (logit)'};
iPlot = 1;

for iVariable = 2

    if strcmpi(variables{iVariable}, 'imiCV') || strcmpi(variables{iVariable}, 'IMI')
        Category = 'Motor';
        structureName = 'Events';
    elseif strcmpi(variables{iVariable}, 'resultantLength')
        Category = 'Sync';
        structureName = 'dataSync';
    end


    for iInteraction = 1%1:3
        if ismember(iInteraction, [1 3])
            nCompare = 3;
        else
            nCompare = 2;
        end

        % Preallocate matrix
        DATA = nan(length(Participants),2*nCompare);

        for iCondition = 1:2

            for iParticipant = 1:length(Participants)

                % Load data
                pathImport = [pathData Participants{iParticipant} '/'];
                load([pathImport 'Events.mat']);
                if strcmpi(Category, 'Motor')
                    Structure = load([pathImport 'Events.mat']);
                elseif strcmpi(Category, 'Sync')
                    Structure = load([pathImport 'dataSync.mat']);
                end

                for iCompare = 1:nCompare

                    if iInteraction == 1  % Movement*Difficulty

                        if strcmpi(Difficulty{iCompare}, 'ODD')
                            Instruction = {'stim'; 'sync'};
                        else
                            Instruction = {'none'; 'sync'};
                        end

                        if strcmpi(Category, 'Sync')
                            Instruction = {'sync'};
                        end

                        condName = [Mvt{iCondition} Difficulty{iCompare}];

                        if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(Mvt{iCondition}, 'Walk')
                        elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(Mvt{iCondition}, 'Walk')
                        elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(Mvt{iCondition}, 'Walk')
                        else

                            if strcmpi(variables{iVariable}, 'IMI')
                                x = nanmean(Structure.(structureName).([Instruction{1} condName]).([variables{iVariable}]));
                                y = nanmean(Structure.(structureName).([Instruction{2} condName]).([variables{iVariable}]));

                                if strcmpi(condName(1:4), 'Walk') % to get inter-step rather than inter-stride interval
                                    x = x/2;
                                    y = y/2;
                                end
                             elseif strcmpi(variables{iVariable}, 'resultantLength')
                                x = log(Structure.(structureName).([Instruction{1} condName]).([variables{iVariable}]) ./ (1- Structure.(structureName).([Instruction{1} condName]).([variables{iVariable}])));
                                y = NaN;
                            else
                                x = Structure.(structureName).([Instruction{1} condName]).([variables{iVariable}]);
                                y = Structure.(structureName).([Instruction{2} condName]).([variables{iVariable}]);
                            end

                            if sum(isnan(Events.([Instruction{1} condName]).mvtOnsets)) >= length(Events.([Instruction{1} condName]).mvtOnsets)/3
                                x = NaN;
                            end
                            if sum(isnan(Events.([Instruction{end} condName]).mvtOnsets)) >= length(Events.([Instruction{end} condName]).mvtOnsets)/3
                                y = NaN;
                            end
                            DATA(iParticipant, iPlot+iCompare-1) = nanmean(vertcat([x y]));

                        end

                    elseif iInteraction == 2 % Movement * Instruction
                        condName = [Instruction{iCompare} Mvt{iCondition}];
                       
                        if strcmpi(Participants{iParticipant}, 'P04') && strcmpi(Mvt{iCondition}, 'Walk')
                        elseif strcmpi(Participants{iParticipant}, 'P08') && strcmpi(Mvt{iCondition}, 'Walk')
                        elseif strcmpi(Participants{iParticipant}, 'P13') && strcmpi(Mvt{iCondition}, 'Walk')
                        else
                            if strcmpi(Instruction{iCompare}, 'none')
                                if sum(isnan(Events.(['stim' Mvt{iCondition} Difficulty{2}]).mvtOnsets)) >= length(Events.(['stim' Mvt{iCondition} Difficulty{2}]).mvtOnsets)/3
                                    y = NaN;
                                else
                                    y = Structure.(structureName).(['stim' Mvt{iCondition} Difficulty{2}]).([variables{iVariable}]);
                                end
                            else
                                if sum(isnan(Events.([condName Difficulty{2}]).mvtOnsets)) >= length(Events.([condName Difficulty{2}]).mvtOnsets)/3
                                    y = NaN;
                                else
                                    y = Structure.(structureName).([condName Difficulty{2}]).([variables{iVariable}]);
                                end
                            end

                            if sum(isnan(Events.([condName Difficulty{1}]).mvtOnsets)) >= length(Events.([([condName Difficulty{1}])]).mvtOnsets)/3
                                x = NaN;
                            else
                                x = Structure.(structureName).([condName Difficulty{1}]).([variables{iVariable}]);
                            end
                            if sum(isnan(Events.([condName Difficulty{3}]).mvtOnsets)) >= length(Events.([condName Difficulty{3}]).mvtOnsets)/3
                                z = NaN;
                            else
                                z = Structure.(structureName).([condName Difficulty{3}]).([variables{iVariable}]);
                            end
                            DATA(iParticipant, iPlot+iCompare-1) = nanmean(vertcat([x y z]));

                        end

                    else % Instruction * Difficulty
                        condFirst  = [Instruction{iCondition}];
                        condSecond = [Difficulty{iCompare}];
                        DATA(iParticipant, iPlot+iCompare-1) = (Structure.(structureName).([condFirst Mvt{1} condSecond]).([variables{iVariable}]) + Structure.(structureName).([condFirst Mvt{2} condSecond]).([variables{iVariable}]))/2;
                    end

                end

                if iParticipant == length(Participants)
                    iPlot = iPlot + nCompare;
                end

            end % End Participants

        end % End Conditions

        if iInteraction == 1
            plotScatterUpdated(DATA, Difficulty, Mvt, yLabels{iVariable});
            title('Movement*Difficulty Interaction')
            saveas(figure(1), [pathResults Category '/fig_' variables{iVariable} '_Mvt-Difficulty.png'])

        elseif iInteraction == 2
            plotScatter(DATA, Instruction, Mvt, yLabels{iVariable});
            title('Movement*Instruction Interaction')
            saveas(figure(2), [pathResults Category '/fig_' variables{iVariable} '_Mvt-Instruction.png'])

        else
            plotScatterUpdated(DATA, Difficulty, Instruction, yLabels{iVariable});
            title('Instruction*Difficulty Interaction')
            saveas(figure(3), [pathResults Category '/fig_' variables{iVariable} '_Difficulty-Instruction.png'])

        end
        iPlot = 1;

    end % End Interactions

end % End Variables