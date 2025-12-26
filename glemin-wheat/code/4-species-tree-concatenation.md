---
layout: default
title: Species tree estimation
parent: Glemin (Wheat)
nav_order: 3
---

# 1. Species tree via concatenation

There will be two types of concatenation:
- full concatenation
- 10Mb windows

## 1.1 Full concatenation

The authors already provide the fully concatenated fasta file in `FullConcatenation_OneCopyGenes.zip` and when you unzip, you get `triticeae_allindividuals_OneCopyGenes.fasta`. We will run RAxML on this file following the details in the paper: "We inferred the phylogeny from this supermatrix with RAxML v8 using the GTR+Γ4 model and the fast-bootstrap option".

Note that RAxML will save output files in the folder where the data is, so we will run the command in the `data/Wheat_Relative_History_Data_Glemin_et_al` folder:

```
raxml-ng --msa triticeae_allindividuals_OneCopyGenes.fasta --model GTR+G4
```
Note that this will take ~24 hours to run.

We now move the output files to the `results` folder:
```
cd ../../results/RAxML/
mkdir full-concatenation
cd ../../data/Wheat_Relative_History_Data_Glemin_et_al
ls ## to check files are there
mv *.raxml* ../../results/RAxML/full-concatenation
```

### Creating our own concatenated file

We could practice the process of concatenating all the sequence files in `OneCopyGenes`:

[need to add code here; note that different genes have different taxa and not in order]

### Visualization

```r
library(ape)
library(phangorn)
library(phytools)

tre = read.tree(file="triticeae_allindividuals_OneCopyGenes.fasta.raxml.bestTree")
plot(tre)
```

Note that we need to root at the outgroup: `H_vulgare_HVens23`

```r
rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```

## 1.2 10Mb sliding window concatenation

Rather than building one species tree for the fully concatenated sequences, we could create smaller concatenated files (10Mb windows) to assess tree discordance.
The authors provide already the 10Mb sliding window concatenated sequence files in the `Concatenation10Mb_OneCopyGenes.zip` file which unzips into the `Concatenation10Mb_OneCopyGenes` folder:

```
$ cd Concatenation10Mb_OneCopyGenes
$ ls | wc -l
     248
```

In the paper, the authors say:
"Using the Hordeum genome as a reference, we also concatenated genes in 10-Mb windows along chromosomes, obtaining 298 alignments with at least three genes per window.
[...]
Among the 298 10-Mb trees, only 248 contained all individuals."

We want to build one species tree per file, so we will use a similar bash script to the one for gene trees (`raxml-concatenation.sh`). This script has the flag `--threads 5` to use 5 threads within each raxml job.

Within the `code` folder:
```
./raxml-concatenation.sh
```

There are 248 genes, each gene tree estimation took around 140 seconds in my computer (so total would be ~10 hours).

### Visualization

We want to reproduce Figure 1(B) with a densitree with all species trees from 10Mb sliding windows.

We need to be in the `results/RAxML/10Mb-concatenation` folder:

```r
library(ape)
library(phangorn)
library(phytools)

files <- list.files(
  pattern = "\\.bestTree$",
  full.names = TRUE
)

trees <- lapply(files, read.tree)
densityTree(trees,type="cladogram",nodes="intermediate")
densityTree(trees,use.edge.length=FALSE,type="cladogram",nodes="centered")
```

[do we want to create the 10Mb windows ourselves?]

# 2. Species tree via coalescent models