---
layout: default
title: Species tree supertree/coalescent
parent: S26 Wheat
nav_order: 5
---

# Species tree via supertree

In the original paper, the authors used 11,033 gene trees, but we only have 8739. We have all the gene trees estimated by RAxML in `04-all_gene_trees.tre`.

We had already installed `SuperTriplets_v1.1.jar` and you need to know the path where it is. Let's say that the path is `~/software/`, so we would run the command like:

We need to be in the `results/RAxML`
```
java -jar ~/software/SuperTriplets_v1.1.jar 04-all_gene_trees.tre 07-supertree.tre
```

Now we can visualize it in R:
```r
library(ape)
tre = read.tree(file="07-supertree.tre")
plot(tre)

rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```



# Species tree via coalescent models

We will use [Weighted ASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md) to reconstruct the species tree under the coalescent model. The input is the list of RAxML estimated gene trees with branch lengths: `04-all_gene_trees.tre`.

We have to be in the `results/RAxML` path and run:
```
wastral -i 04-all_gene_trees.tre -o 08-species-tree.tre
```

Now we can visualize it in R:
```r
library(ape)
tre = read.tree(file="08-species-tree.tre")
plot(tre)

rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```