---
layout: default
title: 09 Species network
parent: S26 Wheat
nav_order: 7
---

# Species network

## Creating input files

We have the estimated gene trees (`04-all-gene-trees.tre`) and the mapping of individuals to species (`07-species_mapping.txt`). We want to run [SNaQ](https://juliaphylo.github.io/SNaQ.jl/stable/man/multiplealleles/) on multiple alleles to estimate the species network at species level (13 wheat species and 4 outgroups).

We also have a starting species tree at species level (`07-species-tree.tre`).

Now, in Julia, in the `code` folder:
```julia
using PhyloNetworks
using SNaQ
using CSV, DataFrames

mappingfile = CSV.read("../results/07-species_mapping.txt", DataFrame; header=false, delim=' ')
```

Note that we have this file as column1=individual and column2=species, and we need the opposite for SNaQ. We also need the columns to have names "species" and "individual".

```julia
rename!(mappingfile, :Column1 => :individual)
rename!(mappingfile, :Column2 => :species)

select!(mappingfile,[:species, :individual])

## We want to remove 3 of the 4 outgroups to simplify the analysis:
## We keep `H_vulgare_HVens23`, 
## We remove `Ta_caputMedusae_TB2`, `Er_bonaepartis_TB1`, `S_vavilovii_Tr279`
filter(row -> row.species in ["Ta_caputMedusae", "Er_bonaepartis", "S_vavilovii"], mappingfile)
size(mappingfile) ## (47,2)

mappingfile = filter(row -> !(row.species in ["Ta_caputMedusae", "Er_bonaepartis", "S_vavilovii"]), mappingfile)
size(mappingfile) ## (44, 2)

CSV.write("../results/09-species_mapping.csv", mappingfile)

## mappingfile = CSV.read("../results/09-species_mapping.csv", DataFrame)
taxonmap = Dict(r[:individual] => r[:species] for r in eachrow(mappingfile)) # as dictionary
```

Now we read the gene trees and compute CF table:
```julia
trees = readmultinewick("../results/04-all_gene_trees.tre")
length(trees) ## 8708


for gt in trees
  for badtip in ["Ta_caputMedusae_TB2", "Er_bonaepartis_TB1", "S_vavilovii_Tr279"]
    if badtip in tiplabels(gt)
      deleteleaf!(gt, badtip)
    end
  end
end


writemultinewick(trees, "../results/09-all_gene_trees_snaq.tre")

## trees = readmultinewick("../results/09-all_gene_trees_snaq.tre")

## creating CF table:
df_sp = tablequartetCF(countquartetsintrees(trees, taxonmap; showprogressbar=false)...);
keys(df_sp)  # columns names
CSV.write("../results/09-tableCF_species.csv", df_sp); 

```

## Running SNaQ to infer phylogenetic network

First, we want to create a subfolder `snaq` in `results.

We want to open a Julia session with multithreads. So, we need to type in the terminal:
```
julia -t 2
```

And now inside Julia (in the `code` folder):

```julia
using Distributed
addprocs(4)

@everywhere using PhyloNetworks
@everywhere using SNaQ

## read table of CF
d_sp = readtableCF("../results/09-tableCF_species.csv"); # "DataCF" object for use in snaq!
#read in the species tree from ASTRAL as a starting point
T_sp = readnewick("../results/07-species-tree-astral4.tre")

net = snaq!(T_sp, d_sp, runs=100, Nfail=200, filename= "../results/snaq/09-snaq-h1",seed=8485);
```
Note that this command will take several days to run, so we should leave it running somewhere in the background.
