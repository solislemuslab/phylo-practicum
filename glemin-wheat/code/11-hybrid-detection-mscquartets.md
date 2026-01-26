---
layout: default
title: 11 Hybrid detection with MSCQuartets
parent: S26 Wheat
nav_order: 10
---

# Hybrid detection with MSCQuartets

To compare the hybrid detection results from HyDe, we will run MSCQuartets in R.

In `results`:
```r
library(MSCquartets)

gtrees=read.tree(file="09-all_gene_trees_snaq.tre")
tnames <- unique(unlist(lapply(gtrees, function(x) x$tip.label)))

QT=quartetTable(gtrees,tnames)
RQT=quartetTableResolved(QT)

pTable3=quartetTreeTestInd(RQT,"T3")
quartetTablePrint(pTable3[1:6,])

write.csv(pTable3, "11-mscquartets-ptable.csv")
```