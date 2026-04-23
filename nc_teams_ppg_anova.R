anova_model <- aov(points ~ team, data = dataset_nc_teams_2025)
summary(anova_model)

TukeyHSD(anova_model)

### ANOVA: Points Per Game by Team
#A one-way ANOVA test found a statistically significant
#difference in average points per game among North Carolina football teams (F = 3.13, p = 0.035)
#Post-hoc analysis (Tukey HSD) shows UNC scored significantly fewer point
#per game than Duke, while no other pairwise differences were statistically significant.