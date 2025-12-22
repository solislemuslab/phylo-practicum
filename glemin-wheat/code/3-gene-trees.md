# Gene Trees

The data started with 13,288 genes which were filtered to 12,959 by discarding trees where the outgroups were not monophyletic (this set was denoted F_i). They renamed each sequence as the species to go from F_i to F_m (F_m^95 only has clades with bootstrap greater than 95).
They used SSIMUL to go from multilabeled trees in F_m (F_m^95) to single labeled trees (denoted F_s and F_s^95 respectively). They pruned isomorphic trees so that there are only now 11,033 gene trees.
Finally, they kept the 8739 gene trees containing at most one sequence per individual (each individual has only one sequence (copy)).

The zipped folder `IndividualAlignements_OneCopyGenes.zip` contains a folder `OneCopyGenes` with 8739 aligned genes.

## Running RAxML on all the genes

RAxML saves output files on the path you are, so we will run it from a `results` folder. We will not run bootstrap because this was used on previous steps for data filtering.

Also, we will run the analyses for all genes with a bash script that loops over genes in `OneCopy`. So, we move into the `code` folder and there is the `raxml.sh` bash script to run:

```
cd code
raxml.sh
```

This command will take 3-24 hours to run, so we will leave this running and check results next class.

