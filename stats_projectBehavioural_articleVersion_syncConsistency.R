library(lme4) # Mixed models
library(lmerTest) # Mixed models
library(emmeans) # Posthoc tests
library(tidyverse) # GGPlot
library(effectsize)
library(car)
library(data.table)

# Load result table
DATA <- read.csv("/Users/claraziane/Library/CloudStorage/OneDrive-UniversitedeMontreal/Projets/projetDT/Articles/articleBehavioural/SUBMITTED/PsyArXiv/dataTable_EXP2_syncConsistency.csv")
head(DATA)

DATA$Movement <- factor(DATA$Movement, levels = c("tapping", "walking")) 
DATA$Cognitive.Load <- factor(DATA$Cognitive.Load, levels = c("singleTask", "oddball", "subtractions"))

# Define the specific contrasts for posthocs
contrasts(DATA$Movement) <- contr.sum
contrasts(DATA$Cognitive.Load) <- contr.sum

model <- lmer(Sync.Consistency..logit. ~ 1 + Movement + Cognitive.Load + Movement:Cognitive.Load + (1|Participant), data = DATA)
summary(model)

Anova(model, type=3, test.statistic = "F")
eta_squared(model, partial = TRUE)

# Check means
emm_mvtDifficultyIntruction <- emmeans(model, ~ Movement * Cognitive.Load * Instruction)
summary(emm_mvtDifficultyIntruction)

# Effect of complexity
contrast_Complexity <- list(
  "ST - ODD"    = c(1, -1, 0), 
  "ST - SUB"    = c(1, 0, -1), 
  "ODD - SUB"    = c(0, 1, -1)
)

emm_Complexity <- emmeans(model, ~ Cognitive.Load)
summary(emm_Complexity)

contrast(emm_Complexity, contrast_Complexity, adjust = "bonferroni")

## Check assumptions
# plot(model, which = 1) # Residuals
# plot(model, which = 2) # QQplot

## Compute post hoc for Movement * Difficulty interaction
contrast_mvtComplexity <- list(
  "Tap ST - Tap ODD"    = c(1, 0, -1, 0, 0, 0), 
  "Tap ST - Tap SUB"    = c(1, 0, 0, 0, -1, 0), 
  "Tap ODD - Tap SUB"   = c(0, 0, 1, 0, -1, 0), 
  "Walk ST - Walk ODD"  = c(0, 1, 0, -1, 0, 0),   
  "Walk ST - Walk SUB"  = c(0, 1, 0, 0, 0, -1),  
  "Walk ODD - Walk SUB" = c(0, 0, 0, 1, 0, -1),
  "Tap ST - Walk ST"    = c(1, -1, 0, 0, 0, 0),
  "Tap ODD - Walk ODD"  = c(0, 0, 1, -1, 0, 0),
  "Tap SUB - Walk SUB"  = c(0, 0, 0, 0, 1, -1)
)
emm_mvtComplexity <- emmeans(model, ~ Movement * Cognitive.Load)
summary(emm_mvtComplexity)

## Run all comparisons with Bonferroni correction
# pairwise_Movement <- contrast(emm_movementDifficulty, method = "pairwise", adjust = "bonferroni")
# summary(pairwise_Movement)

# Run targeted comparisons with Bonferroni correction
contrast(emm_mvtComplexity, contrast_mvtComplexity, adjust = "bonferroni")
# (prelim_plot <- ggplot(DATA, aes(x = Movement, y = mvtVar)) + geom_point() + geom_smooth(method = "lm"))

## Compute post hoc for Movement * Modality interaction
contrast_mvtInstruction <- list(
  "Tap none - Tap sync"   = c(1, 0, -1, 0),  
  "Walk none - Walk sync" = c(0, 1, 0, -1),
  "Tap none - Walk none"  = c(1, -1, 0, 0),
  "Tap sync - Walk sync"  = c(0, 0, 1, -1)
)
emm_mvtInstruction <- emmeans(model, ~ Movement * Instruction)
summary(emm_mvtInstruction)

# Run targeted comparisons with Bonferroni correction
contrast(emm_mvtInstruction, contrast_mvtInstruction, adjust = "bonferroni")

## Compute post hoc for Difficulty * Modality interaction
contrast_diffInstruction <- list(
  "none ST - none ODD"    = c(1, -1, 0, 0, 0, 0), 
  "none ST - none SUB"    = c(1, 0, -1, 0, 0, 0), 
  "none ODD - none SUB"   = c(0, 1, -1, 0, 0, 0), 
  "sync ST - sync ODD"    = c(0, 0, 0, 1, -1, 0),   
  "sync ST - sync SUB"    = c(0, 0, 0, 1, 0, -1),  
  "sync ODD - sync SUB"   = c(0, 0, 0, 0, 1, -1),
  "none ST - sync ST"     = c(1, 0, 0, -1, 0, 0),
  "none ODD - sync ODD"   = c(0, 1, 0, 0, -1, 0),
  "none SUB - sync SUB"   = c(0, 0, 1, 0, 0, -1)
)
emm_diffInstruction <- emmeans(model, ~ Cognitive.Load * Instruction)
summary(emm_diffInstruction)

# Run targeted comparisons with Bonferroni correction
contrast(emm_diffInstruction, contrast_diffInstruction, adjust = "bonferroni")
# 
# setDT(DATA)
# DATA[Instruction == "none" & Movement == "Walk" & Cognitive.Load == "ST", mean(IMI, na.rm = TRUE)]