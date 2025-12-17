---
layout: default
title: Setting up data/software
nav_order: 2
---

# Downloading the data

The authors of the paper made data publicly available in a clean manner in this [data repository](https://www.agap-ge2pop.org/wheat-relative-history/).

We will download the [Wheat_Relative_History_Data_Glemin_et_al.zip](https://www.agap-ge2pop.org/wp-content/uploads/WheatRelativeHistory/download/Wheat_Relative_History_Data_Glemin_et_al.zip) and move it into our `data` subfolder.

The authors uploaded the alignments, rather than raw data for us to assemble and align. 

[discussion on alignment/assembly based on paper]

[final assessment of data at hand]


# Installing required software

## 1. RAxML Next Generation

The repository for RAxML has installation instructions [here](https://github.com/amkozlov/raxml-ng).

### For Mac

I click on `Download OSX/macOS binary (x86 and ARM)` and I download `raxml-ng_v1.2.2_macos.zip`. I put this folder in my computer (I have a folder `software`), and inside it is the executable `raxml-ng`.

I will copy this executable into `/usr/local/bin` so that I can call it from wherever in my machine, but you can also use the whole path.

```
cd software/raxml-ng_v1.2.2_macos/ ## you need to modify to your own path
ls ## check the raxml-ng executable is there
cp raxml-ng /usr/local/bin
```

When you try to run `raxml-ng`, your computer will complain that it cannot verify it is free of malware. You need to go to System Settings > Privacy and Security. Find the app and choose "Open Anyway". 
Note that if you copied your executable on your PATH, you will need to choose "open anyway" twice: once for the file in the original path and once for when you call it somewhere else in your machine.

Confirm that you can run RAxML by typing `raxml-ng` in the terminal.

## 2. bppSuite (skipped)

The software repository has instructions for installation [here](https://github.com/BioPP/bppsuite).

Before git cloning `bppsuite`, we need to make sure we have installed specific libraries.

### For Mac

Following [this](https://github.com/BioPP/bpp-documentation/wiki/Installation), we do:

```
brew tap jydu/homebrew-biopp
brew update ## optional
brew install libbpp-core libbpp-seq libbpp-phyl libbpp-popgen
```
Note that I had to update my OS and XCode.

Note that the libraries names change per Homebrew notation.

These are the project or library names:
- `bpp-core`
- `bpp-seq`
- `bpp-phyl`
- `bpp-popgen`


Homebrew prefixes most C/C++ libraries with lib to make it explicit that they install libraries, hence:
- `libbpp-core`
- `libbpp-seq`
- `libbpp-phyl`
- `libbpp-popgen`

I get the following error due to `cmake` version:

```
$ brew install libbpp-core libbpp-seq libbpp-phyl libbpp-popgen
==> Fetching downloads for: libbpp-core, libbpp-seq, libbpp-phyl and libbpp-popgen
✔︎ Bottle Manifest cmake (4.2.1)                           [Downloaded   11.4KB/ 11.4KB]
✔︎ Bottle cmake (4.2.1)                                    [Downloaded   20.1MB/ 20.1MB]
✔︎ Formula libbpp-core (2.4.1)                             [Verified    361.3KB/361.3KB]
✔︎ Formula libbpp-seq (2.4.1)                              [Verified    322.6KB/322.6KB]
✔︎ Formula libbpp-phyl (2.4.1)                             [Verified    600.4KB/600.4KB]
✔︎ Formula libbpp-popgen (2.4.1)                           [Verified    116.9KB/116.9KB]
==> Installing libbpp-core from jydu/biopp
==> Installing jydu/biopp/libbpp-core dependency: cmake
==> Pouring cmake--4.2.1.sequoia.bottle.tar.gz
🍺  /usr/local/Cellar/cmake/4.2.1: 4,016 files, 66.8MB
==> cmake ..
Last 15 lines from /Users/Clauberry/Library/Logs/Homebrew/libbpp-core/01.cmake.log:
-Wno-dev
-DBUILD_TESTING=OFF
-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk

CMake Error at CMakeLists.txt:8 (cmake_minimum_required):
  Compatibility with CMake < 3.5 has been removed from CMake.

  Update the VERSION argument <min> value.  Or, use the <min>...<max> syntax
  to tell CMake that the project requires at least <min> but has been updated
  to work with policies introduced by <max> or earlier.

  Or, add -DCMAKE_POLICY_VERSION_MINIMUM=3.5 to try configuring anyway.


-- Configuring incomplete, errors occurred!

If reporting this issue please do so at (not Homebrew/* repositories):
  https://github.com/jydu/homebrew-biopp/issues
```

I asked ChatGPT, and they suggest forcing the cmake version:

```
export CMAKE_POLICY_VERSION_MINIMUM=3.5
brew install libbpp-core
```
or
```
brew install libbpp-core \
  --cmake-args="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
```
But neither works!

From the paper, it seems they only use `bppSuite` for re-rooting the gene trees:
"BppReroot of the BppSuite (42, 43) was used to reroot the 13,288 gene trees, using as outgroups the following ordered list of species: H_vulgare, Er_bonaepartis, S_vavilovii, and Ta_caputMedusae."

So, we will skip this software for now.

## 3. SSIMUL (skipped)

We download the binaries from the software website for Mac and Linux [here](http://www.atgc-montpellier.fr/ssimul/).

Since this software is only good for Mac/Linux, and it is also only used to go from MUL trees into single label trees, we will skip it:
"We thus used SSIMUL (44) to process the multilabel of trees of Fm and F95m by turning—without losing phylogenetic signal when possible—its multilabeled trees into single-labeled trees. This was done by removing a copy of each pair of isomorphic sibling subtrees (44)."


## 4. SuperTriplets

There is download information in the SuperTriplets [website](https://www.agap-ge2pop.org/supertriplets/download/).

You simply download the java file `SuperTriplets_v1.1.jar`. I put it in my computer `software` folder inside a subfolder named `supertriplets`. We will have to use the whole path when calling this function:
```
java -jar -Xmx500m ~/software/supertriplets/SuperTriplets_v1.1.jar newick_file.nwk outfile
```

## 5. ASTRAL

The [ASTRAL repo](https://github.com/smirarab/ASTRAL) recommends us to use the new C code [ASTER](https://github.com/chaoszhang/ASTER). Installation instructions are within. For me, installing with conda worked:
```
conda install aster
```

To know where everything was installed:
```
$ which wastral
/Users/Clauberry/.julia/conda/3/bin/wastral
```

And you can test it works by:
```
$ ~/.julia/conda/3/bin/wastral
```

## 6. Julia and packages

I recommend installing Julia via [JuliaUp](https://github.com/JuliaLang/juliaup) as this allows you to have multiple Julia versions installed.

### For Mac

Install JuliaUp:
```
curl -fsSL https://install.julialang.org | sh
```

Install Julia:
```
juliaup add release
```

Start Julia by typing `julia` in the terminal.
Inside Julia, install packages by first pressing `]` to go into package mode (the prompt will change to `(@v1.12) pkg>`):
```
add PhyloNetworks
add SNaQ
add PhyloPlots
```
Leave Julia by typing `exit()`.

## 7. HyDe

We will follow the installation commands from the [github repo](https://github.com/pblischak/HyDe).

### For Mac

I need to update Python:
```
brew install python@3.11
```

I will move to my `software` folder in my computer:
```
git clone https://github.com/pblischak/HyDe.git
cd HyDe
python3.11 -m pip install -r requirements.txt
python3.11 -m pip install .
```

Note that I had updated XCode, but did not agree to the new license, so I was getting weird errors because of that.

## 8. R

Those that don't have them should install R and RStudio, see [here](https://posit.co/download/rstudio-desktop/).

Inside R:
```
install.packages("ape")
install.packages("phangorn")
install.packages("BiocManager")
BiocManager::install("YuLab-SMU/treedataverse")
install.packages("MSCquartets")
```