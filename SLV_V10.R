#======================================================== Datos modificables 
dia = "31"
mes = "08"
año = "2023"

#Coloque la tasa de cambio (usando punto (.) como separador decimal)
tasa_de_cambio = 4099.20

# ==================================== F351 =================================
# ==================================== Librerias 
#instalación de paquetes una unica vez
#install.packages(c("gargle","FRACTION","dplyr","tidyverse","stringr","lubridate","tidyr","openxlsx","readxl","shiny","miniUI","timechange","taskscheduleR","openxlsx","writexl"))

#abrimos las librerias 
library(gargle)
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

#Para que los datos no esten en anotación cientifica
options(scipen=999)

# ==================================== Definicion de carpeta
#parte variable 
carpeta= Sys.getenv("HOME")

#cambiamos los diagonales
carpeta = gsub("\\\\", "/", carpeta)    

#definimos la parte fija --> cambiar en el escritorio de equipo CR -->  ojo con los / 
input = paste(carpeta, "/F351/ENTRADA", sep = "") 
output = paste(carpeta, "/F351/SALIDA", sep = "")
parametros = paste(carpeta, "/F351/PARAMETROS", sep = "")

# ==================================== importacion de archivos 
#acordamos la dirección de entrada (input) de los archivos 
setwd(input)

participativas_precio <- read_excel("participativas.xlsx", sheet = "participativas_precio_x_accion", col_types = c("text", "numeric", "text", "text", "date", "date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric", "numeric"), skip = 2)
participativas_normal  <- read_excel("participativas.xlsx", sheet = "participativas_normal", col_types = c("text", "numeric", "text", "date", "date", "text", "numeric", "numeric", "text", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "text", "numeric"), skip = 2)
Calif_Deterioro <- read_excel("Calif_Deterioro.xlsx", sheet = "Calificaciones", col_types = c("text", "text","text", "text",          "text",  "text",                           "text",            "date",              "text",                   "date",                     "text",         "date",           "text",            "date",              "text",                  "date",                         "text",      "date",          "text",           "date",           "text",                  "date",                    "text",                "date",                "numeric",             "numeric",                    "numeric", "date", "date", "date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "date", "date", "date", "date", "date",                                                                                                                                                                                                                            "date",               "numeric",             "text", "numeric", "text", "text", "text", "text", "text", "text", "text", "numeric", "text", "text"), skip = 4)
Calif_Deterioro_Pais <- read_excel("Calif_Deterioro.xlsx", sheet = "Calificacion País", col_types = c("text", "text", "date", "text", "date", "text", "date", "numeric", "numeric", "numeric", "date", "date", "date", "numeric", "text", "text", "numeric", "numeric", "text", "numeric", "text", "text"), skip = 5)
reportos <- read_excel("reportos.xlsx", col_types = c("text","numeric", "numeric", "text","numeric"))

New_PL <- read_excel("New_PL.xlsm", sheet = "Database", col_types = c("text", "numeric", "text", "numeric", "numeric", "date", "date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "numeric")) 
New_PL_setup <- read_excel("New_PL.xlsm", sheet = "Setup", range = "J5:Q500", col_types = c("text", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric"))
PIP <- read_excel("PIP.xlsx", sheet = "PIP", col_types = c("text", "text", "text", "text", "numeric", "numeric", "text", "text", "text",  "text", "numeric", "text", "text", "text", "numeric", "text", "numeric", "numeric"))
InversionesNuevasTV <- read_excel("InversionesNuevasTV.xlsx",  col_types = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
prospecto <- read_excel("prospecto.xlsx",  col_types = c("numeric","text", "date", "numeric", "date", "text"))
Plano_integrado <- read_excel("Plano_integrado.xlsx",  sheet = "Renta Fija", col_types = c("text", "text", "text", "text", "text", "text", "text", "text", "numeric", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "date", "date", "date", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "numeric"))
Plano_Portafolio <- read_excel("Plano_Portafolio.xlsx", col_types = c("text", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "text", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
Stage <- read_excel("Stage.xlsx", sheet = "CAM", skip = 4)

#--------------------------------------------------- Parametros
#acordamos la dirección de entrada (parametro) de los archivos 
setwd(parametros)
homologado <- read_excel("homologado.xlsx", col_types = c("text", "text", "text", "text", "text", "text", "text", "text", "text"))
parametros_pais <- read_excel("parametros.xlsx", sheet = "pais", col_types = c("numeric", "text"))
parametros_emisor <- read_excel("parametros.xlsx", sheet = "emisor", col_types = c("text", "text","text"))
parametros_moneda <- read_excel("parametros.xlsx", sheet = "monedas", col_types = c("text", "text","text"))
parametros_118_sin_stage <- read_excel("parametros.xlsx", sheet = "118_sin_stage", col_types = c("text", "numeric", "numeric","numeric"))
parametros_118_con_stage_corpo <- read_excel("parametros.xlsx", sheet = "118_con_stage_corpo", col_types = c("text", "numeric", "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
parametros_118_con_stage_sobe <- read_excel("parametros.xlsx", sheet = "118_con_stage_sobe", col_types = c("text", "numeric", "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
parametros_CalificacionSeparado <- read_excel("parametros.xlsx", sheet = "CalificacionSeparado", col_types = c("numeric", "text", "text"))
parametros_calificacionesConsolidado <- read_excel("parametros.xlsx", sheet = "calificacionesConsolidado", col_types = c("text", "text", "text"))
parametros_calificacionTitulo = read_excel("parametros.xlsx", sheet = "calificacionTitulo", col_types = c("numeric", "text", "text","text","text","text","text","text","text","text"))
parametros_Riesgo_de_credito = read_excel("parametros.xlsx", sheet = "Riesgo_de_credito", col_types = c("text", "numeric"))

#=================================== Limpiamos las datas 
#----------------------------------- fecha de corte 
fechaCorte = as.Date(str_remove_all (paste(dia,"/",mes,"/",año)," ") ,format= "%d/%m/%Y")

#----------------- Participativas
#Participativas ---- Precio 
names(participativas_precio) = c("c75", "DealID", "c2", "c9", "c12_date", "c15_date", "ValorAccion", "c17", "c19", "c20", "c22", "c32", "c46", "c64", "c65")

#Agregamos las columnas de fechas en el formato DDMMAAAA
participativas_precio <- participativas_precio %>%
  mutate(c12_date = as.Date(c12_date),
         c12 = format(c12_date, "%d%m%Y"),
         c15_date = as.Date(c15_date),
         c15 = format(c15_date, "%d%m%Y"))

participativas_precio <- participativas_precio %>%
  mutate(c75 = toupper(c75),
         c75 = str_replace_all(c75,"[ÁÄÀÂ]", "A"),
         c75 = str_replace_all(c75,"[ÉÈÊË]", "E"),
         c75 = str_replace_all(c75,"[ÍÏÌÎ]", "I"),
         c75 = str_replace_all(c75,"[ÓÖÔ]", "O"),
         c75 = str_replace_all(c75,"[ÚÜÙÛ]", "U"),
         c75 = str_replace_all(c75,"[Ñ]", "N"))


#Participativas ---- Normal
names(participativas_normal) = c("c75", "DealID", "c2", "c12_date", "c15_date", "Cuenta_contable", "ValorAccion", "c17", "Cuenta2", "Saldo2", "Cuenta3", "Saldo3", "c19", "c20", "c22", "c32", "c46", "c64", "c65")

#Agregamos las columnas de fechas en el formato DDMMAAAA
participativas_normal <- participativas_normal %>%
  mutate(c12_date = as.Date(c12_date),
         c12 = format(c12_date, "%d%m%Y"),
         c15_date = as.Date(c15_date),
         c15 = format(c15_date, "%d%m%Y")) %>% 
  select(-c(ValorAccion,Cuenta2,Saldo2,Cuenta3,Saldo3))


participativas_normal <- participativas_normal %>%
  mutate(c75 = toupper(c75),
         c75 = str_replace_all(c75,"[ÁÄÀÂ]", "A"),
         c75 = str_replace_all(c75,"[ÉÈÊË]", "E"),
         c75 = str_replace_all(c75,"[ÍÏÌÎ]", "I"),
         c75 = str_replace_all(c75,"[ÓÖÔ]", "O"),
         c75 = str_replace_all(c75,"[ÚÜÙÛ]", "U"),
         c75 = str_replace_all(c75,"[Ñ]", "N"))


#---------------------------------------- NEw_pl 
#----------------------------------- New_PL_DATABASE 
New_PL = New_PL[-c(1:9),-c(3,4,8,9,11,12,15:20)] 

#Encabezados
names(New_PL) = c("Cuenta_contable", "DealID", "c33",	"c15_date",	"c13_date",	"c32", "c17", "c40")				

#Reorganización para mantener la logica anterior con el cambio de la columna
New_PL = New_PL [,c("Cuenta_contable", "DealID", "c17",	"c33",	"c15_date",	"c13_date",	"c32", "c40")	]			

# Creamos una columa con los primeros datos del "Cuenta contable" y las fechas
New_PL = New_PL %>% 
  mutate(cuenta = substr(Cuenta_contable, 1, 4),
         c15 = format(c15_date, "%d%m%Y"),
         c13 = format(c13_date, "%d%m%Y"),
         c15_date = as.Date(c15_date, format ="%d/%m/%Y"),
         c13_date = as.Date(c13_date, format ="%d/%m/%Y"))

#Hacemos la separación de los difernetes tipos de inversion
New_PL_DataBase_vencimiento = filter(New_PL, New_PL$cuenta == "1131") 
New_PL_DataBase_disponible = filter(New_PL, New_PL$cuenta == "1132")
New_PL_DataBase_depositos = filter(New_PL, New_PL$cuenta == "1110")

#----------------------------------- New_PL_seput
New_PL_setup = New_PL_setup[,c(2,8)]
names(New_PL_setup) = c("DealID","c22")   

#----------------------------------- prospecto
names(prospecto) = c("DealID", "ISIN", "c12_date", "c18", "c42_date","c87")
prospecto = prospecto %>% 
  mutate(c12 = format(c12_date, "%d%m%Y"),
         c42 = format(c42_date, "%d%m%Y"),
         c12_date = as.Date(c12_date, format ="%d/%m/%Y"),
         c42_date = as.Date(c42_date, format ="%d/%m/%Y"))

#----------------------------------- PIP
PIP = PIP[,c(3,4,11,13,15,16,18)]
names(PIP) = c("c56", "c97","c25","c27_1","c26_1","c75","DealID")

#c26 = Colocamos las variables categoricas 360 = 1 ; 365 = 2 y 366 = 3
PIP$c26 = case_when(PIP$c26_1 == 360 ~ 1, PIP$c26_1 == 365 ~ 2, PIP$c26_1 == 366 ~ 3, TRUE ~ PIP$c26_1) 

#c27 = Columna 27 varibles categoricas
PIP$c27 = case_when(PIP$c27_1 == "M" | PIP$c27_1 == "m" ~ 1, PIP$c27_1 == "B" | PIP$c27_1 == "b"~ 2,PIP$c27_1 == "T" | PIP$c27_1 == "t"~ 3,PIP$c27_1 == "C" | PIP$c27_1 == "c"~ 4,PIP$c27_1 == "S" | PIP$c27_1 == "s"~ 5,PIP$c27_1 == "A" | PIP$c27_1 == "a"~ 6,PIP$c27_1 == "P" | PIP$c27_1 == "p"~ 7,PIP$c27_1 == "D" | PIP$c27_1 == "d"~ 8,TRUE ~ 9)    

#limpiamos el nombre del emisor
PIP$c75 <-  toupper(PIP$c75)

#Remplazamos caracteres especiales 
PIP <- PIP %>%
  mutate(c75 = str_replace_all(c75,"[ÁÄÀÂ]", "A"),
         c75 = str_replace_all(c75,"[ÉÈÊË]", "E"),
         c75 = str_replace_all(c75,"[ÍÏÌÎ]", "I"),
         c75 = str_replace_all(c75,"[ÓÖÔ]", "O"),
         c75 = str_replace_all(c75,"[ÚÜÙÛ]", "U"),
         c75 = str_replace_all(c75,"[Ñ]", "N"))


#---------------------------------- InversionesNuevasTV 
InversionesNuevasTV = InversionesNuevasTV[,c(2,10)]
names(InversionesNuevasTV) = c("DealID", "c37") 

#---------------------------------- Plano integrado 
Plano_integrado = Plano_integrado[,c(3,4,9,18)]
names(Plano_integrado) = c("c83_1","c85","DealID","c92")

Plano_integrado$c83 = case_when(
  Plano_integrado$c83_1 == "Reserva de Liquidez Interna" | Plano_integrado$c83_1 == "Excedentes de Liquidez" | Plano_integrado$c83_1 == "Portafolio Mínimo" | Plano_integrado$c83_1 == "Portafolio Mínimo Tramo I" | Plano_integrado$c83_1 == "Portafolio Mínimo Tramo II" ~ "Estructural - Reserva de Liquidez Interna Estratégica",
  Plano_integrado$c83_1 == "Requerimiento 3% Activos Líquidos" |  Plano_integrado$c83_1 == "Encaje" ~ "Estructural - Reserva de Liquidez Regulatoria Estratégica",
  Plano_integrado$c83_1 == "Gestión Balance"  ~ "Estructural - Gestión Balance",
  TRUE ~ paste("Estructural -", Plano_integrado$c83_1))


#---------------------------------- Plano Portafolio
Plano_Portafolio = Plano_Portafolio[,c(4,16)]
names(Plano_Portafolio) = c("DealID","c107")


#----------------------------------------- Calif_deterioro
#----------------------------------------- calif_deterioro calificaciones
Calif_Deterioro = Calif_Deterioro[,c(1,4:7,9,11,48:50)]                 
names(Calif_Deterioro)    =   c("c76", "PaisEmisor" ,"c101", "CalificaciónPaísFinalDelEmisor", "Inter_cal_MOODYS","Inter_cal_FITCH_RATINGS", "Inter_cal_SyP", "c106", "c105","c103")  

#Pasamos a mayusculas el pais y las calificaciones, y quitamos los espacios de las calificaciones
Calif_Deterioro <- Calif_Deterioro %>% 
  mutate(across(c(2,4:8,10), ~ toupper(.) ),
         across(c(4:8,10), ~ str_remove_all(.," ")))

#Remplazamos caracteres especiales 
Calif_Deterioro <- Calif_Deterioro %>%
  mutate(PaisEmisor = str_replace_all(PaisEmisor,"[ÁÄÀÂ]", "A"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÉÈÊË]", "E"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÍÏÌÎ]", "I"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÓÖÔ]", "O"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÚÜÙÛ]", "U"),
         PaisEmisor = str_replace_all(PaisEmisor,"[Ñ]", "N"))

#----------------------------------------- calif_deterioro pais
Calif_Deterioro_Pais = Calif_Deterioro_Pais[,c(1,2,4,6)]
names(Calif_Deterioro_Pais) = c("PaisEmisor", "P_Calif_moodys", "P_calif_ficht", "P_calif_SyP")

#Pasamos a mayuscula el país y quitamos los espacios de las calificaciones
Calif_Deterioro_Pais <- Calif_Deterioro_Pais %>% 
  mutate(across(c(1:4), ~ toupper(.) ),
         across(c(2:4), ~ str_remove_all(.," ")))

##Remplazamos caracteres especiales 
Calif_Deterioro_Pais <- Calif_Deterioro_Pais %>%
  mutate(PaisEmisor = str_replace_all(PaisEmisor,"[ÁÄÀÂ]", "A"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÉÈÊË]", "E"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÍÏÌÎ]", "I"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÓÖÔ]", "O"),
         PaisEmisor = str_replace_all(PaisEmisor,"[ÚÜÙÛ]", "U"),
         PaisEmisor = str_replace_all(PaisEmisor,"[Ñ]", "N"))

#Por si no llega a estar una calificación de la inversión se pone del país 
Calif_Deterioro_Pais$c50_opcion4 <- 
  ifelse(Calif_Deterioro_Pais$P_calif_ficht != "0" , 4,
         ifelse(Calif_Deterioro_Pais$P_calif_SyP != "0" ,3,
                ifelse(Calif_Deterioro_Pais$P_Calif_moodys != "0" ,5,
                       NA_integer_ )))

#Unimos la calificación de la inversión con la calificación país 
Calif_Deterioro = left_join(Calif_Deterioro, Calif_Deterioro_Pais, by = "PaisEmisor")


#------------------- REPORTOS
names(reportos) = c ("Cuenta_contable","DealID", "Monto", "TipoValor","c72")


#------------------ Stage
#limpiamos y que solo quede numerico
Stage$DealID = as.numeric(gsub("CAM084-", "", Stage$...2))

#seleccionamos las ultimas 2 columnas que seran el que contiene la información de las noches y el dealID
Stage1 <- Stage[, (ncol(Stage)-1):ncol(Stage)]
names(Stage1) = c("noches","DealID")
Stage1$noches = as.numeric(Stage1$noches)

#================== Parametros 
names(homologado) = c("Cuenta_contable","Descripcion","c2","DescripcionCUIF","c9","TipoValor","c24","c90","c91")   
names(parametros_pais) = c("c74", "c97")
names(parametros_emisor) = c("c76", "c75", "c98")
names(parametros_118_sin_stage) = c("c106", "SOBERANOS", "CORPORATIVOS", "DAVIVIENDA")
names(parametros_118_con_stage_corpo)= c("c106","corpo_1_365","corpo_366_730", "corpo_731_1095", "corpo_1096_1460", "corpo_1461_1825", "corpo_1826_2190", "corpo_2191_2555","corpo_2556_2920", "corpo_2921_3285", "corpo_3286_3650", "corpo_3651_4015","corpo_4016_4380", "corpo_4381_4745", "corpo_4746_5110", "corpo_5111_5475","corpo_5476_5840", "corpo_5841_6205", "corpo_6206_6570", "corpo_6571_6935","corpo_6936_+"  )  
names(parametros_118_con_stage_sobe) = c("c106","sobe_1_365", "sobe_366_730", "sobe_731_1095", "sobe_1096_1460", "sobe_1461_1825", "sobe_1826_2190", "sobe_2191_2555","sobe_2556_2920", "sobe_2921_3285", "sobe_3286_+")  
names(parametros_CalificacionSeparado) = c("c49", "c124", "c125")

names(parametros_calificacionesConsolidado) = c("c106","c126","c127")
parametros_calificacionesConsolidado <- parametros_calificacionesConsolidado %>% 
  mutate(across(c(1,2), ~ toupper(.))) %>% 
  mutate(across(c(1,2), ~ str_remove_all(.," ")))

parametros_calificacionTitulo = parametros_calificacionTitulo[,c(1,5:7)]
names(parametros_calificacionTitulo) = c("c49","S&P","Fitch","Moodys")
#Pasamos las calificaciones a mayuscula y luego quitamos los espacios
parametros_calificacionTitulo <- parametros_calificacionTitulo %>% 
  mutate(across(c(2:4), ~ toupper(.))) %>% 
  mutate(across(c(2:4), ~ str_remove_all(.," ")))

parametros_118_con_stage_corpo <- parametros_118_con_stage_corpo %>% 
  mutate(across(c(1), ~ toupper(.))) %>% 
  mutate(across(c(1), ~ str_remove_all(.," ")))

parametros_118_con_stage_sobe <- parametros_118_con_stage_sobe %>% 
  mutate(across(c(1), ~ toupper(.))) %>% 
  mutate(across(c(1), ~ str_remove_all(.," ")))

names(parametros_Riesgo_de_credito) = c("c101", "c102") 

parametros_emisor <- parametros_emisor %>%
  mutate(c75 = str_replace_all(c75,"[ÁÄÀÂ]", "A"),
         c75 = str_replace_all(c75,"[ÉÈÊË]", "E"),
         c75 = str_replace_all(c75,"[ÍÏÌÎ]", "I"),
         c75 = str_replace_all(c75,"[ÓÖÔ]", "O"),
         c75 = str_replace_all(c75,"[ÚÜÙÛ]", "U"),
         c75 = str_replace_all(c75,"[Ñ]", "N"))


#===================================== Titulos participativos =========================
# Verificar si hay observaciones en el data frame
if (nrow(participativas_precio) > 0) {
  
  #Merge para traer la c24, c90 y la c91 
  Formato_351_participativas_p = merge(participativas_precio, homologado, by = c("c2", "c9"))
  
  #columna 76 y c98
  Formato_351_participativas_p = left_join(Formato_351_participativas_p, parametros_emisor, by = "c75")
  
  #Columna 101, 105,103, 106
  Formato_351_participativas_p =left_join(Formato_351_participativas_p, Calif_Deterioro, by = "c76")
  
  #creamos la columna 1 
  Formato_351_participativas_p$c1 = str_remove_all( paste("CAM084-",Formato_351_participativas_p$DealID)," ")
  
  #columna 102
  Formato_351_participativas_p = left_join(Formato_351_participativas_p, parametros_Riesgo_de_credito, by = "c101")
  
  #Creamos las columnas fijas
  Formato_351_participativas_p <- Formato_351_participativas_p %>% 
    mutate(c3 = 3,
           c4 = " ",
           c5 = " ", 
           c6 = " ", 
           c7 = " ", 
           c8 = " ", 
           c10 = " ", 
           c11 = 1,
           c13 = " ", 
           c14 = " ", 
           c16 = "USD",
           c18 = 1,
           c21 = 1,
           c24 = " ",
           c25 = " ",
           c26 = " ",
           c27 = " ",
           c28 = " ",
           c29 = " ",
           c33 = " ",
           c34 = " ",
           c35 = " ",
           c36 = " ",
           c37 = " ",
           c38 = " ",
           c39 = " ",
           c40 = " ",
           c41 = 20,
           c42 = " ",
           c43 = " ",
           c44 = " ",
           c45 = " ",
           c47 = " ",
           c48 = " ",
           c51 = " ",
           c52 = " ",
           c53 = " ",
           c54 = " ",
           c55 = 3,
           c56 = " ",
           c57 = " ",
           c58 = " ",
           c59 = " ",
           c60 = " ",
           c61 = " ",
           c62 = " ",
           c63 = " ",
           c66 = " ",
           c67 = " ", 
           c68 = 3,
           c69 = " ",
           c70 = " ",
           c71 = " ",
           c72 = " ",
           c73 = " ",
           c74 = 222,
           c77 = " ",
           c78 = " ",
           c79 = " ",
           c80 = 5,
           c81 = "Banco Davivienda Salvadoreño",
           c82 = "El Salvador",
           c83 = "Estructural - Instrumentos de Patrimonio",
           c84 = "No aplica",
           c85 = "Disponible para la venta",
           c86 = "Instrumentos de Patrimonio",
           c87 = "No aplica",
           c88 = "Disponible para la venta",
           c89 = "Valor Razonable cambios en ORI",
           c92 = " ",
           c93 = " ",
           c94 = " ",
           c95 = "No aplica",
           c96 = " ",
           c97 = "El Salvador",
           c98 = "Corporativo en el Exterior",
           c99 = "Entidades del Sector Real",
           c100 = "Corporativo",
           c104 = " ",
           c106.1= " ",
           c106.2= " ",
           c106.3= " ",
           c106.4= " ",
           c107 = " ",
           c108 = " ",
           c109 = " ",
           c110 = " ",
           c111 = " ",
           c112 = " ",
           c117 = " ",
           c118 = " ",
           c119 = " ",
           c120 = " ",
           c121 = " ",
           c122 = " ",
           c123 = " ",
           c128 = "Dólar Americano",
           c129 = "Moneda Extranjera",
           c130 = " ",
           c131 = str_remove_all(paste(dia,mes,año)," " ))
  
  
  #Columnas formuladas
  Formato_351_participativas_p <- Formato_351_participativas_p %>% 
    mutate(c22 = c17, 
           c23 = tasa_de_cambio * c22,
           c32 = c22,
           c30 = tasa_de_cambio * c32,
           c31 = c30,
           c113 = c30,
           c115 = c30,
           c116 = c30,
           c132 = c116 - c30,
           c133 = c116)
  
  #Columna 114 
  Formato_351_participativas_p$c114 = case_when(
    (Formato_351_participativas_p$c85 == "Al Vencimiento" | Formato_351_participativas_p$c85 == "Al vencimiento") ~ as.character(Formato_351_participativas_p$c30),
    (Formato_351_participativas_p$c85 == "Al Vencimiento" | Formato_351_participativas_p$c85 == "Al vencimiento")& is.na(Formato_351_participativas_p$c30) ~ "Inválido",
    TRUE ~ "No aplica")
  
  #Asigna numero a calificación país
  #Columna 50
  Formato_351_participativas_p$c50 <- 
    ifelse(Formato_351_participativas_p$Inter_cal_FITCH_RATINGS != "0" , 4,
           ifelse(Formato_351_participativas_p$Inter_cal_SyP != "0" ,3,
                  ifelse(Formato_351_participativas_p$Inter_cal_MOODYS != "0" ,5,
                         ifelse(Formato_351_participativas_p$CalificaciónPaísFinalDelEmisor != "0" , Formato_351_participativas_p$c50_opcion4, NA_integer_)))) 
  
  #Hacer una columna que guarde la calificación para la columna 49
  Formato_351_participativas_p$calificacion = case_when(Formato_351_participativas_p$c50 == 4 ~ ifelse(Formato_351_participativas_p$Inter_cal_FITCH_RATINGS != "0", Formato_351_participativas_p$Inter_cal_FITCH_RATINGS, 
                                                                                                       ifelse(Formato_351_participativas_p$P_calif_ficht != "0", Formato_351_participativas_p$P_calif_ficht, 'Error' )) , 
                                                        Formato_351_participativas_p$c50 == 3 ~ ifelse(Formato_351_participativas_p$Inter_cal_SyP != "0", Formato_351_participativas_p$Inter_cal_SyP, 
                                                                                                       ifelse(Formato_351_participativas_p$Inter_cal_SyP != "0", Formato_351_participativas_p$P_calif_SyP ,'Error')) ,
                                                        Formato_351_participativas_p$c50 == 5 ~ ifelse(Formato_351_participativas_p$Inter_cal_MOODYS != "0", Formato_351_participativas_p$Inter_cal_MOODYS, 
                                                                                                       ifelse(Formato_351_participativas_p$P_Calif_moodys != "0", Formato_351_participativas_p$P_Calif_moodys,'Error') ),
                                                        TRUE ~ 'Error 1')
  
  #Columna 49 calificación en letra a su homolgación en numero 
  Formato_351_participativas_p$c49 = case_when(
  (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 | Formato_351_participativas_p$c50 == 5) & Formato_351_participativas_p$calificacion == "AAA" ~ 20,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "AA+")  | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "AA1") ~ 21,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "AA")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "AA2") ~ 22,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "AA-")  | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "AA3") ~ 23,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "A+")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "A1")  ~ 24,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "A")    | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "A2")  ~ 25,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "A-")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "A3")  ~ 26,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "BBB+") | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "BAA1") ~ 27,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "BBB")  | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "BAA2") ~ 28,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "BBB-") | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "BAA3") ~ 29,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "BB+")  | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "BA1")  ~ 30,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "BB")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "BA2")  ~ 31,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "BB-")  | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "BA3")  ~ 32,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "B+")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "B1")   ~ 33,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "B")    | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "B2")   ~ 34,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "B-")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "B3")   ~ 35,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "CCC+") | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "CAA1") ~ 36,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "CCC")  | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "CAA2") ~ 37,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "CCC-") | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "CAA3") ~ 38,
  ( (Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 )  & Formato_351_participativas_p$calificacion == "CC")   | (Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "CA")   ~ 39,
  ( Formato_351_participativas_p$c50 == 4 | Formato_351_participativas_p$c50 == 3 | Formato_351_participativas_p$c50 == 5) & Formato_351_participativas_p$calificacion == "C" ~ 40,
   Formato_351_participativas_p$c50 == 4 & Formato_351_participativas_p$calificacion == "DDD"  ~ 41,
   Formato_351_participativas_p$c50 == 4 & Formato_351_participativas_p$calificacion == "DD"  ~ 42,
   Formato_351_participativas_p$c50 == 4 & Formato_351_participativas_p$calificacion == "D"  ~ 43,
   Formato_351_participativas_p$c50 == 5 & Formato_351_participativas_p$calificacion == "D"  ~ 41)   
  
  #Columna 124 y 125 
  Formato_351_participativas_p = left_join(Formato_351_participativas_p, parametros_CalificacionSeparado, by = "c49")
  
  #Columa 126 y 127
  Formato_351_participativas_p = left_join(Formato_351_participativas_p, parametros_calificacionesConsolidado, by = "c106")
  
  #------------------------------------------ Limpiamos la data 
  Formato_351_participativas_final_p = Formato_351_participativas_p[,c(  "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                                   "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                                   "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                                   "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                                   "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                                   "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                                   "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                                   "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                                   "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                                   "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                                   "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                                   "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                                   "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                                   "c127","c128","c129","c130","c131","c132","c133")]
  
  
  #Redondeamos todos los datos numericos a 2 decimales 
  Formato_351_participativas_final_p <- Formato_351_participativas_final_p %>% 
    mutate(across(where(is.numeric), ~ round(., 5)))

  
  #Aqui revisamos si hay reportos 

  if (nrow(reportos) > 0) { 
    
    #Cruzamos con homologado
    reportos_P_P = left_join(reportos, homologado, by = c("Cuenta_contable","TipoValor"))
    
    #limpiamos formato 351 quitando las columnas que ya estan en reportos 
    Formato_351_participativas_reportos_p = Formato_351_participativas_p %>% select(-c("Cuenta_contable","TipoValor","c72","Descripcion","c2","DescripcionCUIF", "c9","c24","c90","c91"))
    
    #Creamos reportos_3 si es que hay 
    reportos_1_p = merge(reportos_P_P, Formato_351_participativas_reportos_p, by = c("DealID"))
    
    if (nrow(reportos_1_p) > 0) { 
      
      #Cambiamos las columnas monetarias 
      reportos_1_p <- reportos_1_p %>%
        mutate(c17 = Monto,
               c19 = Monto,
               c22 = Monto,
               c23 = Monto * tasa_de_cambio,
               c30 = Monto * tasa_de_cambio,
               c31 = Monto * tasa_de_cambio,
               c32 = Monto,
               c73 = Monto,
               c113 = Monto * tasa_de_cambio,
               c115 = Monto * tasa_de_cambio,
               c116 = Monto * tasa_de_cambio,
               c121 = 0,
               c132 = c116 - c30,
               c133 = Monto * tasa_de_cambio)
      
      #Columna 121
      reportos_1_p$c121 = case_when(
        reportos_1_p$DealID != 715027689 & reportos_1_p$c117 != "No aplica" & reportos_1_p$c120 == "No" ~ as.numeric(reportos_1_p$c31) * as.numeric(reportos_1_p$c102) * as.numeric(reportos_1_p$c119),
        reportos_1_p$DealID != 715027689 & reportos_1_p$c117 != "No aplica" & reportos_1_p$c120 == "Si" ~ 0,
        TRUE ~ NA_integer_)
      
      reportos_1_p <- reportos_1_p %>% 
        mutate(c133 = c133 - c121)
      
      #Ordenamos reportos
      reportos_1_p = reportos_1_p[,c(  
                                 "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                 "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                 "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                 "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                 "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                 "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                 "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                 "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                 "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                 "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                 "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                 "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                 "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                 "c127","c128","c129","c130","c131","c132","c133")]
      
      #redondear reportos -OJO ESTO SE PUEDE PONER AL FINAL CUANDO YA TENGAMOS TODOS LOS REPORTOS UNIDOS - esto es solo una prueba 
      #Redondeamos todos los datos numericos a 2 decimales 
      reportos_1_p <- reportos_1_p %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
      #Hacer un group_by para sumar todas las inversiones hijas, para restarle el total a la inversión madre
      reportos_1_agrupado_p  =  reportos_1_p %>% select(c1,c17,c19,c22,c23,c30,c31,c32, c113,c115, c116,c121, c133) 
      reportos_1_agrupado_p <- reportos_1_agrupado_p %>% 
        group_by(c1) %>% 
        summarise(c17_a1 = sum(c17),
                  c19_a1 = sum(c19),
                  c22_a1 = sum(c22),
                  c23_a1 = sum(c23),
                  c30_a1 = sum(c30),
                  c31_a1 = sum(c31),
                  c32_a1 = sum(c32),
                  c113_a1 = sum(c113),
                  c115_a1 = sum(c115), 
                  c116_a1 = sum(c116),
                  c121_a4 = sum(c121),
                  c133_a1 = sum(c133),
                  .groups = 'drop') 
      
      #Como hay reportos entonces formato_351_participativas_final va a cambiar restando el monto 
      Formato_351_participativas_final_p = case_when( Formato_351_participativas_final_p$c1 == reportos_1_agrupado_p$c1 ~ Formato_351_participativas_final_p %>%  mutate (c17 = c17 - reportos_1_agrupado_p$c17_a1,
                                                                                                                                                                  c19 = c19 - reportos_1_agrupado_p$c19_a1,
                                                                                                                                                                  c22 = c22 - reportos_1_agrupado_p$c22_a1,
                                                                                                                                                                  c23 = c23 - reportos_1_agrupado_p$c23_a1,
                                                                                                                                                                  c30 = c30 - reportos_1_agrupado_p$c30_a1,
                                                                                                                                                                  c31 = c31 - reportos_1_agrupado_p$c31_a1,
                                                                                                                                                                  c32 = c32 - reportos_1_agrupado_p$c32_a1,
                                                                                                                                                                  c113 = c113 - reportos_1_agrupado_p$c113_a1,
                                                                                                                                                                  c115 = c115 - reportos_1_agrupado_p$c115_a1, 
                                                                                                                                                                  c116 = c116 - reportos_1_agrupado_p$c116_a1,
                                                                                                                                                                  c121 = c121 - reportos_1_agrupado_p$c121_a4,
                                                                                                                                                                  c132 = 0,
                                                                                                                                                                  c133 = c133 - reportos_1_agrupado_p$c133_a1), 
                                                    TRUE ~ Formato_351_participativas_final_p) 
      
      #Redondeamos los datos
      #Redondeamos todos los datos numericos a 2 decimales 
      Formato_351_participativas_final_p <- Formato_351_participativas_final_p %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
    } else {"No hay reportos en participativas precio 2"}
    
  } else {"No hay reportos en participativas precio 1"}
  
} else {
  # Ejecutar código si no hay observaciones
  print("No hay inversiones participativas precio por accion")
}

if (nrow(participativas_normal) > 0) {
  
  #c9, c24, c90, c91
  Formato_351_participativas_n = merge(participativas_normal, homologado, by = c("c2", "Cuenta_contable"))
  
  #columna 76 
  Formato_351_participativas_n = left_join(Formato_351_participativas_n, parametros_emisor, by = "c75")
  
  #Columna 101, 105, 106, 103
  Formato_351_participativas_n =left_join(Formato_351_participativas_n, Calif_Deterioro, by = "c76")
  
  #creamos la columna 1 
  Formato_351_participativas_n$c1 = str_remove_all( paste("CAM084-",Formato_351_participativas_n$DealID)," ")
  
  #columna 102
  Formato_351_participativas_n = left_join(Formato_351_participativas_n, parametros_Riesgo_de_credito, by = "c101")
  
  #Creamos las columnas fijas
  Formato_351_participativas_n <- Formato_351_participativas_n %>% 
    mutate(c3 = 3,
           c4 = " ",
           c5 = " ", 
           c6 = " ", 
           c7 = " ", 
           c8 = " ", 
           c10 = " ", 
           c11 = 1,
           c13 = " ", 
           c14 = " ", 
           c16 = "USD",
           c18 = 1,
           c21 = 1,
           c24 = " ",
           c25 = " ",
           c26 = " ",
           c27 = " ",
           c28 = " ",
           c29 = " ",
           c33 = " ",
           c34 = " ",
           c35 = " ",
           c36 = " ",
           c37 = " ",
           c38 = " ",
           c39 = " ",
           c40 = " ",
           c41 = 13,
           c42 = " ",
           c43 = " ",
           c44 = " ",
           c45 = " ",
           c47 = " ",
           c48 = " ",
           c51 = " ",
           c52 = " ",
           c53 = " ",
           c54 = " ",
           c55 = 3,
           c56 = " ",
           c57 = " ",
           c58 = " ",
           c59 = " ",
           c60 = " ",
           c61 = " ",
           c62 = " ",
           c63 = " ",
           c66 = " ",
           c67 = " ", 
           c68 = 3,
           c69 = " ",
           c70 = " ",
           c71 = " ",
           c72 = " ",
           c73 = " ",
           c74 = 222,
           c77 = " ",
           c78 = " ",
           c79 = " ",
           c80 = 5,
           c81 = "Banco Davivienda Salvadoreño",
           c82 = "El Salvador",
           c83 = "Estructural - Instrumentos de Patrimonio",
           c84 = "No aplica",
           c85 = "Disponible para la venta",
           c86 = "Instrumentos de Patrimonio",
           c87 = "No aplica",
           c88 = "Disponible para la venta",
           c89 = "Valor Razonable cambios en ORI",
           c92 = " ",
           c93 = " ",
           c94 = " ",
           c95 = "No aplica",
           c96 = " ",
           c97 = "El Salvador",
           c98 = "Corporativo en el Exterior",
           c99 = "Entidades del Sector Real",
           c100 = "Corporativo",
           c104 = " ",
           c106.1= " ",
           c106.2= " ",
           c106.3= " ",
           c106.4= " ",
           c107 = " ",
           c108 = " ",
           c109 = " ",
           c110 = " ",
           c111 = " ",
           c112 = " ",
           c117 = " ",
           c118 = " ",
           c119 = " ",
           c120 = " ",
           c121 = " ",
           c122 = " ",
           c123 = " ",
           c128 = "Dólar Americano",
           c129 = "Moneda Extranjera",
           c130 = " ",
           c131 = str_remove_all(paste(dia,mes,año)," " ))
  
  #Columnas formuladas
  Formato_351_participativas_n <- Formato_351_participativas_n %>% 
    mutate(c22 = c17, 
           c23 = tasa_de_cambio * c22,
           c32 = c19,
           c30 = tasa_de_cambio * c32,
           c31 = c30,
           c113 = c30,
           c115 = c30,
           c116 = c30,
           c132 = c116 - c30,
           c133 = c116)
  
  #Columna 114 
  Formato_351_participativas_n$c114 = case_when(
    (Formato_351_participativas_n$c85 == "Al Vencimiento" | Formato_351_participativas_n$c85 == "Al vencimiento") ~ as.character(Formato_351_participativas_n$c30),
    (Formato_351_participativas_n$c85 == "Al Vencimiento" | Formato_351_participativas_n$c85 == "Al vencimiento") & is.na(Formato_351_participativas_n$c30) ~ "Inválido",
    TRUE ~ "No aplica")
  
  #Asigna numero a calificación país
  #Columna 50
  Formato_351_participativas_n$c50 <- 
    ifelse(Formato_351_participativas_n$Inter_cal_FITCH_RATINGS != "0" , 4,
           ifelse(Formato_351_participativas_n$Inter_cal_SyP != "0" ,3,
                  ifelse(Formato_351_participativas_n$Inter_cal_MOODYS != "0" ,5,
                         ifelse(Formato_351_participativas_n$CalificaciónPaísFinalDelEmisor != "0" ,Formato_351_participativas_n$c50_opcion4, NA_integer_)))) 
  
  
  
  #Hacer una columna que guarde la calificación para la columna 49
  Formato_351_participativas_n$calificacion = case_when(Formato_351_participativas_n$c50 == 4 ~ ifelse(Formato_351_participativas_n$Inter_cal_FITCH_RATINGS != "0", Formato_351_participativas_n$Inter_cal_FITCH_RATINGS, 
                                                                                                       ifelse(Formato_351_participativas_n$P_calif_ficht != "0", Formato_351_participativas_n$P_calif_ficht, 'Error' )) , 
                                                        Formato_351_participativas_n$c50 == 3 ~ ifelse(Formato_351_participativas_n$Inter_cal_SyP != "0", Formato_351_participativas_n$Inter_cal_SyP, 
                                                                                                       ifelse(Formato_351_participativas_n$Inter_cal_SyP != "0", Formato_351_participativas_n$P_calif_SyP ,'Error')) ,
                                                        Formato_351_participativas_n$c50 == 5 ~ ifelse(Formato_351_participativas_n$Inter_cal_MOODYS != "0", Formato_351_participativas_n$Inter_cal_MOODYS, 
                                                                                                       ifelse(Formato_351_participativas_n$P_Calif_moodys != "0", Formato_351_participativas_n$P_Calif_moodys,'Error') ),
                                                        TRUE ~ 'Error 1')
  
  #Columna 49 calificación en letra a su homolgación en numero 
  Formato_351_participativas_n$c49 = case_when(
    (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 | Formato_351_participativas_n$c50 == 5) & Formato_351_participativas_n$calificacion == "AAA" ~ 20,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "AA+")  | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "AA1") ~ 21,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "AA")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "AA2") ~ 22,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "AA-")  | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "AA3") ~ 23,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "A+")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "A1")  ~ 24,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "A")    | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "A2")  ~ 25,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "A-")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "A3")  ~ 26,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "BBB+") | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "BAA1") ~ 27,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "BBB")  | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "BAA2") ~ 28,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "BBB-") | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "BAA3") ~ 29,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "BB+")  | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "BA1")  ~ 30,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "BB")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "BA2")  ~ 31,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "BB-")  | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "BA3")  ~ 32,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "B+")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "B1")   ~ 33,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "B")    | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "B2")   ~ 34,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "B-")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "B3")   ~ 35,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "CCC+") | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "CAA1") ~ 36,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "CCC")  | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "CAA2") ~ 37,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "CCC-") | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "CAA3") ~ 38,
    ( (Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 )  & Formato_351_participativas_n$calificacion == "CC")   | (Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "CA")   ~ 39,
    ( Formato_351_participativas_n$c50 == 4 | Formato_351_participativas_n$c50 == 3 | Formato_351_participativas_n$c50 == 5) & Formato_351_participativas_n$calificacion == "C" ~ 40,
    Formato_351_participativas_n$c50 == 4 & Formato_351_participativas_n$calificacion == "DDD"  ~ 41,
    Formato_351_participativas_n$c50 == 4 & Formato_351_participativas_n$calificacion == "DD"  ~ 42,
    Formato_351_participativas_n$c50 == 4 & Formato_351_participativas_n$calificacion == "D"  ~ 43,
    Formato_351_participativas_n$c50 == 5 & Formato_351_participativas_n$calificacion == "D"  ~ 41)   
  

  #Columna 124 y 125 
  Formato_351_participativas_n = left_join(Formato_351_participativas_n, parametros_CalificacionSeparado, by = "c49")
  
  #Columa 126 y 127
  Formato_351_participativas_n = left_join(Formato_351_participativas_n, parametros_calificacionesConsolidado, by = "c106")
  
  
  #------------------------------------------ Limpiamos la data 
  Formato_351_participativas_final_n = Formato_351_participativas_n[,c( "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                                   "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                                   "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                                   "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                                   "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                                   "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                                   "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                                   "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                                   "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                                   "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                                   "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                                   "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                                   "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                                   "c127","c128","c129","c130","c131","c132","c133")]
  

  #Redondeamos todos los datos numericos a 2 decimales 
  Formato_351_participativas_final_n <- Formato_351_participativas_final_n %>% 
    mutate(across(where(is.numeric), ~ round(., 5)))
  
  #Aqui revisamos si hay reportos 
  if (nrow(reportos) > 0) { 
    
    #Cruzamos con homologado
    reportos_n = left_join(reportos, homologado, by = c("Cuenta_contable","TipoValor"))
    
    #limpiamos formato 351 quitando las columnas que ya estan en reportos 
    Formato_351_participativas_n_reportos = Formato_351_participativas_n %>% select(-c("Cuenta_contable","TipoValor","c72","Descripcion","c2","DescripcionCUIF", "c9","c24","c90","c91"))
    
    #Creamos reportos_3 si es que hay 
    reportos_1_n = merge(reportos_n, Formato_351_participativas_n_reportos, by = c("DealID"))
    
    if (nrow(reportos_1_n) > 0) { 
      
      #Cambiamos las columnas monetarias 
      reportos_1_n <- reportos_1_n %>% 
        mutate(c17 = Monto,
               c19 = Monto,
               c22 = Monto,
               c23 = Monto * tasa_de_cambio,
               c30 = Monto * tasa_de_cambio,
               c31 = Monto * tasa_de_cambio,
               c32 = Monto,
               c73 = Monto,
               c113 = Monto * tasa_de_cambio,
               c115 = Monto * tasa_de_cambio,
               c116 = Monto * tasa_de_cambio,
               c121 = 0,
               c132 = c116 - c30,
               c133 = Monto * tasa_de_cambio)
      
      #Columna 121
      reportos_1_n$c121 = case_when(
        reportos_1_n$DealID != 715027689 & reportos_1_n$c117 != "No aplica" & reportos_1_n$c120 == "No" ~ as.numeric(reportos_1_n$c31) * as.numeric(reportos_1_n$c102) * as.numeric(reportos_1_n$c119),
        reportos_1_n$DealID != 715027689 & reportos_1_n$c117 != "No aplica" & reportos_1_n$c120 == "Si" ~ 0,
        TRUE ~ NA_integer_)
      
      reportos_1_n <- reportos_1_n %>% 
        mutate(c133 = c133 - c121)
      
      #Ordenamos reportos
      reportos_1_n = reportos_1_n[,c("c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                 "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                 "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                 "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                 "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                 "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                 "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                 "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                 "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                 "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                 "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                 "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                 "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                 "c127","c128","c129","c130","c131","c132","c133")]
      
      #redondear reportos -OJO ESTO SE PUEDE PONER AL FINAL CUANDO YA TENGAMOS TODOS LOS REPORTOS UNIDOS - esto es solo una prueba 
      #Redondeamos todos los datos numericos a 2 decimales 
      reportos_1_n <- reportos_1_n %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
      #Hacer un group_by para sumar todas las inversiones hijas, para restarle el total a la inversión madre
      reportos_1_agrupado  =  reportos_1_n %>% select(c1,c17,c19,c22,c23,c30,c31,c32,c113,c115, c116,c121,c133) 
      reportos_1_agrupado <- reportos_1_agrupado %>% 
        group_by(c1) %>% 
        summarise(c17_a1 = sum(c17),
                  c19_a1 = sum(c19),
                  c22_a1 = sum(c22),
                  c23_a1 = sum(c23),
                  c30_a1 = sum(c30),
                  c31_a1 = sum(c31),
                  c32_a1 = sum(c32),
                  c113_a1 = sum(c113),
                  c115_a1 = sum(c115), 
                  c116_a1 = sum(c116),
                  c121_a4 = sum(c121),
                  c133_a1 = sum(c133),
                  .groups = 'drop') 
      
      #Como hay reportos entonces Formato_351_participativas_final_n va a cambiar restando el monto 
      Formato_351_participativas_final_n = case_when( Formato_351_participativas_final_n$c1 == reportos_1_agrupado$c1 ~ Formato_351_participativas_final_n %>%  mutate (c17 = c17 - reportos_1_agrupado$c17_a1,
                                                                                                                                                                        c19 = c19 - reportos_1_agrupado$c19_a1,
                                                                                                                                                                        c22 = c22 - reportos_1_agrupado$c22_a1,
                                                                                                                                                                        c23 = c23 - reportos_1_agrupado$c23_a1,
                                                                                                                                                                        c30 = c30 - reportos_1_agrupado$c30_a1,
                                                                                                                                                                        c31 = c31 - reportos_1_agrupado$c31_a1,
                                                                                                                                                                        c32 = c32 - reportos_1_agrupado$c32_a1,
                                                                                                                                                                        c113 = c113 - reportos_1_agrupado$c113_a1,
                                                                                                                                                                        c115 = c115 - reportos_1_agrupado$c115_a1, 
                                                                                                                                                                        c116 = c116 - reportos_1_agrupado$c116_a1,
                                                                                                                                                                        c121 = c121 - reportos_1_agrupado$c121_a4,
                                                                                                                                                                        c132 = 0,
                                                                                                                                                                        c133 = c133 - reportos_1_agrupado$c133_a1), 
                                                      TRUE ~ Formato_351_participativas_final_n) 
      
      #Redondeamos los datos
      #Redondeamos todos los datos numericos a 2 decimales 
      Formato_351_participativas_final_n <- Formato_351_participativas_final_n %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
    } else {"No hay reportos en participativas 2 normal"}
    
  } else {"No hay reportos en participativas 1 normal"}
  
} else {
  # Ejecutar código si no hay observaciones
  print("No hay inversiones participativas normales")
}

#Aqui vamos a unir si existe los formatos finales y colocamos la columna c0 

#Formato_351_participativas_final_n
if (exists("Formato_351_participativas_final_n")) {
  if (exists("Formato_351_participativas_final")) {
    Formato_351_participativas_final <- rbind(Formato_351_participativas_final, Formato_351_participativas_final_n)
  } else {
    Formato_351_participativas_final <- Formato_351_participativas_final_n
  }
}

#Formato_351_participativas_final_p
if (exists("Formato_351_participativas_final_p")) {
  if (exists("Formato_351_participativas_final")) {
    Formato_351_participativas_final <- rbind(Formato_351_participativas_final, Formato_351_participativas_final_p)
  } else {
    Formato_351_participativas_final <- Formato_351_participativas_final_p
  }
}

#Formato_351_participativas_final
if (exists("Formato_351_participativas_final")) {
  
  #ponemos el consecutivoS
  Formato_351_participativas_final$c0 =  row_number(Formato_351_participativas_final$c1)
  
  #ordenamos por el consecutivo
  Formato_351_participativas_final <- Formato_351_participativas_final[order(Formato_351_participativas_final$c0), ]
  
  #Ordenamos las columnas 
  Formato_351_participativas_final = Formato_351_participativas_final[,c("c0", "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                                         "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                                         "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                                         "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                                         "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                                         "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                                         "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                                         "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                                         "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                                         "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                                         "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                                         "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                                         "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                                         "c127","c128","c129","c130","c131","c132","c133")]
  
} else {
  print("No se creó ningún dataframe final de participativas")
}


#Dejamos el archivo final llamado reportos_1 

if (exists("reportos_1_n")) {
  if (exists("reportos_1")) {
    reportos_1 <- rbind(reportos_1, reportos_1_n)
  } else {
    reportos_1 <- reportos_1_n
  }
}

if (exists("reportos_1_p")) {
  if (exists("reportos_1")) {
    reportos_1 <- rbind(reportos_1, reportos_1_p)
  } else {
    reportos_1 <- reportos_1_p
  }
}

#reportos_1
if (exists("reportos_1")) {
  
  #ponemos el consecutivoS
  reportos_1$c0 =  row_number(reportos_1$c1)
  
  #ordenamos por el consecutivo
  reportos_1 <- reportos_1[order(reportos_1$c0), ]
  
  #Ordenamos las columnas 
  reportos_1 = reportos_1[,c("c0", "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                                         "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                                         "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                                         "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                                         "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                                         "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                                         "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                                         "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                                         "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                                         "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                                         "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                                         "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                                         "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                                         "c127","c128","c129","c130","c131","c132","c133")]
  
} else {
  print("No se creó ningún dataframe de reportos 1 ")
}


#===================================== Al vencimiento =============================
# Verificar si hay observaciones en el data frame
if (nrow(New_PL_DataBase_vencimiento) > 0) {
  
  #Cruzamos con new_pl y homologado
  Formato_351_vencimiento = merge(New_PL_DataBase_vencimiento, homologado, by = "Cuenta_contable")
  
  #Cruzamos con setup para tener la columna 22 - llave dealID
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, New_PL_setup, by = "DealID")
  
  #cruzamos con PIP
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, PIP, by = "DealID")
  
  #cruzamos con prospecto
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, prospecto, by = "DealID")
  
  #cruzamos con plano integrado
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, Plano_integrado, by = "DealID")
  
  #cruzamos con plano portafolio
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, Plano_Portafolio, by = "DealID")
  
  #Columna 74
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_pais, by = "c97")
  
  #columna 76 
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_emisor, by = "c75")
  
  #Columna 101 - 106 - 105 - 103
  Formato_351_vencimiento =left_join(Formato_351_vencimiento, Calif_Deterioro, by = "c76")
  
  #columna c37
  Formato_351_vencimiento =left_join(Formato_351_vencimiento, InversionesNuevasTV, by = "DealID")
  
  #creamos la columna 0
  Formato_351_vencimiento$c0 = row_number(Formato_351_vencimiento$DealID)
  
  #creamos la columna 1 
  Formato_351_vencimiento$c1 = str_remove_all( paste("CAM084-",Formato_351_vencimiento$DealID)," ")    
  
  #Creamos las columnas fijas
  Formato_351_vencimiento <- Formato_351_vencimiento %>% 
    mutate(c3 = 3,
           c4 = " ",
           c5 = " ", 
           c6 = " ", 
           c7 = " ", 
           c8 = " ", 
           c10 = " ", 
           c11 = 3,
           c14 = " ", 
           c16 = "USD",
           c20 = " ",
           c21 = " ",
           c28 = 1,
           c29 = 1,
           c35 = " ",
           c36 = " ",
           c38 = " ",
           c39 = " ",
           c41 = 21,
           c44 = " ",
           c45 = " ",
           c46 = " ",
           c47 = " ",
           c48 = " ",
           c51 = "A",
           c52 = " ",
           c53 = " ",
           c54 = " ",
           c55 = 3,
           c57 = " ",
           c58 = " ",
           c59 = " ",
           c60 = " ",
           c61 = " ",
           c62 = " ",
           c63 = " ",
           c64 = 411106,
           c65 = " ",
           c66 = " ",
           c67 = " ", 
           c68 = 3,
           c69 = " ",
           c70 = " ",
           c71 = " ",
           c72 = " ",
           c73 = " ",
           c77 = " ",
           c78 = " ",
           c79 = " ",
           c80 = 13,
           c81 = "Banco Davivienda Salvadoreño",
           c82 = "El Salvador",
           c104 = " ",
           c106.1= " ",
           c106.2= " ",
           c106.3= " ",
           c106.4= " ",
           c108 = " ",
           c109 = " ",
           c110 = " ",
           c111 = " ",
           c112 = " ",
           c122 = " ",
           c123 = " ",
           c128 = "Dólar Americano",
           c129 = "Moneda Extranjera",
           c130 = " ",
           c131 = str_remove_all(paste(dia,mes,año)," " )) 
  
  #columna 43 
  Formato_351_vencimiento$c43 = ifelse(is.na(Formato_351_vencimiento$c42),NA_integer_,Formato_351_vencimiento$c32)
  
  #Asigna numero a calificación país
  #Columna 50
  Formato_351_vencimiento$c50 <- 
    ifelse(Formato_351_vencimiento$Inter_cal_FITCH_RATINGS != "0" , 4,
           ifelse(Formato_351_vencimiento$Inter_cal_SyP != "0" ,3,
                  ifelse(Formato_351_vencimiento$Inter_cal_MOODYS != "0" ,5,
                         ifelse(Formato_351_vencimiento$CalificaciónPaísFinalDelEmisor != "0" ,Formato_351_vencimiento$c50_opcion4, NA_integer_)))) 
  
  #Hacer una columna que guarde la calificación para la columna 49
  Formato_351_vencimiento$calificacion = case_when(Formato_351_vencimiento$c50 == 4 ~ ifelse(Formato_351_vencimiento$Inter_cal_FITCH_RATINGS != "0", Formato_351_vencimiento$Inter_cal_FITCH_RATINGS, 
                                                                                             ifelse(Formato_351_vencimiento$P_calif_ficht != "0", Formato_351_vencimiento$P_calif_ficht, 'Error' )) , 
                                                   Formato_351_vencimiento$c50 == 3 ~ ifelse(Formato_351_vencimiento$Inter_cal_SyP != "0", Formato_351_vencimiento$Inter_cal_SyP, 
                                                                                             ifelse(Formato_351_vencimiento$Inter_cal_SyP != "0", Formato_351_vencimiento$P_calif_SyP ,'Error')) ,
                                                   Formato_351_vencimiento$c50 == 5 ~ ifelse(Formato_351_vencimiento$Inter_cal_MOODYS != "0", Formato_351_vencimiento$Inter_cal_MOODYS, 
                                                                                             ifelse(Formato_351_vencimiento$P_Calif_moodys != "0", Formato_351_vencimiento$P_Calif_moodys,'Error') ),
                                                   TRUE ~ 'Error 1')
  
  #Columna 49 calificación en letra a su homolgación en numero 
  Formato_351_vencimiento$c49 = case_when(
    (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 | Formato_351_vencimiento$c50 == 5) & Formato_351_vencimiento$calificacion == "AAA" ~ 20,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "AA+")  | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "AA1") ~ 21,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "AA")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "AA2") ~ 22,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "AA-")  | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "AA3") ~ 23,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "A+")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "A1")  ~ 24,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "A")    | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "A2")  ~ 25,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "A-")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "A3")  ~ 26,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "BBB+") | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "BAA1") ~ 27,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "BBB")  | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "BAA2") ~ 28,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "BBB-") | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "BAA3") ~ 29,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "BB+")  | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "BA1")  ~ 30,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "BB")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "BA2")  ~ 31,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "BB-")  | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "BA3")  ~ 32,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "B+")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "B1")   ~ 33,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "B")    | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "B2")   ~ 34,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "B-")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "B3")   ~ 35,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "CCC+") | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "CAA1") ~ 36,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "CCC")  | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "CAA2") ~ 37,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "CCC-") | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "CAA3") ~ 38,
    ( (Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 )  & Formato_351_vencimiento$calificacion == "CC")   | (Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "CA")   ~ 39,
    ( Formato_351_vencimiento$c50 == 4 | Formato_351_vencimiento$c50 == 3 | Formato_351_vencimiento$c50 == 5) & Formato_351_vencimiento$calificacion == "C" ~ 40,
    Formato_351_vencimiento$c50 == 4 & Formato_351_vencimiento$calificacion == "DDD"  ~ 41,
    Formato_351_vencimiento$c50 == 4 & Formato_351_vencimiento$calificacion == "DD"  ~ 42,
    Formato_351_vencimiento$c50 == 4 & Formato_351_vencimiento$calificacion == "D"  ~ 43,
    Formato_351_vencimiento$c50 == 5 & Formato_351_vencimiento$calificacion == "D"  ~ 41)   
  
  #Columna 124 y 125 
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_CalificacionSeparado, by = "c49")
  
  #Columa 126 y 127
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_calificacionesConsolidado, by = "c106")
  
  #Multiplicamos la tasa de cambio por la C22 para crear la c23
  Formato_351_vencimiento <- Formato_351_vencimiento %>% 
    mutate(c19 = c17,
           c23 = tasa_de_cambio * c22,
           c30 =  tasa_de_cambio * c32, 
           c31 = c30, 
           c34 = c13_date - fechaCorte,  
           c88 = c85,
           c93 = c25,
           c113 = c30,
           c115 = c30,
           c116 = c30,
           c132 = c116 - c30)
  
  #Columna 12 para cuando c9 es CDEBE
  Formato_351_vencimiento$c12 = case_when(
    Formato_351_vencimiento$c9 == "CDEBE" ~ Formato_351_vencimiento$c15,
    TRUE ~ Formato_351_vencimiento$c12)
  
  
  #Columna 84 
  Formato_351_vencimiento$c84 = case_when(
    Formato_351_vencimiento$c83 == "Estructural - Reserva de Liquidez Interna Estratégica"  ~ "Portafolio Mínimo",
    Formato_351_vencimiento$c83 == "Estructural - Gestión Balance"  ~ "Gestión Balance",
    Formato_351_vencimiento$c83 == "Estructural - Reserva de Liquidez Regulatoria Estratégica" ~ "Liquidez regulatoria",
    Formato_351_vencimiento$c83 == "Estructural - Gestión Balance GOES"  ~ "Gestión Balance GOES",
    TRUE ~ NA_character_ )
  
  #Columna 86 
  Formato_351_vencimiento$c86 = case_when(
    Formato_351_vencimiento$c83 == "Estructural - Reserva de Liquidez Interna Estratégica"  ~ "Hold To Collect & Sale - HTC&S",
    Formato_351_vencimiento$c83 == "Estructural - Gestión Balance"  ~ "Hold To Collect - HTC",
    Formato_351_vencimiento$c83 == "Estructural - Reserva de Liquidez Regulatoria Estratégica" ~ "Hold To Collect & Sale - HTC&S",
    Formato_351_vencimiento$c83 == "Estructural - Gestión Balance GOES"  ~ "Hold To Collect - HTC",
    TRUE ~ NA_character_ )
  
  #columna 89 
  Formato_351_vencimiento$c89 = case_when(
    Formato_351_vencimiento$c86 == "Hold To Collect - HTC" &  Formato_351_vencimiento$c87 == "Cumple" ~ "Costo Amortizado cambios en P&G",
    Formato_351_vencimiento$c86 == "Hold To Collect - HTC" &  Formato_351_vencimiento$c87 == "No cumple" ~ "Valor Razonable cambios en P&G",
    Formato_351_vencimiento$c86 == "Hold To Collect & Sale - HTC&S" &  Formato_351_vencimiento$c87 == "Cumple" ~ "Valor Razonable cambios en ORI",
    Formato_351_vencimiento$c86 == "Hold To Collect & Sale - HTC&S" &  Formato_351_vencimiento$c87 == "No cumple" ~ "Valor Razonable cambios en P&G",
    Formato_351_vencimiento$c86 == "Instrumentos de Patrimonio" &  Formato_351_vencimiento$c87 == "No aplica" ~ "Valor Razonable cambios en ORI",
    Formato_351_vencimiento$c86 == "Hold To Sale - HTS" &  Formato_351_vencimiento$c87 == "No aplica" ~ "Valor Razonable cambios en P&G",
    TRUE ~ "Inválido")
  
  #columna 94 
  Formato_351_vencimiento$c34_caracter = as.character(Formato_351_vencimiento$c34)
  Formato_351_vencimiento$c94 = case_when(
    Formato_351_vencimiento$c91 == "Deuda Pública" | Formato_351_vencimiento$c91 == "Deuda Privada" & Formato_351_vencimiento$c34_caracter != is.na(Formato_351_vencimiento$c34_caracter) ~ Formato_351_vencimiento$c34_caracter,
    Formato_351_vencimiento$c91 == "Títulos Participativos" ~ "No Aplica",
    TRUE ~ "Inválido")
  
  #Columna 95 
  Formato_351_vencimiento$c95 <- ifelse(Formato_351_vencimiento$c91 == "Fondos de inversión" & substr(Formato_351_vencimiento$c2, start = 1, stop = 4) == "1360",
                                        "De 0 a 1 años",
                                        case_when(
                                          Formato_351_vencimiento$c94 == "No Aplica"  ~ "No Aplica",
                                          is.numeric(as.numeric(Formato_351_vencimiento$c94)) & as.numeric(Formato_351_vencimiento$c94) >= 1 & as.numeric(Formato_351_vencimiento$c94) <= 365 ~ "De 0 a 1 años",
                                          is.numeric(as.numeric(Formato_351_vencimiento$c94)) & as.numeric(Formato_351_vencimiento$c94) >= 366 & as.numeric(Formato_351_vencimiento$c94) <= 1825 ~ "De 1 a 5 años",
                                          is.numeric(as.numeric(Formato_351_vencimiento$c94)) & as.numeric(Formato_351_vencimiento$c94) >= 1826 & as.numeric(Formato_351_vencimiento$c94) <= 3650 ~ "De 5 a 10 años",
                                          is.numeric(as.numeric(Formato_351_vencimiento$c94)) & as.numeric(Formato_351_vencimiento$c94) >= 3651 ~ "Más de 10 años",
                                          TRUE ~ "Inválido"))
  
  #columna 96 
  Formato_351_vencimiento$c96 = case_when(
    Formato_351_vencimiento$c91 == "Deuda Pública" | Formato_351_vencimiento$c91 == "Deuda Privada"  ~ as.character(Formato_351_vencimiento$c13_date - Formato_351_vencimiento$c12_date),
    Formato_351_vencimiento$c91 == "No Aplica" ~ "No Aplica",
    TRUE ~ "Inválido")
  
  #Columna 99
  Formato_351_vencimiento$c99 = case_when(
    Formato_351_vencimiento$c98 == "Gobierno Colombiano" ~ "Gobierno Colombiano",
    Formato_351_vencimiento$c98 == "Gobierno Extranjero" ~ "Gobierno Extranjero",
    Formato_351_vencimiento$c98 == "Instituciones Oficiales Especiales - IOE - Colombia" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Bancos en Colombia" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Bancos en el Exterior" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Instituciones Financieras en Colombia diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Instituciones Financieras en el Exterior diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Corporativo en Colombia" ~ "Entidades del Sector Real",
    Formato_351_vencimiento$c98 == "Corporativo en el Exterior" ~ "Entidades del Sector Real",
    Formato_351_vencimiento$c98 == "Organismos Multilaterales de Crédito" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Titularizadora" ~ "Otros",
    TRUE ~ "Inválido")
  
  #columna 100
  Formato_351_vencimiento$c100 = case_when(
    Formato_351_vencimiento$c98 == "Gobierno Colombiano" ~ "Gobierno Nacional",
    Formato_351_vencimiento$c98 == "Gobierno Extranjero" ~ "Gobiernos Extranjeros",
    Formato_351_vencimiento$c98 == "Instituciones Oficiales Especiales - IOE - Colombia" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Bancos en Colombia" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Bancos en el Exterior" ~ "Bancos en el Exterior",
    Formato_351_vencimiento$c98 == "Instituciones Financieras en Colombia diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Instituciones Financieras en el Exterior diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_vencimiento$c98 == "Corporativo en Colombia" ~ "Corporativo",
    Formato_351_vencimiento$c98 == "Corporativo en el Exterior" ~ "Corporativo",
    Formato_351_vencimiento$c98 == "Organismos Multilaterales de Crédito" ~ "Organismos Multilaterales de Crédito",
    Formato_351_vencimiento$c98 == "Titularizadora" ~ "Titularizaciones",
    TRUE ~ "Inválido")
  
  #columna 102
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_Riesgo_de_credito, by = "c101")
  
  #Formato_351_vencimiento$c102 = case_when(
  #  Formato_351_vencimiento$c101 == "Soberanos ML" ~ "0.47",
  #  Formato_351_vencimiento$c101 == "Soberanos" ~ "0.47",
  #  Formato_351_vencimiento$c101 == "Corporativos" ~ "0.623",
  #  Formato_351_vencimiento$c101 == "Davivienda" ~  "0.623",
  #  Formato_351_vencimiento$c101 == "Participativos" ~ "No Aplica",
  #  TRUE ~ "Inválido")
  
  #columna 114 
  Formato_351_vencimiento$c114 = case_when(
    (Formato_351_vencimiento$c85 == "Al Vencimiento" | Formato_351_vencimiento$c85 == "Al vencimiento"  ) ~ as.character(Formato_351_vencimiento$c30),
    (Formato_351_vencimiento$c85 == "Al Vencimiento" | Formato_351_vencimiento$c85 == "Al vencimiento" ) & as.character(Formato_351_vencimiento$c30) == is.na(as.character(Formato_351_vencimiento$c30)) ~ "Inválido",
    TRUE ~ "No Aplica")
  
  #Columna 117 
  Formato_351_vencimiento$c117 = case_when(
    Formato_351_vencimiento$DealID == 715027689 ~ "No aplica",
    TRUE ~ " ")
  
  #Columna 118
  #Hacemos una nueva columna numerica con los datos de la 94 para poder manipular y sacar la 118 
  Formato_351_vencimiento$c94_para_c118 = as.numeric(Formato_351_vencimiento$c94)
  
  #juntamos con el stage para ver si cambiaron las noches (+4 se usan las otras dos tablas)
  #Formato_351_vencimiento = left_join(Formato_351_vencimiento, Stage1, by = "DealID", multiple = "all" )  #QUITAR EL ALL DESPUES DE QUE MARIA JOSE LIMPIE EL ARCHIVO 
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, Stage1, by = "DealID")  #QUITAR EL ALL DESPUES DE QUE MARIA JOSE LIMPIE EL ARCHIVO 
  
  #Juntamos con las tres tablas para luego hacer el condicional
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_118_sin_stage, by = "c106")
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_118_con_stage_corpo, by = "c106")
  Formato_351_vencimiento = left_join(Formato_351_vencimiento, parametros_118_con_stage_sobe, by = "c106")
  
  Formato_351_vencimiento$c118 = ifelse(Formato_351_vencimiento$noches >= 4 & Formato_351_vencimiento$DealID != 715027689,
                                        case_when( 
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 1 & Formato_351_vencimiento$c94_para_c118 <= 365 ~ Formato_351_vencimiento$corpo_1_365,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 366 & Formato_351_vencimiento$c94_para_c118 <= 730 ~ Formato_351_vencimiento$corpo_366_730,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 731 & Formato_351_vencimiento$c94_para_c118 <= 1095 ~ Formato_351_vencimiento$corpo_731_1095,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 1096 & Formato_351_vencimiento$c94_para_c118 <= 1460 ~ Formato_351_vencimiento$corpo_1096_1460,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 1461 & Formato_351_vencimiento$c94_para_c118 <= 1825 ~ Formato_351_vencimiento$corpo_1461_1825,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 1826 & Formato_351_vencimiento$c94_para_c118 <= 2190 ~ Formato_351_vencimiento$corpo_1826_2190,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 2191 & Formato_351_vencimiento$c94_para_c118 <= 2555 ~ Formato_351_vencimiento$corpo_2191_2555,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 2556 & Formato_351_vencimiento$c94_para_c118 <= 2920 ~ Formato_351_vencimiento$corpo_2556_2920,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 2921 & Formato_351_vencimiento$c94_para_c118 <= 3285 ~ Formato_351_vencimiento$corpo_2921_3285,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 3286 & Formato_351_vencimiento$c94_para_c118 <= 3650 ~ Formato_351_vencimiento$corpo_3286_3650,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 3651 & Formato_351_vencimiento$c94_para_c118 <= 4015 ~ Formato_351_vencimiento$corpo_3651_4015,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 4016 & Formato_351_vencimiento$c94_para_c118 <= 4380 ~ Formato_351_vencimiento$corpo_4016_4380,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 4381 & Formato_351_vencimiento$c94_para_c118 <= 4745 ~ Formato_351_vencimiento$corpo_4381_4745,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 4746 & Formato_351_vencimiento$c94_para_c118 <= 5110 ~ Formato_351_vencimiento$corpo_4746_5110,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 5111 & Formato_351_vencimiento$c94_para_c118 <= 5475 ~ Formato_351_vencimiento$corpo_5111_5475,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 5476 & Formato_351_vencimiento$c94_para_c118 <= 5840 ~ Formato_351_vencimiento$corpo_5476_5840,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 5841 & Formato_351_vencimiento$c94_para_c118 <= 6205 ~ Formato_351_vencimiento$corpo_5841_6205,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 6206 & Formato_351_vencimiento$c94_para_c118 <= 6570 ~ Formato_351_vencimiento$corpo_6206_6570,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 6571 & Formato_351_vencimiento$c94_para_c118 <= 6935 ~ Formato_351_vencimiento$corpo_6571_6935,
                                          Formato_351_vencimiento$c101 == "Corporativos" & Formato_351_vencimiento$c94_para_c118 >= 6936  ~ Formato_351_vencimiento$`corpo_6936_+`,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 1 & Formato_351_vencimiento$c94_para_c118 <= 365  ~ Formato_351_vencimiento$sobe_1_365,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 366 & Formato_351_vencimiento$c94_para_c118 <= 730  ~ Formato_351_vencimiento$sobe_366_730,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 731 & Formato_351_vencimiento$c94_para_c118 <= 1095  ~ Formato_351_vencimiento$sobe_731_1095,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 1096 & Formato_351_vencimiento$c94_para_c118 <= 1460  ~ Formato_351_vencimiento$sobe_1096_1460,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 1461 & Formato_351_vencimiento$c94_para_c118 <= 1825  ~ Formato_351_vencimiento$sobe_1461_1825,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 1826 & Formato_351_vencimiento$c94_para_c118 <= 2190  ~ Formato_351_vencimiento$sobe_1826_2190,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 2191 & Formato_351_vencimiento$c94_para_c118 <= 2555  ~ Formato_351_vencimiento$sobe_2191_2555,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 2556 & Formato_351_vencimiento$c94_para_c118 <= 2920  ~ Formato_351_vencimiento$sobe_2556_2920,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 2921 & Formato_351_vencimiento$c94_para_c118 <= 3285  ~ Formato_351_vencimiento$sobe_2921_3285,
                                          Formato_351_vencimiento$c101 == "Soberanos" & Formato_351_vencimiento$c94_para_c118 >= 3286 ~ Formato_351_vencimiento$`sobe_3286_+`,
                                          Formato_351_vencimiento$c101 == "Davivienda" ~ Formato_351_vencimiento$DAVIVIENDA),
                                        case_when(
                                          Formato_351_vencimiento$DealID != 715027689 & Formato_351_vencimiento$c101 == "Corporativos" ~ Formato_351_vencimiento$CORPORATIVOS,
                                          Formato_351_vencimiento$DealID != 715027689 & Formato_351_vencimiento$c101 == "Soberanos" ~ Formato_351_vencimiento$SOBERANOS,
                                          Formato_351_vencimiento$DealID != 715027689 & Formato_351_vencimiento$c101 == "Davivienda" ~ Formato_351_vencimiento$DAVIVIENDA,
                                          TRUE ~ NA_integer_) )
  
  
  #Columna 119
  Formato_351_vencimiento$c119 = case_when(
    Formato_351_vencimiento$DealID != 715027689 & as.numeric(Formato_351_vencimiento$c94_para_c118) >= 366 ~ 1 * Formato_351_vencimiento$c118,
    Formato_351_vencimiento$DealID != 715027689 & as.numeric(Formato_351_vencimiento$c94_para_c118) < 366 ~ (as.numeric(Formato_351_vencimiento$c94_para_c118) / 365)*Formato_351_vencimiento$c118,
    TRUE ~ NA_integer_)
  
  #Columna 120
  Formato_351_vencimiento$c120 = case_when(
    Formato_351_vencimiento$DealID != 715027689 & as.numeric(Formato_351_vencimiento$c96) >= 91 ~ "No",
    Formato_351_vencimiento$DealID != 715027689 & as.numeric(Formato_351_vencimiento$c96) < 91 ~ "Si",
    TRUE ~ "No aplica")
  
  #Columna 121
  Formato_351_vencimiento$c121 = case_when(
    Formato_351_vencimiento$DealID != 715027689 & Formato_351_vencimiento$c117 != "No aplica" & Formato_351_vencimiento$c120 == "No" ~ as.numeric(Formato_351_vencimiento$c31) * as.numeric(Formato_351_vencimiento$c102) * as.numeric(Formato_351_vencimiento$c119),
    Formato_351_vencimiento$DealID != 715027689 & Formato_351_vencimiento$c117 != "No aplica" & Formato_351_vencimiento$c120 == "Si" ~ 0,
    Formato_351_vencimiento$DealID == 715027689 & Formato_351_vencimiento$c117 == "No aplica" & Formato_351_vencimiento$c120 == "No aplica" ~ 0,
    TRUE ~ NA_integer_)
  
  #columna 133
  Formato_351_vencimiento <- Formato_351_vencimiento %>% mutate(c133 = c116 - c121)  
  
  
  #------------------------------------------ Limpiamos la data 
  Formato_351_vencimiento_final = Formato_351_vencimiento[,c("c0",  
                                                             "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                             "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                             "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                             "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                             "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                             "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                             "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                             "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                             "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                             "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                             "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                             "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                             "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                             "c127","c128","c129","c130","c131","c132","c133")]
  
  Formato_351_vencimiento_final <- Formato_351_vencimiento_final[order(Formato_351_vencimiento_final$c0), ]
  
  #Redondeamos todos los datos numericos a 2 decimales 
  Formato_351_vencimiento_final <- Formato_351_vencimiento_final %>% 
    mutate(across(where(is.numeric), ~ round(., 5)))
  
  #-------------------------------- Aqui revisamos si hay reportos 
  
  if (nrow(reportos) > 0) { 
    
    #Cruzamos con homologado
    reportos_V = left_join(reportos, homologado, by = c("Cuenta_contable","TipoValor"))
    
    #limpiamos formato 351 quitando las columnas que ya estan en reportos 
    Formato_351_vencimiento_reportos = Formato_351_vencimiento %>% select(-c("Cuenta_contable","TipoValor","c72","Descripcion","c2","DescripcionCUIF", "c9","c24","c90","c91"))
    
    #Creamos reportos_2 si es que hay 
    reportos_2 = merge(reportos_V, Formato_351_vencimiento_reportos, by = c("DealID"))
    
    if (nrow(reportos_2) > 0) { 
      
      #Cambiamos las columnas monetarias 
      reportos_2 <- reportos_2 %>% 
        mutate(c17 = Monto,
               c19 = Monto,
               c22 = Monto,
               c23 = Monto * tasa_de_cambio,
               c30 = Monto * tasa_de_cambio,
               c31 = Monto * tasa_de_cambio,
               c32 = Monto,
               c73 = Monto,
               c113 = Monto * tasa_de_cambio,
               c115 = Monto * tasa_de_cambio,
               c116 = Monto * tasa_de_cambio,
               c121 = 0,
               c132 = c116 - c30,
               c133 = Monto * tasa_de_cambio)
      
      #Columna 121
      reportos_2$c121 = case_when(
        reportos_2$DealID != 715027689 & reportos_2$c117 != "No aplica" & reportos_2$c120 == "No" ~ as.numeric(reportos_2$c31) * as.numeric(reportos_2$c102) * as.numeric(reportos_2$c119),
        reportos_2$DealID != 715027689 & reportos_2$c117 != "No aplica" & reportos_2$c120 == "Si" ~ 0,
        TRUE ~ NA_integer_)
      
      reportos_2 <- reportos_2 %>% 
        mutate(c133 = c133 - c121)
      
      #Ordenamos reportos
      reportos_2 = reportos_2[,c("c0",  
                                 "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                 "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                 "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                 "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                 "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                 "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                 "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                 "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                 "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                 "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                 "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                 "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                 "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                 "c127","c128","c129","c130","c131","c132","c133")]
      
      #redondear reportos -OJO ESTO SE PUEDE PONER AL FINAL CUANDO YA TENGAMOS TODOS LOS REPORTOS UNIDOS - esto es solo una prueba 
      #Redondeamos todos los datos numericos a 2 decimales 
      reportos_2 <- reportos_2 %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
      #Hacer un group_by para sumar todas las inversiones hijas, para restarle el total a la inversión madre
      reportos_2_agrupado  =  reportos_2 %>% select(c1,c17,c19,c22,c23,c30,c31,c32,c113,c115, c116,c121, c133) 
      reportos_2_agrupado <- reportos_2_agrupado %>% 
        group_by(c1) %>% 
        summarise(c17_a2 = sum(c17),
                  c19_a2 = sum(c19),
                  c22_a2 = sum(c22),
                  c23_a2 = sum(c23),
                  c30_a2 = sum(c30),
                  c31_a2 = sum(c31),
                  c32_a2 = sum(c32),
                  c113_a2 = sum(c113),
                  c115_a2 = sum(c115), 
                  c116_a2 = sum(c116),
                  c121_a4 = sum(c121),
                  c133_a2 = sum(c133),
                  .groups = 'drop') 
      
      #Como hay reportos entonces formato_351_participativas_final va a cambiar restando el monto 
      Formato_351_vencimiento_final = case_when( Formato_351_vencimiento_final$c1 == reportos_2_agrupado$c1 ~ Formato_351_vencimiento_final %>%  mutate (c17 = c17 - reportos_2_agrupado$c17_a2,
                                                                                                                                                         c19 = c19 - reportos_2_agrupado$c19_a2,
                                                                                                                                                         c22 = c22 - reportos_2_agrupado$c22_a2,
                                                                                                                                                         c23 = c23 - reportos_2_agrupado$c23_a2,
                                                                                                                                                         c30 = c30 - reportos_2_agrupado$c30_a2,
                                                                                                                                                         c31 = c31 - reportos_2_agrupado$c31_a2,
                                                                                                                                                         c32 = c32 - reportos_2_agrupado$c32_a2,
                                                                                                                                                         c113 = c113 - reportos_2_agrupado$c113_a2,
                                                                                                                                                         c115 = c115 - reportos_2_agrupado$c115_a2, 
                                                                                                                                                         c116 = c116 - reportos_2_agrupado$c116_a2,
                                                                                                                                                         c121 = c121 - reportos_2_agrupado$c121_a4,
                                                                                                                                                         c132 = 0,
                                                                                                                                                         c133 = c133 - reportos_2_agrupado$c133_a2), 
                                                 TRUE ~ Formato_351_vencimiento_final) 
      
      #Redondeamos los datos
      #Redondeamos todos los datos numericos a 2 decimales 
      Formato_351_vencimiento_final <- Formato_351_vencimiento_final %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
    } else {"No hay reportos en vencimiento 2 - despues de comprobar que hay reportos (despues de join)"}
    
  } else {"No hay reportos en vencimiento 1"}
  
} else {
  # Ejecutar código si no hay observaciones
  print("No hay inversiones para mantener hasta el vencimiento")
}


#======================================= DEPOSITOS A PLAZO =======================
# Verificar si hay observaciones en el data frame
if (nrow(New_PL_DataBase_depositos) > 0) {
  
  #Cruzamos con new_pl y homologado
  Formato_351_depositos = merge(New_PL_DataBase_depositos, homologado, by = "Cuenta_contable")
  
  #Cruzamos con setup para tener la columna 22 - llave dealID
  Formato_351_depositos = left_join(Formato_351_depositos, New_PL_setup, by = "DealID")
  
  #cruzamos con PIP
  Formato_351_depositos = left_join(Formato_351_depositos, PIP, by = "DealID")
  
  #cruzamos con prospecto
  Formato_351_depositos = left_join(Formato_351_depositos, prospecto, by = "DealID")
  
  #cruzamos con plano integrado
  Formato_351_depositos = left_join(Formato_351_depositos, Plano_integrado, by = "DealID")
  
  #cruzamos con plano portafolio
  Formato_351_depositos = left_join(Formato_351_depositos, Plano_Portafolio, by = "DealID")
  
  #Columna 74
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_pais, by = "c97")
  
  #columna 76 
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_emisor, by = "c75")
  
  #Columna 101 - 106 - 105 - 103
  Formato_351_depositos =left_join(Formato_351_depositos, Calif_Deterioro, by = "c76")
  
  #columna c37
  Formato_351_depositos =left_join(Formato_351_depositos, InversionesNuevasTV, by = "DealID")
  
  #creamos la columna 0
  Formato_351_depositos$c0 = row_number(Formato_351_depositos$DealID)
  
  #creamos la columna 1 
  Formato_351_depositos$c1 = str_remove_all( paste("CAM084-",Formato_351_depositos$DealID)," ")    
  
  #Creamos las columnas fijas
  Formato_351_depositos <- Formato_351_depositos %>% 
    mutate(c3 = 3,
           c4 = " ",
           c5 = " ", 
           c6 = " ", 
           c7 = " ", 
           c8 = " ", 
           c10 = " ", 
           c11 = 3,
           c14 = " ", 
           c16 = "USD",
           c20 = " ",
           c21 = " ",
           c28 = 1,
           c29 = 1,
           c35 = " ",
           c36 = " ",
           c38 = " ",
           c39 = " ",
           c40 = 1,
           c41 = 21,
           c44 = " ",
           c45 = " ",
           c46 = " ",
           c47 = " ",
           c48 = " ",
           c51 = "A",
           c52 = " ",
           c53 = " ",
           c54 = " ",
           c55 = 3,
           c57 = " ",
           c58 = " ",
           c59 = " ",
           c60 = " ",
           c61 = " ",
           c62 = " ",
           c63 = " ",
           c64 = 411106,
           c65 = " ",
           c66 = " ",
           c67 = " ", 
           c68 = 3,
           c69 = " ",
           c70 = " ",
           c71 = " ",
           c72 = " ",
           c73 = " ",
           c77 = " ",
           c78 = " ",
           c79 = " ",
           c80 = 13,
           c81 = "Banco Davivienda Salvadoreño",
           c82 = "El Salvador",
           c104 = " ",
           c106.1= " ",
           c106.2= " ",
           c106.3= " ",
           c106.4= " ",
           c108 = " ",
           c109 = " ",
           c110 = " ",
           c111 = " ",
           c112 = " ",
           c122 = " ",
           c123 = " ",
           c128 = "Dólar Americano",
           c129 = "Moneda Extranjera",
           c130 = " ",
           c131 = str_remove_all(paste(dia,mes,año)," " )) 
  
  #columna 43 
  Formato_351_depositos$c43 = ifelse(is.na(Formato_351_depositos$c42),NA_integer_,Formato_351_depositos$c32)
  
  #Asigna numero a calificación país
  #Columna 50
  Formato_351_depositos$c50 <- 
    ifelse(Formato_351_depositos$Inter_cal_FITCH_RATINGS != "0" , 4,
           ifelse(Formato_351_depositos$Inter_cal_SyP != "0" ,3,
                  ifelse(Formato_351_depositos$Inter_cal_MOODYS != "0" ,5,
                         ifelse(Formato_351_depositos$CalificaciónPaísFinalDelEmisor != "0" ,Formato_351_depositos$c50_opcion4, NA_integer_)))) 
  
  #Hacer una columna que guarde la calificación para la columna 49
  Formato_351_depositos$calificacion = case_when(Formato_351_depositos$c50 == 4 ~ ifelse(Formato_351_depositos$Inter_cal_FITCH_RATINGS != "0", Formato_351_depositos$Inter_cal_FITCH_RATINGS, 
                                                                                         ifelse(Formato_351_depositos$P_calif_ficht != "0", Formato_351_depositos$P_calif_ficht, 'Error' )) , 
                                                 Formato_351_depositos$c50 == 3 ~ ifelse(Formato_351_depositos$Inter_cal_SyP != "0", Formato_351_depositos$Inter_cal_SyP, 
                                                                                         ifelse(Formato_351_depositos$Inter_cal_SyP != "0", Formato_351_depositos$P_calif_SyP ,'Error')) ,
                                                 Formato_351_depositos$c50 == 5 ~ ifelse(Formato_351_depositos$Inter_cal_MOODYS != "0", Formato_351_depositos$Inter_cal_MOODYS, 
                                                                                         ifelse(Formato_351_depositos$P_Calif_moodys != "0", Formato_351_depositos$P_Calif_moodys,'Error') ),
                                                 TRUE ~ 'Error 1')
  
  #Columna 49 calificación en letra a su homolgación en numero 
  Formato_351_depositos$c49 = case_when(
    (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 | Formato_351_depositos$c50 == 5) & Formato_351_depositos$calificacion == "AAA" ~ 20,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "AA+")  | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "AA1") ~ 21,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "AA")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "AA2") ~ 22,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "AA-")  | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "AA3") ~ 23,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "A+")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "A1")  ~ 24,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "A")    | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "A2")  ~ 25,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "A-")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "A3")  ~ 26,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "BBB+") | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "BAA1") ~ 27,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "BBB")  | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "BAA2") ~ 28,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "BBB-") | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "BAA3") ~ 29,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "BB+")  | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "BA1")  ~ 30,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "BB")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "BA2")  ~ 31,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "BB-")  | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "BA3")  ~ 32,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "B+")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "B1")   ~ 33,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "B")    | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "B2")   ~ 34,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "B-")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "B3")   ~ 35,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "CCC+") | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "CAA1") ~ 36,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "CCC")  | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "CAA2") ~ 37,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "CCC-") | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "CAA3") ~ 38,
    ( (Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 )  & Formato_351_depositos$calificacion == "CC")   | (Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "CA")   ~ 39,
    ( Formato_351_depositos$c50 == 4 | Formato_351_depositos$c50 == 3 | Formato_351_depositos$c50 == 5) & Formato_351_depositos$calificacion == "C" ~ 40,
    Formato_351_depositos$c50 == 4 & Formato_351_depositos$calificacion == "DDD"  ~ 41,
    Formato_351_depositos$c50 == 4 & Formato_351_depositos$calificacion == "DD"  ~ 42,
    Formato_351_depositos$c50 == 4 & Formato_351_depositos$calificacion == "D"  ~ 43,
    Formato_351_depositos$c50 == 5 & Formato_351_depositos$calificacion == "D"  ~ 41)   
  
  #Columna 124 y 125 
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_CalificacionSeparado, by = "c49")
  
  #Columa 126 y 127
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_calificacionesConsolidado, by = "c106")
  
  #Multiplicamos la tasa de cambio por la C22 para crear la c23
  Formato_351_depositos <- Formato_351_depositos %>% 
    mutate(c19 = c17,
           c22 = c17,
           c23 = tasa_de_cambio * c22,
           c30 =  tasa_de_cambio * c32, 
           c31 = c30, 
           c34 = c13_date - fechaCorte,  
           c88 = c85,
           c93 = c25,
           c113 = c30,
           c115 = c30,
           c116 = c30,
           c132 = c116 - c30)
  
  #Columna 12 para cuando c9 es CDEBE
  Formato_351_depositos$c12 = case_when(
    Formato_351_depositos$c9 == "CDEBE" ~ Formato_351_depositos$c15,
    TRUE ~ Formato_351_depositos$c12)
  
  
  #Columna 84 
  Formato_351_depositos$c84 = case_when(
    Formato_351_depositos$c83 == "Estructural - Reserva de Liquidez Interna Estratégica"  ~ "Portafolio Mínimo",
    Formato_351_depositos$c83 == "Estructural - Gestión Balance"  ~ "Gestión Balance",
    Formato_351_depositos$c83 == "Estructural - Reserva de Liquidez Regulatoria Estratégica" ~ "Liquidez regulatoria",
    Formato_351_depositos$c83 == "Estructural - Gestión Balance GOES"  ~ "Gestión Balance GOES",
    TRUE ~ NA_character_ )
  
  #Columna 86 
  Formato_351_depositos$c86 = case_when(
    Formato_351_depositos$c83 == "Estructural - Reserva de Liquidez Interna Estratégica"  ~ "Hold To Collect & Sale - HTC&S",
    Formato_351_depositos$c83 == "Estructural - Gestión Balance"  ~ "Hold To Collect - HTC",
    Formato_351_depositos$c83 == "Estructural - Reserva de Liquidez Regulatoria Estratégica" ~ "Hold To Collect & Sale - HTC&S",
    Formato_351_depositos$c83 == "Estructural - Gestión Balance GOES"  ~ "Hold To Collect - HTC",
    TRUE ~ NA_character_ )
  
  #columna 89 
  Formato_351_depositos$c89 = case_when(
    Formato_351_depositos$c86 == "Hold To Collect - HTC" &  Formato_351_depositos$c87 == "Cumple" ~ "Costo Amortizado cambios en P&G",
    Formato_351_depositos$c86 == "Hold To Collect - HTC" &  Formato_351_depositos$c87 == "No cumple" ~ "Valor Razonable cambios en P&G",
    Formato_351_depositos$c86 == "Hold To Collect & Sale - HTC&S" &  Formato_351_depositos$c87 == "Cumple" ~ "Valor Razonable cambios en ORI",
    Formato_351_depositos$c86 == "Hold To Collect & Sale - HTC&S" &  Formato_351_depositos$c87 == "No cumple" ~ "Valor Razonable cambios en P&G",
    Formato_351_depositos$c86 == "Instrumentos de Patrimonio" &  Formato_351_depositos$c87 == "No aplica" ~ "Valor Razonable cambios en ORI",
    Formato_351_depositos$c86 == "Hold To Sale - HTS" &  Formato_351_depositos$c87 == "No aplica" ~ "Valor Razonable cambios en P&G",
    TRUE ~ "Inválido")
  
  #columna 94 
  Formato_351_depositos$c34_caracter = as.character(Formato_351_depositos$c34)
  Formato_351_depositos$c94 = case_when(
    Formato_351_depositos$c91 == "Deuda Pública" | Formato_351_depositos$c91 == "Deuda Privada" & Formato_351_depositos$c34_caracter != is.na(Formato_351_depositos$c34_caracter) ~ Formato_351_depositos$c34_caracter,
    Formato_351_depositos$c91 == "Títulos Participativos" ~ "No Aplica",
    TRUE ~ "Inválido")
  
  #Columna 95 
  Formato_351_depositos$c95 <- ifelse(Formato_351_depositos$c91 == "Fondos de inversión" & substr(Formato_351_depositos$c2, start = 1, stop = 4) == "1360",
                                      "De 0 a 1 años",
                                      case_when(
                                        Formato_351_depositos$c94 == "No Aplica"  ~ "No Aplica",
                                        is.numeric(as.numeric(Formato_351_depositos$c94)) & as.numeric(Formato_351_depositos$c94) >= 1 & as.numeric(Formato_351_depositos$c94) <= 365 ~ "De 0 a 1 años",
                                        is.numeric(as.numeric(Formato_351_depositos$c94)) & as.numeric(Formato_351_depositos$c94) >= 366 & as.numeric(Formato_351_depositos$c94) <= 1825 ~ "De 1 a 5 años",
                                        is.numeric(as.numeric(Formato_351_depositos$c94)) & as.numeric(Formato_351_depositos$c94) >= 1826 & as.numeric(Formato_351_depositos$c94) <= 3650 ~ "De 5 a 10 años",
                                        is.numeric(as.numeric(Formato_351_depositos$c94)) & as.numeric(Formato_351_depositos$c94) >= 3651 ~ "Más de 10 años",
                                        TRUE ~ "Inválido"))
  
  #columna 96 
  Formato_351_depositos$c96 = case_when(
    Formato_351_depositos$c91 == "Deuda Pública" | Formato_351_depositos$c91 == "Deuda Privada"  ~ as.character(Formato_351_depositos$c13_date - Formato_351_depositos$c12_date),
    Formato_351_depositos$c91 == "No Aplica" ~ "No Aplica",
    TRUE ~ "Inválido")
  
  #Columna 99
  Formato_351_depositos$c99 = case_when(
    Formato_351_depositos$c98 == "Gobierno Colombiano" ~ "Gobierno Colombiano",
    Formato_351_depositos$c98 == "Gobierno Extranjero" ~ "Gobierno Extranjero",
    Formato_351_depositos$c98 == "Instituciones Oficiales Especiales - IOE - Colombia" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Bancos en Colombia" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Bancos en el Exterior" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Instituciones Financieras en Colombia diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Instituciones Financieras en el Exterior diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Corporativo en Colombia" ~ "Entidades del Sector Real",
    Formato_351_depositos$c98 == "Corporativo en el Exterior" ~ "Entidades del Sector Real",
    Formato_351_depositos$c98 == "Organismos Multilaterales de Crédito" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Titularizadora" ~ "Otros",
    TRUE ~ "Inválido")
  
  #columna 100
  Formato_351_depositos$c100 = case_when(
    Formato_351_depositos$c98 == "Gobierno Colombiano" ~ "Gobierno Nacional",
    Formato_351_depositos$c98 == "Gobierno Extranjero" ~ "Gobiernos Extranjeros",
    Formato_351_depositos$c98 == "Instituciones Oficiales Especiales - IOE - Colombia" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Bancos en Colombia" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Bancos en el Exterior" ~ "Bancos en el Exterior",
    Formato_351_depositos$c98 == "Instituciones Financieras en Colombia diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Instituciones Financieras en el Exterior diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_depositos$c98 == "Corporativo en Colombia" ~ "Corporativo",
    Formato_351_depositos$c98 == "Corporativo en el Exterior" ~ "Corporativo",
    Formato_351_depositos$c98 == "Organismos Multilaterales de Crédito" ~ "Organismos Multilaterales de Crédito",
    Formato_351_depositos$c98 == "Titularizadora" ~ "Titularizaciones",
    TRUE ~ "Inválido")
  
  #columna 102
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_Riesgo_de_credito, by = "c101")
  
  #Formato_351_depositos$c102 = case_when(
  #  Formato_351_depositos$c101 == "Soberanos ML" ~ "0.47",
  #  Formato_351_depositos$c101 == "Soberanos" ~ "0.47",
  #  Formato_351_depositos$c101 == "Corporativos" ~ "0.623",
  #  Formato_351_depositos$c101 == "Davivienda" ~  "0.623",
  #  Formato_351_depositos$c101 == "Participativos" ~ "No Aplica",
  #  TRUE ~ "Inválido")
  
  #columna 114 
  Formato_351_depositos$c114 = case_when(
    (Formato_351_depositos$c85 == "Al Vencimiento" | Formato_351_depositos$c85 == "Al vencimiento") ~ as.character(Formato_351_depositos$c30),
    (Formato_351_depositos$c85 == "Al Vencimiento" | Formato_351_depositos$c85 == "Al vencimiento") & as.character(Formato_351_depositos$c30) == is.na(as.character(Formato_351_depositos$c30)) ~ "Inválido",
    TRUE ~ "No Aplica")
  
  #Columna 117 
  Formato_351_depositos$c117 = case_when(
    Formato_351_depositos$DealID == 715027689 ~ "No aplica",
    TRUE ~ " ")
  
  
  #Columna 118
  #Hacemos una nueva columna numerica con los datos de la 94 para poder manipular y sacar la 118 
  Formato_351_depositos$c94_para_c118 = as.numeric(Formato_351_depositos$c94)
  
  #juntamos con el stage para ver si cambiaron las noches (+4 se usan las otras dos tablas)
  Formato_351_depositos = left_join(Formato_351_depositos, Stage1, by = "DealID", multiple = "all" )  #QUITAR EL ALL DESPUES DE QUE MARIA JOSE LIMPIE EL ARCHIVO 
  
  #Juntamos con las tres tablas para luego hacer el condicional
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_118_sin_stage, by = "c106")
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_118_con_stage_corpo, by = "c106")
  Formato_351_depositos = left_join(Formato_351_depositos, parametros_118_con_stage_sobe, by = "c106")
  
  Formato_351_depositos$c118 = ifelse(Formato_351_depositos$noches >= 4 & Formato_351_depositos$DealID != 715027689,
                                      case_when( 
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 1 & Formato_351_depositos$c94_para_c118 <= 365 ~ Formato_351_depositos$corpo_1_365,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 366 & Formato_351_depositos$c94_para_c118 <= 730 ~ Formato_351_depositos$corpo_366_730,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 731 & Formato_351_depositos$c94_para_c118 <= 1095 ~ Formato_351_depositos$corpo_731_1095,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 1096 & Formato_351_depositos$c94_para_c118 <= 1460 ~ Formato_351_depositos$corpo_1096_1460,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 1461 & Formato_351_depositos$c94_para_c118 <= 1825 ~ Formato_351_depositos$corpo_1461_1825,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 1826 & Formato_351_depositos$c94_para_c118 <= 2190 ~ Formato_351_depositos$corpo_1826_2190,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 2191 & Formato_351_depositos$c94_para_c118 <= 2555 ~ Formato_351_depositos$corpo_2191_2555,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 2556 & Formato_351_depositos$c94_para_c118 <= 2920 ~ Formato_351_depositos$corpo_2556_2920,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 2921 & Formato_351_depositos$c94_para_c118 <= 3285 ~ Formato_351_depositos$corpo_2921_3285,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 3286 & Formato_351_depositos$c94_para_c118 <= 3650 ~ Formato_351_depositos$corpo_3286_3650,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 3651 & Formato_351_depositos$c94_para_c118 <= 4015 ~ Formato_351_depositos$corpo_3651_4015,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 4016 & Formato_351_depositos$c94_para_c118 <= 4380 ~ Formato_351_depositos$corpo_4016_4380,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 4381 & Formato_351_depositos$c94_para_c118 <= 4745 ~ Formato_351_depositos$corpo_4381_4745,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 4746 & Formato_351_depositos$c94_para_c118 <= 5110 ~ Formato_351_depositos$corpo_4746_5110,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 5111 & Formato_351_depositos$c94_para_c118 <= 5475 ~ Formato_351_depositos$corpo_5111_5475,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 5476 & Formato_351_depositos$c94_para_c118 <= 5840 ~ Formato_351_depositos$corpo_5476_5840,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 5841 & Formato_351_depositos$c94_para_c118 <= 6205 ~ Formato_351_depositos$corpo_5841_6205,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 6206 & Formato_351_depositos$c94_para_c118 <= 6570 ~ Formato_351_depositos$corpo_6206_6570,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 6571 & Formato_351_depositos$c94_para_c118 <= 6935 ~ Formato_351_depositos$corpo_6571_6935,
                                        Formato_351_depositos$c101 == "Corporativos" & Formato_351_depositos$c94_para_c118 >= 6936  ~ Formato_351_depositos$`corpo_6936_+`,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 1 & Formato_351_depositos$c94_para_c118 <= 365  ~ Formato_351_depositos$sobe_1_365,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 366 & Formato_351_depositos$c94_para_c118 <= 730  ~ Formato_351_depositos$sobe_366_730,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 731 & Formato_351_depositos$c94_para_c118 <= 1095  ~ Formato_351_depositos$sobe_731_1095,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 1096 & Formato_351_depositos$c94_para_c118 <= 1460  ~ Formato_351_depositos$sobe_1096_1460,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 1461 & Formato_351_depositos$c94_para_c118 <= 1825  ~ Formato_351_depositos$sobe_1461_1825,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 1826 & Formato_351_depositos$c94_para_c118 <= 2190  ~ Formato_351_depositos$sobe_1826_2190,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 2191 & Formato_351_depositos$c94_para_c118 <= 2555  ~ Formato_351_depositos$sobe_2191_2555,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 2556 & Formato_351_depositos$c94_para_c118 <= 2920  ~ Formato_351_depositos$sobe_2556_2920,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 2921 & Formato_351_depositos$c94_para_c118 <= 3285  ~ Formato_351_depositos$sobe_2921_3285,
                                        Formato_351_depositos$c101 == "Soberanos" & Formato_351_depositos$c94_para_c118 >= 3286 ~ Formato_351_depositos$`sobe_3286_+`,
                                        Formato_351_depositos$c101 == "Davivienda" ~ Formato_351_depositos$DAVIVIENDA),
                                      case_when(
                                        Formato_351_depositos$DealID != 715027689 & Formato_351_depositos$c101 == "Corporativos" ~ Formato_351_depositos$CORPORATIVOS,
                                        Formato_351_depositos$DealID != 715027689 & Formato_351_depositos$c101 == "Soberanos" ~ Formato_351_depositos$SOBERANOS,
                                        Formato_351_depositos$DealID != 715027689 & Formato_351_depositos$c101 == "Davivienda" ~ Formato_351_depositos$DAVIVIENDA,
                                        TRUE ~ NA_integer_) )
  
  
  #Columna 119
  Formato_351_depositos$c119 = case_when(
    Formato_351_depositos$DealID != 715027689 & as.numeric(Formato_351_depositos$c94_para_c118) >= 366 ~ 1 * Formato_351_depositos$c118,
    Formato_351_depositos$DealID != 715027689 & as.numeric(Formato_351_depositos$c94_para_c118) < 366 ~ (as.numeric(Formato_351_depositos$c94_para_c118) / 365)*Formato_351_depositos$c118,
    TRUE ~ NA_integer_)
  
  #Columna 120
  Formato_351_depositos$c120 = case_when(
    Formato_351_depositos$DealID != 715027689 & as.numeric(Formato_351_depositos$c96) >= 91 ~ "No",
    Formato_351_depositos$DealID != 715027689 & as.numeric(Formato_351_depositos$c96) < 91 ~ "Si",
    TRUE ~ "No aplica")
  
  #Columna 121
  Formato_351_depositos$c121 = case_when(
    Formato_351_depositos$DealID != 715027689 & Formato_351_depositos$c117 != "No aplica" & Formato_351_depositos$c120 == "No" ~ as.numeric(Formato_351_depositos$c31) * as.numeric(Formato_351_depositos$c102) * as.numeric(Formato_351_depositos$c119),
    Formato_351_depositos$DealID != 715027689 & Formato_351_depositos$c117 != "No aplica" & Formato_351_depositos$c120 == "Si" ~ 0,
    TRUE ~ NA_integer_)
  
  #columna 133
  Formato_351_depositos <- Formato_351_depositos %>% mutate(c133 = c116 - c121)
  #------------------------------------------ Limpiamos la data 
  Formato_351_depositos_final = Formato_351_depositos[,c("c0",  
                                                         "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                         "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                         "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                         "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                         "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                         "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                         "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                         "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                         "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                         "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                         "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                         "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                         "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                         "c127","c128","c129","c130","c131","c132","c133")]
  
  Formato_351_depositos_final <- Formato_351_depositos_final[order(Formato_351_depositos_final$c0), ]
  
  #Redondeamos todos los datos numericos a 2 decimales 
  Formato_351_depositos_final <- Formato_351_depositos_final %>% 
    mutate(across(where(is.numeric), ~ round(., 5)))
  
  
  #-------------------------------- Aqui revisamos si hay reportos 
  
  if (nrow(reportos) > 0) { 
    
    #Cruzamos con homologado
    reportos_D = left_join(reportos, homologado, by = c("Cuenta_contable","TipoValor"))
    
    #limpiamos formato 351 quitando las columnas que ya estan en reportos 
    Formato_351_depositos_reportos = Formato_351_depositos %>% select(-c("Cuenta_contable","TipoValor","c72","Descripcion","c2","DescripcionCUIF", "c9","c24","c90","c91"))
    
    #Creamos reportos_3 si es que hay 
    reportos_3 = merge(reportos_D, Formato_351_depositos_reportos, by = c("DealID"))
    
    if (nrow(reportos_3) > 0) { 
      
      #Cambiamos las columnas monetarias 
      reportos_3 <- reportos_3 %>% 
        mutate(c17 = Monto,
               c19 = Monto,
               c22 = Monto,
               c23 = Monto * tasa_de_cambio,
               c30 = Monto * tasa_de_cambio,
               c31 = Monto * tasa_de_cambio,
               c32 = Monto,
               c73 = Monto,
               c113 = Monto * tasa_de_cambio,
               c115 = Monto * tasa_de_cambio,
               c116 = Monto * tasa_de_cambio,
               c121 = 0,
               c132 = c116 - c30,
               c133 = Monto * tasa_de_cambio)
      
      #Columna 121
      reportos_3$c121 = case_when(
        reportos_3$DealID != 715027689 & reportos_3$c117 != "No aplica" & reportos_3$c120 == "No" ~ as.numeric(reportos_3$c31) * as.numeric(reportos_3$c102) * as.numeric(reportos_3$c119),
        reportos_3$DealID != 715027689 & reportos_3$c117 != "No aplica" & reportos_3$c120 == "Si" ~ 0,
        TRUE ~ NA_integer_)
      
      #Columna 133
      reportos_3 <- reportos_3 %>% 
        mutate(c133 = c133 - c121)
      
      #Ordenamos reportos
      reportos_3 = reportos_3[,c("c0",  
                                 "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                 "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                 "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                 "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                 "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                 "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                 "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                 "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                 "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                 "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                 "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                 "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                 "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                 "c127","c128","c129","c130","c131","c132","c133")]
      
      #redondear reportos -OJO ESTO SE PUEDE PONER AL FINAL CUANDO YA TENGAMOS TODOS LOS REPORTOS UNIDOS - esto es solo una prueba 
      #Redondeamos todos los datos numericos a 2 decimales 
      reportos_3 <- reportos_3 %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
      #Hacer un group_by para sumar todas las inversiones hijas, para restarle el total a la inversión madre
      reportos_3_agrupado  =  reportos_3 %>% select(c1,c17,c19,c22,c23,c30,c31,c32, c113,c115, c116,c121,c133) 
      reportos_3_agrupado <- reportos_3_agrupado %>% 
        group_by(c1) %>% 
        summarise(c17_a3 = sum(c17),
                  c19_a3 = sum(c19),
                  c22_a3 = sum(c22),
                  c23_a3 = sum(c23),
                  c30_a3 = sum(c30),
                  c31_a3 = sum(c31),
                  c32_a3 = sum(c32),
                  c113_a3 = sum(c113),
                  c115_a3 = sum(c115), 
                  c116_a3 = sum(c116),
                  c121_a4 = sum(c121),
                  c133_a3 = sum(c133),
                  .groups = 'drop') 
      
      
      #Como hay reportos entonces formato_351_depositivos_final va a cambiar restando el monto 
      Formato_351_depositos_final = case_when( Formato_351_depositos_final$c1 == reportos_3_agrupado$c1 ~ Formato_351_depositos_final %>%  mutate (c17 = c17 - reportos_3_agrupado$c17_a3,
                                                                                                                                                   c19 = c19 - reportos_3_agrupado$c19_a3,
                                                                                                                                                   c22 = c22 - reportos_3_agrupado$c22_a3,
                                                                                                                                                   c23 = c23 - reportos_3_agrupado$c23_a3,
                                                                                                                                                   c30 = c30 - reportos_3_agrupado$c30_a3,
                                                                                                                                                   c31 = c31 - reportos_3_agrupado$c31_a3,
                                                                                                                                                   c32 = c32 - reportos_3_agrupado$c32_a3,
                                                                                                                                                   c113 = c113 - reportos_3_agrupado$c113_a3,
                                                                                                                                                   c115 = c115 - reportos_3_agrupado$c115_a3, 
                                                                                                                                                   c116 = c116 - reportos_3_agrupado$c116_a3,
                                                                                                                                                   c121 = c121 - reportos_3_agrupado$c121_a4,
                                                                                                                                                   c132 = 0,
                                                                                                                                                   c133 = c133 - reportos_3_agrupado$c133_a3), 
                                               TRUE ~ Formato_351_depositos_final) 
      
      #Redondeamos los datos
      #Redondeamos todos los datos numericos a 2 decimales 
      Formato_351_depositos_final <- Formato_351_depositos_final %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
    } else {"No hay reportos en depositos 2 - despues de comprobar que hay reportos (despues de join)"}
    
  } else {"No hay reportos en depositos 1"}
  
} else {
  # Ejecutar código si no hay observaciones
  print("No hay depositos a plazo")
}


#=================================== Disponible para la venta ====================
# Verificar si hay observaciones en el data frame
if (nrow(New_PL_DataBase_disponible) > 0) {
  
  #Cruzamos con new_pl y homologado
  Formato_351_disponible = merge(New_PL_DataBase_disponible, homologado, by = "Cuenta_contable")
  
  #Cruzamos con setup para tener la columna 22 - llave dealID
  Formato_351_disponible = left_join(Formato_351_disponible, New_PL_setup, by = "DealID")
  
  #cruzamos con PIP
  Formato_351_disponible = left_join(Formato_351_disponible, PIP, by = "DealID")
  
  #cruzamos con prospecto
  Formato_351_disponible = left_join(Formato_351_disponible, prospecto, by = "DealID")
  
  #cruzamos con plano integrado
  Formato_351_disponible = left_join(Formato_351_disponible, Plano_integrado, by = "DealID")
  
  #cruzamos con plano portafolio
  Formato_351_disponible = left_join(Formato_351_disponible, Plano_Portafolio, by = "DealID")
  
  #Columna 74
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_pais, by = "c97")
  
  #columna 76 
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_emisor, by = "c75")
  
  #Columna 101 - 106 - 105 - 103
  Formato_351_disponible =left_join(Formato_351_disponible, Calif_Deterioro, by = "c76")
  
  #columna c37
  Formato_351_disponible =left_join(Formato_351_disponible, InversionesNuevasTV, by = "DealID")
  
  #creamos la columna 0
  Formato_351_disponible$c0 = row_number(Formato_351_disponible$DealID)
  
  #creamos la columna 1 
  Formato_351_disponible$c1 = str_remove_all( paste("CAM084-",Formato_351_disponible$DealID)," ")    
  
  #Creamos las columnas fijas
  Formato_351_disponible <- Formato_351_disponible %>% 
    mutate(c3 = 3,
           c4 = " ",
           c5 = " ", 
           c6 = " ", 
           c7 = " ", 
           c8 = " ", 
           c10 = " ", 
           c11 = 3,
           c14 = " ", 
           c16 = "USD",
           c20 = " ",
           c21 = " ",
           c28 = 1,
           c29 = 1,
           c35 = " ",
           c36 = " ",
           c38 = " ",
           c39 = " ",
           c41 = 21,
           c44 = " ",
           c45 = " ",
           c46 = " ",
           c47 = " ",
           c48 = " ",
           c51 = "A",
           c52 = " ",
           c53 = " ",
           c54 = " ",
           c55 = 3,
           c57 = " ",
           c58 = " ",
           c59 = " ",
           c60 = " ",
           c61 = " ",
           c62 = " ",
           c63 = " ",
           c64 = 411106,
           c65 = " ",
           c66 = " ",
           c67 = " ", 
           c68 = 3,
           c69 = " ",
           c70 = " ",
           c71 = " ",
           c72 = " ",
           c73 = " ",
           c77 = " ",
           c78 = " ",
           c79 = " ",
           c80 = 13,
           c81 = "Banco Davivienda Salvadoreño",
           c82 = "El Salvador",
           c104 = " ",
           c106.1= " ",
           c106.2= " ",
           c106.3= " ",
           c106.4= " ",
           c108 = " ",
           c109 = " ",
           c110 = " ",
           c111 = " ",
           c112 = " ",
           c122 = " ",
           c123 = " ",
           c128 = "Dólar Americano",
           c129 = "Moneda Extranjera",
           c130 = " ",
           c131 = str_remove_all(paste(dia,mes,año)," " )) 
  
  #columna 43 
  Formato_351_disponible$c43 = ifelse(is.na(Formato_351_disponible$c42),NA_integer_,Formato_351_disponible$c32)
  
  #Asigna numero a calificación país
  #Columna 50
  Formato_351_disponible$c50 <- 
    ifelse(Formato_351_disponible$Inter_cal_FITCH_RATINGS != "0" , 4,
           ifelse(Formato_351_disponible$Inter_cal_SyP != "0" ,3,
                  ifelse(Formato_351_disponible$Inter_cal_MOODYS != "0" ,5,
                         ifelse(Formato_351_disponible$CalificaciónPaísFinalDelEmisor != "0" , Formato_351_disponible$c50_opcion4, NA_integer_)))) 
  #Hacer una columna que guarde la calificación para la columna 49
  Formato_351_disponible$calificacion = case_when(Formato_351_disponible$c50 == 4 ~ ifelse(Formato_351_disponible$Inter_cal_FITCH_RATINGS != "0", Formato_351_disponible$Inter_cal_FITCH_RATINGS, 
                                                                                           ifelse(Formato_351_disponible$P_calif_ficht != "0", Formato_351_disponible$P_calif_ficht, 'Error' )) , 
                                                  Formato_351_disponible$c50 == 3 ~ ifelse(Formato_351_disponible$Inter_cal_SyP != "0", Formato_351_disponible$Inter_cal_SyP, 
                                                                                           ifelse(Formato_351_disponible$Inter_cal_SyP != "0", Formato_351_disponible$P_calif_SyP ,'Error')) ,
                                                  Formato_351_disponible$c50 == 5 ~ ifelse(Formato_351_disponible$Inter_cal_MOODYS != "0", Formato_351_disponible$Inter_cal_MOODYS, 
                                                                                           ifelse(Formato_351_disponible$P_Calif_moodys != "0", Formato_351_disponible$P_Calif_moodys,'Error') ),
                                                  TRUE ~ 'Error 1')
  
  #Columna 49 calificación en letra a su homolgación en numero 
  Formato_351_disponible$c49 = case_when(
    (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 | Formato_351_disponible$c50 == 5) & Formato_351_disponible$calificacion == "AAA" ~ 20,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "AA+")  | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "AA1") ~ 21,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "AA")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "AA2") ~ 22,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "AA-")  | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "AA3") ~ 23,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "A+")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "A1")  ~ 24,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "A")    | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "A2")  ~ 25,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "A-")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "A3")  ~ 26,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "BBB+") | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "BAA1") ~ 27,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "BBB")  | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "BAA2") ~ 28,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "BBB-") | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "BAA3") ~ 29,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "BB+")  | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "BA1")  ~ 30,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "BB")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "BA2")  ~ 31,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "BB-")  | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "BA3")  ~ 32,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "B+")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "B1")   ~ 33,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "B")    | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "B2")   ~ 34,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "B-")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "B3")   ~ 35,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "CCC+") | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "CAA1") ~ 36,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "CCC")  | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "CAA2") ~ 37,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "CCC-") | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "CAA3") ~ 38,
    ( (Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 )  & Formato_351_disponible$calificacion == "CC")   | (Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "CA")   ~ 39,
    ( Formato_351_disponible$c50 == 4 | Formato_351_disponible$c50 == 3 | Formato_351_disponible$c50 == 5) & Formato_351_disponible$calificacion == "C" ~ 40,
    Formato_351_disponible$c50 == 4 & Formato_351_disponible$calificacion == "DDD"  ~ 41,
    Formato_351_disponible$c50 == 4 & Formato_351_disponible$calificacion == "DD"  ~ 42,
    Formato_351_disponible$c50 == 4 & Formato_351_disponible$calificacion == "D"  ~ 43,
    Formato_351_disponible$c50 == 5 & Formato_351_disponible$calificacion == "D"  ~ 41)   
  
  #Columna 124 y 125 
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_CalificacionSeparado, by = "c49")
  
  #Columa 126 y 127
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_calificacionesConsolidado, by = "c106")
  
  #Multiplicamos la tasa de cambio por la C22 para crear la c23
  Formato_351_disponible <- Formato_351_disponible %>% 
    mutate(c19 = c17,
           c23 = tasa_de_cambio * c22,
           c30 =  tasa_de_cambio * c32, 
           c31 = c30, 
           c34 = c13_date - fechaCorte,  
           c88 = c85,
           c93 = c25,
           c113 = c30,
           c115 = c30,
           c116 = c30,
           c132 = c116 - c30)
  
  #Columna 12 para cuando c9 es CDEBE
  Formato_351_disponible$c12 = case_when(
    Formato_351_disponible$c9 == "CDEBE" ~ Formato_351_disponible$c15,
    TRUE ~ Formato_351_disponible$c12)
  
  
  #Columna 84 
  Formato_351_disponible$c84 = case_when(
    Formato_351_disponible$c83 == "Estructural - Reserva de Liquidez Interna Estratégica"  ~ "Portafolio Mínimo",
    Formato_351_disponible$c83 == "Estructural - Gestión Balance"  ~ "Gestión Balance",
    Formato_351_disponible$c83 == "Estructural - Reserva de Liquidez Regulatoria Estratégica" ~ "Liquidez regulatoria",
    Formato_351_disponible$c83 == "Estructural - Gestión Balance GOES"  ~ "Gestión Balance GOES",
    TRUE ~ NA_character_ )
  
  #Columna 86 
  Formato_351_disponible$c86 = case_when(
    Formato_351_disponible$c83 == "Estructural - Reserva de Liquidez Interna Estratégica"  ~ "Hold To Collect & Sale - HTC&S",
    Formato_351_disponible$c83 == "Estructural - Gestión Balance"  ~ "Hold To Collect - HTC",
    Formato_351_disponible$c83 == "Estructural - Reserva de Liquidez Regulatoria Estratégica" ~ "Hold To Collect & Sale - HTC&S",
    Formato_351_disponible$c83 == "Estructural - Gestión Balance"  ~ "Hold To Collect & Sale - HTC&S",
    TRUE ~ NA_character_ )
  
  #columna 89 
  Formato_351_disponible$c89 = case_when(
    Formato_351_disponible$c86 == "Hold To Collect - HTC" &  Formato_351_disponible$c87 == "Cumple" ~ "Costo Amortizado cambios en P&G",
    Formato_351_disponible$c86 == "Hold To Collect - HTC" &  Formato_351_disponible$c87 == "No cumple" ~ "Valor Razonable cambios en P&G",
    Formato_351_disponible$c86 == "Hold To Collect & Sale - HTC&S" &  Formato_351_disponible$c87 == "Cumple" ~ "Valor Razonable cambios en ORI",
    Formato_351_disponible$c86 == "Hold To Collect & Sale - HTC&S" &  Formato_351_disponible$c87 == "No cumple" ~ "Valor Razonable cambios en P&G",
    Formato_351_disponible$c86 == "Instrumentos de Patrimonio" &  Formato_351_disponible$c87 == "No aplica" ~ "Valor Razonable cambios en ORI",
    Formato_351_disponible$c86 == "Hold To Sale - HTS" &  Formato_351_disponible$c87 == "No aplica" ~ "Valor Razonable cambios en P&G",
    TRUE ~ "Inválido")
  
  #columna 94 
  Formato_351_disponible$c34_caracter = as.character(Formato_351_disponible$c34)
  Formato_351_disponible$c94 = case_when(
    Formato_351_disponible$c91 == "Deuda Pública" | Formato_351_disponible$c91 == "Deuda Privada" & Formato_351_disponible$c34_caracter != is.na(Formato_351_disponible$c34_caracter) ~ Formato_351_disponible$c34_caracter,
    Formato_351_disponible$c91 == "Títulos Participativos" ~ "No Aplica",
    TRUE ~ "Inválido")
  
  #Columna 95 
  Formato_351_disponible$c95 <- ifelse(Formato_351_disponible$c91 == "Fondos de inversión" & substr(Formato_351_disponible$c2, start = 1, stop = 4) == "1360",
                                       "De 0 a 1 años",
                                       case_when(
                                         Formato_351_disponible$c94 == "No Aplica"  ~ "No Aplica",
                                         is.numeric(as.numeric(Formato_351_disponible$c94)) & as.numeric(Formato_351_disponible$c94) >= 1 & as.numeric(Formato_351_disponible$c94) <= 365 ~ "De 0 a 1 años",
                                         is.numeric(as.numeric(Formato_351_disponible$c94)) & as.numeric(Formato_351_disponible$c94) >= 366 & as.numeric(Formato_351_disponible$c94) <= 1825 ~ "De 1 a 5 años",
                                         is.numeric(as.numeric(Formato_351_disponible$c94)) & as.numeric(Formato_351_disponible$c94) >= 1826 & as.numeric(Formato_351_disponible$c94) <= 3650 ~ "De 5 a 10 años",
                                         is.numeric(as.numeric(Formato_351_disponible$c94)) & as.numeric(Formato_351_disponible$c94) >= 3651 ~ "Más de 10 años",
                                         TRUE ~ "Inválido"))
  
  #columna 96 
  Formato_351_disponible$c96 = case_when(
    Formato_351_disponible$c91 == "Deuda Pública" | Formato_351_disponible$c91 == "Deuda Privada"  ~ as.character(Formato_351_disponible$c13_date - Formato_351_disponible$c12_date),
    Formato_351_disponible$c91 == "No Aplica" ~ "No Aplica",
    TRUE ~ "Inválido")
  
  #Columna 99
  Formato_351_disponible$c99 = case_when(
    Formato_351_disponible$c98 == "Gobierno Colombiano" ~ "Gobierno Colombiano",
    Formato_351_disponible$c98 == "Gobierno Extranjero" ~ "Gobierno Extranjero",
    Formato_351_disponible$c98 == "Instituciones Oficiales Especiales - IOE - Colombia" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Bancos en Colombia" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Bancos en el Exterior" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Instituciones Financieras en Colombia diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Instituciones Financieras en el Exterior diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Corporativo en Colombia" ~ "Entidades del Sector Real",
    Formato_351_disponible$c98 == "Corporativo en el Exterior" ~ "Entidades del Sector Real",
    Formato_351_disponible$c98 == "Organismos Multilaterales de Crédito" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Titularizadora" ~ "Otros",
    TRUE ~ "Inválido")
  
  #columna 100
  Formato_351_disponible$c100 = case_when(
    Formato_351_disponible$c98 == "Gobierno Colombiano" ~ "Gobierno Nacional",
    Formato_351_disponible$c98 == "Gobierno Extranjero" ~ "Gobiernos Extranjeros",
    Formato_351_disponible$c98 == "Instituciones Oficiales Especiales - IOE - Colombia" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Bancos en Colombia" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Bancos en el Exterior" ~ "Bancos en el Exterior",
    Formato_351_disponible$c98 == "Instituciones Financieras en Colombia diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Instituciones Financieras en el Exterior diferente a Bancos" ~ "Instituciones Financieras",
    Formato_351_disponible$c98 == "Corporativo en Colombia" ~ "Corporativo",
    Formato_351_disponible$c98 == "Corporativo en el Exterior" ~ "Corporativo",
    Formato_351_disponible$c98 == "Organismos Multilaterales de Crédito" ~ "Organismos Multilaterales de Crédito",
    Formato_351_disponible$c98 == "Titularizadora" ~ "Titularizaciones",
    TRUE ~ "Inválido")
  
  #columna 102
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_Riesgo_de_credito, by = "c101")
  
  #Formato_351_disponible$c102 = case_when(
  #  Formato_351_disponible$c101 == "Soberanos ML" ~ "0.47",
  #  Formato_351_disponible$c101 == "Soberanos" ~ "0.47",
  #  Formato_351_disponible$c101 == "Corporativos" ~ "0.623",
  #  Formato_351_disponible$c101 == "Davivienda" ~  "0.623",
  #  Formato_351_disponible$c101 == "Participativos" ~ "No Aplica",
  #  TRUE ~ "Inválido")
  
  #columna 114 
  Formato_351_disponible$c114 = case_when(
    (Formato_351_disponible$c85 == "Al Vencimiento" | Formato_351_disponible$c85 == "Al vencimiento" ) ~ as.character(Formato_351_disponible$c30),
    (Formato_351_disponible$c85 == "Al Vencimiento" | Formato_351_disponible$c85 == "Al vencimiento") & as.character(Formato_351_disponible$c30) == is.na(as.character(Formato_351_disponible$c30)) ~ "Inválido",
    TRUE ~ "No Aplica")
  
  #Columna 117 
  Formato_351_disponible$c117 = case_when(
    Formato_351_disponible$DealID == 715027689 ~ "No aplica",
    TRUE ~ " ")
  
  
  #Columna 118
  #Hacemos una nueva columna numerica con los datos de la 94 para poder manipular y sacar la 118 
  Formato_351_disponible$c94_para_c118 = as.numeric(Formato_351_disponible$c94)
  
  #juntamos con el stage para ver si cambiaron las noches (+4 se usan las otras dos tablas)
  Formato_351_disponible = left_join(Formato_351_disponible, Stage1, by = "DealID", multiple = "all" )  #QUITAR EL ALL DESPUES DE QUE MARIA JOSE LIMPIE EL ARCHIVO 
  
  #Juntamos con las tres tablas para luego hacer el condicional
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_118_sin_stage, by = "c106")
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_118_con_stage_corpo, by = "c106")
  Formato_351_disponible = left_join(Formato_351_disponible, parametros_118_con_stage_sobe, by = "c106")
  
  Formato_351_disponible$c118 = ifelse(Formato_351_disponible$noches >= 4 & Formato_351_disponible$DealID != 715027689,
                                       case_when( 
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 1 & Formato_351_disponible$c94_para_c118 <= 365 ~ Formato_351_disponible$corpo_1_365,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 366 & Formato_351_disponible$c94_para_c118 <= 730 ~ Formato_351_disponible$corpo_366_730,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 731 & Formato_351_disponible$c94_para_c118 <= 1095 ~ Formato_351_disponible$corpo_731_1095,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 1096 & Formato_351_disponible$c94_para_c118 <= 1460 ~ Formato_351_disponible$corpo_1096_1460,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 1461 & Formato_351_disponible$c94_para_c118 <= 1825 ~ Formato_351_disponible$corpo_1461_1825,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 1826 & Formato_351_disponible$c94_para_c118 <= 2190 ~ Formato_351_disponible$corpo_1826_2190,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 2191 & Formato_351_disponible$c94_para_c118 <= 2555 ~ Formato_351_disponible$corpo_2191_2555,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 2556 & Formato_351_disponible$c94_para_c118 <= 2920 ~ Formato_351_disponible$corpo_2556_2920,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 2921 & Formato_351_disponible$c94_para_c118 <= 3285 ~ Formato_351_disponible$corpo_2921_3285,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 3286 & Formato_351_disponible$c94_para_c118 <= 3650 ~ Formato_351_disponible$corpo_3286_3650,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 3651 & Formato_351_disponible$c94_para_c118 <= 4015 ~ Formato_351_disponible$corpo_3651_4015,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 4016 & Formato_351_disponible$c94_para_c118 <= 4380 ~ Formato_351_disponible$corpo_4016_4380,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 4381 & Formato_351_disponible$c94_para_c118 <= 4745 ~ Formato_351_disponible$corpo_4381_4745,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 4746 & Formato_351_disponible$c94_para_c118 <= 5110 ~ Formato_351_disponible$corpo_4746_5110,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 5111 & Formato_351_disponible$c94_para_c118 <= 5475 ~ Formato_351_disponible$corpo_5111_5475,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 5476 & Formato_351_disponible$c94_para_c118 <= 5840 ~ Formato_351_disponible$corpo_5476_5840,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 5841 & Formato_351_disponible$c94_para_c118 <= 6205 ~ Formato_351_disponible$corpo_5841_6205,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 6206 & Formato_351_disponible$c94_para_c118 <= 6570 ~ Formato_351_disponible$corpo_6206_6570,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 6571 & Formato_351_disponible$c94_para_c118 <= 6935 ~ Formato_351_disponible$corpo_6571_6935,
                                         Formato_351_disponible$c101 == "Corporativos" & Formato_351_disponible$c94_para_c118 >= 6936  ~ Formato_351_disponible$`corpo_6936_+`,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 1 & Formato_351_disponible$c94_para_c118 <= 365  ~ Formato_351_disponible$sobe_1_365,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 366 & Formato_351_disponible$c94_para_c118 <= 730  ~ Formato_351_disponible$sobe_366_730,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 731 & Formato_351_disponible$c94_para_c118 <= 1095  ~ Formato_351_disponible$sobe_731_1095,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 1096 & Formato_351_disponible$c94_para_c118 <= 1460  ~ Formato_351_disponible$sobe_1096_1460,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 1461 & Formato_351_disponible$c94_para_c118 <= 1825  ~ Formato_351_disponible$sobe_1461_1825,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 1826 & Formato_351_disponible$c94_para_c118 <= 2190  ~ Formato_351_disponible$sobe_1826_2190,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 2191 & Formato_351_disponible$c94_para_c118 <= 2555  ~ Formato_351_disponible$sobe_2191_2555,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 2556 & Formato_351_disponible$c94_para_c118 <= 2920  ~ Formato_351_disponible$sobe_2556_2920,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 2921 & Formato_351_disponible$c94_para_c118 <= 3285  ~ Formato_351_disponible$sobe_2921_3285,
                                         Formato_351_disponible$c101 == "Soberanos" & Formato_351_disponible$c94_para_c118 >= 3286 ~ Formato_351_disponible$`sobe_3286_+`,
                                         Formato_351_disponible$c101 == "Davivienda" ~ Formato_351_disponible$DAVIVIENDA),
                                       case_when(
                                         Formato_351_disponible$DealID != 715027689 & Formato_351_disponible$c101 == "Corporativos" ~ Formato_351_disponible$CORPORATIVOS,
                                         Formato_351_disponible$DealID != 715027689 & Formato_351_disponible$c101 == "Soberanos" ~ Formato_351_disponible$SOBERANOS,
                                         Formato_351_disponible$DealID != 715027689 & Formato_351_disponible$c101 == "Davivienda" ~ Formato_351_disponible$DAVIVIENDA,
                                         TRUE ~ NA_integer_) )
  
  
  #Columna 119
  Formato_351_disponible$c119 = case_when(
    Formato_351_disponible$DealID != 715027689 & as.numeric(Formato_351_disponible$c94_para_c118) >= 366 ~ 1 * Formato_351_disponible$c118,
    Formato_351_disponible$DealID != 715027689 & as.numeric(Formato_351_disponible$c94_para_c118) < 366 ~ (as.numeric(Formato_351_disponible$c94_para_c118) / 365)*Formato_351_disponible$c118,
    TRUE ~ NA_integer_)
  
  #Columna 120
  Formato_351_disponible$c120 = case_when(
    Formato_351_disponible$DealID != 715027689 & as.numeric(Formato_351_disponible$c96) >= 91 ~ "No",
    Formato_351_disponible$DealID != 715027689 & as.numeric(Formato_351_disponible$c96) < 91 ~ "Si",
    TRUE ~ "No aplica")
  
  #Columna 121
  Formato_351_disponible$c121 = case_when(
    Formato_351_disponible$DealID != 715027689 & Formato_351_disponible$c117 != "No aplica" & Formato_351_disponible$c120 == "No" ~ as.numeric(Formato_351_disponible$c31) * as.numeric(Formato_351_disponible$c102) * as.numeric(Formato_351_disponible$c119),
    Formato_351_disponible$DealID != 715027689 & Formato_351_disponible$c117 != "No aplica" & Formato_351_disponible$c120 == "Si" ~ 0,
    TRUE ~ NA_integer_)
  
  #columna 133
  Formato_351_disponible <- Formato_351_disponible %>% mutate(c133 = c116 - c121)
  
  #------------------------------------------ Limpiamos la data 
  Formato_351_disponible_final = Formato_351_disponible[,c("c0",  
                                                           "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                                           "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                                           "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                                           "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                                           "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                                           "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                                           "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                                           "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                                           "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                                           "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                                           "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                                           "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                                           "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                                           "c127","c128","c129","c130","c131","c132","c133")]
  
  Formato_351_disponible_final <- Formato_351_disponible_final[order(Formato_351_disponible_final$c0), ]
  
  #Redondeamos todos los datos numericos a 2 decimales 
  Formato_351_disponible_final <- Formato_351_disponible_final %>% 
    mutate(across(where(is.numeric), ~ round(., 5)))
  
  #-------------------------------- Aqui revisamos si hay reportos 
  
  if (nrow(reportos) > 0) { 
    
    #Cruzamos con homologado
    reportos_DI = left_join(reportos, homologado, by = c("Cuenta_contable","TipoValor"))
    
    #limpiamos formato 351 quitando las columnas que ya estan en reportos 
    Formato_351_disponible_reportos = Formato_351_disponible %>% select(-c("Cuenta_contable","TipoValor","c72","Descripcion","c2","DescripcionCUIF", "c9","c24","c90","c91"))
    
    #Creamos reportos_3 si es que hay 
    reportos_4 = merge(reportos_DI, Formato_351_disponible_reportos, by = c("DealID"))
    
    if (nrow(reportos_4) > 0) { 
      
      #Cambiamos las columnas monetarias 
      reportos_4 <- reportos_4 %>% 
        mutate(c17 = Monto,
               c19 = Monto,
               c22 = Monto,
               c23 = Monto * tasa_de_cambio,
               c30 = Monto * tasa_de_cambio,
               c31 = Monto * tasa_de_cambio,
               c32 = Monto,
               c73 = Monto,
               c113 = Monto * tasa_de_cambio,
               c115 = Monto * tasa_de_cambio,
               c116 = Monto * tasa_de_cambio,
               c121 = 0,
               c132 = c116 - c30,
               c133 = Monto * tasa_de_cambio)
      
      #Columna 121
      reportos_4$c121 = case_when(
        reportos_4$DealID != 715027689 & reportos_4$c117 != "No aplica" & reportos_4$c120 == "No" ~ as.numeric(reportos_4$c31) * as.numeric(reportos_4$c102) * as.numeric(reportos_4$c119),
        reportos_4$DealID != 715027689 & reportos_4$c117 != "No aplica" & reportos_4$c120 == "Si" ~ 0,
        TRUE ~ NA_integer_)
      
      #Columna 133
      reportos_4 <- reportos_4 %>% 
        mutate(c133 = c133 - c121)
      
      #Ordenamos reportos
      reportos_4 = reportos_4[,c("c0",  
                                 "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                                 "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                                 "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                                 "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                                 "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                                 "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                                 "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                                 "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                                 "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                                 "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                                 "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                                 "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                                 "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                                 "c127","c128","c129","c130","c131","c132","c133")]
      
      #redondear reportos -OJO ESTO SE PUEDE PONER AL FINAL CUANDO YA TENGAMOS TODOS LOS REPORTOS UNIDOS - esto es solo una prueba 
      #Redondeamos todos los datos numericos a 2 decimales 
      reportos_4 <- reportos_4 %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
      #Hacer un group_by para sumar todas las inversiones hijas, para restarle el total a la inversión madre
      reportos_4_agrupado  =  reportos_4 %>% select(c1,c17,c19,c22,c23,c30,c31,c32, c113,c115, c116,c121, c133) 
      reportos_4_agrupado <- reportos_4_agrupado %>% 
        group_by(c1) %>% 
        summarise(c17_a4 = sum(c17),
                  c19_a4 = sum(c19),
                  c22_a4 = sum(c22),
                  c23_a4 = sum(c23),
                  c30_a4 = sum(c30),
                  c31_a4 = sum(c31),
                  c32_a4 = sum(c32),
                  c113_a4 = sum(c113),
                  c115_a4 = sum(c115), 
                  c116_a4 = sum(c116),
                  c121_a4 = sum(c121),
                  c133_a4 = sum(c133),
                  .groups = 'drop') 
      
      #Como hay reportos entonces formato_351_participativas_final va a cambiar restando el monto 
      Formato_351_disponible_final = case_when( Formato_351_disponible_final$c1 == reportos_4_agrupado$c1 ~ Formato_351_disponible_final %>%  mutate (c17 = c17 - reportos_4_agrupado$c17_a4,
                                                                                                                                                      c19 = c19 - reportos_4_agrupado$c19_a4,
                                                                                                                                                      c22 = c22 - reportos_4_agrupado$c22_a4,
                                                                                                                                                      c23 = c23 - reportos_4_agrupado$c23_a4,
                                                                                                                                                      c30 = c30 - reportos_4_agrupado$c30_a4,
                                                                                                                                                      c31 = c31 - reportos_4_agrupado$c31_a4,
                                                                                                                                                      c32 = c32 - reportos_4_agrupado$c32_a4,
                                                                                                                                                      c113 = c113 - reportos_4_agrupado$c113_a4,
                                                                                                                                                      c115 = c115 - reportos_4_agrupado$c115_a4, 
                                                                                                                                                      c116 = c116 - reportos_4_agrupado$c116_a4,
                                                                                                                                                      c121 = c121 - reportos_4_agrupado$c121_a4,
                                                                                                                                                      c132 = 0,
                                                                                                                                                      c133 = c133 - reportos_4_agrupado$c133_a4), 
                                                TRUE ~ Formato_351_disponible_final) 
      
      #Redondeamos los datos
      #Redondeamos todos los datos numericos a 2 decimales 
      Formato_351_disponible_final <- Formato_351_disponible_final %>% 
        mutate(across(where(is.numeric), ~ round(., 5)))
      
    } else {"No hay reportos en disponible 2 - despues de comprobar que hay reportos (despues de join)"}
    
  } else {"No hay reportos en disponible 1"}
  
} else {
  # Ejecutar código si no hay observaciones
  print("No hay inversiones disponible para la venta")
}



#========================================== Vamos a unir los reportos ==================
# Verificar existencia y consolidar los data frames
#Reportos_1
if (exists("reportos_1")) {
  if (exists("Reportos_Final")) {
    Reportos_Final <- rbind(Reportos_Final, reportos_1)
  } else {
    Reportos_Final <- reportos_1
    }
}

#Reportos_2
if (exists("reportos_2")) {
  if (exists("Reportos_Final")) {
    Reportos_Final <- rbind(Reportos_Final, reportos_2)
  } else {
    Reportos_Final <- reportos_2
  }
}

#Reportos_3
if (exists("reportos_3")) {
  if (exists("Reportos_Final")) {
    Reportos_Final <- rbind(Reportos_Final, reportos_3)
  } else {
    Reportos_Final <- reportos_3
  }
}

#Reportos_4
if (exists("reportos_4")) {
  if (exists("Reportos_Final")) {
    Reportos_Final <- rbind(Reportos_Final, reportos_4)
  } else {
    Reportos_Final <- reportos_4
  }
}

#reportos_final
if (exists("Reportos_Final")) {
  
  #ponemos el consecutivoS
  Reportos_Final$c0 =  row_number(Reportos_Final$c0)
  
  #Colocamos las columnas que van vacias vacias
  Reportos_Final$c3 =  NA_integer_
  
  Reportos_Final$c55 =  NA_integer_
  
  #hacemos el c1 
  Reportos_Final$c1 = str_remove_all(paste("CAM084-", Reportos_Final$c0)," ")
  
  #ordenamos por el consecutivo
  Reportos_Final <- Reportos_Final[order(Reportos_Final$c0), ]
  
} else {
  print("No se creó ningún dataframe final de reportos")
}


#========================================== Construcción de F351  ==========================
#direccionamos la salida
setwd(output)

#=========================================== Verificamos participativas
# Verificar existencia y consolidar los data frames
if (exists("Formato_351_participativas_final")) {
  if (exists("Formato_351_Final")) {
    Formato_351_Final <- rbind(Formato_351_Final, Formato_351_participativas_final)
  } else {
    Formato_351_Final <- Formato_351_participativas_final
    
    #Exportamos separado para el regulatorio
    
    #Sacamos la inversión participativa de Telecom para el regulatorio
    Formato_351_Final_sin_telecom = filter(Formato_351_participativas_final, Formato_351_participativas_final$c75 != 'CTE TELECOM')
    
    #Hacemos nuevamente el consecutivo 
    Formato_351_Final_sin_telecom$c0 =  row_number(Formato_351_Final_sin_telecom$c1)
    
    #ordenamos por el consecutivo
    Formato_351_Final_sin_telecom <- Formato_351_Final_sin_telecom[order(Formato_351_Final_sin_telecom$c0), ]
    
    write.xlsx(Formato_351_Final_sin_telecom[,1:75], str_remove_all(paste("CAM084_F351_Separado_", año, mes, dia, ".xlsx"), " "), sheetName = "participativas", colNames = FALSE)
  }
}

#=========================================== Verificamos vencimiento 
if (exists("Formato_351_vencimiento_final")) {
  if (exists("Formato_351_Final")) {
    Formato_351_Final <- rbind(Formato_351_Final, Formato_351_vencimiento_final)
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"vencimiento")
    writeData(wb,"vencimiento",Formato_351_vencimiento_final[,1:75 ],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  } else {
    Formato_351_Final <- Formato_351_vencimiento_final
    
    #Exportamos separado para el regulatorio
    write.xlsx(Formato_351_vencimiento_final[,1:75 ], str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," ") , sheetName = "vencimiento",colNames = FALSE)
    
  }
}

#=========================================== Verificamos depositos
if (exists("Formato_351_depositos_final")) {
  if (exists("Formato_351_Final")) {
    Formato_351_Final <- rbind(Formato_351_Final, Formato_351_depositos_final)
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"deposito")
    writeData(wb,"deposito",Formato_351_depositos_final[,1:75],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  } else {
    Formato_351_Final <- Formato_351_depositos_final
    
    #Exportamos separado para el regulatorio
    write.xlsx(Formato_351_depositos_final[,1:75], str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," ") , sheetName = "deposito",colNames = FALSE)
    
  }
}

#=========================================== Verificamos disponible
if (exists("Formato_351_disponible_final")) {
  if (exists("Formato_351_Final")) {
    Formato_351_Final <- rbind(Formato_351_Final, Formato_351_disponible_final)
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"disponible")
    writeData(wb,"disponible",Formato_351_disponible_final[,1:75],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  } else {
    Formato_351_Final <- Formato_351_disponible_final
    
    #Exportamos separado para el regulatorio
    write.xlsx(Formato_351_disponible_final[,1:75], str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," ") , sheetName = "disponible",colNames = FALSE)
  }
}

#=========================================== Verificamos reportos
if (exists("Reportos_Final")) {
  if (exists("Formato_351_Final")) {
    Formato_351_Final <- rbind(Formato_351_Final, Reportos_Final)
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"reportos")
    writeData(wb,"reportos",Reportos_Final[,1:75],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  } else {
    Formato_351_Final <- Reportos_Final
    
    #Exportamos separado para el regulatorio
    write.xlsx(Reportos_Final[,1:75], str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," ") , sheetName = "reportos",colNames = FALSE)
  }
}

#======================================== Verificamos el formato 351 final 
# Verificar si se consolidaron los data frames
if (exists("Formato_351_Final")) {
  
  #Cambiar los encabezados
  fila2 = data.frame(cbind("Subcuenta",	"No. Asignado por la Entidad",	"Código Catálogo Único de Información Financiera",	"Aval",	"Tipo ident. aval.",	"No. de identif. avalista",	"Razón social avalista",	"No. identif. administ.",	"Razón social administ.",	"Clase de inversión",	"Nemotécnico",	"Cupón, ppal o total",	"Fecha emisión (Formato Texto)",	"Fecha vnto título o valor (Formato Texto)",	"Fecha vnto cupón  (Formato Texto)",	"Fecha compra (Formato Texto)",	"Código de moneda",	"Valor nominal",	
                            "Amortiz. capital intereses especiales",	"Vr. nominal residual o capitaliz",	"No. acciones, unid. o partic.",	"Clase de acciones",	"Valor de compra moneda original",	"Valor de compra en pesos",	"Código tasa facial título o valor",	"Valor tasa o spread",	"Base cálculo intereses",	"Period pago rendim",	"Modalid pago intereses",	"Indicador tasa vble referen.",	"Vr. mercado o valor presente en $",	"Vr. presente en $ ",	"Vr.mercado o presente moneda diferente al peso",	"Tasa de negoc",	
                            "Días al vto",	"ELIMINADA ",	"ELIMINADA ",	"Valor tasa vble 1er. flujo",	"ELIMINADA ",	"Tasa de duento",	"Precio",	"Método valorac",	"Fecha último reprecio",	"Vr. presen último reprecio",	"Indice de bursatilidad",	"Intereses y capital vencidos y no cobrados",	"Código PUC provisión",	"Base provisión",	"Valor provisión",	"Calific. título o valor o emisor",	"Entidad calific.",	"Calif. riesgo crediticio",	"Calific. avalista",	"Calif. deuda soberana",	"Entidad calificad. deuda soberana",	
                            "Depósito de valores",	"No. Identif. asignado por el Depósito de Valores",	"ELIMINADA ",	"Monto de emisión",	"% partic. en monto emis.",	"Ramo de seguros",	"Relación matriz, filial, subsidiaria",	"Concent. propiedad accionaria",	"Relación vinculac. emisores",	"Código PUC causación cuentas resultados",	"Causación valoración cuentas resultado",	"Código PUC causación cuentas patrimonio",	"Causación valoración cuentas patrimonio",	"Restricc",	"Valorización",	"Desvalorización",	"Fecha de Captura de la Tasa Variable de Referencia",	
                            "Número asignado por la entidad a la operación",	"Valor de mercado inversiones para mantener hasta el vencimiento",	"Código país de origen del emisor",	"Nombre Emisor",	"Numero Id emisor",	"ELIMINADA",	"ELIMINADA",	"ELIMINADA",	"Unidad de captura",	
                            "Entidad Reportante",	"País Reportante",	"Modelo de Negocio Davivienda",	"Portafolio Reportante (Código o Nombre asignado sistema)",	"Clasificación Contable Local",	"Modelo de Negocio IFRS 9",	"Evaluación SPPI Test IFRS 9",	"Clasificación Contable para el Balance Separado Colombia",	"Clasificación Contable IFRS 9 - Balance Consolidado",	"Tipo de Título",	"Tipo de Inversión",	"Nombre del Indicador de Tasa Variable",	"Valor de Tasa Completa (Valor Indicador + Spread)",	"Días al Vencimiento",	
                            "Bucket días al vencimiento",	"Plazo del título",	"País del Emisor",	"Clasificación del Emisor",	"Clasificación Emisor Nota VR",	"Grupos Emisores Nota Inversiones",	"Sector del Emisor (Riesgo de Crédito)",	"Loss Given Default (Riesgo de Crédito)",	"Calificación del Emisor (Largo Plazo)",	"Fecha de Calificación del Emisor (ddmmaaaa) [Columna 98]",	"Tipo de Calificación del Emisor [Columna 98]",	"Calificación Homologada Final del Emisor",	"Calificación del Emisor (Largo Plazo) en la fecha de compra del título",	
                            "Tipo de Calificación del Emisor (Largo Plazo) en la fecha de compra del título",	"Calificación de Riesgo del País del Emisor en la fecha de compra del título",	"Calificación HOMOLOGADA del Emisor (Largo Plazo) en la fecha de compra del título",	"Duración",	"Método de Valoración PIP",	"Descripción Método de Valoración PIP",	"Nivel de Jerarquía de Precios a Valor Razonable",	"Precio Sucio PiP",	"Precio Limpio PiP",	"Valor Razonable en COP",	"Costo Amortizado COP",	"Valor Reporte Balance Separado en COP (sin provisión)",	
                            "Valor reporte Balance Consolidado en COP (sin provisión)",	"Valor Deterioro Balance Separado",	"Probabilidad de Default (PD)",	"PD Proporcional (Aplica para títulos de vencimiento menor a 1 año)",	"Equivalente Efectivo (Inversiones de plazo menor a 90 días)",	"Valor Deterioro Balance Consolidado",	"Inversiones GrupoNo Grupo",	"Cuenta PUC Provisión",	"Calificación Riesgo para notas EEFF SEPARADOS",	"Calidades Crediticias Riesgo para notas EEFF SEPARADOS",	"Calificación Riesgo para notas EEFF CONSOLIDADOS",	"Calidades Crediticias Riesgo para notas EEFF CONSOLIDADOS", "Moneda
                            (nombre completo)","Clase Moneda",	"Cuenta Homologa FIFRS",	"Fecha de corte",	"Diferencia Vr. Reporte Consolidado - Individual (Sin deterioro)",	"Valor reporte Balance Consolidado en COP (Neto con deterioro)"))
  
  names(fila2)= c("c0",  
                  "c1",  "c2",  "c3",  "c4",  "c5",  "c6",  "c7",  "c8",  "c9",  "c10", 
                  "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20", 
                  "c21", "c22", "c23", "c24", "c25", "c26", "c27", "c28", "c29", "c30", 
                  "c31", "c32", "c33", "c34", "c35", "c36", "c37", "c38", "c39", "c40",
                  "c41", "c42", "c43", "c44", "c45", "c46", "c47", "c48", "c49", "c50",
                  "c51", "c52", "c53", "c54", "c55", "c56", "c57", "c58", "c59", "c60", 
                  "c61", "c62", "c63", "c64", "c65", "c66", "c67", "c68", "c69", "c70",
                  "c71", "c72", "c73", "c74", "c75", "c76", "c77", "c78", "c79", "c80",
                  "c81", "c82", "c83", "c84", "c85", "c86", "c87", "c88", "c89", "c90",
                  "c91", "c92", "c93", "c94", "c95", "c96", "c97", "c98", "c99", "c100",
                  "c101","c102","c103","c104","c105","c106", "c106.1","c106.2","c106.3", "c106.4", 
                  "c107","c108","c109","c110","c111","c112","c113","c114","c115","c116",
                  "c117","c118","c119","c120","c121","c122","c123","c124","c125","c126",
                  "c127","c128","c129","c130","c131","c132","c133")
  
  #Encabezado 2
  Formato_351_Final = rbind(fila2, Formato_351_Final)
  
  #Encabezado 1
  names(Formato_351_Final) = c('0','1', '2', '3', '4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102','103','104','105','106', '106,1',	'106,2', '106,3',	'106,4','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124','125','126','127','128','129','130','131','132','133')
  
  #Exportamos el archivo final
  write.xlsx(Formato_351_Final, str_remove_all(paste("CAM084_F351_",año,mes,dia,".xlsx")," "), sheetName =  str_remove_all(paste("CAM084_F351_",año,mes,dia)," "), overwrite = TRUE)
  
} else {
  print("No se creó ningún dataframe final")
}


#======================================= Juntamos vencimiento y depositos para el regulatorio
if (exists("Formato_351_vencimiento_final")) {
  if (exists("Formato_351_depositos_final")) {
    Formato_351_Vencimiento_Depositos <- rbind(Formato_351_depositos_final, Formato_351_vencimiento_final)
    
    #Cambiamos el consecutivo para regulatorio 
    Formato_351_Vencimiento_Depositos$c0 =  row_number(Formato_351_Vencimiento_Depositos$c1)
    
    #ordenamos por el consecutivo
    Formato_351_Vencimiento_Depositos <- Formato_351_Vencimiento_Depositos[order(Formato_351_Vencimiento_Depositos$c0), ]
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"Vencimiento_Y_Deposito")
    writeData(wb,"Vencimiento_Y_Deposito",Formato_351_Vencimiento_Depositos[,1:75 ],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  } else {
    Formato_351_Vencimiento_Depositos <- Formato_351_vencimiento_final
    
    #Cambiamos el consecutivo para regulatorio 
    Formato_351_Vencimiento_Depositos$c0 =  row_number(Formato_351_Vencimiento_Depositos$c1)
    
    #ordenamos por el consecutivo
    Formato_351_Vencimiento_Depositos <- Formato_351_Vencimiento_Depositos[order(Formato_351_Vencimiento_Depositos$c0), ]
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"Vencimiento_Y_Deposito")
    writeData(wb,"Vencimiento_Y_Deposito",Formato_351_Vencimiento_Depositos[,1:75 ],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  }
}  else {if (exists("Formato_351_depositos_final")) { 
  if (exists("Formato_351_vencimiento_final")) {
    Formato_351_Vencimiento_Depositos <- rbind(Formato_351_depositos_final, Formato_351_vencimiento_final)
    
    #Cambiamos el consecutivo para regulatorio 
    Formato_351_Vencimiento_Depositos$c0 =  row_number(Formato_351_Vencimiento_Depositos$c1)
    
    #ordenamos por el consecutivo
    Formato_351_Vencimiento_Depositos <- Formato_351_Vencimiento_Depositos[order(Formato_351_Vencimiento_Depositos$c0), ]
    
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"Vencimiento_Y_Deposito")
    writeData(wb,"Vencimiento_Y_Deposito",Formato_351_Vencimiento_Depositos[,1:75 ],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  } else {
    Formato_351_Vencimiento_Depositos <- Formato_351_depositos_final
    
    #Cambiamos el consecutivo para regulatorio 
    Formato_351_Vencimiento_Depositos$c0 =  row_number(Formato_351_Vencimiento_Depositos$c1)
    
    #ordenamos por el consecutivo
    Formato_351_Vencimiento_Depositos <- Formato_351_Vencimiento_Depositos[order(Formato_351_Vencimiento_Depositos$c0), ]
    
    #Exportamos separado para el regulatorio
    wb <- loadWorkbook(str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "))
    addWorksheet(wb,"Vencimiento_Y_Deposito")
    writeData(wb,"Vencimiento_Y_Deposito",Formato_351_Vencimiento_Depositos[,1:75 ],colNames = FALSE)
    saveWorkbook(wb,str_remove_all(paste("CAM084_F351_Separado_",año,mes,dia,".xlsx")," "),overwrite = TRUE)
    
  }
}  else {print("No hay de depositos 2") } }








