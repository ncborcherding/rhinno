#' Loading deep immune repertoire models
#' 
#' Use this to load models for downstream analysis 
#' of TCR or BCR sequences.
#' 
#' @examples
#'Trex.TRB.OHE <- loadRhinno(package = "Trex",
#'                           chain = "TRB",
#'                           encoder.input = "OHE",
#'                           encoder.model = "AE")
#'                           
#'                         
#' @param package The package the model will be used with - \strong{Ibex}, 
#' \strong{Trex}, or \strong{Giraffe},
#' @param chain TCR or BCR chain to use - \strong{TRA}, 
#' \strong{TRB}, \strong{Heavy}, \strong{Light}
#' @param encoder.model \strong{"AE"} = dense autoencoder or 
#' \strong{"VAE"} = variation autoencoder
#' @param encoder.input Atchley factors (\strong{AF}), Kidera factors 
#' ((\strong{KF})), Atchley and Kidera factors ((\strong{both})), 
#' or One-Hot Encoder (\strong{OHE}).
#' 
#' @export
#' @importFrom tensorflow tf
#' @importFrom keras load_model_hdf5
#' 
#' @return keras encoder for further analysis
loadRhinno <- function(package = NULL, 
                       chain = NULL, 
                       encoder.input = NULL, 
                       encoder.model = NULL) {
  
  if(any(is.null(c(package, chain, encoder.input, encoder.model)))) {
    stop("Please ensure there is input values for package, chain, encoder.input, and encoder.model parameters")
  }
  
  if(chain %!in% c("TRA", "TRB", "Heavy", "Light")) {
    stop("The chain argument should have either 'TRA', 'TRB', 'Heavy', or 'Light'")
  }
  
  if(package %in% c("Trex", "Ibex") & encoder.input %in% c("AF", "KF", "both", "OHE")) {
    stop("For Trex and Ibex models, please use 'AF', 'KF', 'both', or 'OHE' for encoder.inputs.")
  }
  
  
  select  <- system.file("extdata", paste0(package, "_", chain, "_", 
                                           encoder.input, "_", encoder.model, ".h5"), 
                         package = "rhinno")
  model <- quiet(load_model_hdf5(select, compile = FALSE))
  return(model)
}