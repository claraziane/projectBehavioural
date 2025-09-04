library(lme4) # Mixed models
library(lmerTest) # Mixed models
library(emmeans) # Posthoc tests
library(tidyverse) # GGPlot
library(effectsize)
library(car)
library(data.table)

# Load result table
DATA <- read.csv("/Users/claraziane/Desktop/statsTable_oddballResults_Behav_noOutliers.csv")
# DATA <- read.csv("/Users/claraziane/Desktop/statsTable_oddballResults_Behav.csv")
head(DATA)
# View(DATA)

# Declare factor levels
DATA$Mvt <- factor(DATA$Mvt, levels = c("Tap", "Walk")) 
DATA$Instruction <- factor(DATA$Instruction, levels = c("stim", "sync"))

# Define specific contrasts for post-hocs
contrasts(DATA$Mvt) <- contr.sum
contrasts(DATA$Instruction) <- contr.sum

model <- lmer(Nb.Errors ~ 1 + Mvt + Instruction + Mvt:Instruction + (1|Participants), data = DATA)
summary(model)

Anova(model, type=3, test.statistic = "F")
eta_squared(model, partial = TRUE)

emm_Instruction <- emmeans(model, ~ Mv)
summary(emm_Instruction)
