---
layout: default
title: 12 Hybrid Visualizations
parent: S26 Wheat
nav_order: 11
---


# Reproducing Figure 3A and 3B

In `results`, we have the HyDe output files per position in chromosome 3. We want to extract the triplets were _Ae mutica_ is a parent and the hybrid belongs to D clade (Ae bicornis, Ae longissima, Ae sharonensis, Ae searsii, Ae tauschii, Ae caudata, Ae umbellilata, Ae comosa, Ae uniaristata). We note something wrong in the HyDe output files.

In `results/HyDe/10Mb-concatenation-ch3`:
```r
i = 1
dt = read.table(paste0("Size_10_Mb_Chrom_3_Pos_",i,"-out.txt"), header=TRUE)
```

```r
> head(dt)
           P1        Hybrid            P2   Zscore Pvalue Gamma      AAAA AAAB
1 Ae_bicornis    Ae_caudata     Ae_comosa 13.41641      0   NaN 204375852    0
2 Ae_bicornis     Ae_comosa    Ae_caudata 13.41641      0   NaN 204375852    0
3  Ae_caudata   Ae_bicornis     Ae_comosa 13.41641      0   NaN 204375852    0
4 Ae_bicornis    Ae_caudata Ae_longissima 16.43168      0   NaN 306563778    0
5 Ae_bicornis Ae_longissima    Ae_caudata 16.43168      0   NaN 306563778    0
6  Ae_caudata   Ae_bicornis Ae_longissima 16.43168      0   NaN 306563778    0
  AABA AABB AABC ABAA ABAB ABAC ABBA BAAA ABBC CABC BACA BCAA ABCD
1    0    0    0    0    0    0    0    0    0    0    0    0    0
2    0    0    0    0    0    0    0    0    0    0    0    0    0
3    0    0    0    0    0    0    0    0    0    0    0    0    0
4    0    0    0    0    0    0    0    0    0    0    0    0    0
5    0    0    0    0    0    0    0    0    0    0    0    0    0
6    0    0    0    0    0    0    0    0    0    0    0    0    0
```

All gammas as NaN and the column AAAA has all the counts. We see the same pattern in the other positions in chromosome 3 and even the output of HyDe with the full concatenation.

We will then try to summarize MSCQuartets instead.

```r
df = read.csv("12-mscquartets-ptable.csv", header=TRUE)
```

To reproduce something similar to Figure 3A (top left panel), we want to extract the rows where there is a 1 in one of the Ae mutica columns (and zero in the other Ae muticas), 1 in one of the T boeoticum columns (and 0 in the others), and 1 in one of the Ae bicornis columns (and 0 in the others).

```r
library(dplyr)

# find the columns for each species
#mutica_cols   <- grep("^Ae_mutica", names(df), value = TRUE)
#tboe_cols     <- grep("^T_boeoticum", names(df), value = TRUE)

mutica_cols   <- grep("^Ae_speltoides", names(df), value = TRUE)
tboe_cols     <- grep("^T_urartu", names(df), value = TRUE)
bicornis_cols <- grep("^Ae_bicornis", names(df), value = TRUE)


# filter rows that have exactly one "1" in each group
df_filtered <- df %>%
  filter(
    rowSums(select(., all_of(mutica_cols))   == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(tboe_cols))     == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(bicornis_cols)) == 1, na.rm = TRUE) == 1
  )

> sum(df_filtered$p_T3<0.05)/length(df_filtered$p_T3)
[1] 0.270202
```

Let's create a data frame with the pvalues:

```r
outdf = data.frame(hybrid = "Ae_bicornis", pval = df_filtered$p_T3)
```

Let's loop over the hybrid species:

```r
hybrids = c("Ae_longissima", "Ae_sharonensis", "Ae_searsii", "Ae_tauschii", "Ae_caudata", "Ae_umbellulata", "Ae_comosa", "Ae_uniaristata")

for(h in hybrids){
    hyb_cols <- grep(h, names(df), value = TRUE)
    tmp <- df %>%
    filter(
    rowSums(select(., all_of(mutica_cols))   == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(tboe_cols))     == 1, na.rm = TRUE) == 1,
    rowSums(select(., all_of(hyb_cols)) == 1, na.rm = TRUE) == 1
    )
    tmpdf = data.frame(hybrid=h, pval=tmp$p_T3)
    outdf = rbind(outdf,tmpdf)
}

Now, we can do a violin plot of the pvalues:

```r
library(ggplot2)

ggplot(outdf, aes(x=hybrid, y=pval))+ geom_violin()+geom_boxplot()
```

