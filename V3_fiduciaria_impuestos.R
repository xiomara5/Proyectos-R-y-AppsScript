#------------------------------------------ Librerias =============
#install.packages(c("FRACTION","dplyr","tidyverse","stringr","lubridate","tidyr","openxlsx","readxl","shiny","miniUI","timechange","taskscheduleR","openxlsx","writexl"))
#install.packages("googlesheets4")
#install.packages("tidyverse")
#install.packages("remotes")


library(FRACTION)
library(dplyr)
library(stringr)
library(readxl)
library(shiny)
library(miniUI)
library(timechange)
library(lubridate)
library(tidyr)
library(openxlsx)
library(writexl)
library(readr)
library(googlesheets4)
library(googledrive)



#Para que los datos no esten en anotación cientifica
options(scipen=999)

#------------------------------------------ Importacion 
#parte variable 
carpeta = Sys.getenv("HOME")

#cambiamos los diagonales
carpeta = gsub("\\\\", "/", carpeta)

#definimos la parte fija --> ojo con los / 
input = paste(carpeta, "/Capacitaciones_Analitica/Fiduciaria-Impuestos/ENTRADA", sep = "") 
output = paste(carpeta, "/Capacitaciones_Analitica/Fiduciaria-Impuestos/SALIDA", sep = "")


#acordamos la dirección de entrada (input) de los archivos 
setwd(input)

#Importamos los archivos 
Reporte_SAFE <- read_delim("Reporte_SAFE.txt", 
                           delim = ";", escape_double = FALSE, trim_ws = TRUE, col_types = cols(
                             `NUMERO DEL PRODUCTO (NEGOCIO FIDUCIARIO)` = col_number(), 
                             `NOMBRE DEL NEGOCIO FIDUCIARIO` = col_character(), 
                             `CALIDAD DEL BENEFICIARIO` = col_character(), 
                             `CRITERIOS PARA LA DETERMINACION DEL BENEFICIARIO FINAL  - TITULARIDAD` = col_number(), 
                             `CRITERIOS PARA LA DETERMINACION DEL BENEFICIARIO FINAL  - BENEFICIO` = col_number(), 
                             `CRITERIOS PARA LA DETERMINACION DEL BENEFICIARIO FINAL - CONTROL POR OTRO MEDIO` = col_number(),
                             `CRITERIOS PARA LA DETERMINACION DEL BENEFICIARIO FINAL - Â¿ES REPRESENTANTE LEGAL Y/O MAYOR AUTORIDAD EN RELACION CON LAS FUNCIONES DE GESTION O DIRECCION?` = col_number(),
                             `BENEFICIARIO FINAL DE LA ESTRUCTURA SIN PERSONERIA JURIDICA - FIDUCIANTE/FIDEICOMITENTE/CONSTITUYENTE O POSICION SIMILAR O EQUIVALENTE` = col_number(),
                             `BENEFICIARIO FINAL DE LA ESTRUCTURA SIN PERSONERIA JURIDICA FIDUCIARIO O POSICION SIMILAR O EQUIVALENTE` = col_number(),
                             `BENEFICIARIO FINAL DE LA ESTRUCTURA SIN PERSONERIA JURIDICA COMITÃ© FIDUCIARIO / COMITÃ© FINANCIERO O POSICION SIMILAR O EQUIVALENTE` = col_number(),
                             `BENEFICIARIO FINAL DE LA ESTRUCTURA SIN PERSONERIA JURIDICA FIDEICOMISARIO / BENEFICIARIO` = col_number(),
                             `BENEFICIARIO FINAL DE LA ESTRUCTURA SIN PERSONERIA JURIDICA EJERCE EL CONTROL FINAL Y/O EFECTIVO O TIENE DERECHO A GOZAR Y/O DISPONER DE LOS ACTIVOS, BENEFICIOS, RESULTADOS O UTILIDADES` = col_number(),
                             `CONDICIONES QUE SE DEBEN  TENER PARA LA CALIDAD DE BENEFICIARIO FINAL` = col_number(),
                             `INFORMACION INICIAL. 1. ACCIONES AL PORTADOR.Â¿EL FIDEICOMISO O CONSORCIO TIENE ACCIONES AL PORTADOR O EN SU CADENA DE PROPIEDAD TIENE PERSONA(S) JURIDICA(S) CON ACCIONES AL PORTADOR?` = col_number(),
                             `Â¿TIENE INFORMACION DE LOS BENEFICIARIOS FINALES DE LA(S) PERSONA(S) JURIDICA(S) CON ACCIONES AL PORTADOR ?` = col_number(),
                             `INFORMACION DE LA(S) PERSONA(S) JURIDICA(S) CON ACCIONES AL PORTADOR - TIPO DE DOCUMENTO` = col_number(),
                             `NUMERO DE IDENTIFICACION TRIBUTARIA` = col_number(),
                             `PAIS DE EXPEDICION DEL NIT` = col_number(),
                             `RAZON SOCIAL (RAZON SOCIAL ACCIONES AL PORTADOR)` = col_character(),
                             `EL BENEFICIARIO QUE VA A REPORTAR ES UN BENEFICIARIO CONDICIONADO` = col_number(),
                             `CRITERIOS PARA LA DETERMINACION DEL BENEFICIARIO CONDICIONADO.` = col_character(),
                             `FECHA INICIAL COMO BENEFICIARIO CONDICIONADO` = col_character(),
                             `FECHA FINAL COMO BENEFICIARIO CONDICIONADO` = col_character(),
                             `TIPO DE DOCUMENTO` = col_number(),
                             `NUMERO IDENTIFICACION` = col_number(),
                             `PAIS DE EXPEDICION DEL NUMERO DE IDENTIFICACION` = col_number(),
                             `NUMERODE IDENTIFICACION TRIBUTARIA` = col_number(),
                             `PAIS DE EXPEDICION DEL NUMERO DE IDENTIFICACION TRIBUTARIA` = col_number(),
                             `PRIMER APELLIDO DEL INFORMADO` = col_character(),
                             `SEGUNDO APELLIDO DEL INFORMADO` = col_character(),
                             `PRIMER NOMBRE DEL INFORMADO` = col_character(),
                             `OTROS NOMBRES DEL INFORMADO` = col_character(),
                             `FECHA DE NACIMIENTO` = col_character(),
                             `PAIS DE NACIMIENTO` = col_number(),
                             `PAIS DE NACIONALIDAD` = col_number(),
                             `PAIS DE RESIDENCIA O DOMICILIO` = col_number(),
                             `DEPARTAMENTO DE DIRECCION DE NOTIFICACION` = col_number(),
                             `MUNICIPIO  DE DIRECCION DE NOTIFICACION` = col_number(),
                             `DIRECCION DE NOTIFICACION` = col_character(),
                             `CODIGO POSTAL` = col_number(),
                             `CORREO ELECTRONICO` = col_character(),
                             `NIT PERSONA JURIDICA FIDEICOMITENTE Y/O BENEFICIARIO` = col_number(),
                             `NOMBRE  PERSONA JURIDICA FIDEICOMITENTE Y /O BENEFICIARIO DEL NEGOCIO FIDUCIARIO` = col_character(),
                             `PORCENTAJE PARTICIPACION EN EL CAPITAL DE LA PERSONA JURIDICA` = col_number(),
                             `PORCENTAJE DE BENEFICIO EN LOS RESULTADOS, RENDIMIENTOS O UTILIDADES DE LA PERSONA JURIDICA O ESTRUCTURA SIN PERSONERIA JURIDICA` = col_number(),
                             `FECHA INICIAL COMO BENEFICIARIO FINAL` = col_character(),
                             `FECHA FINAL COMO BENEFICIARIO FINAL` = col_character(),
                             `TIPO DE NOVEDAD` = col_number()
                           ))


Reporte_SAF <- read.delim("Reporte_SAF.xls", colClasses = c('numeric',	'character',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',
                                                            'numeric',	'character',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	
                                                            'numeric',	'numeric',  	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'character',	'character',	'character',	
                                                            'character',	'character',	'numeric',	'numeric',	'numeric',	'numeric',	'numeric',	'character',	'numeric',	'character',
                                                            'numeric',	'character',	'numeric',	'numeric',	'character',	'character',	'numeric'))


#=============================== Limpieza SAFE ====================
Reporte_SAFE = Reporte_SAFE %>% 
  mutate(across(c(44:45), ~ round(., 5)),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[<>]", " ")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[-]", " ")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[()]", " ")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[;]", " ")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[/]", " ")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[*]", " ")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[&]", "y")),
         across(c(2,29:32,39), ~ str_replace_all(. ,"[@]", " ")),   #Correo
         across(c(2,29:32,39), ~ str_replace_all(. ,"[.]", " ")),   #Correo
         across(c(39), ~ str_replace_all(. ,"[#]", "NO")),          #Dirección
         across(c(2,29:32,39,41), ~ toupper(.)),   #Mayusculas
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[ÁÄÀÂ]", "A")), 
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[ÉÈÊË]", "E")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[ÍÏÌÎ]", "I")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[ÓÖÔ]", "O")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[ÚÜÙÛ]", "U")),
         across(c(2,29:32,39,41), ~ str_replace_all(. ,"[Ñ]", "N")),
         #across(c(44,45), ~ str_replace_all(. ,"[,]", ".")),        #Decimal es punto
         across(c(41), ~ tolower(.)),     #Minusculas
         
         #Longitudes
         across(c(4:12,14:15,20,48), ~ substr(. , 1,1)),    #substr --> como el extraer de excel
         across(c(16,24,37), ~ substr(. , 1,2)),
         across(c(34:36,38), ~ substr(. , 1,3)),
         across(c(18,26,28), ~ substr(. , 1,4)),
         across(c(22,23,33,40,46,47), ~ substr(. , 1,10)),
         across(c(17,25,27), ~ substr(. , 1,20)),
         across(c(41), ~ substr(. , 1,50)),
         across(c(19,29:32), ~ substr(. , 1,60)),
         across(c(21,39), ~ substr(. , 1,250))
  )

#=============================== Limpieza SAF ====================
Reporte_SAF <- Reporte_SAF %>% 
  mutate(across(c(43:44), ~ round(., 5)),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[<>]", " ")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[-]", " ")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[()]", " ")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[;]", " ")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[/]", " ")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[*]", " ")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[&]", "y")),
         across(c(2,12,28:31,38), ~ str_replace_all(. ,"[@]", " ")),   #Correo
         across(c(2,12,28:31,38), ~ str_replace_all(. ,"[.]", " ")),   #Correo
         across(c(38), ~ str_replace_all(. ,"[#]", "NO")),          #Dirección
         
         across(c(2,12,28:31,38,40), ~ toupper(.)), 
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[ÁÄÀÂ]", "A")), 
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[ÉÈÊË]", "E")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[ÍÏÌÎ]", "I")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[ÓÖÔ]", "O")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[ÚÜÙÛ]", "U")),
         across(c(2,12,28:31,38,40), ~ str_replace_all(. ,"[Ñ]", "N")),
         across(c(43,44), ~ str_replace_all(. ,"[,]", ".")),        #Decimal es punto
         across(c(40), ~ tolower(.)),
         
         #Longitudes
         across(c(3:11,13:14,19:20,47), ~ substr(. , 1,1)),
         across(c(15,23,36,), ~ substr(. , 1,2)),
         across(c(17,27,33:35,37), ~ substr(. , 1,3)),
         across(c(21,22,32,39,45:46), ~ substr(. , 1,10)),
         across(c(16,24,26), ~ substr(. , 1,20)),
         across(c(40), ~ substr(. , 1,50)),
         across(c(28:31), ~ substr(. , 1,60)),
         across(c(25), ~ substr(. , 1,169)),
         across(c(12,38), ~ substr(. , 1,250))
  )

#==================== Exportacion ====================
#Definimos la salida
setwd(output)
write.xlsx(Reporte_SAFE, 'Reporte SAFE.xlsx')
write.xlsx(Reporte_SAF, 'Reporte SAF.xlsx')
