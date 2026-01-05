---
layout: default
title: Species tree supermatrix (full)
parent: S26 Wheat
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
