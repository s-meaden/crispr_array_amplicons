

# CRISPR Spacer amplicon sequencing:

# Error correct reads with SPAdes

#for dir in CR2/*PCR2*
#do
#    for file in "$dir"/*R1_001.fastq.gz
#    do
      #echo $file
#        base=$(basename $file "_R1_001.fastq.gz")
#        echo $base
#        python ~/programs/SPAdes-3.5.0-Linux/bin/spades.py --only-error-correction -1 "$dir"/${base}_R1_001.fastq.gz -2 "$dir"/${base}_R2_001.fastq.gz -o "$dir"/${base}_err_corr
#    done
#done

# Merge reads with Flash
#mkdir flashed/
#for dir in CR2/*PCR2*/PCR2*_err_corr/corrected
#do
#    for file in "$dir"/*R1_001.fastq*
#    do
        #echo $file
#        base=$(basename $file "_L001_R1_001.fastq.00.0_0.cor.fastq.gz")
#        echo $base
#        ~/programs/FLASH-1.2.11/flash --output-prefix $base -d flashed/ --max-overlap 200 "$dir"/${base}_L001_R1_001.fastq.00.0_0.cor.fastq.gz "$dir"/${base}_L001_R2_001.fastq.00.0_0.cor.fastq.gz
#    done
#done

# Stick merged reads in new directory & remove excess files:
#mkdir flashed/merged/
#mv flashed/*extendedFrags.fastq flashed/merged/
#rm flashed/*

# Get read length distributions. Could be enough for spacer aq. result?
# For 1 file:
#awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' flashed/merged/PCR2_1-1.1_PCR2_TAGCGCTC-TCGACTAG.extendedFrags.fastq > test_read_distribution.txt

# Remove sequences with Ns in the reads- not doing this.

# Size selection- not doing this
# 30 - 140 bp for CR1
# 70 - 500 bp for CR2

# Remove phiX- use Blast- not doing this

# Cluster wth Qiime1. SWARM + usearch.
# Quality filter:
# Moved files over to Mac (from server) as Qiime version is old. 
multiple_split_libraries_fastq.py
multiple_split_libraries_fastq.py -i input_files -o output_folder --demultiplexing_method sampleid_by_file
# Tempting to just de-replicate sequences. This is effectively OTU picking at 100%...
pick_de_novo_otus.py -i $PWD/seqs.fna -o $PWD/derep_uc/ -p $PWD/dereplication_params.txt

# Rarefaction Plots

# Alpha Diversity
