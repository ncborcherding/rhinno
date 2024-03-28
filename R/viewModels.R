#' View available models
#' 
#' Use this to view the available models in rhinno
#' 
#' @examples
#' viewModels()
#'                           
#' 
#' @export
#' 
#' @return table of the models in rhinno
viewModels <- function() {
  meta.file <- system.file("extdata", "metadata.csv", 
              package = "rhinno")
  meta.data <- read.csv(meta.file)
  return(meta.data)
}