#!/bin/bash

DATADIR="../results/10concatenation10Mb_OneCopy-phylip"
mkdir ../results/HyDE/
mkdir ../results/HyDe/10Mb-concatenation

for file in "$DATADIR"/*; do
    run_hyde.py -i $file -m ../results/07-species_mapping.txt -o H_vulgare -n 47 -t 17 -s 11354214 --prefix 10-hyde-${file}
    mv 10-hyde-${file}** ../results/HyDe/10Mb-concatenation
done