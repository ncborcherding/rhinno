model.names <- c("Trex TRB OHE AE", "Trex TRB AF AE", "Trex TRB KF AE", "Trex TRB both AE",
                 "Trex TRA OHE AE", "Trex TRA AF AE", "Trex TRA KF AE", "Trex TRA both AE",
                 "Trex TRB OHE VAE", "Trex TRB AF VAE", "Trex TRB KF VAE", "Trex TRB both VAE",
                 "Trex TRA OHE VAE", "Trex TRA AF VAE", "Trex TRA KF VAE", "Trex TRA both VAE",
                 "Ibex Heavy OHE AE", "Ibex Heavy AF AE", "Ibex Heavy KF AE", "Ibex Heavy both AE",
                 "Ibex Light OHE AE", "Ibex Light AF AE", "Ibex Light KF AE", "Ibex Light both AE",
                 "Ibex Heavy OHE VAE", "Ibex Heavy AF VAE", "Ibex Heavy KF VAE", "Ibex Heavy both VAE",
                 "Ibex Light OHE VAE", "Ibex Light AF VAE", "Ibex Light KF VAE", "Ibex Light both VAE")

  
approach <- c(VAE = "Variational Autoencode", AE = "Autoencoder")

lapply(model.names, function(x) {
  df <- data.frame(
    Title = x,
    Description = paste0("Deep ",  as.vector(approach[strsplit(x, " ")[[1]][4]]), " for the ", strsplit(x, " ")[[1]][2], " chain using the ", strsplit(x, " ")[[1]][3], " transformation of sequences."),
    RDataPath = file.path("rhinno", paste0(gsub(" ", "_", x), ".h5")),
    BiocVersion="3.19", 
    Genome=NA, 
    SourceType="HDF5", 
    SourceUrl=paste0("https://github.com/", strsplit(x, " ")[[1]][1]),
    SourceVersion="April 1 2024",
    Species="Homo sapiens",
    TaxonomyId="9606",
    Coordinate_1_based=NA,
    DataProvider="Nick Borcherding",
    Maintainer="Nick Borcherding <ncborch@gmail.com>",
    RDataClass="h5",
    DispatchClass="H5File", 
    stringsAsFactors = FALSE
  )
}) -> meta.list

meta.data <- do.call(rbind, meta.list)

write.csv(file="./inst/extdata/metadata.csv", meta.data, row.names=FALSE)
