---
layout: default
title: 09 Species network
parent: S26 Wheat
nav_order: 7
---

# Species network

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

taxonmap = Dict(r[:individual] => r[:species] for r in eachrow(mappingfile)) # as dictionary
```

Now we read the gene trees and compute CF table:
```julia
trees = readmultinewick("../results/04-all_gene_trees.tre")
length(trees) ## 8708

## [missing: we need to remove the 3 outgroups from all gene trees]

## creating CF table:
df_sp = tablequartetCF(countquartetsintrees(trees, taxonmap; showprogressbar=false)...);
keys(df_sp)  # columns names
CSV.write("../results/09-tableCF_species.csv", df_sp); 
d_sp = readtableCF("../results/09-tableCF_species.csv"); # "DataCF" object for use in snaq!
```

Last, we need to read the starting tree:
```julia
#read in the species tree from ASTRAL as a starting point
T_sp = readnewick("../results/07-species-tree.tre")
```

Now, we run snaq:
```julia
net = snaq!(T_sp, d_sp, nruns=45, Nfail=600, filename= "../results/09-snaq-h1");
```

[waiting to decide nruns, Nfail, threads and processors]