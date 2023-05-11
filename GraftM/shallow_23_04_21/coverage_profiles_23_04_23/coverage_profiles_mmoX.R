#!/usr/bin/env Rscript

.libPaths(c("/user_data/kalinka/r_packages", .libPaths()))

library(tidyr)
library(stringr)
library(purrr)
library(dplyr)
library(vroom)
library(ggplot2)

# set working directory (jeg skal lige have det her til at rulle)
setwd("/user_data/kalinka/GraftM/shallow_23_04_21/coverage_profiles_23_04_23")

#Importing the position file 
hits_mmoX<-vroom("/user_data/kalinka/GraftM/shallow_23_04_21/coverage_profiles_23_04_23/Position_files/position_of_mmoX_hits.tsv", delim = "\t")
hits_mmoX <- hits_mmoX %>%
  mutate(Taxonomy = str_extract(Tax, "[^;]*$"))

# Adding habitat_classification
metadata <- readRDS("/projects/microflora_danica/Data_freezes/2022_10_10/2022-12-05_mfd-metadata.rds")%>%
select(seq_id, mfd_hab1)%>%
  group_by(mfd_hab1) %>%
  mutate(Samples_in_hab = n_distinct(seq_id))

hits_mmoX <- merge(hits_mmoX, metadata, by.x = "Sample", by.y = "seq_id")%>%
    drop_na(mfd_hab1)

# Step 1: Create a data frame with every position of the gene
gene_positions_mmoX <- hits_mmoX %>%
  summarise(start = min(hmm_start),
            end = max(hmm_end)) %>%
  expand(Position = seq(start, end))


# Step 2: Join the gene_positions data frame with the hits data frame and group by "Taxonomy"
reads_by_position_mmoX <- gene_positions_mmoX %>%
  left_join(hits_mmoX %>% 
              mutate(Position = map2(hmm_start, hmm_end, seq)) %>%
              unnest(Position) %>%
              group_by(Position, Taxonomy, mfd_hab1, Samples_in_hab) %>%
              count()) %>%
  replace_na(list(n = 0)) %>%
  rename(Count=n) %>%
  mutate(Avg_count=Count/Samples_in_hab)

# Step 3: Summarize the number of reads for each position and Taxonomy
reads_summary_mmoX <- reads_by_position_mmoX %>%
  group_by(Position, Taxonomy, mfd_hab1) %>%
  summarise(Coverage = sum(Avg_count))


mmoX_diff <- reads_summary_mmoX %>% 
  group_by(Taxonomy, mfd_hab1) %>% 
  summarise(median_cov = median(Coverage),
            max_cov = max(Coverage),
            diff_cov = max_cov - median_cov,
            ratio_cov = max_cov/median_cov)

mmoX_diff_bar<-ggplot(mmoX_diff, aes(y = reorder(Taxonomy, desc(Taxonomy)), x = ratio_cov, color =Taxonomy)) +
  geom_bar(stat = "identity", fill="white", linewidth=1.5) +
  xlab("Ratio between maximum and median average coverage")+
  ylab("")+
  xlim(0,8)+
  facet_wrap(~mfd_hab1)+
  theme(panel.background = element_rect(fill = "transparent", colour = NA))+
    labs(title="Coverage Ratio mmoX")+
  theme(plot.title = element_text(hjust=0.5, face="bold"))


ggsave("/user_data/kalinka/GraftM/shallow_23_04_21/coverage_profiles_23_04_23/Coverage_plots/ratio_cov_mmoX.png",
       mmoX_diff_bar,
       height = 5,
       width = 15)



#### Then ensuring plotting of 0 positions;


# Step 1: Create a data frame with all positions
# Create a data frame with all the positions for each Taxonomy and mfd_hab1 combination
all_positions <- expand.grid(Position = 2:525,
                              Taxonomy = unique(reads_by_position_mmoX$Taxonomy),
                              mfd_hab1 = unique(reads_by_position_mmoX$mfd_hab1))

# Left join the all_positions data frame with the reads_by_position_mmoX data frame
reads_by_position_all <- left_join(all_positions, reads_by_position_mmoX, by = c("Position", "Taxonomy", "mfd_hab1"))

# Replace NA values in the Count column with 0
reads_by_position_all$Avg_count[is.na(reads_by_position_all$Avg_count)] <- 0

# Step 3: Summarize the number of reads for each position and Taxonomy
reads_summary_mmoX <- reads_by_position_all %>%
  group_by(Position, Taxonomy, mfd_hab1) %>%
  summarise(Coverage = sum(Avg_count))

# Step 4: Visualize the distribution of reads along the gene by Taxonomy
cov_tax<-ggplot(reads_summary_mmoX, aes(x = Position, y = Coverage, color = Taxonomy)) + 
  geom_line(linewidth=1)+
  facet_wrap(~mfd_hab1, scales = "free_y")+  
  ylab("Average Coverage within each Habitat Type")+
  #scale_colour_manual(values=c("#702020","#648847","#9b568a","#858584","#1c1c79" , "#52f506", "#ea8706", "#cfcc12", "#09c9ef"), name="Taxonomy") +
  theme(panel.background = element_rect(fill = "transparent", colour = NA))+
  labs(title="Coverage mmoX")+
  theme(plot.title = element_text(hjust=0.5, face="bold"))

ggsave("/user_data/kalinka/GraftM/shallow_23_04_21/coverage_profiles_23_04_23/Coverage_plots/cov_mmoX_free.png",
       cov_tax,
       height = 7,
       width = 15)
