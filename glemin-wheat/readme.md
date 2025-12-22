---
layout: default
title: About
nav_order: 1
---

# Spring 2026

We will reproduce the phylogenetic analyses of [Pervasive hybridizations in the history of wheat relatives](https://www.science.org/doi/10.1126/sciadv.aav9188) by Glemin et al (2019).

## Software

- RAxML
- SuperTriplets
- ASTRAL
- Julia
  - SNaQ
  - PhyloPlots
- HyDe
- R
  - ape, phangorn, ggtree, MSCQuartets

## Schedule 2026

| Session | Topic | Pre-class work | Lecture notes | Homework | 
| :---:   | :---: | :---:         | :---: | :---: | 
| 01/23 | Introduction and reproducibility practices | | [notes](https://github.com/solislemuslab/phylo-practicum/blob/main/notes/1-intro-reproducibility.md) | Set-up local folder for the class ([HW](https://github.com/solislemuslab/phylo-practicum/blob/main/notes/1-intro-reproducibility.md#homework)) |
| 01/30 | Paper discussion | Read [Glemin et al, 2019](https://www.science.org/doi/10.1126/sciadv.aav9188); Optional reading [Marcussen et al, 2014](https://www.science.org/doi/full/10.1126/science.1250092)
| 02/06 | Goal of the analyses, required software and data | | [notes](https://github.com/solislemuslab/phylo-practicum/blob/main/glemin-wheat/code/2-data-software.md) | Make sure all software is properly installed in your computer |
| 02/13 | Gene tree inference | | [notes](https://github.com/solislemuslab/phylo-practicum/blob/main/glemin-wheat/code/2-gene-trees.md) | Run RAxML on all genes |
| 02/20 | Species tree: supermatrix (full concatenation) | | [notes](https://github.com/solislemuslab/phylo-practicum/blob/main/glemin-wheat/code/4-species-tree-concatenation.md)
| 02/27 | Species tree: supermatrix (10Mb sliding window) | | [notes](https://github.com/solislemuslab/phylo-practicum/blob/main/glemin-wheat/code/4-species-tree-concatenation.md)
| 03/06 | Species tree: supertree
| 03/13 | Species tree: coalescent-based (new analysis)
| 03/20 | Species tree results (Figure 1)
| 03/27 | Species network inference (new analysis)
| 04/03 | Spring break
| 04/10 | Hybrid tests: HyDe
| 04/17 | Hybrid tests: MSCQuartets (new analysis)
| 04/24 | Species network (Figure 5) and hybridization results (Figures 3-4)
| 05/01 | Open question: other analyses
| 05/04 | Final reproducible script due


### More details

See list of topics, grading and academic policies in the [syllabus](https://github.com/solislemuslab/phylo-practicum/blob/main/syllabus.tex)
