#!/bin/bash


#Cleaning scripts

#human prompts:
awk -F',' 'NR > 1 {print $1 "\n"} NR == 52 {exit}' chatgpt_paraphrases.csv | sed 's/^[[:punct:]]*\|[[:punct:]&&[^?]]*$//g' | sed 's/?/\n?/g' | tr ' ' '\n' > extraction_col_1_human

#ai prompts:
awk -F',' 'NR > 1 {print $2 "\n"} NR == 52 {exit}' chatgpt_paraphrases.csv | sed 's/^[[:punct:]]*\|[[:punct:]&&[^?]]*$//g' | sed 's/?/\n?/g' | tr ' ' '\n' > extraction_col_2_para


#Preprocessing scripts

#tnt tagger:

cd /opt/tnt

#human:
./tnt models/wsj.tnt ~/Project/extraction_col_1_human > ~/Project/extraction_col_1_human_pos  

#ai:
./tnt models/wsj.tnt ~/Project/extraction_col_2_para > ~/Project/extraction_col_2_para_pos 

cd ~/Project

paste extraction_col_1_human_pos extraction_col_2_para_pos > all_pos_final

#bigrams:

paste -d' ' <(awk -F' ' '{print $2}' extraction_col_1_human_pos) <(awk -F' ' '{print $2}' extraction_col_1_human_pos | tail -n +2) | sort | uniq -c | sort -nr > col_1_bigrams

paste -d' ' <(awk -F' ' '{print $2}' extraction_col_2_para_pos) <(awk -F' ' '{print $2}' extraction_col_2_para_pos | tail -n +2) | sort | uniq -c | sort -nr > col_2_bigrams

#all bigrams:

paste col_1_bigrams col_2_bigrams > all_bigrams_final

