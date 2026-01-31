---
layout: default
title: 02 Paper Discussion
parent: S26 Wheat
nav_order: 1
---

# Paper Discussion of [Glemin et al (2019)](https://www.science.org/doi/10.1126/sciadv.aav9188)

## Learning objectives for today

- Understand what raw data the authors produced (type of data, individuals per species, sequencing platform) and how they transformed it into the alignments used for phylogenomic inference

- Critically evaluate preprocessing/assembly/orthology decisions and how those choices can bias phylogenomic/hybridization inferences

- Grasp the biological questions / systems (Aegilops/Triticum lineages, the A/B/D genomes) and which data features matter most for interpreting hybridization signals

## Motivating questions

- Framing the discussion
  - What do you think the authors are trying to convince us of in this paper, biologically, not methodologically?
  - What long-standing biological question about wheat evolution is this paper trying to answer?
  - What features of Aegilops/Triticum evolution make phylogenetic inference especially challenging?
    - Timescale of divergence?
    - Effective population sizes?
    - Hybridization compatibility?
- What is the _raw_ data?
  - Q1. What exactly did they measure?
    - Before any analysis, what is the biological object they actually sequenced?
      - Is this genomic DNA, RNA, or something else?
      - From how many individuals per species?
      - From what tissues? (does this matter?)
  - Q2. What biological information is missing by design?
    - Given the data type and tissues sampled, what kinds of genes or signals are guaranteed to be absent or under-represented?
      - Would every gene in the genome have an equal chance of appearing here?
      - Could two species differ biologically but appear similar because of expression?
      - How might this matter for detecting hybridization?
  - Q3. Why might the authors have chosen transcriptomes anyway?
    - Given these limitations, why do you think they chose transcriptomes instead of whole genomes?
      - Cost? Genome size?
      - Orthology vs paralogy?
      - Computational tractability at the time?
- From reads to genes — preprocessing decisions
  - Q4. What is the first irreversible decision in the pipeline?
    - Where in the pipeline do the authors make the first choice that permanently discards data?
      - Trimming thresholds?
      - Discarding short CDS?
      - Removing ambiguous cluster assignments?
  - Q5. What kinds of genes are most likely lost?
    - Given the filters they use (length cutoffs, clustering rules), what kinds of genes are more likely to be removed?
      - Short genes?
      - Fast-evolving genes?
      - Recently duplicated genes?
  - Q6. Is their orthology strategy conservative or aggressive?
    - They only keep CDS that match exactly one cluster bait. Is this a conservative or aggressive choice — and conservative with respect to what?
      - Conservative against false orthology or false paralogy?
      - Which biological scenarios suffer under this rule?
      - How might this affect inference of hybridization vs ILS?
  - Q7. If you changed one preprocessing decision, which would it be?
    - If you were replicating this study, which single preprocessing step would you most want to sensitivity-test? Why?
      - Length cutoff?
      - Identity threshold?
      - Use of consensus sequences later?
- Gene trees, conflict, and biological interpretation
  - Q8. How do the authors decide it’s hybridization and not “just ILS”?
    - Conceptually, what kind of evidence would you need to say this conflict reflects hybridization rather than incomplete lineage sorting?
  - Q9. What conclusions are most sensitive to the data choices?
    - Which parts of the biological story would you trust the least if the data preprocessing were slightly different?
      - Presence vs absence of hybridization?
      - Identity of parental lineages?
      - Timing/order of events?
- Final question: If you had to summarize this paper in one sentence that mentions both biology and data limitations, what would it be?