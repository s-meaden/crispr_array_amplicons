# Pipeline to link Qiime commands together
# Run this script in this directory:
cd /Volumes/Sean\ Meaden\ Exeter/CRISPR_Postdoc/Anne_Amplicons/Trimmed/qiime2_analysis

source activate qiime2-2018.4


##### Using merged reads:

# import into qiime :

  # Real command: (had to round trip between text edit and excel to get rid of weird excel artefacts that were screwing up csv format.)
qiime tools import --type 'SampleData[SequencesWithQuality]' --input-path  ~/Dropbox/CRISPR_Postdoc/Other_projects/Anne_amplicons/cr2_manifest3.csv --output-path demux.qza --source-format SingleEndFastqManifestPhred33


# Visualise summary of reads:
qiime demux summarize --i-data demux.qza --o-visualization demux.qzv

# Quality filter (based on visualization it's just the first 20bp that are bad)
qiime quality-filter q-score --i-demux demux.qza --o-filtered-sequences demux_filtered.qza --o-filter-stats demux-joined-filter-stats.qza

# Visualise:
qiime demux summarize --i-data demux_filtered.qza --o-visualization filtered_demux.qzv

# Denoise using deblur. Doesn't work without reference database. Could try denoise 16S?
# qiime deblur denoise-other --i-demultiplexed-seqs demux_filtered.qza --p-trim-length -1 --output-dir deblurresults --p-jobs-to-start 1

# Dereplicate if deblur doesnt work: very slow! Took ~ 16 hours
qiime vsearch dereplicate-sequences --i-sequences demux_filtered.qza --o-dereplicated-table table.qza --o-dereplicated-sequences rep-seqs.qza

# Cluster at 99% similarity...like the Loris Lines paper (and Q2 vsearch tutorial).
# Also likely to be an overnight job...
qiime vsearch cluster-features-de-novo \
  --i-table table.qza \
  --i-sequences rep-seqs.qza \
  --p-perc-identity 0.99 \
  --o-clustered-table table-dn-99.qza \
  --o-clustered-sequences rep-seqs-dn-99.qza

  qiime vsearch cluster-features-de-novo --i-table table.qza --i-sequences rep-seqs.qza --p-perc-identity 0.99 --o-clustered-table table-dn-99.qza --o-clustered-sequences rep-seqs-dn-99.qza

# Already did a lot of QC with Sickle, Cutadapt, FLASH and then qiime quality socre, so could roll with
# the dereplicated sequences only (i.e. not clustered- 100% identity); or go with clustered, 99% identity.

# Get rarefaction curves:
qiime diversity alpha-rarefaction --i-table table-dn-99.qza --p-max-depth 321673 --p-steps 50 --o-visualization alpha-rarefaction.qzv

# Rarefy down to lowest sample (still 150k reads)
qiime diversity core-metrics --i-table table-dn-99.qza --p-sampling-depth 150000 --output-dir core-metrics-results --m-metadata-file ~/Dropbox/CRISPR_Postdoc/Other_projects/Anne_amplicons/metadata2.tsv

# Extract into an OTU table and process in R. Exported cluster sequences (non-rarefied), observed otus and shannon index for rarefied samples. 
qiime tools export INSERT_FEATURE_TABLE_HERE --output-dir EXPORTED_DIRECTORY_NAME
