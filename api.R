

#* @get /version
version <- function() {
  ejemplo <- fromJSON(
    '{"version" : "0.0.1"}'
  )
  print(ejemplo)
}


#* @param codigo Código del indicador del banco mundial
#* @get /indicador
recolecta_datos <- function(codigo = "FP.CPI.TOTL.ZG") {

  url <- paste0("https://api.worldbank.org/v2/es/indicator/", 
                codigo, "?downloadformat=csv")
  download(url, "archivo.zip", mode = "wb")
  
  unzip("archivo.zip")
  
  archivo_seleccionado <- list.files(pattern = "^API")
  
  gcs_upload(
    file = archivo_seleccionado,
    bucket = "serviciobm",
    name = paste0(codigo, ".csv"),
    predefinedAcl = "bucketLevel"
  )
  
  file.remove( list.files(pattern = "*.csv"))

  return(codigo)
}

