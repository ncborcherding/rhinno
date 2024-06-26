% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loadRhinno.R
\name{loadRhinno}
\alias{loadRhinno}
\title{Loading deep immune repertoire models}
\usage{
loadRhinno(
  package = NULL,
  chain = NULL,
  encoder.input = NULL,
  encoder.model = NULL
)
}
\arguments{
\item{package}{The package the model will be used with - \strong{Ibex}, 
\strong{Trex}, or \strong{Giraffe},}

\item{chain}{TCR or BCR chain to use - \strong{TRA}, 
\strong{TRB}, \strong{Heavy}, \strong{Light}}

\item{encoder.input}{Atchley factors (\strong{AF}), Kidera factors 
((\strong{KF})), Atchley and Kidera factors ((\strong{both})), 
or One-Hot Encoder (\strong{OHE}).}

\item{encoder.model}{\strong{"AE"} = dense autoencoder or 
\strong{"VAE"} = variation autoencoder}
}
\value{
keras encoder for further analysis
}
\description{
Use this to load models for downstream analysis 
of TCR or BCR sequences.
}
\examples{
Trex.TRB.OHE <- loadRhinno(package = "Trex",
                          chain = "TRB",
                          encoder.input = "OHE",
                          encoder.model = "AE")
                          
                        
}
