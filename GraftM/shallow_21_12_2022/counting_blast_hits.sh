WD=/user_data/kalinka/GraftM/shallow_21_12_2022
ls $WD | grep "MFD.*\.txt" | sed 's/_pmoA_seqs_blast.txt//' > $WD/temp.txt

echo "Sample  Total_pmoA_umbrella  Macondi>90id" \
> $WD/pmoA_umbrella.tsv

while read -r line; do
  file="$WD/"$line"_pmoA_seqs_blast.txt"
  total=$(wc -l < "$file")
  macondi=$(grep "Candidatus Macondimonas diazotrophica" "$file" | awk '{ if ($4 > 90) {print $1}}' | wc -l)
  printf "%s\t%s\t%s\n" "$line" "$total" "$macondi">> "$WD/pmoA_umbrella.tsv"
done < "$WD/temp.txt"

rm $WD/temp.txt