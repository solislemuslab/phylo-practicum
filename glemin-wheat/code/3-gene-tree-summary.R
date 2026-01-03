library(ape)
library(phangorn)
library(phytools)
library(ggplot2)

getwd()
#setwd("../results/RAxML") # if not in the correct folder


tree_files <-list.files(pattern="\\.raxml.bestTree$") ##List all .bestTree files. $ ensures the end of the name

gene_trees<- list() #list with all the trees
class(gene_trees)<- "multiPhylo" #make it a multiphylo object for ease of use with other 

i<-1
for(tree_file in tree_files){ ##go thru each file and read the tree
  gene_trees[[i]]<- read.tree(tree_file)
  i<-i+1
}


#Find the appropriate root taxon
root_taxa <- c("H_vulgare_HVens23", "Er_bonaepartis_TB1", "S_vavilovii_Tr279", "Ta_caputMedusae_TB2")

# Extract the first matching species for each tree
gene_tree_outgroup<- rep(NA,length(gene_trees))
for(i in 1:length(gene_trees)){
  gene_tree <- gene_trees[[i]]
  found_taxa <- root_taxa[root_taxa %in% gene_tree$tip.label]
  
  # Return the first one if it exists
  if (length(found_taxa) > 0) {
    gene_tree_outgroup[i]<-found_taxa[1]
  }
}

#check if any gene trees don't have an outgroup taxon
any(is.na(gene_tree_outgroup)) ## should return FALSE

#re-reroot all our gene trees by the respective outgroup
for(i in 1:length(gene_trees)){
  gene_trees[[i]]<- root(gene_trees[[i]],
                         outgroup = gene_tree_outgroup[i],
                         resolve.root=TRUE)
  gene_trees[[i]]<-chronos(gene_trees[[i]]) ## make ultrametric for nicer densitree
}


# see which genes have which taxa
all_labels <- unlist(lapply(gene_trees, function(x) x$tip.label)) ##count how often each individual appears
df <- as.data.frame(table(all_labels) / length(gene_trees)) #organize as a nice data frame for plotting

ggplot(df, aes(x = all_labels, y = Freq)) +
  geom_col() +
  labs(x = "Individual", y = "Proportion")+
  theme(axis.text.x = element_text(angle = 90))

st<-superTree(gene_trees)
st<-root(st,"H_vulgare_HVens23",resolve.root = T)
plot(st)

densiTree(gene_trees,consensus=st,scaleX=T,type='cladogram')


trees = read.tree(file="Ae_bicornis_Tr406_BIS2_Contig10132_simExt_macseNT_noFS_clean.aln.raxml.mlTrees")

rtrees <- lapply(trees, function(tr) {
  root(tr, outgroup = "H_vulgare_HVens23", resolve.root = TRUE)
})


##Densitree of common taxa

common_tips <- Reduce(
  intersect,
  lapply(gene_trees, function(tr) tr$tip.label)
)

length(common_tips) ## 6

trees_pruned <- lapply(
  gene_trees,
  function(tr) drop.tip(tr, setdiff(tr$tip.label, common_tips))
)

densityTree(trees_pruned,use.edge.length=FALSE,type="cladogram",nodes="centered")



##Densitree of gene tree plots

densityTree(trees,type="cladogram",nodes="intermediate")
densityTree(rtrees,type="cladogram",nodes="intermediate")


densityTree(trees,use.edge.length=FALSE,type="cladogram",nodes="centered")
densityTree(rtrees,use.edge.length=FALSE,type="cladogram",nodes="centered")

