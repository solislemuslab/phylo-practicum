---
layout: default
title: Species tree supermatrix (10Mb)
parent: S26 Wheat
nav_order: 4
---

# 1. Species tree via concatenation

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

We want to build one species tree per file, so we will use a similar bash script to the one for gene trees (`06-raxml-concatenation.sh`). This script has the flag `--threads 5` to use 5 threads within each raxml job.

Within the `code` folder:
```
./06-raxml-concatenation.sh
```

There are 248 genes, each gene tree estimation took around 140 seconds in my computer (so total would be ~10 hours).

### Making the 10Mb windows ourselves

We will use the script `06-make-10Mb-windows.R` to create the 10Mb windows per chromosome.

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

