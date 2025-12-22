# Gene Trees

The data started with 13,288 genes which were filtered to 12,959 by discarding trees where the outgroups were not monophyletic (this set was denoted F_i). They renamed each sequence as the species to go from F_i to F_m (F_m^95 only has clades with bootstrap greater than 95).
They used SSIMUL to go from multilabeled trees in F_m (F_m^95) to single labeled trees (denoted F_s and F_s^95 respectively). They pruned isomorphic trees so that there are only now 11,033 gene trees.
Finally, they kept the 8739 gene trees containing at most one sequence per individual (each individual has only one sequence (copy)).

The zipped folder `IndividualAlignements_OneCopyGenes.zip` contains a folder `OneCopyGenes` with 8739 aligned genes.

## Running RAxML on 10 genes

We will create a data folder with only 10 genes that we can in class, and the full set will be run as HW.

We are in `data/Wheat_Relative_History_Data_Glemin_et_al`. We create a subfolder and copy the first 10 genes in this folder.
```
mkdir OneCopyGenes-trimmed
cd OneCopyGenes
ls | head -n10 | xargs -I {} cp "{}" ../OneCopyGenes-trimmed
```

Now we move to the `code` folder to run the `raxml.sh` script.

```
./raxml.sh
```

For each gene, we have 8 output files created inside `results/RAxML`:
```
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.startTree 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.reduced.phy 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.rba 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.mlTrees 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.log 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.bestTreeCollapsed 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.bestTree 
Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.bestModel
```

[Visualization steps: densitree phytools]
https://blog.phytools.org/2017/04/slanted-phylogram-cladogram-densitytree.html

## Running RAxML on all the genes

RAxML saves output files on the path you are, so we will run it from a `results` folder. We will not run bootstrap because this was used on previous steps for data filtering.

Also, we will run the analyses for all genes with a bash script that loops over genes in `OneCopy`. So, we move into the `code` folder and there is the `raxml.sh` bash script to run:

```
cd code
raxml.sh
```

This command will take 3-24 hours to run, so we will leave this running. We can go over the output files.

