
# Count read length distributions of spacer arrays.
# Run this awk expression from the directory above (i.e. /Volumes/Sean Meaden Exeter/CRISPR_Postdoc/Anne_Amplicons/Trimmed).
# Then process output files n R.


for file in qiime1_analysis/*extendedFrags.fastq
do
      #echo $file
     base=$(basename $file ".extendedFrags.fastq")
     echo $base
        awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' qiime1_analysis/${base}.extendedFrags.fastq > length_distributions/${base}_count.txt
done
