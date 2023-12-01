#========================================= Parte 1 =================================
#-------------------------------- Instalación de paquetes 
#install.packages("googlesheets4")
#install.packages("tidyverse")
#install.packages("remotes")
#install.packages(c("FRACTION","dplyr","tidyverse","stringr","lubridate","tidyr","openxlsx","readxl","shiny","miniUI","timechange","taskscheduleR","openxlsx","writexl"))

#abrimos las librerias 
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
library(googlesheets4)
library(googledrive)
library(readr)

#Para que los datos no esten en anotación cientifica
options(scipen=999)

#------------------------------------------ Conceder permisos 
#autenticación pasar a google chrome para dar permisos al r 
gs4_auth()
drive_auth()



#========================================= Parte 2 ==================================
#Funciones
#============= CDT 
TipoAnio = function(anio) { 
  a0 = "No_bisiesto"
  a4 <- "Si_bisiesto"          
  anioS = ifelse(anio %% 100 == 0, anio/100, anio)  
  anioT = ifelse(anioS %% 4  == 0, a4, a0)          
  año_bisisto = anioT }    
dias360_eeuu =  function(fecha_inicio, fecha_fin) {
  año_inicio <- as.numeric(format(fecha_inicio, "%Y"))
  mes_inicio <- as.numeric(format(fecha_inicio, "%m"))
  dia_inicio <- as.numeric(format(fecha_inicio, "%d"))
  
  año_fin <- as.numeric(format(fecha_fin, "%Y"))
  mes_fin <- as.numeric(format(fecha_fin, "%m"))
  dia_fin <- as.numeric(format(fecha_fin, "%d"))
  
  #Año bisiesto
  año_bisisto = TipoAnio(año_inicio)
  
  #Condicionales DIAS360
  dia_inicio = case_when(dia_inicio == 31 & mes_inicio == 1 ~ 30,
                         dia_inicio == 28 & mes_inicio == 2 & año_bisisto == "No_bisiesto" ~ 30,
                         dia_inicio == 29 & mes_inicio == 2 & año_bisisto == "Si_bisiesto" ~ 30,
                         dia_inicio == 31 & mes_inicio == 3 ~ 30,
                         dia_inicio == 30 & mes_inicio == 4 ~ 30,
                         dia_inicio == 31 & mes_inicio == 5 ~ 30,
                         dia_inicio == 30 & mes_inicio == 6 ~ 30,
                         dia_inicio == 31 & mes_inicio == 7  ~ 30,
                         dia_inicio == 31 & mes_inicio == 8 ~ 30,
                         dia_inicio == 30 & mes_inicio == 9 ~ 30,
                         dia_inicio == 31 & mes_inicio == 10 ~ 30,
                         dia_inicio == 30 & mes_inicio == 11 ~ 30,
                         dia_inicio == 31 & mes_inicio == 12 ~ 30,
                         TRUE ~ dia_inicio)
  
  dia_fin_1 = dia_fin
  dia_fin = case_when(dia_fin == 31 & dia_inicio < 30 ~ 1,
                      dia_fin == 31 & dia_inicio == 30 ~ 30,
                      TRUE ~ dia_fin)
  
  mes_fin_1 = mes_fin
  mes_fin = case_when(dia_fin_1 != dia_fin &  dia_fin < 30 & mes_fin < 12 ~ mes_fin + 1,
                      dia_fin_1 != dia_fin &  dia_fin < 30  & mes_fin == 12 ~ 1,
                      TRUE ~ mes_fin)
  
  año_fin  = case_when(dia_fin_1 != dia_fin & dia_fin == 1 & mes_fin_1 != mes_fin & mes_fin == 1 ~ año_fin + 1,
                       TRUE ~ año_fin)
  
  
  # Calcular la diferencia de días
  dias360 <- 360 * (año_fin - año_inicio) + 30 * (mes_fin - mes_inicio) + (dia_fin - dia_inicio)
  
}
t_aprox = function(t_v,PLAZO_PTE_v ) { 
  t_aprox = case_when( t_v == 0 | t_v > PLAZO_PTE_v ~ 0,
                       t_v >= 1 &  t_v <= 180 ~ 180, 
                       t_v >= 181 &  t_v <= 360 ~ 360,
                       t_v >= 361 &  t_v <= 720 ~ 720,
                       t_v >= 721 &  t_v <= 100000 ~ 100000,
                       TRUE ~ 200000)}
tm_fun = function(t_aprox_v,factor_v, Tasas_d){
  tm = case_when(t_aprox_v == 0 ~ 0,
               factor_v == "IPC" & t_aprox_v >= 1 &  t_aprox_v <= 180 ~ Tasas_d[1,2], 
               factor_v == "IPC" & t_aprox_v >= 181 &  t_aprox_v <= 360 ~ Tasas_d[2,2],
               factor_v == "IPC" & t_aprox_v >= 361 &  t_aprox_v <= 720 ~ Tasas_d[3,2],
               factor_v == "IPC" & t_aprox_v >= 721 &  t_aprox_v <= 100000 ~ Tasas_d[4,2],
               factor_v == "DTF" & t_aprox_v >= 1 &  t_aprox_v <= 180 ~ Tasas_d[1,3], 
               factor_v == "DTF" & t_aprox_v >= 181 &  t_aprox_v <= 360 ~ Tasas_d[2,3],
               factor_v == "DTF" & t_aprox_v >= 361 &  t_aprox_v <= 720 ~ Tasas_d[3,3],
               factor_v == "DTF" & t_aprox_v >= 721 &  t_aprox_v <= 100000 ~ Tasas_d[4,3],
               factor_v == "IBR" & t_aprox_v >= 1 &  t_aprox_v <= 180 ~ Tasas_d[1,4], 
               factor_v == "IBR" & t_aprox_v >= 181 &  t_aprox_v <= 360 ~ Tasas_d[2,4],
               factor_v == "IBR" & t_aprox_v >= 361 &  t_aprox_v <= 720 ~ Tasas_d[3,4],
               factor_v == "IBR" & t_aprox_v >= 721 &  t_aprox_v <= 100000 ~ Tasas_d[4,4],
               factor_v == "Fija" & t_aprox_v >= 1 &  t_aprox_v <= 180 ~ Tasas_d[1,5], 
               factor_v == "Fija" & t_aprox_v >= 181 &  t_aprox_v <= 360 ~ Tasas_d[2,5],
               factor_v == "Fija" & t_aprox_v >= 361 &  t_aprox_v <= 720 ~ Tasas_d[3,5],
               factor_v == "Fija" & t_aprox_v >= 721 &  t_aprox_v <= 100000 ~ Tasas_d[4,5],
               TRUE ~ 200000) }
vp_fun = function(t_aprox_v,t_v,PLAZO_PTE_v,PAGO_v,SALDOTOTAL_v,tm_v) {
  vp = ifelse(t_aprox_v == 0,0, 
              ifelse(t_v == PLAZO_PTE_v, 
                     (PAGO_v + SALDOTOTAL_v)/((1 + tm_v)^(t_v/360)), 
                     PAGO_v /((1+tm_v)^(t_v/360)))) }
t_n_fun = function(PERIODICIDAD_v, PERIODICIDAD_NUM_v, t_v) {
  t_n = case_when(PERIODICIDAD_v == 'ALVENCIMIENTO' ~ 0,
                  TRUE ~ PERIODICIDAD_NUM_v + t_v) }

#============ Obligaciones
fecha_pago_fun = function(Fecha_pago_de_intereses_f,Frecuencia_de_pago_de_intereses_f, Fecha_Final_v) {
  fecha_pago_1 = as.Date(case_when(Frecuencia_de_pago_de_intereses_f == 'MENSUAL' | Frecuencia_de_pago_de_intereses_f == 'mensual' | Frecuencia_de_pago_de_intereses_f == 'MV'  ~ Fecha_pago_de_intereses_f %m+% months(1),
                                   Frecuencia_de_pago_de_intereses_f == 'BIMENSUAL' | Frecuencia_de_pago_de_intereses_f == 'bimensual' | Frecuencia_de_pago_de_intereses_f == 'BV'  ~ Fecha_pago_de_intereses_f %m+% months(2),
                                   Frecuencia_de_pago_de_intereses_f == 'TRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'trimestral' | Frecuencia_de_pago_de_intereses_f == 'TV'  ~ Fecha_pago_de_intereses_f %m+% months(3),
                                   Frecuencia_de_pago_de_intereses_f == 'CUATRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'cuatrimestral' | Frecuencia_de_pago_de_intereses_f == 'CV'  ~ Fecha_pago_de_intereses_f %m+% months(4),
                                   Frecuencia_de_pago_de_intereses_f == 'SEMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'semestral' | Frecuencia_de_pago_de_intereses_f == 'SV'  ~ Fecha_pago_de_intereses_f %m+% months(6),
                                   TRUE ~ NA_Date_))
  
  diferencia_fechas = difftime(fecha_pago_1,Fecha_Final_v) 
  
  fecha_pago = as.Date.numeric(ifelse(diferencia_fechas > 0 , Fecha_Final_v ,
                                      case_when(Frecuencia_de_pago_de_intereses_f == 'MENSUAL' | Frecuencia_de_pago_de_intereses_f == 'mensual' | Frecuencia_de_pago_de_intereses_f == 'MV'  ~ Fecha_pago_de_intereses_f  %m+% months(1),
                                                Frecuencia_de_pago_de_intereses_f == 'BIMENSUAL' | Frecuencia_de_pago_de_intereses_f == 'bimensual' | Frecuencia_de_pago_de_intereses_f == 'BV'  ~ Fecha_pago_de_intereses_f %m+% months(2),
                                                Frecuencia_de_pago_de_intereses_f == 'TRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'trimestral' | Frecuencia_de_pago_de_intereses_f == 'TV'  ~ Fecha_pago_de_intereses_f %m+% months(3),
                                                Frecuencia_de_pago_de_intereses_f == 'CUATRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'cuatrimestral' | Frecuencia_de_pago_de_intereses_f == 'CV'  ~ Fecha_pago_de_intereses_f  %m+% months(4),
                                                Frecuencia_de_pago_de_intereses_f == 'SEMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'semestral' | Frecuencia_de_pago_de_intereses_f == 'SV'  ~ Fecha_pago_de_intereses_f %m+% months(6),
                                                TRUE ~ NA_Date_)), origin )
}
interes_fun = function (tasa_pactada, fecha_pago_v, fecha_ultimo_pago_intereses) { 
  (1+tasa_pactada)^( (as.numeric(difftime(fecha_pago_v, fecha_ultimo_pago_intereses)))/365)-1 }
fecha_pago_fun_n = function(Fecha_pago,Frecuencia_de_pago_de_intereses_f, Fecha_Final_v) {
  fecha_pago_1 = as.Date(case_when(Frecuencia_de_pago_de_intereses_f == 'MENSUAL' | Frecuencia_de_pago_de_intereses_f == 'mensual' | Frecuencia_de_pago_de_intereses_f == 'MV'  ~ Fecha_pago %m+% months(1),
                                   Frecuencia_de_pago_de_intereses_f == 'BIMENSUAL' | Frecuencia_de_pago_de_intereses_f == 'bimensual' | Frecuencia_de_pago_de_intereses_f == 'BV'  ~ Fecha_pago %m+% months(2),
                                   Frecuencia_de_pago_de_intereses_f == 'TRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'trimestral' | Frecuencia_de_pago_de_intereses_f == 'TV'  ~ Fecha_pago %m+% months(3),
                                   Frecuencia_de_pago_de_intereses_f == 'CUATRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'cuatrimestral' | Frecuencia_de_pago_de_intereses_f == 'CV'  ~ Fecha_pago %m+% months(4),
                                   Frecuencia_de_pago_de_intereses_f == 'SEMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'semestral' | Frecuencia_de_pago_de_intereses_f == 'SV'  ~ Fecha_pago %m+% months(6),
                                   TRUE ~ NA_Date_))
  
  diferencia_fechas = difftime(fecha_pago_1,Fecha_Final_v) 
  
  fecha_pago = as.Date.numeric(ifelse(diferencia_fechas > 0  & Fecha_pago != Fecha_Final_v , Fecha_Final_v , 
                                      ifelse ( diferencia_fechas > 0  & Fecha_pago == Fecha_Final_v, NA_Date_, 
                                               case_when(Frecuencia_de_pago_de_intereses_f == 'MENSUAL' | Frecuencia_de_pago_de_intereses_f == 'mensual' | Frecuencia_de_pago_de_intereses_f == 'MV'  ~ Fecha_pago %m+% months(1),
                                                         Frecuencia_de_pago_de_intereses_f == 'BIMENSUAL' | Frecuencia_de_pago_de_intereses_f == 'bimensual' | Frecuencia_de_pago_de_intereses_f == 'BV'  ~ Fecha_pago %m+% months(2),
                                                         Frecuencia_de_pago_de_intereses_f == 'TRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'trimestral' | Frecuencia_de_pago_de_intereses_f == 'TV'  ~ Fecha_pago %m+% months(3),
                                                         Frecuencia_de_pago_de_intereses_f == 'CUATRIMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'cuatrimestral' | Frecuencia_de_pago_de_intereses_f == 'CV'  ~ Fecha_pago %m+% months(4),
                                                         Frecuencia_de_pago_de_intereses_f == 'SEMESTRAL' | Frecuencia_de_pago_de_intereses_f == 'semestral' | Frecuencia_de_pago_de_intereses_f == 'SV'  ~ Fecha_pago %m+% months(6),
                                                         TRUE ~ NA_Date_))), origin )
}
couta_fun_n = function(Fecha_pago, couta_n_mas_1, intereses_n, Saldo_Al_Corte_En_Pesos )  {
          Couta_n = ifelse(is.na(Fecha_pago), 0, ifelse(couta_n_mas_1 == 0, intereses_n * Saldo_Al_Corte_En_Pesos + Saldo_Al_Corte_En_Pesos, 
                                      intereses_n * Saldo_Al_Corte_En_Pesos)) } 
VPN_fun = function(fecha_pago_v, fecha_final_v, couta_v, tasa_de_mercado_v,fecha_corte_v){
  VPN = ifelse(fecha_pago_v > fecha_final_v, 0, couta_v/(1+tasa_de_mercado_v)^(as.numeric((fecha_pago_v-fecha_corte_v))/365))
  VPN = ifelse(is.na(VPN), 0, VPN)
  }

 
#========================================= Importamos los datos =====================
#Importamos las fechas y  los parametros
dia1 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "B2"))
mes1 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "D2"))
año1 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "F2"))

dia2 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "B6"))
mes2 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "D6"))
año2 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "F6"))

dia3 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "B10"))
mes3 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "D10"))
año3 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "F10"))

folder_id_1 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "B3"))
folder_id_2 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "B7"))
folder_id_3 = as.character(read_sheet("ID_carpeta", sheet = 'Datos_Variables', col_names = FALSE, range = "B11"))

parametros_tipo_tasa = read_sheet("ID_carpeta", sheet = 'Para_Tipo_Tasa', col_names = TRUE)
parametros_periocidad = read_sheet("ID_carpeta", sheet = 'Para_periocidad', col_names = TRUE)
parametros_rango = read_sheet("ID_carpeta", sheet = 'Para_rango', col_names = TRUE)

#========================================= LIMPIEZA PARAMETROS =====================
#Limpiaza parametros
names(parametros_periocidad) =  c("PERIODICIDAD", "PERIODICIDAD_NUM")
parametros_periocidad <- parametros_periocidad %>%
  mutate(PERIODICIDAD = toupper(PERIODICIDAD),
         PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÁÄÀÂ]", "A"),
         PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÉÈÊË]", "E"),
         PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÍÏÌÎ]", "I"),
         PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÓÖÔ]", "O"),
         PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÚÜÙÛ]", "U"),
         PERIODICIDAD = str_replace_all(PERIODICIDAD,"[Ñ]", "N"),
         PERIODICIDAD = str_remove_all(PERIODICIDAD, " "))


names(parametros_rango) = c("Desde","Hasta","Rango_aproximado")
names(parametros_tipo_tasa) = c("TIPOTASA", "FACTOR") 


#========================================= Funcion Valor Razonable ===================
Funcion_Valor_Razonable = function(folder_id, index, Año, Mes, Dia) { 
  
  #Extraemos las diferentes formas de fechas    
  Mes = case_when(Mes == 1 | Mes == 2 | Mes == 3 | Mes == 4 | Mes == 5 | Mes == 6 | Mes == 7 | Mes == 8 | Mes == 9 ~ paste0("0",Mes), TRUE ~ Mes)
  Mes_letra = case_when(Mes == '01' ~paste0("Ene", Año), Mes == '02' ~  paste0("Feb", Año), Mes == '03' ~ paste0("Mar", Año), Mes == '04' ~ paste0("Abr", Año), Mes == '05' ~ paste0("May", Año), Mes == '06' ~  paste0("Jun", Año), Mes == '07' ~ paste0("Jul" , Año), Mes == '08' ~ paste0("Ago", Año), Mes == '09' ~ paste0("Set", Año), Mes == '10' ~ paste0("Oct" , Año), Mes == '11' ~ paste0("Nov", Año), Mes == '12' ~ paste0("Dic" , Año), TRUE ~ "Error")
  fecha_completa = case_when(Mes == '01' ~ paste("Enero", Año), Mes == '02' ~  paste("Febrero", Año), Mes == '03' ~ paste("Marzo", Año), Mes == '04' ~ paste("Abril", Año), Mes == '05' ~ paste("Mayo", Año), Mes == '06' ~  paste("Junio", Año), Mes == '07' ~ paste("Julio" , Año), Mes == '08' ~ paste("Agosto", Año), Mes == '09' ~ paste("Septiembre", Año), Mes == '10' ~ paste("Octubre" , Año), Mes == '11' ~ paste("Noviembre", Año), Mes == '12' ~ paste("Diciembre" , Año), TRUE ~ "Error")
  fecha_corte = paste0(Año,Mes,Dia)
 
  #Nombramos el folder
  folder <- as_id(folder_id)
  files <- drive_ls(path = folder)
  
  # Nombres de archivos que quieres descargar
  Balance_Trasmitido = paste0("Balance_Trasmitido_",Mes_letra,".xlsx")
  CDT = paste0("CDT_", Mes_letra,".txt" )
  Tasas_CDTS =  paste0("Tasas_Cdts_",Año,"_",Mes,".xlsx" )
  Bonos =  paste0("Bonos_",Año,"_",Mes,".xlsx")
  Preciospip_Cons_T =  paste0("Preciospip_Cons_T+0_", fecha_corte,".csv")
  Preciospip_INT_DVDA_T =  paste0("Preciospip_INT_DVDA_T+0_", fecha_corte,".csv")
  Anexo_Obligaciones_Col =  paste0("Anexo_Obligaciones_Col_",Año,"_",Mes,".xlsx")
  Anexo_Obligaciones_Miami = paste0("Anexo_Obligaciones_Miami_",Año,"_",Mes,".xlsx")
  Tasas_Cartera_Pasiva =  paste0("Tasas_Cartera_Pasiva_",Año,"_",Mes,".xlsx")
  historico_tasas =  paste0("historico_tasas_",Año,"_",Mes,".xlsx")
  
  file_names <- c(Balance_Trasmitido,CDT,Tasas_CDTS, Bonos, Preciospip_Cons_T,Preciospip_INT_DVDA_T, Anexo_Obligaciones_Col, Anexo_Obligaciones_Miami, Tasas_Cartera_Pasiva, historico_tasas )
  
  #Directorio local donde deseas guardar los archivos descargados
  local_directory <- "user"
  
  #Eliminar los insumos de la corrida pasada
  unlink(local_directory, recursive = FALSE)
  
  
  # Descargar los archivos por nombre
  for (file_name in file_names) {
    file_to_download <- files[files$name == file_name,]
    if (nrow(file_to_download) > 0) {
      drive_download(file = file_to_download, path = file.path(local_directory, file_name), overwrite = TRUE)
    } else {
      cat("El archivo", file_name, "no se encontró en la carpeta de Google Drive.\n")
    }
  }
  
  #------------------------------------------ Importacion a R 
  #definimos la parte fija --> cambiar en el escritorio de equipo CR -->  ojo con los / 
  input = local_directory
  
  #acordamos la dirección de entrada (input) de los archivos 
  setwd(input)
  
  Balance_Trasmitido <- read_excel(Balance_Trasmitido, 
                                    col_types = c("numeric", "text", "numeric", 
                                                  "numeric", "numeric", "numeric", 
                                                  "numeric", "numeric", "numeric"), 
                                   skip = 10)
  
  #======================= Grupo 1 ================
  CDT <- read_delim(CDT, 
                     delim = "\t", escape_double = FALSE, 
                     col_types = cols(PERIODO = col_date(format = "%d/%m/%Y"), 
                                      SALDOTOTAL = col_number(), PLAZO = col_number(), 
                                      TIPOTASA = col_number(),
                                      FEXPEDICION = col_date(format = "%Y%m%d"), 
                                      FVCTOPLAZO = col_date(format = "%Y%m%d"), 
                                      TASA = col_number(), TASAADICIONAL = col_number(), 
                                      TASAESPECADI = col_number()), trim_ws = TRUE)
  
  Tasas_CDTS <- read_excel(Tasas_CDTS, 
                            sheet = "TASAS PROVEEDOR PIP", col_types = c("date", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric", "numeric", 
                                                                         "numeric", "numeric"))
  
  
  
  #======================= GRUPO 2 =====================
  Bonos <- read_excel(Bonos,col_types = c("numeric", "text", "numeric", "text", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "numeric", "text", "numeric", "text", "date"), skip = 5)
  
  Preciospip_Cons_T <- read_csv(Preciospip_Cons_T, col_types = cols(FECHA = col_date(format = "%Y%m%d"),
                                                                    HORA = col_character(),
                                                                    NEMO = col_character(), 
                                                                    EMISOR = col_character(),
                                                                    SECTOR = col_number(),
                                                                    CODIGO_CFI = col_character(),
                                                                    CODIGO_ISIN = col_character(),
                                                                    PRECIO_SUCIO = col_number()))
  

  Preciospip_INT_DVDA_T <- read_csv(Preciospip_INT_DVDA_T, 
                                    col_types = cols(FECHA = col_date(format = "%Y%m%d"), 
                                                     HORA = col_character(), 
                                                     NEMO = col_character(), 
                                                     EMISOR = col_character(), 
                                                     SECTOR = col_character(), 
                                                     CODIGO_CFI = col_character(), 
                                                     CODIGO_ISIN = col_character(), 
                                                     PRECIO_SUCIO = col_number()))
  
  #======================= GRUPO 3 ==============================
  Anexo_Obligaciones_Col <- read_excel(Anexo_Obligaciones_Col, 
                                        sheet = "Plantilla", col_types = c("numeric", 
                                                                           "text", "numeric", "text", "numeric", 
                                                                           "numeric", "numeric", "text", "numeric", 
                                                                           "numeric", "text", "text", "numeric", 
                                                                           "numeric", "text", "text", "text", "numeric", 
                                                                           "numeric", "text", "numeric", "numeric", 
                                                                           "date", "date", "text", "text", 
                                                                           "date", "date"), skip = 3)
  
  
  Anexo_Obligaciones_Miami <- read_excel(Anexo_Obligaciones_Miami, 
                                          sheet = fecha_completa, col_types = c("text", 
                                                                                "numeric", "numeric", "text", "numeric", 
                                                                                "numeric", "text", "numeric", "date", 
                                                                                "date", "text", "date", "date"),  skip = 7)
  
  historico_tasas <- read_excel(historico_tasas, 
                                 sheet = "Tasas Históricas", col_types = c("date", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric", 
                                                                           "numeric"))
  
  parametros_tasas_pasivas <- read_excel(Tasas_Cartera_Pasiva, sheet = "Tasas_pasivas", col_types = c("text", "text", "numeric"))
  
  #========================================= BALANCE y PARAMETROS =====================
  #Limpiamos Balance
  #Parametrizamos encabezados
  names(Balance_Trasmitido) = c("Cuenta","Descripcion", "Saldo_Inicial","Mov_Debitos","Mov_Creditos", "Neto", "Moneda_Base","Moneda_Extranjera","Moneda_Total")
  Balance_Trasmitido = Balance_Trasmitido[,c(1,9)]
  
  names(parametros_tasas_pasivas) =  c("Nombre", "SOFR", "Working_Capital")
  parametros_tasas_pasivas <- parametros_tasas_pasivas %>%
    mutate(Nombre = toupper(Nombre),
           Nombre = str_replace_all(Nombre,"[ÁÄÀÂ]", "A"),
           Nombre = str_replace_all(Nombre,"[ÉÈÊË]", "E"),
           Nombre = str_replace_all(Nombre,"[ÍÏÌÎ]", "I"),
           Nombre = str_replace_all(Nombre,"[ÓÖÔ]", "O"),
           Nombre = str_replace_all(Nombre,"[ÚÜÙÛ]", "U"),
           Nombre = str_replace_all(Nombre,"[Ñ]", "N"),
           Nombre = str_replace_all(Nombre,"[,]", " "),
           Nombre = str_replace_all(Nombre,"[()]", " "),
           Nombre = str_replace_all(Nombre,"[\\\"]", " "),
           Nombre = str_replace_all(Nombre,"[.]", " "),
           Nombre = str_remove_all(Nombre, " "))
  
  
  #========================================= GRUPO1 CDTS =====================
  #==================== Limpiamos ================
  #Limpiamos CDT
  names(CDT) = c("PERIODO","ESTADO","NUMERO","SALDOTOTAL","PLAZO","TIPOTASA","MODALIDAD","FEXPEDICION","FVCTOPLAZO","SERIE","TIPOIDENT1","TASA","TASAADICIONAL","TASAESPECADI","OFICINA","CLASEPLPAGOREN","PERIODICIDAD") 
  CDT <- CDT %>% mutate(PERIODICIDAD = toupper(PERIODICIDAD),PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÁÄÀÂ]", "A"),PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÉÈÊË]", "E"),PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÍÏÌÎ]", "I"),PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÓÖÔ]", "O"),PERIODICIDAD = str_replace_all(PERIODICIDAD,"[ÚÜÙÛ]", "U"),PERIODICIDAD = str_replace_all(PERIODICIDAD,"[Ñ]", "N"),PERIODICIDAD = str_remove_all(PERIODICIDAD, " "))
  
  #Extraemos el total de valores en CDT para comparar contra el Balance
  Total_CDT = sum(CDT$SALDOTOTAL)
  
  #Como la fecha de corte viene con el primer día cambiamos para que sea el ultimo día 
  CDT$PERIODO = as.Date(fecha_corte,format = "%Y%m%d")
  
  #Hacemos la diferencia de fechas (Fecha de vencimiento - Fecha de corte)
  CDT$PLAZO = CDT$FVCTOPLAZO - CDT$PERIODO
  
  #Filtramos los CDT's mayores o iguales a 360 días por la columna Plazo
  CDT_Mas_360 = filter(CDT, CDT$PLAZO >= 360)
  CDT_Menos_360 = filter(CDT, CDT$PLAZO < 360)
  
  #Totalizamos los valores de las dos tablas anteriores de CDT's
  Total_CDT_Mas_360 = sum(CDT_Mas_360$SALDOTOTAL)
  Total_CDT_Menos_360 = sum(CDT_Menos_360$SALDOTOTAL)
  
  
  #Limpiamos tasas_cdts_2023
  #Dejamos unicamente la fila de la fecha de corte 
  names(Tasas_CDTS) = c("fcorte","IPC_1","IPC_15","IPC_30","IPC_60","IPC_90","IPC_180","IPC_360","IPC_720","IPC_1080","IPC_1800","IPC_3600","IPC_5400","IPC_7200","DTF_1","DTF_15","DTF_30","DTF_60","DTF_90","DTF_180","DTF_360","DTF_720","DTF_1080","DTF_1800","IBR_1","IBR_15","IBR_30","IBR_60","IBR_90","IBR_180","IBR_360","IBR_720","IBR_1080", "IBR_1800","TASA_FIJA_1", "TASA_FIJA_15","TASA_FIJA_30", "TASA_FIJA_60","TASA_FIJA_90", "TASA_FIJA_180","TASA_FIJA_360", "TASA_FIJA_720","TASA_FIJA_1080", "TASA_FIJA_1800","TASA_FIJA_3600")
  Tasas_CDTS = filter(Tasas_CDTS, Tasas_CDTS$fcorte == as.Date(fecha_corte, format = '%Y%m%d'))
  
  #Pasar a numericos los datos de las tasas
  Tasas_CDTS = Tasas_CDTS %>% mutate(across(c(2:45), ~ as.numeric(.)))
  
  #Creamos la tabla con los promedios de tasas
  Corte = c("Menor_o_igual_180", "Mayor_180_menor_o_igual_360", "Mayor_360_menor_o_igual_720", "Mayor_720")
  IPC = c(sum(Tasas_CDTS[1,2:7])/6,  Tasas_CDTS[1,8], Tasas_CDTS[1,9], sum(Tasas_CDTS[1,10:14])/5)
  DTF = c(sum(Tasas_CDTS[1,15:20])/6,  Tasas_CDTS[1,21], Tasas_CDTS[1,22], sum(Tasas_CDTS[1,23:24])/2)
  IBR = c(sum(Tasas_CDTS[1,25:30])/6,  Tasas_CDTS[1,31], Tasas_CDTS[1,32], sum(Tasas_CDTS[1,33:34])/2)
  TASA_FIJA = c(sum(Tasas_CDTS[1,35:40])/6,  Tasas_CDTS[1,41], Tasas_CDTS[1,42], sum(Tasas_CDTS[1,43:45])/3)
  
  Tasas = data.frame(Corte) %>% mutate (IPC = IPC, DTF = DTF, IBR = IBR, TASA_FIJA = TASA_FIJA,
                                        across(c(2:5), ~ as.numeric(.)))
  #==================== Calculos ===================
  #Hacemos el control entre Balance y CDT's
  #Creamos la tabla de resumen del balance
  Descripcion = c('PESOS RENTABILIDAD < 6 M COBIS','PESOS RENTABILIDAD < 180 DÍAS','PESOS RENTABILIDAD 6 A <12 M COBIS','PESOS RENTABILIDAD => 180 < 360 DÍAS ','PESOS RENTABILIDAD 12 A <18 M COBIS','PESOS RENTABILIDAD => 360 < 540 DÍAS ','PESOS RENTABILIDAD > 18 M COBIS','PESOS RENTABILIDAD => 540 DÍAS ','PESOS CAPITALIZABLES < 6 M COBIS','PESOS CAPITALIZABLES < 180 DÍAS','PESOS CAPITALIZABLES 6 A <12 M COBIS','PESOS CAPITALIZABLES => 180 < 359 DÍAS ','PESOS CAPITALIZABLES 12 A <18 M COBIS','PESOS CAPITALIZABLES => 360 < 539 DÍAS ','PESOS CAPITALIZABLES >18 M COBIS','PESOS CAPITALIZABLES => 540 ','IPC CAPITALIZABLES < 180 DÍAS','IPC CAPITALIZABLES => 180 < 359 DÍAS ','IPC CAPITALIZABLES => 360 < 539 DÍAS ','IPC RENTABILIDAD < 180 DÍAS','IPC RENTABILIDAD => 180 < 359 DÍAS ','IPC RENTABILIDAD => 360 < 539 DÍAS ','CDAT  RENT  VIRT.< 6 MESES','CDAT  RENT  VIRT.< 6 M COBIS','CDAT  RENT  VIRT.  6 A 12 MES', 'CDAT RENT VIRT. 6 A 12 M COBIS','CDAT  RENT  VIRT.  12 A 18 MES','CDAT RENT VIRT 12 A18 M COBIS','CDAT  RENT  VIRT.  >  18 MESES','CDAT RENT VIRT. > 18 M COBIS','CDAT  CAPI  VIRT.< 6 MESES','CDAT  CAPI  VIRT.< 6 M COBIS','CDAT  CAPI  VIRT.  6 A 12 MES','CDAT CAPI VIRT. 6 A 12 M COBIS','CDAT  CAPI  VIRT.  12 A 18 MES','CDAT CAPI VIRT 12 A18 M COBIS','CDAT  CAPI  VIRT.  >  18 MESES','CDAT  CAPI  VIRT.  >18 M COBIS')
  Cuenta = c(2107050342,2107050011,2107100311,2107100014,2107150266,2107150019,2107200269,2107200012,2107050359,2107050045,2107100329,2107100022,2107150274,2107150027,2107200277,2107200020,2107050029,2107100030,2107150035,2107050037,2107100048,2107150043,2108151024,2108152063,2108151032,2108152113,2108151040,2108152162,2108151057,2108152212,2108152022,2108152071,2108152030,2108152121,2108152048,2108152170,2108152055,2108152220)
  Control_CDT = data.frame(Descripcion = Descripcion, Cuenta = Cuenta)
  
  #Tomamos las dos columnas que nos interesan del Balance
  Balance_2 = Balance_Trasmitido[,c('Cuenta','Moneda_Total')]
  Control_CDT = merge(Control_CDT, Balance_2, by = 'Cuenta')  #Traemos los saldos a la tabal de control del CDT
  
  #De ta tabla de control_CDT dividimos en los que contablemente son mayores a 360 y menores a 360                    
  Control_CDT_Menos_360 = filter(Control_CDT, Control_CDT$Cuenta == 2107050342 |  Control_CDT$Cuenta == 2107050011 |  Control_CDT$Cuenta == 2107100311 |  Control_CDT$Cuenta == 2107100014 |  Control_CDT$Cuenta == 2107050359 |  Control_CDT$Cuenta == 2107050045 |  Control_CDT$Cuenta == 2107100329 |  Control_CDT$Cuenta == 2107100022 |  Control_CDT$Cuenta == 2107050029 |  Control_CDT$Cuenta == 2107100030 |  Control_CDT$Cuenta == 2107050037 |  Control_CDT$Cuenta == 2107100048 |  Control_CDT$Cuenta == 2108151024 |  Control_CDT$Cuenta == 2108152063 |  Control_CDT$Cuenta == 2108151032 |  Control_CDT$Cuenta == 2108152113 |  Control_CDT$Cuenta == 2108152022 |  Control_CDT$Cuenta == 2108152071 |  Control_CDT$Cuenta == 2108152030 |  Control_CDT$Cuenta == 2108152121)
  Control_CDT_Mas_360= filter(Control_CDT, Control_CDT$Cuenta == 2107150266 | Control_CDT$Cuenta == 2107150019 | Control_CDT$Cuenta == 2107200269 | Control_CDT$Cuenta == 2107200012 | Control_CDT$Cuenta == 2107150274 | Control_CDT$Cuenta == 2107150027 | Control_CDT$Cuenta == 2107200277 | Control_CDT$Cuenta == 2107200020 | Control_CDT$Cuenta == 2107150035 | Control_CDT$Cuenta == 2107150043 | Control_CDT$Cuenta == 2108151040 | Control_CDT$Cuenta == 2108152162 | Control_CDT$Cuenta == 2108151057 | Control_CDT$Cuenta == 2108152212 | Control_CDT$Cuenta == 2108152048 | Control_CDT$Cuenta == 2108152170 | Control_CDT$Cuenta == 2108152055 | Control_CDT$Cuenta == 2108152220 )
  
  #Totalizamos de las dos tablas anteriores
  Control_CDT_Menos_360 = sum(Control_CDT_Menos_360$Moneda_Total)
  Control_CDT_Mas_360 = sum(Control_CDT_Mas_360$Moneda_Total)
  
  #Creamos la tabla resumen comparativa
  registros = c('>= 360', '< 360', 'Total')
  No_Registros = c(nrow(CDT_Mas_360), nrow(CDT_Menos_360) , nrow(CDT_Mas_360) + nrow(CDT_Menos_360))
  Base_CDT = c(Total_CDT_Mas_360, Total_CDT_Menos_360, Total_CDT_Mas_360 + Total_CDT_Menos_360)
  Contabilidad = c(Control_CDT_Mas_360,Control_CDT_Menos_360, Control_CDT_Mas_360 + Control_CDT_Menos_360 )
  Comparativa_CDT_Balance = data.frame(Registros = registros,No_Registros = No_Registros, Base_CDT = Base_CDT, Contabilidad = Contabilidad) %>% mutate(Diferencia = Base_CDT - (Contabilidad*-1))
  
  
  #============= Modelo de valor razonable 
  #Factor
  CDT_Mas_360 = left_join(CDT_Mas_360, parametros_tipo_tasa, by = 'TIPOTASA')
  CDT_Mas_360 = left_join(CDT_Mas_360, parametros_periocidad, by = "PERIODICIDAD")
  
  CDT_Mas_360 = CDT_Mas_360 %>% mutate(DIAS_AL_VTO =  dias360_eeuu(FEXPEDICION, FVCTOPLAZO), 
                                       PLAZO_PTE = dias360_eeuu(PERIODO, FVCTOPLAZO), 
                                       PERIODICIDAD_NUM = ifelse(PERIODICIDAD == 'ALVENCIMIENTO', PLAZO_PTE, PERIODICIDAD_NUM),
                                       PERIODOS_TOTALES = ifelse(PERIODICIDAD == 'ALVENCIMIENTO', 1, DIAS_AL_VTO/PERIODICIDAD_NUM),
                                       PERIODOS_CUMPLIDOS = ifelse(PERIODICIDAD == 'ALVENCIMIENTO',0, (DIAS_AL_VTO - PLAZO_PTE)/PERIODICIDAD_NUM),
                                       PERIODOS_FALTANTES = PLAZO_PTE/PERIODICIDAD_NUM,
                                       PAGO = SALDOTOTAL *((1+CDT_Mas_360$TASA/100) ^ (PERIODICIDAD_NUM/360)-1),
                                       t1 = ifelse(PERIODICIDAD == 'ALVENCIMIENTO', PLAZO_PTE, PLAZO_PTE %% PERIODICIDAD_NUM),
                                       t1_aprox = t_aprox(t1, PLAZO_PTE), 
                                       tm_1 = tm_fun(t1_aprox, FACTOR, Tasas),
                                       VP_1 = vp_fun(t1_aprox,t1, PLAZO_PTE, PAGO, SALDOTOTAL, tm_1),
                                       t2 = t_n_fun(PERIODICIDAD,PERIODICIDAD_NUM, t1 ),
                                       t2_aprox = t_aprox (t2, PLAZO_PTE),
                                       tm_2 = tm_fun(t2_aprox, FACTOR, Tasas),
                                       VP_2 = vp_fun(t2_aprox,t2, PLAZO_PTE, PAGO, SALDOTOTAL, tm_2))
  
  
  # Número de veces que deseas iterar
  num_iteraciones <- 99
  
  # Realiza las iteraciones para creación de columnas
  for (i in 2:(num_iteraciones + 1)) {
    
    # Nombre de las columnas para esta iteración
    col_prefix <- paste0("t", i)
    coo_prefix_1 = paste0("t", i - 1)
    
    CDT_Mas_360 <- CDT_Mas_360 %>%
      mutate(
        !!col_prefix := t_n_fun(CDT_Mas_360$PERIODICIDAD, CDT_Mas_360$PERIODICIDAD_NUM, !!sym(coo_prefix_1)),
        !!paste0(col_prefix, "_aprox") := t_aprox(!!sym(col_prefix), CDT_Mas_360$PLAZO_PTE),
        !!paste0("tm_", i) := tm_fun(!!sym(paste0(col_prefix, "_aprox")), CDT_Mas_360$FACTOR, Tasas),
        !!paste0("VP_", i) := vp_fun(!!sym(paste0(col_prefix, "_aprox")), !!sym(col_prefix), CDT_Mas_360$PLAZO_PTE, CDT_Mas_360$PAGO, CDT_Mas_360$SALDOTOTAL, !!sym(paste0("tm_", i)))
      )
  }
  
  #Calculamos el valor razonable
  num_columnas_vp = 100
  columnas_vp = paste0("VP_", 1:num_columnas_vp)
  CDT_Mas_360$Valor_Razonable = rowSums(CDT_Mas_360[columnas_vp])
  
  Total_Valor_Razonable_CDT = sum(CDT_Mas_360$Valor_Razonable)
  Total_Valor_Razonable_CDT
  
  CDTS_MAYORES = CDT_Mas_360[,c("PERIODO","NUMERO","SALDOTOTAL","PLAZO","FEXPEDICION","FVCTOPLAZO","Valor_Razonable" )]
  names(CDTS_MAYORES) = c(paste0("PERIODO_",index),"NUMERO",paste0("SALDOTOTAL_",index), paste0("PLAZO_",index),paste0("FEXPEDICION_",index),paste0("FVCTOPLAZO_",index),paste0("Valor_Razonable_",index) )
  
  cdts_prueba = CDT_Mas_360

  #========================================= GRUPO2 BONOS ====================
  #==================== Limpiamos ====================
  #Limpiamos los archivos de precios
  Preciospip_Cons_T  = Preciospip_Cons_T [,c("FECHA","HORA","NEMO","EMISOR","SECTOR","CODIGO_CFI","CODIGO_ISIN","PRECIO_SUCIO")]
  Preciospip_INT_DVDA_T = Preciospip_INT_DVDA_T[,c("FECHA","HORA","NEMO","EMISOR","SECTOR","CODIGO_CFI","CODIGO_ISIN","PRECIO_SUCIO")]
  
  #Limpiamos Bonos
  names(Bonos) <- c("Emision_Valor_Nominal", "Isin","Serie", "Plazo","Tasa", "Modalidad","F_Emision","F_Vcto","Nombre", "Identificacion","Vr_Capital_Pesos","Intereses_por_pagar","Vr_Unidades","Modalidad_Pago_Int","Base","Moneda","Fecha_Del_Ultimo_Pago_De_Intereses")

  #Limpiamos Preciospip
  Preciospip_Cons_T = Preciospip_Cons_T[,7:8]
  names(Preciospip_Cons_T) = c('Isin', "Precio_sucio_Cons_t")

  #Limpiamos Preciospip
  Preciospip_INT_DVDA_T = Preciospip_INT_DVDA_T[,7:8]
  names(Preciospip_INT_DVDA_T) = c('Isin', "Precio_sucio_INT_DVDA_T")

  #==================== Calculos ======================
  #Comparativa de Bonos contra balance
  #Totalizamos la columna de bonos sobre "Vr. Capital Pesos"
  Bonos = Bonos[!is.na(Bonos$Isin),]

  Total_bonos = sum(Bonos$Vr_Capital_Pesos)
  Balance_Bonos = filter(Balance_2, Balance_2$Cuenta == 2130120039 | Balance_2$Cuenta == 2130120047 | Balance_2$Cuenta == 2130120120 | Balance_2$Cuenta == 2130120153 | Balance_2$Cuenta == 2130120161 | Balance_2$Cuenta == 2130120203 | Balance_2$Cuenta == 2130130053 | Balance_2$Cuenta == 2130130061 | Balance_2$Cuenta == 2130131044 | Balance_2$Cuenta == 2130131050 | Balance_2$Cuenta == 2130131051 | Balance_2$Cuenta == 2130131060 | Balance_2$Cuenta == 2130131069 | Balance_2$Cuenta == 2130131070)
  Total_balance_bonos = sum(Balance_Bonos$Moneda_Total)
  
  Descripcion = c('Total bonos', 'Total Balance', 'Control')
  Totales = c(abs(Total_bonos), abs(Total_balance_bonos),abs(Total_bonos) - abs(Total_balance_bonos))
  Comparativa_Bonos_Balance = data.frame(Descripcion = Descripcion, Totales = Totales)
  
  #Traemos los precios sumos a bonos
  Bonos = left_join(Bonos, Preciospip_Cons_T, by = 'Isin')
  Bonos = left_join(Bonos, Preciospip_INT_DVDA_T, by = 'Isin')
  
  Bonos = Bonos %>% mutate(Precio_sucio = case_when(is.na(Bonos$Precio_sucio_Cons_t) ~ Bonos$Precio_sucio_INT_DVDA_T, TRUE ~ Bonos$Precio_sucio_Cons_t))
  Bonos = Bonos[!is.na(Bonos$Precio_sucio),]
  Bonos = Bonos %>% mutate(Valoracion_PM_Precio_sucio = (Vr_Capital_Pesos * Precio_sucio)/100 )
  Total_bonos_Valoracion = sum(Bonos$Valoracion_PM_Precio_sucio)
  
  Bonos_prueba = Bonos
  
  Bonos = Bonos[,c("Isin", "Vr_Capital_Pesos", "Precio_sucio", "Valoracion_PM_Precio_sucio")]
  
  
  
  #========================================= GRUPO3 OBLIGACIONES =====================
  # =================== Limpieza ===================
  #Limpiamos NA de Anexo obligaciones 
  names(Anexo_Obligaciones_Col) = c("MONE", "NEGOCIO","NIT","F_INICIO","SALDO_ACT_MDA","SALDO_ACT_USD","SALDO_ORIGINAL","CLIENTE","SDO_ACT_PESOS","RUBRO_DAV","FechaCorte","Tipo_Prestamo", "Cuenta_Gl","Negocio","Nit","Descripcion","Moneda","Valor_Moneda_Origen", "Saldo_Al_Corte_En_Pesos","Nombre","Margen","Tasa_Interes","Fecha_Inicial","Fecha_Final","Modalidad_Vencida_Anticipada","Frecuencia_de_pago_de_intereses","Fecha_ultimo_pago_realizado_Capital","Fecha_pago_de_intereses")                                     
  Anexo_Obligaciones_Col = Anexo_Obligaciones_Col[!is.na(Anexo_Obligaciones_Col$Cuenta_Gl),]
  Anexo_Obligaciones_Col = Anexo_Obligaciones_Col[, c("Tipo_Prestamo", 'Cuenta_Gl', 'Negocio', 'Nit', 'Descripcion','Moneda', 'Valor_Moneda_Origen', 'Saldo_Al_Corte_En_Pesos', 'Nombre', 'Margen', 'Tasa_Interes', "Fecha_Inicial","Fecha_Final",'Modalidad_Vencida_Anticipada', 'Frecuencia_de_pago_de_intereses', "Fecha_pago_de_intereses")]
  Anexo_Obligaciones_Col$Negocio =as.character(Anexo_Obligaciones_Col$Negocio)
  
  names(Anexo_Obligaciones_Miami) = c("Tipo_Prestamo","Cuenta_Gl","Negocio","Nit","Valor_Moneda_Origen","Saldo_Al_Corte_En_Pesos","Nombre","Tasa_Interes","Fecha_Inicial","Fecha_Final","Modalidad_Vencida_Anticipada","Frecuencia_de_pago_de_intereses","Fecha_pago_de_intereses")
  Anexo_Obligaciones_Miami = Anexo_Obligaciones_Miami[!is.na(Anexo_Obligaciones_Miami$Tipo_Prestamo),]
  Anexo_Obligaciones_Miami = Anexo_Obligaciones_Miami %>% mutate(Descripcion = 'Mm Prest Ot Entidad Finra Ctra', Moneda = 'USD',Margen  = 0, Modalidad = 'Vencida')
  Anexo_Obligaciones_Miami = Anexo_Obligaciones_Miami[ , c("Tipo_Prestamo", 'Cuenta_Gl', 'Negocio', 'Nit', 'Descripcion','Moneda', 'Valor_Moneda_Origen', 'Saldo_Al_Corte_En_Pesos', 'Nombre', 'Margen', 'Tasa_Interes', "Fecha_Inicial","Fecha_Final",'Modalidad_Vencida_Anticipada', 'Frecuencia_de_pago_de_intereses', "Fecha_pago_de_intereses")]
  Anexo_Obligaciones_Miami$Negocio =as.character(Anexo_Obligaciones_Miami$Negocio)
  
  #Juntamos Obligaciones de Col y de Miami 
  Obligaciones = rbind(Anexo_Obligaciones_Col, Anexo_Obligaciones_Miami)
  Obligaciones$Fecha_Final = as.Date(Obligaciones$Fecha_Final, format = '%Y%m%d')
  Obligaciones$Fecha_pago_de_intereses = as.Date(Obligaciones$Fecha_pago_de_intereses, format = '%Y%m%d')
  
  #Limpiamos Historico tasas 
  names(historico_tasas) =c("Fecha","TIBR","IBR_Overnight","IBR_1M","IBR_3M","IBR_6M","IBR_12M","DTF","Indice","IPC_Anual","IPC_Mensual","FED","UVR","%UVR","IBC","USURA","TRM","DEV_TRM","LIBOR_3M","LIBOR_6M","SOFR","SOFR_1M","SOFR_3M","SOFR_6M","SOFR_1Y","LEMPIRA/USD","DEV_LEMPIRA","COLON/USD","DEV_COLON")   
  historico_tasas = historico_tasas[!is.na(historico_tasas$Fecha),]
  
  
  #Extraemos para hacer el condicional 
  historico_tasas$fecha_caracter = as.character.Date(historico_tasas$Fecha)
  
  historico_tasas = historico_tasas %>% mutate(
    año = substr(historico_tasas$fecha_caracter, start = 1, stop = 4), 
    mes = substr(historico_tasas$fecha_caracter, start = 6, stop = 7))
  
  #Filtramos para traer solo el mes 
  historico_tasas = filter(historico_tasas, historico_tasas$año == Año & historico_tasas$mes == Mes)
  
  #Calculamos los promedios 
  promedio_SOFR = mean(historico_tasas$SOFR)
  promedio_SOFR_1M = mean(historico_tasas$SOFR_1M)
  promedio_SOFR_3M = mean(historico_tasas$SOFR_3M)
  promedio_SOFR_6M = mean(historico_tasas$SOFR_6M)
  promedio_SOFR_1Y = mean(historico_tasas$SOFR_1Y)
  
  
  Obligaciones <- Obligaciones %>%
    mutate(Nombre = toupper(Nombre),
           Nombre = str_remove_all(Nombre, " "),
           Nombre = str_replace_all(Nombre,"[ÁÄÀÂ]", "A"),
           Nombre = str_replace_all(Nombre,"[ÉÈÊË]", "E"),
           Nombre = str_replace_all(Nombre,"[ÍÏÌÎ]", "I"),
           Nombre = str_replace_all(Nombre,"[ÓÖÔ]", "O"),
           Nombre = str_replace_all(Nombre,"[ÚÜÙÛ]", "U"),
           Nombre = str_replace_all(Nombre,"[Ñ]", "N"),
           Nombre = str_replace_all(Nombre,"[,]", " "),
           Nombre = str_replace_all(Nombre,"[()]", " "),
           Nombre = str_replace_all(Nombre,"[\\\"]", " "),
           Nombre = str_replace_all(Nombre,"[.]", " "),
           Nombre = str_remove_all(Nombre, " "),
           Tasa_Interes = Tasa_Interes/100)
  
  
  # =================== Calculos ==================== 
  #Comparativa de Obligaciones contra balance
  Balance_Obligaciones = filter(Balance_2, Balance_2$Cuenta == 2440350003 | Balance_2$Cuenta ==2440350011 |  Balance_2$Cuenta ==2440350052 |  Balance_2$Cuenta ==2440358022 | Balance_2$Cuenta ==2440358030 | Balance_2$Cuenta ==2440400006 |  Balance_2$Cuenta ==2440400055 |  Balance_2$Cuenta ==2440450019 | Balance_2$Cuenta ==2440450035 |  Balance_2$Cuenta ==2440450076 | Balance_2$Cuenta ==2440500003 )
  Total_Obligaciones =  sum(Obligaciones$Saldo_Al_Corte_En_Pesos)
  Total_balance_Obligaciones = sum(Balance_Obligaciones$Moneda_Total)
  
  Descripcion = c('Total Obligaciones', 'Total Balance', 'Control')
  Totales = c(Total_Obligaciones, Total_balance_Obligaciones, Total_Obligaciones - (-1* Total_balance_Obligaciones))
  Comparativa_Obligaciones_Balance = data.frame(Descripcion = Descripcion, Totales = Totales)
  
  #Obligaciones
  Obligaciones$Dias = Obligaciones$Fecha_Final - as.Date(fecha_corte, format = '%Y%m%d') 
  Obligaciones$Frecuencia_de_pago_de_intereses = case_when(is.na(Obligaciones$Frecuencia_de_pago_de_intereses) ~ Obligaciones$Modalidad_Vencida_Anticipada,
                                                           TRUE ~ Obligaciones$Frecuencia_de_pago_de_intereses)
  
  Obligaciones_mayor_360 = filter(Obligaciones, Obligaciones$Dias >= 360)
  Obligaciones_menor_360 = filter(Obligaciones, Obligaciones$Dias < 360)
  
  Total_Obligaciones_mas_360 = sum(Obligaciones_mayor_360$Saldo_Al_Corte_En_Pesos)
  
  #Hacemos la segunda tabla de control 
  Descripcion = c('>= 360', '< 360', 'Total')
  No_registros = c(nrow(Obligaciones_mayor_360), nrow(Obligaciones_menor_360), nrow(Obligaciones_mayor_360) + nrow(Obligaciones_menor_360))
  Totales = c(Total_Obligaciones_mas_360, sum(Obligaciones_menor_360$Saldo_Al_Corte_En_Pesos), Total_Obligaciones_mas_360 + sum(Obligaciones_menor_360$Saldo_Al_Corte_En_Pesos))
  Control_Obligaciones = data.frame(Descripcion = Descripcion,No_registros = No_registros, Totales = Totales)
  
  
  #================== Sobre las de mayor a 360 calculamos valor razonable
  Obligaciones_mayor_360 = left_join(Obligaciones_mayor_360, parametros_tasas_pasivas, by = 'Nombre')
  
  Obligaciones_mayor_360 <- Obligaciones_mayor_360 %>%
    mutate(SOFR_TASA = case_when(SOFR == 'SOFR' ~ promedio_SOFR,
                                 SOFR == 'SOFR30' ~ promedio_SOFR_1M,
                                 SOFR == 'SOFR90' ~ promedio_SOFR_3M,
                                 SOFR == 'SOFR180' ~ promedio_SOFR_6M,
                                 SOFR == 'SOFR360' ~ promedio_SOFR_1Y,
                                 TRUE ~ 0),
           Tasa_de_Mercado = SOFR_TASA + Working_Capital, 
           Frecuencia_de_pago_de_intereses_2 = case_when(Frecuencia_de_pago_de_intereses == 'MENSUAL' | Frecuencia_de_pago_de_intereses == 'mensual' | Frecuencia_de_pago_de_intereses == 'Mensual' ~ 'MV',
                                                         Frecuencia_de_pago_de_intereses == 'BIMENSUAL' | Frecuencia_de_pago_de_intereses == 'Bimensual' | Frecuencia_de_pago_de_intereses == 'bimensual' ~ 'BV',
                                                         Frecuencia_de_pago_de_intereses == 'TRIMESTRAL' | Frecuencia_de_pago_de_intereses == 'Trimestral'| Frecuencia_de_pago_de_intereses == 'trimestral' ~ 'TV',
                                                         Frecuencia_de_pago_de_intereses == 'CUATRIMESTRAL' | Frecuencia_de_pago_de_intereses == 'Cuatrimestral'| Frecuencia_de_pago_de_intereses == 'cuatrimestral' ~ 'CV',
                                                         Frecuencia_de_pago_de_intereses == 'SEMESTRAL' | Frecuencia_de_pago_de_intereses == 'semestral' | Frecuencia_de_pago_de_intereses == 'Semestral' | Frecuencia_de_pago_de_intereses == 'ANUAL' | Frecuencia_de_pago_de_intereses == 'anual'| Frecuencia_de_pago_de_intereses == 'Anual' ~ 'SV',
                                                         TRUE ~ 'Error'),
           Fecha_pago_1 = fecha_pago_fun(Fecha_pago_de_intereses, Frecuencia_de_pago_de_intereses_2, Fecha_Final), 
           intereses_1 = interes_fun(Tasa_Interes, Fecha_pago_1, Fecha_pago_de_intereses))
  
  # Número de veces que deseas iterar
  num_iteraciones <- 119
  # Realiza las iteraciones para creación de columnas
  for (i in 2:(num_iteraciones + 1)) {
    
    # Nombre de las columnas para esta iteración
    col_prefix <- paste0("Fecha_pago_", i)
    coo_prefix_1 = paste0("Fecha_pago_", i - 1)
    coo_prefix_2 = paste0("intereses_", i)
    
    Obligaciones_mayor_360 <- Obligaciones_mayor_360 %>%
      mutate(
        !!col_prefix := fecha_pago_fun_n( !!sym(coo_prefix_1), Frecuencia_de_pago_de_intereses_2, Fecha_Final),
        !!coo_prefix_2 := interes_fun(Tasa_Interes, !!sym(col_prefix), !!sym(coo_prefix_1)))
  }
  
  #Creamos la columna Couta_120 que estara en cero para que empiece hacia atras el calculo de las coutas
  Obligaciones_mayor_360 = Obligaciones_mayor_360 %>% mutate(
    Couta_120 =0,
    fecha_corte_Obligaciones = as.Date(fecha_corte,format = "%Y%m%d"))
  
  # Número de veces que deseas iterar - Bucle a la inversa
  num_iteraciones <- 2
  for (i in 120:(num_iteraciones - 1)) {
    
    # Nombre de las columnas para esta iteración
    col_prefix <- paste0("Couta_", i)
    coo_prefix_1 = paste0("Fecha_pago_", i)
    coo_prefix_2 = paste0("Couta_", i+1)
    coo_prefix_3 = paste0("intereses_", i)
    
    Obligaciones_mayor_360 <- Obligaciones_mayor_360 %>%
      mutate(!!col_prefix := couta_fun_n( !!sym(coo_prefix_1), !!sym(coo_prefix_2), !!sym(coo_prefix_3), Saldo_Al_Corte_En_Pesos ))
  }
  
  # Número de veces que deseas iterar
  num_iteraciones <- 119
  # Realiza las iteraciones para creación de columnas
  for (i in 1:(num_iteraciones + 1)) {
    
    # Nombre de las columnas para esta iteración
    col_prefix <- paste0("VNP_", i)
    coo_prefix_1 = paste0("Fecha_pago_", i)
    coo_prefix_2 = paste0("Couta_", i)
    
    Obligaciones_mayor_360 <- Obligaciones_mayor_360 %>%
      mutate(!!col_prefix := VPN_fun(!!sym(coo_prefix_1), Fecha_Final, !!sym(coo_prefix_2), Tasa_de_Mercado, fecha_corte_Obligaciones))
  }
  
  #Creamos el Valor Presente Neto
  #Calculamos el valor razonable
  num_columnas_vpn = 120
  columnas_vpn = paste0("VNP_", 1:num_columnas_vp)
  Obligaciones_mayor_360$Valor_Presente_Neto = rowSums(Obligaciones_mayor_360[columnas_vpn])
  
  Total_Valor_Presente_Neto_Obligaciones = sum(Obligaciones_mayor_360$Valor_Presente_Neto)
  Total_Valor_Presente_Neto_Obligaciones
  
  Comparativo_obligaciones = Obligaciones_mayor_360[,c("Negocio","Valor_Moneda_Origen", "Saldo_Al_Corte_En_Pesos", "Nombre","Tasa_Interes", "Tasa_de_Mercado",  "Valor_Presente_Neto", "Fecha_Inicial", "Fecha_Final")]
  #Comparativo_obligaciones = Comparativo_obligaciones %>% mutate(Negocio = as.character(Negocio), 
  #                                                             across(c(2:3,5:7), ~ as.numeric(.)), 
  #                                                             across(c(4), ~ as.character(.)))
  #                                                              
  
  
  
  Obligaciones_pruebas =  Obligaciones_mayor_360 
  
  #========================================= Resumen ================
  #Creamos la tabla resumen 
  Pasivos_Financieros = c('Bonos', "CDT's", 'Obligaciones')
  Saldo_en_libros = c(Total_bonos, Total_CDT_Mas_360, Total_Obligaciones_mas_360)
  Valor_Razonable = c(Total_bonos_Valoracion, Total_Valor_Razonable_CDT, Total_Valor_Presente_Neto_Obligaciones)
  Resumen = data.frame(Pasivos_Financieros = Pasivos_Financieros, Saldo_en_libros = Saldo_en_libros, Valor_Razonable = Valor_Razonable) %>% mutate(Variación = (Valor_Razonable - Saldo_en_libros)/Saldo_en_libros)
  
  
  #==================== Importación de resumenes al R ===========
  # Generar un nombre de variable con un índice
  index <- index
  var_name_1 <- paste("Resumen_", index, sep = "")
  var_name_2 <- paste("CDT_Vs_Balance_", index, sep = "")
  var_name_3 <- paste("Obligaciones_VS_Balance_", index, sep = "")
  var_name_4 <- paste("Control_Obligaciones_", index, sep = "")
  var_name_5 <- paste("Comparativo_obligaciones_", index, sep = "")
  var_name_6 <- paste("Bonos_Vs_Balance_", index, sep = "")
  var_name_7 <- paste("Bonos_", index, sep = "")
  var_name_8 <- paste("CDTS_", index, sep = "")
  
  var_name_9 <- paste("Bonos_Pruebas_", index, sep = "")
  var_name_10 <- paste("Obligaciones_Prueas_", index, sep = "")
  var_name_11 <- paste("CDTS_Pruebas_", index, sep = "")
  var_name_12 <- paste("CDTS_Totales_", index, sep = "")
  
  
  # Asignar la data al entorno global con el nombre dinámico
  assign(var_name_1, Resumen, envir = .GlobalEnv)
  assign(var_name_2, Comparativa_CDT_Balance, envir = .GlobalEnv)
  assign(var_name_3, Comparativa_Obligaciones_Balance, envir = .GlobalEnv)
  assign(var_name_4, Control_Obligaciones, envir = .GlobalEnv)
  assign(var_name_5, Comparativo_obligaciones, envir = .GlobalEnv)
  assign(var_name_6, Comparativa_Bonos_Balance, envir = .GlobalEnv)
  assign(var_name_7, Bonos, envir = .GlobalEnv)
  assign(var_name_8, CDTS_MAYORES, envir = .GlobalEnv)
  
  assign(var_name_9,Bonos_prueba, envir = .GlobalEnv)
  assign(var_name_10,Obligaciones_pruebas, envir = .GlobalEnv)
  assign(var_name_11,cdts_prueba, envir = .GlobalEnv)
  assign(var_name_12, CDT,envir = .GlobalEnv)
  
}

Funcion_Valor_Razonable(folder_id_1,1,año1,mes1,dia1)
Funcion_Valor_Razonable(folder_id_2,2,año2,mes2,dia2)
Funcion_Valor_Razonable(folder_id_3,3,año3,mes3,dia3)

#Limpiamos la carpeta para que no ocupe mucho espacio
local_directory <- "user"

#Eliminar los insumos de la corrida pasada
unlink(local_directory, recursive = TRUE)


# ======================================== fechas y titulos ======================= 
#Para la exportación y diferentes operaciones realizamos la combinaciones necesarias.  
mes1 = case_when(mes1 == 1 | mes1 == 2 | mes1 == 3 | mes1 == 4 | mes1 == 5 | mes1 == 6 | mes1 == 7 | mes1 == 8 | mes1 == 9 ~ paste0("0",mes1),TRUE ~ mes1)
fecha_de_corte_1 = paste0(año1,mes1,dia1)
titulo_1 = paste(fecha_de_corte_1, "- Actual")

mes2 = case_when(mes2 == 1 | mes2 == 2 | mes2 == 3 | mes2 == 4 | mes2 == 5 | mes2 == 6 | mes2 == 7 | mes2 == 8 | mes2 == 9 ~ paste0("0",mes2),TRUE ~ mes2)
fecha_de_corte_2 = paste0(año2,mes2,dia2)
titulo_2 = paste(fecha_de_corte_2, "- Trimestral")

mes3 = case_when(mes3 == 1 | mes3 == 2 | mes3 == 3 | mes3 == 4 | mes3 == 5 | mes3 == 6 | mes3 == 7 | mes3 == 8 | mes3 == 9 ~ paste0("0",mes3),TRUE ~ mes3)
fecha_de_corte_3 = paste0(año3,mes3,dia3)
titulo_3 = paste(fecha_de_corte_3, "- anual")

Mensaje_1 = "* La estimación de Valor Razonable de CDTs y Obligaciones Financieras tienen vencimiento mayor a 1 año, para la información menor a un año su Valor Razonable corresponde a su valor en libros."
variacion = "Variación Anual"
variacion_2 = "Variación Trimestral"

Obligaciones_titulo_1 = "Valor Moneda Origen"
Obligaciones_titulo_2 = "Tasa de Interés"
Obligaciones_titulo_3 = "Diferencia Moneda Origen"
Obligaciones_titulo_4 = "Diferencia Tasa Interés"

Obligaciones_titulo_5 = "Diferencia en pesos"
Obligaciones_titulo_6 = "Valor en pesos"
Obligaciones_titulo_7 = "Diferencia Tasa de mercado"
Obligaciones_titulo_8 = "Diferencia VPN"
Obligaciones_titulo_9 = "VPN"
Obligaciones_titulo_10 = "Tasa de mercado"

Obligaciones_titulo_11 = "Fecha Inicial"
Obligaciones_titulo_12 = "Fecha Final"
Obligaciones_titulo_13 = "Dif fecha inicial"
Obligaciones_titulo_14 = "Dif fecha final"


#======================================= Resumen variaciones ======================
#Hacemos las variaciones anuales y trimestrales
Resumen_1 = Resumen_1 %>% mutate(across(c(2:4), ~ ifelse(is.na(.),0,.)))
Resumen_2 = Resumen_2 %>% mutate(across(c(2:4), ~ ifelse(is.na(.),0,.)))
Resumen_3 = Resumen_3 %>% mutate(across(c(2:4), ~ ifelse(is.na(.),0,.)))

Variacion_anual = Resumen_1 %>% mutate(Saldo_en_libros = Resumen_1$Saldo_en_libros - Resumen_3$Saldo_en_libros,
                                       Valor_Razonable = Resumen_1$Valor_Razonable - Resumen_3$Valor_Razonable,
                                       Variación = Resumen_1$Variación - Resumen_3$Variación)

Variacion_trimestral = Resumen_1 %>% mutate(Saldo_en_libros = Resumen_1$Saldo_en_libros - Resumen_2$Saldo_en_libros,
                                            Valor_Razonable = Resumen_1$Valor_Razonable - Resumen_2$Valor_Razonable,
                                            Variación = Resumen_1$Variación - Resumen_2$Variación)


#============================ Obligaciones comparativa =====================
Dif_moneda_tasas_actual = Comparativo_obligaciones_1[,c("Negocio", "Nombre",  "Valor_Moneda_Origen", "Tasa_Interes")] 
names(Dif_moneda_tasas_actual) = c("Negocio", "Nombre","MO_actual", "TI_actual")
Dif_moneda_tasas_anterior = Comparativo_obligaciones_2[,c("Negocio","Valor_Moneda_Origen", "Tasa_Interes")]
names(Dif_moneda_tasas_anterior) = c("Negocio", "MO_anterior", "TI_anterior")

#Juntamos las difrencias monedas para hacer comparativa 
Dif_moneda_tasas_final = full_join(Dif_moneda_tasas_actual, Dif_moneda_tasas_anterior, by = "Negocio") 
Dif_moneda_tasas_final = Dif_moneda_tasas_final %>% mutate(across(c(3:6), ~ ifelse(is.na(.), 0, .)),
         dif_MO = MO_actual - MO_anterior, 
         dif_TI = TI_actual - TI_anterior)

Dif_moneda_tasas_final = Dif_moneda_tasas_final[,c("Negocio","Nombre","MO_actual","MO_anterior","TI_actual","TI_anterior","dif_MO","dif_TI")] 



#Diferencia saldos
Dif_Obligaciones_Saldos_Act = Comparativo_obligaciones_1[,c("Negocio", "Nombre",  "Valor_Moneda_Origen","Saldo_Al_Corte_En_Pesos")] 
names(Dif_Obligaciones_Saldos_Act) = c("Negocio", "Nombre","MO_actual", "Pesos_actual")
Dif_Obligaciones_Saldos_Ant = Comparativo_obligaciones_2[,c("Negocio","Valor_Moneda_Origen","Saldo_Al_Corte_En_Pesos")]
names(Dif_Obligaciones_Saldos_Ant) = c("Negocio", "MO_anterior", "Pesos_anterior")

#Juntamos las difrencias monedas para hacer comparativa 
Dif_saldos_final = full_join(Dif_Obligaciones_Saldos_Act, Dif_Obligaciones_Saldos_Ant, by = "Negocio") 
Dif_saldos_final = Dif_saldos_final %>% mutate(across(c(3:6), ~ ifelse(is.na(.), 0, .)),
                                                           dif_MO = MO_actual - MO_anterior, 
                                                           dif_Pesos = Pesos_actual - Pesos_anterior)

Dif_saldos_final = Dif_saldos_final[,c("Negocio","Nombre","MO_actual","MO_anterior","Pesos_actual","Pesos_anterior","dif_MO","dif_Pesos")] 


#Diferencia VPN y TM
Dif_Obligaciones_VPN_Act = Comparativo_obligaciones_1[,c("Negocio", "Nombre", "Valor_Presente_Neto", "Tasa_de_Mercado"  )] 
names(Dif_Obligaciones_VPN_Act) = c("Negocio", "Nombre","VPN_actual", "TM_actual")
Dif_Obligaciones_VPN_Ant = Comparativo_obligaciones_2[,c("Negocio","Valor_Presente_Neto", "Tasa_de_Mercado")]
names(Dif_Obligaciones_VPN_Ant) = c("Negocio", "VPN_anterior", "TM_anterior")


#Juntamos las difrencias monedas para hacer comparativa 
Dif_VPN_final = full_join(Dif_Obligaciones_VPN_Act, Dif_Obligaciones_VPN_Ant, by = "Negocio") 
Dif_VPN_final = Dif_VPN_final %>% mutate(across(c(3:6), ~ ifelse(is.na(.), 0, .)),
                                               dif_VPN = VPN_actual - VPN_anterior, 
                                               dif_TM = TM_actual - TM_anterior)

Dif_VPN_final = Dif_VPN_final[,c("Negocio","Nombre","VPN_actual","VPN_anterior","TM_actual","TM_anterior","dif_VPN","dif_TM")] 


#Diferencia fechas
Dif_Obligaciones_fechas_Act = Comparativo_obligaciones_1[,c("Negocio", "Nombre", "Fecha_Inicial", "Fecha_Final")] 
names(Dif_Obligaciones_fechas_Act) = c("Negocio", "Nombre","fecha_inicial_actual", "fecha_final_actual")
Dif_Obligaciones_fechas_Ant = Comparativo_obligaciones_2[,c("Negocio","Fecha_Inicial", "Fecha_Final")]
names(Dif_Obligaciones_fechas_Ant) = c("Negocio", "fecha_inicial_anterior", "fecha_final_anterior")


#Juntamos las difrencias monedas para hacer comparativa 
Dif_fecha_final = full_join(Dif_Obligaciones_fechas_Act, Dif_Obligaciones_fechas_Ant, by = "Negocio") 
Dif_fecha_final$fecha_inicial_actual = paste0(substr(Dif_fecha_final$fecha_inicial_actual,1,4), "/", substr(Dif_fecha_final$fecha_inicial_actual,6,7),"/",substr(Dif_fecha_final$fecha_inicial_actual,9,10))
Dif_fecha_final$fecha_inicial_anterior = paste0(substr(Dif_fecha_final$fecha_inicial_anterior,1,4), "/", substr(Dif_fecha_final$fecha_inicial_anterior,6,7),"/",substr(Dif_fecha_final$fecha_inicial_anterior,9,10))
Dif_fecha_final$fecha_final_actual = paste0(substr(Dif_fecha_final$fecha_final_actual,1,4), "/", substr(Dif_fecha_final$fecha_final_actual,6,7),"/",substr(Dif_fecha_final$fecha_final_actual,9,10))
Dif_fecha_final$fecha_final_anterior = paste0(substr(Dif_fecha_final$fecha_final_anterior,1,4), "/", substr(Dif_fecha_final$fecha_final_anterior,6,7),"/",substr(Dif_fecha_final$fecha_final_anterior,9,10))

Dif_fecha_final = Dif_fecha_final %>% mutate(across(c(3:6), ~ ifelse(is.na(.), 0, .)),
                                        dif_fecha_inicial = fecha_inicial_actual == fecha_inicial_anterior, 
                                        dif_fecha_final = fecha_final_actual == fecha_final_anterior)

Dif_fecha_final = Dif_fecha_final[,c("Negocio","Nombre","fecha_inicial_actual","fecha_inicial_anterior","fecha_final_actual","fecha_final_anterior","dif_fecha_inicial","dif_fecha_final")] 


#=============================== Bonos ========================================
bonos_precio_sucio = Bonos_1[,c("Isin","Precio_sucio" )]
names(bonos_precio_sucio) = c("Isin","Precio_sucio_Act")
bonos_precio_sucio_2 = Bonos_2[,c("Isin","Precio_sucio" )]
names(bonos_precio_sucio_2) = c("Isin","Precio_sucio_Ant")
dif_bonos_precio_sucio = full_join(bonos_precio_sucio, bonos_precio_sucio_2, by = c("Isin")) %>% mutate(Precio_sucio_Act = ifelse(is.na(Precio_sucio_Act),0, Precio_sucio_Act),
                                                                                                        Precio_sucio_Ant = ifelse(is.na(Precio_sucio_Ant),0, Precio_sucio_Ant),
                                                                                                        dif_moneda = Precio_sucio_Act - Precio_sucio_Ant,
                                                                                                        dif_absoluta = ifelse(is.na(Precio_sucio_Act),0, dif_moneda / Precio_sucio_Act))

bonos_vr_pesos = Bonos_1[,c("Isin","Vr_Capital_Pesos" )]
names(bonos_vr_pesos) = c("Isin","Vr_Capital_Pesos_Act")
bonos_vr_pesos_2 = Bonos_2[,c("Isin","Vr_Capital_Pesos" )]
names(bonos_vr_pesos_2) = c("Isin","Vr_Capital_Pesos_Ant")
dif_bonos_vr_pesos = full_join(bonos_vr_pesos, bonos_vr_pesos_2, by = c("Isin")) %>% mutate(Diferencia = Vr_Capital_Pesos_Act - Vr_Capital_Pesos_Ant)


bonos_PM = Bonos_1[,c("Isin","Valoracion_PM_Precio_sucio" )]
names(bonos_PM) = c("Isin","Vr_PM_Act")
bonos_PM_2 = Bonos_2[,c("Isin","Valoracion_PM_Precio_sucio" )]
names(bonos_PM_2) = c("Isin","Vr_PM_Ant")
dif_bonos_pm = full_join(bonos_PM, bonos_PM_2, by = c("Isin")) %>% mutate(Diferencia = Vr_PM_Act - Vr_PM_Ant)


#=============================== CDTS ===================
CDTS_Totales_1  = CDTS_Totales_1[,c("PERIODO",  "NUMERO",  "SALDOTOTAL",  "PLAZO", "FEXPEDICION", "FVCTOPLAZO")] 
names(CDTS_Totales_1) = c("PERIODO_1","NUMERO","SALDOTOTAL_1","PLAZO_1","FEXPEDICION_1","FVCTOPLAZO_1")
CDTS_2 = CDTS_2 %>% select(- Valor_Razonable_2)
CDTS_PACTUAL_PANTERIOR = full_join(CDTS_Totales_1, CDTS_2, by = "NUMERO")

CDTS_PACTUAL_PANTERIOR = CDTS_PACTUAL_PANTERIOR[,c("NUMERO","PERIODO_1", "PERIODO_2", "FEXPEDICION_1" , "FEXPEDICION_2", "FVCTOPLAZO_1", "FVCTOPLAZO_2","PLAZO_1","PLAZO_2", "SALDOTOTAL_1", "SALDOTOTAL_2")]

CDTS_NUEVOS = filter(CDTS_PACTUAL_PANTERIOR, is.na(CDTS_PACTUAL_PANTERIOR$PERIODO_2) & as.numeric(CDTS_PACTUAL_PANTERIOR$PLAZO_1) >= 360)
CDTS_CANCELADOS = filter(CDTS_PACTUAL_PANTERIOR, is.na(CDTS_PACTUAL_PANTERIOR$PERIODO_1)  & as.numeric(CDTS_PACTUAL_PANTERIOR$PLAZO_2) >= 360)

CDTS_CAMBIO_360 = anti_join(CDTS_PACTUAL_PANTERIOR,CDTS_NUEVOS)
CDTS_CAMBIO_360 = anti_join(CDTS_CAMBIO_360,CDTS_CANCELADOS)
CDTS_CAMBIO_360 = filter(CDTS_CAMBIO_360, CDTS_CAMBIO_360$PLAZO_1 < 360 &  CDTS_CAMBIO_360$PLAZO_2 >= 360 )


SALDO_TOTAL = c(Resumen_2[2,2], sum(CDTS_NUEVOS$SALDOTOTAL_1), sum(CDTS_CANCELADOS$SALDOTOTAL_2), sum(CDTS_CAMBIO_360$SALDOTOTAL_1),  Resumen_2[2,2] + sum(CDTS_NUEVOS$SALDOTOTAL_1) +  (-1* sum(CDTS_CANCELADOS$SALDOTOTAL_2)) + (-1* sum(CDTS_CAMBIO_360$SALDOTOTAL_1)) )
concepto = c("Saldo Inicial", "CDTS Nuevos (+)", "CDTS Cancelados (-)", "CDTS cambio de 360 (-)", "Total")
RESUMEN_CDTS = data.frame(concepto = concepto, SALDO_TOTAL = SALDO_TOTAL)

#=============================== Graficas =============================
Grafica_R1 = data.frame(Fecha = c(as.Date(fecha_de_corte_1, format =  "%Y%m%d"),  
                                  as.Date(fecha_de_corte_2, format =  "%Y%m%d"),
                                  as.Date(fecha_de_corte_3, format =  "%Y%m%d")), 
                        Bonos_Saldo_Libros = c(Resumen_1[1,2], Resumen_2[1,2], Resumen_2[1,2]), 
                        Bonos_Valor_Razonable =  c(Resumen_1[1,3], Resumen_2[1,3], Resumen_2[1,3]), 
                        CDTS_Saldo_Libros = c(Resumen_1[2,2], Resumen_2[2,2], Resumen_2[2,2]),
                        CDTS_Valor_Razonable = c(Resumen_1[2,3], Resumen_2[2,3], Resumen_2[2,3]), 
                        Obligaciones_Saldo_Libros = c(Resumen_1[3,2], Resumen_2[3,2], Resumen_2[3,2]),
                        Obligaciones_Valor_Razonable = c(Resumen_1[3,3], Resumen_2[3,3], Resumen_2[3,3])
                        )

# Reshape los datos para ggplot2
grafica_1_long <- tidyr::gather(Grafica_R1, key = "Tipo_Pasivo", value = "valor", -Fecha)

colores = c("Bonos_Saldo_Libros" = "#CDC0B0", "Bonos_Valor_Razonable" = "#EEDFCC",
            "CDTS_Saldo_Libros" = "#66CDAA", "CDTS_Valor_Razonable" = "#76EEC6",
            "Obligaciones_Saldo_Libros" = "#CDC673", "Obligaciones_Valor_Razonable" = "#EEE685"
            )

# Grafico de barras
grafica = ggplot(grafica_1_long, aes(x = Fecha, y = valor, fill = Tipo_Pasivo)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_date(breaks = grafica_1_long$Fecha, date_labels = "%Y-%m-%d")+ 
  scale_fill_manual(values = colores) +
  labs(title = "Saldo en libros VS Valor Razonable",
       x = "Fecha",
       y = "Valor") +
  theme_minimal() +
  theme(panel.grid = element_blank()) #eliminar cuadricula



#============================ Salidas ===========================
#Creamos el libro
wb = createWorkbook()

#Agregamos una hoja al libro
addWorksheet(wb, "Resumen")
addWorksheet(wb, "Control_CDT_vs_Balance")
addWorksheet(wb, "Control_Bonos_vs_Balance")
addWorksheet(wb, "Bonos_Variación_PSucio")
addWorksheet(wb, "Bonos_Variación_Saldo_en_libros")
addWorksheet(wb, "Bonos_Variación_Vr_Razonable")
addWorksheet(wb, "Control_Obligaciones_vs_Balance")
addWorksheet(wb, "Obligaciones_Dif_fechas")
addWorksheet(wb, "Obligaciones_Dif_MO_TI")
addWorksheet(wb, "Obligaciones_Var_Saldo_libros")
addWorksheet(wb, "Obligaciones_Var_Vr_Razonable")
addWorksheet(wb, "Resumen_CDTS")
addWorksheet(wb, "Conciliación_CDTS")
addWorksheet(wb, "CDTS_Cancelaciones")
addWorksheet(wb, "CDTS_Cambio_360")
addWorksheet(wb, "Grafica")

png("grafico1.png", width = 800, height = 600, units = "px")
print(grafica)
dev.off()

insertImage(wb, sheet = "Grafica", "grafico1.png", width = 6, height = 4)

#=============================== Resumen ========================
#Anual
writeData(wb, sheet = "Resumen", x = titulo_1, startCol = 1, startRow = 1)
writeData(wb, sheet = "Resumen", x = Resumen_1, startCol = 1, startRow = 2)

writeData(wb, sheet = "Resumen", x = titulo_3, startCol = 6, startRow = 1)
writeData(wb, sheet = "Resumen", x = Resumen_3, startCol = 6, startRow = 2)

writeData(wb, sheet = "Resumen", x = variacion, startCol = 11, startRow = 1)
writeData(wb, sheet = "Resumen", x = Variacion_anual, startCol = 11, startRow = 2)

writeData(wb, sheet = "Resumen", x = Mensaje_1, startCol = 1, startRow = 8)


#Trimestral
writeData(wb, sheet = "Resumen", x = titulo_2, startCol = 6, startRow = 10)
writeData(wb, sheet = "Resumen", x = Resumen_2, startCol = 6, startRow = 11)

writeData(wb, sheet = "Resumen", x = variacion_2, startCol = 11, startRow = 10)
writeData(wb, sheet = "Resumen", x = Variacion_trimestral, startCol = 11, startRow = 11)

writeData(wb, sheet = "Resumen", x = Mensaje_1, startCol = 1, startRow = 17)


#Prueba formato 
addStyle(wb,  sheet = "Resumen", rows = 1, cols = c(1:4, 6:9), style = createStyle(textDecoration = "bold", fgFill = "#EE8262", fontSize = 12, halign = "center"))
addStyle(wb,  sheet = "Resumen", rows = 2, cols = 1:4, style = createStyle(textDecoration = "bold"))
addStyle(wb,  sheet = "Resumen", rows = 3:5, cols = 1, style = createStyle(textDecoration = "bold"))
#addStyle(wb,  sheet = "Resumen", rows = 2:5, cols = 1:4, style = createStyle (border = c("top", "bottom", "left", "right"), borderColour = "black"))
mergeCells(wb,  sheet = "Resumen", cols = 1:4, rows = 1)


#=============================== CDT VS Balance ========================
writeData(wb, sheet = "Control_CDT_vs_Balance", x = titulo_1, startCol = 1, startRow = 1)
writeData(wb, sheet = "Control_CDT_vs_Balance", x = CDT_Vs_Balance_1, startCol = 1, startRow = 2)

writeData(wb, sheet = "Control_CDT_vs_Balance", x = titulo_2, startCol = 7, startRow = 1)
writeData(wb, sheet = "Control_CDT_vs_Balance", x = CDT_Vs_Balance_2, startCol = 7, startRow = 2)

#=============================== Bonos VS Balance ========================
writeData(wb, sheet = "Control_Bonos_vs_Balance", x = titulo_1, startCol = 1, startRow = 1)
writeData(wb, sheet = "Control_Bonos_vs_Balance", x = Bonos_Vs_Balance_1, startCol = 1, startRow = 2)

writeData(wb, sheet = "Bonos_Variación_PSucio", x = dif_bonos_precio_sucio, startCol = 1, startRow = 1)
writeData(wb, sheet = "Bonos_Variación_Saldo_en_libros", x = dif_bonos_vr_pesos, startCol = 1, startRow = 1)
writeData(wb, sheet = "Bonos_Variación_Vr_Razonable", x = dif_bonos_pm, startCol = 1, startRow = 1)

#=============================== Control obligaciones ========================
writeData(wb, sheet = "Control_Obligaciones_vs_Balance", x = titulo_1, startCol = 1, startRow = 1)
writeData(wb, sheet = "Control_Obligaciones_vs_Balance", x = Obligaciones_VS_Balance_1, startCol = 1, startRow = 2)
writeData(wb, sheet = "Control_Obligaciones_vs_Balance", x = Control_Obligaciones_1, startCol = 4, startRow = 2)


writeData(wb, sheet = "Obligaciones_Dif_MO_TI", x = Obligaciones_titulo_1, startCol = 3, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_MO_TI", x = Obligaciones_titulo_2, startCol = 5, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_MO_TI", x = Obligaciones_titulo_3, startCol = 7, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_MO_TI", x = Obligaciones_titulo_4, startCol = 8, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_MO_TI", x = Dif_moneda_tasas_final, startCol = 1, startRow = 2)

writeData(wb, sheet = "Obligaciones_Var_Saldo_libros", x = Obligaciones_titulo_1, startCol = 3, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Saldo_libros", x = Obligaciones_titulo_6, startCol = 5, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Saldo_libros", x = Obligaciones_titulo_3, startCol = 7, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Saldo_libros", x = Obligaciones_titulo_5, startCol = 8, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Saldo_libros", x = Dif_saldos_final, startCol = 1, startRow = 2)

writeData(wb, sheet = "Obligaciones_Var_Vr_Razonable", x = Obligaciones_titulo_9, startCol = 3, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Vr_Razonable", x = Obligaciones_titulo_10, startCol = 5, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Vr_Razonable", x = Obligaciones_titulo_8, startCol = 7, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Vr_Razonable", x = Obligaciones_titulo_7, startCol = 8, startRow = 1)
writeData(wb, sheet = "Obligaciones_Var_Vr_Razonable", x = Dif_VPN_final, startCol = 1, startRow = 2)

writeData(wb, sheet = "Obligaciones_Dif_fechas", x = Obligaciones_titulo_11, startCol = 3, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_fechas", x = Obligaciones_titulo_12, startCol = 5, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_fechas", x = Obligaciones_titulo_13, startCol = 7, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_fechas", x = Obligaciones_titulo_14, startCol = 8, startRow = 1)
writeData(wb, sheet = "Obligaciones_Dif_fechas", x = Dif_fecha_final, startCol = 1, startRow = 2)

#=============================== Control CDTS ========================
writeData(wb, sheet = "Resumen_CDTS", x = titulo_1, startCol = 1, startRow = 1)
writeData(wb, sheet = "Resumen_CDTS", x = RESUMEN_CDTS, startCol = 1, startRow = 2)

writeData(wb, sheet = "Conciliación_CDTS", x = CDTS_NUEVOS, startCol = 1, startRow = 1)
writeData(wb, sheet = "CDTS_Cancelaciones", x = CDTS_CANCELADOS, startCol = 1, startRow = 1)
writeData(wb, sheet = "CDTS_Cambio_360", x = CDTS_CAMBIO_360, startCol = 1, startRow = 1)



#Guardamos el libro
saveWorkbook(wb, 'Salidas.xlsx', overwrite = TRUE)

#Enviamos a la carpeta drive 
drive_upload("user/Salidas.xlsx", path = as_id(folder_id_1), name = "Salidas.xlsx")










#=================== Pruebas ========================
setwd(local_directory)
write.xlsx(Bonos_Pruebas_1, "BONOS_R_1.xlsx")
write.xlsx(Bonos_Pruebas_2, "BONOS_R_2.xlsx")
write.xlsx(Bonos_Pruebas_3, "BONOS_R_3.xlsx")

write.xlsx(CDTS_Pruebas_1, "CDTS_R_1.xlsx")
write.xlsx(CDTS_Pruebas_2, "CDTS_R_2.xlsx")
write.xlsx(CDTS_Pruebas_3, "CDTS_R_3.xlsx")

write.xlsx(Obligaciones_Prueas_1, "OBLIGACIONES_R_1.xlsx")
write.xlsx(Obligaciones_Prueas_2, "OBLIGACIONES_R_2.xlsx")
write.xlsx(Obligaciones_Prueas_3, "OBLIGACIONES_R_3.xlsx")



