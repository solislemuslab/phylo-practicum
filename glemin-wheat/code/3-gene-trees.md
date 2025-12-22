# Gene Trees

The data started with 13,288 genes which were filtered to 12,959 by discarding trees where the outgroups were not monophyletic (this set was denoted F_i). They renamed each sequence as the species to go from F_i to F_m (F_m^95 only has clades with bootstrap greater than 95).
They used SSIMUL to go from multilabeled trees in F_m (F_m^95) to single labeled trees (denoted F_s and F_s^95 respectively). They pruned isomorphic trees so that there are only now 11,033 gene trees.
Finally, they kept the 8739 gene trees containing at most one sequence per individual (each individual has only one sequence (copy)). This is the data we have.
The zipped folder `IndividualAlignements_OneCopyGenes.zip` contains a folder `OneCopyGenes` with 8739 aligned genes.

## Running RAxML on 10 genes

We will create a data folder with only 10 genes that we can run in class, and the full set will be run as HW.

We are in the `data/Wheat_Relative_History_Data_Glemin_et_al` folder. We create a subfolder and copy the first 10 genes in this folder.
```
mkdir OneCopyGenes-trimmed
cd OneCopyGenes
ls | head -n10 | xargs -I {} cp "{}" ../OneCopyGenes-trimmed
```

The subfolder `OneCopyGenes-trimmed` now contains the first 10 alignments from `OneCopyGenes`.

We could run RAxML on the terminal directly with the `raxml-ng` executable but we will run it through a bash script so that we can loop over genes and we can move output files to a `results` folder. Note that we will not run bootstrap because this was used on previous steps for data filtering.

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

### Visualizing the results

First, we will plot the gene tree for the first gene `Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln` in R. Note that I am in the `results/RAxML` folder:

```r
library(ape)
library(phangorn)
library(phytools)

tre = read.tree(file="Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.bestTree")
plot(tre)
```

Note that we need to root at the outgroup: `H_vulgare_HVens23`

```r
rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```

Checking all genes have the same outgroup:
```
$ grep "H_vulgare_HVens23" *.bestTree | wc -l
      10
```

Now, we want to compare the ML trees for each of the 20 RAxML runs (in the `.mlTrees` file). We will do a densitree.

```r
trees = read.tree(file="Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.mlTrees")

rtrees <- lapply(trees, function(tr) {
  root(tr, outgroup = "H_vulgare_HVens23", resolve.root = TRUE)
})
```

Plot the densitree (before and after rooting):
```
densityTree(trees,type="cladogram",nodes="intermediate")
densityTree(rtrees,type="cladogram",nodes="intermediate")

Also if we don't care about differences in branch lengths and we want to focus on differences in topology:
```r
densityTree(trees,use.edge.length=FALSE,type="cladogram",nodes="centered")
densityTree(rtrees,use.edge.length=FALSE,type="cladogram",nodes="centered")
```

[note: the plot looks weird for the rooted trees, not sure why]


Now, we want to do the densitree of all 10 best gene trees:

```r
files <- list.files(
  pattern = "\\.bestTree$",
  full.names = TRUE
)

genetrees <- lapply(files, read.tree)
densityTree(genetrees,type="cladogram",nodes="intermediate")
```

Oh! We get an error because they have different number of tips. The easiest is to keep the subset of taxa that appears in all trees.

```r
common_tips <- Reduce(
  intersect,
  lapply(genetrees, function(tr) tr$tip.label)
)

length(common_tips) ## 6

trees_pruned <- lapply(
  genetrees,
  function(tr) drop.tip(tr, setdiff(tr$tip.label, common_tips))
)

densityTree(trees_pruned,use.edge.length=FALSE,type="cladogram",nodes="centered")
```

For more information on density trees, you can see this [phytools blog](https://blog.phytools.org/2017/04/slanted-phylogram-cladogram-densitytree.html).


## Running RAxML on all the genes

We need to modify the `raxml.sh` script so that it loops over all the genes, not just the 10 genes. In the script, we need to change the line:
```
DATADIR="../data/Wheat_Relative_History_Data_Glemin_et_al/OneCopyGenes-trimmed"
```
for
```
DATADIR="../data/Wheat_Relative_History_Data_Glemin_et_al/OneCopyGenes"
```

Then, inside the `code` folder, we run the `raxml.sh` bash script:

```
cd code
raxml.sh
```

This command will take 3-24 hours to run. We can use similar R commands to visualize the results.

