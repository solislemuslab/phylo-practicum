#!/bin/bash

DATADIR="Wheat_Relative_History_Data_Glemin_et_al/OneCopyGenes"
RAXML="/Users/nkolbow/Documents/phylo-practicum/raxml-ng_v1.2.2_macos/raxml-ng"

mkdir $DATADIR/results/
mkdir $DATADIR/../results/RAxML/

for file in "$DATADIR"/*; do
    $RAXML --msa $file --model GTR+G4
    mv *$file $DATADIR/../results/RAxML/
done
