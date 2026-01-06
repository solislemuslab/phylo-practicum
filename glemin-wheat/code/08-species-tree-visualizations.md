---
layout: default
title: Species tree visualizations
parent: S26 Wheat
nav_order: 6
---

# Visualizing the species trees

We have 4 estimated species trees (in `results/RAxML`):

- full concatenation (`full-concatenation/triticeae_allindividuals_OneCopyGenes.fasta.raxml.bestTree`)
- consensus of 10Mb window concatenation trees (folder `10Mb-concatenation`)
- supertree `07-supertree.tre`
- wASTRAL tree `07-species-tree-wastral.tre`

## Reproducing Figure 1A

The authors claim that Figure 1A represents both the full concatenation tree and the supertree.
Although note that we do not have the same supertree input data:
_Figure 1: (A) Phylogenetic tree of the Aegilops/Triticum genus. This same topology was obtained by both the ML analysis of 8739 gene alignments concatenation (supermatrix) and the supertree combination of 11,033 individual gene trees._

We will plot the two trees side by side.

In `results/RAxML`:
```r
library(ape)

tree1 = read.tree(file="full-concatenation/triticeae_allindividuals_OneCopyGenes.fasta.raxml.bestTree")
tree2 = read.tree(file="07-supertree.tre")

tree1 = root(tree1,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
tree2 = root(tree2,outgroup="H_vulgare_HVens23", resolve.root=TRUE)

# Suppose your trees are called tree1 and tree2
# First, ladderize both trees
tree1 <- ladderize(tree1)
tree2 <- ladderize(tree2[[2]])

# Make sure they have the same tip labels
common_tips <- intersect(tree1$tip.label, tree2$tip.label)

length(common_tips)
length(tree1$tip.label)
length(tree2$tip.label)

# Reorder the second tree to match the tip order of the first
tree2 <- reorder.phylo(tree2, order = "cladewise")
tree2 <- rotateConstr(tree2, tree1$tip.label) # rotate to match tree1 tip order

# Plot side by side
par(mfrow = c(1, 2))
plot(tree1, main = "Full concatenation", cex = 0.8)
plot(tree2, main = "Supertree", cex = 0.8)
```

They don't look the same. We can calculate the RF distance:
```r
library(phangorn)
RF.dist(tree1, tree2) ## not zero!
```

Let's try to reproduce the edge colors:
```
library(ape)
library(ggtree)
library(dplyr)

species_colors <- c(
  "Ae_umbellulata" = "yellow",
  "Ae_caudata" = "orange",
  "Ae_comosa" = "darkorange3",
  "Ae_uniaristata" = "sienna4",
  "Ae_bicornis" = "purple",
  "Ae_longissima" = "pink",
  "Ae_sharonensis" = "mediumpurple1",
  "Ae_tauschii"    = "blue",
  "Ae_spelta"      = "green"
)

```