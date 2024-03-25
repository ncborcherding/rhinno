df <- data.frame(
  Title = "Trex TRB OHE AE", 
  Description = "Deep autoencoder for the TRB locus of the TCR using a one-hot encoding approach",
  RDataPath = file.path("rhinno", "Trex_TRB_OHE_AE.h5"),
  BiocVersion="3.19", 
  Genome=NA, 
  SourceType="h5", 
  SourceUrl="https://github.com/Trex",
  SourceVersion="blueprint_encode.rda",
  Species="Homo sapiens",
  TaxonomyId="9606",
  Coordinate_1_based=NA,
  DataProvider="Nick Borcherding",
  Maintainer="Nick Borcherding <ncborch@gmail.com>",
  RDataClass="h5",
  DispatchClass="H5File", 
  stringsAsFactors = FALSE
)

write.csv(file="./inst/extdata/Trex_TRB_OHE_AE.csv", df, row.names=FALSE)
