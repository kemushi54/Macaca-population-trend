# data analysis

library(data.table)
library(lme4)
library(car)
library(magrittr)
library(multcomp)
library(ggplot2)
library(psych)
library(readxl)

M.data <- 
  read_xlsx("data/clean/data_for_analysis.xlsx") %>% 
  setDT %>% 
  .[, Year := as.numeric(Year)] %>% 
  .[, Year.re := Year - min(Year) + 1]

# M.data$Year %<>% as.numeric
# M.data$Survey %<>% as.factor
# m0 <- glmer(Macaca_sur ~ TypeName * Year + (1|Site_N), 
#             family = binomial, data = M.data)

m1 <- glmer(Macaca_sur ~ TypeName + Year.re + (1|Site_N), 
            family = binomial, data = M.data)


Anova(m1)
summary(glht(m1, linfct = mcp(TypeName = "Tukey")))
summary(glht(m1, linfct = mcp(Year = "Tukey")))

### Summary
M.data[, .(M = sum(Macaca_sur)), by = list(Year, Survey, TypeName)] %>% 
  dcast(Year + Survey ~ TypeName, value.var = "M")

M.data[, .(Mean = round(mean(Macaca_sur), 3),
           SD = round(sd(Macaca_sur), 3)),
       by = list(Year, TypeName)] %>% 
  dcast(Year ~ TypeName, value.var = c("Mean", "SD"))

M.data[, .(Mean = mean(Macaca_sur),
           SD = sd(Macaca_sur)/sqrt(length(Macaca_sur))), 
       by = Year]

# describeBy(M.data$Macaca_sur, 
#            group = M.data[,c("TypeName", "Year")])
