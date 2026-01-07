---
layout: default
title: 10 Hybrid detection with HyDe
parent: S26 Wheat
nav_order: 8
---

# Hybrid Detection with HyDe

We can use HyDe to run a series of hytpothesis tests among rooted triplets for signal of hybridization.
We will be following the tutorial [here](https://hybridization-detection.readthedocs.io/analyze.html)
HyDe is available in Python. From the terminal you can open Python with the `python3` or `python` (but this may open an older installation).

## Data Preparation for running HyDe

HyDe needs the sequence data in the `Phylip` format, however, our sequences are in the `fasta` format; we will need to convert our sequences to the `Phylip` format. We can do this in Python by using the BioPython module.
If BioPython is not installed you can run the command `pip3 install BioPython`.

```Python
from Bio import SeqIO

#read in the fasta format sequence
data_path = "../data/Wheat_Relative_History_Data_Glemin_et_al/"
concat_file = "triticeae_allindividuals_OneCopyGenes.fasta"

records = SeqIO.parse(data_path+concat_file, "fasta")

#convert the output to phylip
count = SeqIO.write(records, "../results/10-triticeae_allindividuals_OneCopyGenes.phylip", "phylip-relaxed")
```

Additionally we need a mapping file that maps individuals to their respective species. When performing our coalescent analysis we created the mapping file `07-species-mapping.txt`, this is in the exact format that we need so we can use this file directly


## Running HyDe on the full concatenation

Now that we have all the components from the terminal we can run `run_hyde.py`:
 
```
run_hyde.py -i ../data/Wheat_Relative_History_Data_Glemin_et_al/triticeae_allindividuals_OneCopyGenes.phylip -m 07-species_mapping.txt -o H_vulgare -n 47 -t
 17 -s 11354214 --prefix 10-Hyde
```

[Josh, Figure out what is going on with run_hyde.py on your computer]

Note that in order to read the data, we needed to provide a little extra information. Specifically, we needed to provide the outgroup (H_vulgare), number of individuals sampled (47), number of species (17), and number of sites (11354214).

## Running HyDe on 10MB windows

Similarly to how we ran RAxML on each of the 10MB windows, we can use a bash script to run HyDe on each window. However, we first need to convert all the windows to the appropriate format:

```Python
import os
from Bio import SeqIO

window_phylip_path = "./10concatenation10Mb_OneCopy-phylip/" 
os.makedirs(window_phylip_path,exist_ok=True)
window_path = "../data/Wheat_Relative_History_Data_Glemin_et_al/Concatenation10Mb_OneCopyGenes/"
all_windows = os.listdir(window_path)

for window in all_windows :

	records = SeqIO.parse(window_path+window, "fasta-pearson")

	#convert the output to phylip
	count = SeqIO.write(records, window_phylip_path+window, "phylip-relaxed")
```

Now we can run HyDe on each window:

```
DATADIR="../data/Wheat_Relative_History_Data_Glemin_et_al/Concatenation10Mb_OneCopyGenes"
mkdir ./results/HyDE/
mkdir ./results/HyDe/10Mb-concatenation

for file in "$DATADIR"/*; do
	
    # 1. Extract the filename from the path
    filename=$(basename "$file")
    
    # 2. Remove the extension
    base="${filename%.*}"

    run_hyde.py -i $file -m 07-species_mapping.txt -o H_vulgare -n 47 -t
 17 -s 11354214 -- prefix "./results/HyDe/10Mb-concatenation/${base}"


    raxml-ng --msa $file --model GTR+G4 --threads 5
    mv ${file}**raxml** ../results/RAxML/10Mb-concatenation
done

```