---
layout: default
title: 07 Species tree supertree/coalescent
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
tre = tre[[2]] ## tree stored in second entry
plot(tre)

rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```

# Species tree via coalescent models

## At the individual level

We will use [Weighted ASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md) to reconstruct the species tree under the coalescent model. The input is the list of RAxML estimated gene trees with branch lengths: `04-all_gene_trees.tre`.

We have to be in the `results/RAxML` path and run:
```
wastral -i 04-all_gene_trees.tre -o 07-individual-species-tree.tre
```

Note that weighted ASTRAL has three modes (read more [here](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md)):
1. Weighted ASTRAL by Branch Support (mode 2)
2. Weighted ASTRAL by Branch Length (mode 3)
3. Weighted ASTRAL - Hybrid (default)

"Hybrid" mode combines both types of weights.
Our gene trees do not have branch support, so we assume "hybrid" mode results in the same output as "mode=3" (branch length weighting). We could have explicitly added the flag `--mode 3`.

The wastral command took around 45 minutes to finish in my computer.

Now we can visualize it in R (in `results`):
```r
library(ape)
tre = read.tree(file="07-individual-species-tree.tre")
plot(tre)
rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```

**Extra:** The results did not make a lot of sense, so we will rerun with astral4.

We have to be in the `results` path and run:
```
astral4 -i 04-all_gene_trees.tre -o 07-individual-species-tree-astral4.tre
```

Now we can visualize it in R (in `results`):
```r
library(ape)
tre = read.tree(file="07-individual-species-tree-astral4.tre")
plot(tre)
rtre = root(tre,outgroup="H_vulgare_HVens23", resolve.root=TRUE)
plot(rtre)
```

## At the species level

Since we have multiple individuals per species for some species, we can use the multispecies coalescent model to infer a species level phylogeny.
However, we first need to create a mapping from each individual ID to a species ID. 

We will create this mapping in R (inside `code`):

```r
##First we get all the individual names
genes_dir <- "../data/Wheat_Relative_History_Data_Glemin_et_al/OneCopyGenes/"
gene_files<-paste(genes_dir,list.files(genes_dir,pattern='\\.aln$'),sep='')

all_individuals <- character()
i<-1
for(f in gene_files){
  headers <- rownames(read.dna(f, format = "fasta"))
  all_individuals <- unique(c(all_individuals, headers))
}
all_individuals <- sort(all_individuals) # Sort alphabetically for consistency
all_individuals
```

Here we can see that each individual ID is just the species ID with a unique identifier at the end (e.g., "SpeciesID_IndividualID").
Thus if we remove the tag at the end we have a map from individual to species:

```r
cleaned_individuals <- sub("_[^_]+$", "", all_individuals)

#map all individuals to species
mapping <- paste(all_individuals,cleaned_individuals)
writeLines(mapping, "../results/07-species_mapping.txt") ## write to file
```

Now our mapping is saved as `07-species_mapping.txt`

To make a species-level phylogeny, we just need to specify our mapping file in Weighted ASTRAL with the `-a` flag.

In `results` folder:
```
wastral -i 04-all_gene_trees.tre -a 07-species_mapping.txt -o 07-species-tree.tre
```

Now we want to plot it in R (in `results`):
```r
library(ape)
tre = read.tree(file="07-species-tree.tre")
plot(tre)
rtre = root(tre,outgroup="H_vulgare", resolve.root=TRUE)
plot(rtre)
```

**Extra:** The results did not make a lot of sense, so we will rerun with astral4.

We have to be in the `results` path and run:
```
astral4 -i 04-all_gene_trees.tre -a 07-species_mapping.txt -o 07-species-tree-astral4.tre
```

Now we want to plot it in R (in `results`):
```r
library(ape)
tre = read.tree(file="07-species-tree-astral4.tre")
plot(tre)
rtre = root(tre,outgroup="H_vulgare", resolve.root=TRUE)
plot(rtre)
```
