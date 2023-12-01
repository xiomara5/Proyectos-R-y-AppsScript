#======================================== Parte 1 =================================
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

#======================================== Parte 2 ==================================
#--------------------------------------- Importamos los datos a escritorio y R los que estan en sheets 
#Importamos las fechas
dia1 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B2"))
mes1 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D2"))
año1 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "F2"))

#Construimos la fecha YYYYMMDD
mes1 = case_when(nchar(mes1) == 1 ~ paste0("0",mes1), TRUE ~ mes1)
fecha_corte = paste0(año1,mes1,dia1)

#Impostamos el Folder ID
folder_id = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B3"))

#Importamos la TRM 
Base_TRM <- read_sheet("ID_sheet_trm",sheet = 'TRM',range = "A8:B")
names(Base_TRM) = c("FECHA_INICIO", "TRM")
Base_TRM$FECHA_INICIO = as.Date(Base_TRM$FECHA_INICIO, format = "%Y%m%d")

#Bajamos la fecha para hacer día caido
n_filas <- nrow(Base_TRM)
columna <- "FECHA_INICIO"

# Guardar el último valor de la columna TRM
ultimo_valor <- Base_TRM[n_filas, columna]

# Recorrer las filas en orden inverso (de abajo hacia arriba)
for (fila in (n_filas - 1):1) {
  Base_TRM[fila + 1, columna] <- Base_TRM[fila, columna]
}

# Colocar el último valor en la primera fila
Base_TRM[1, columna] <- ultimo_valor

#Eliminamos la fila 1 
Base_TRM = Base_TRM[-1,]


#Ahora traemos la TRM de la fecha de corte 
TRM_FECHA_CORTE = filter(Base_TRM, Base_TRM$FECHA_INICIO == as.Date(fecha_corte, format = '%Y%m%d'))
#Traemos la TRM del ultimo día del año anterior
TRM_FECHA_ANTERIOR = filter(Base_TRM, Base_TRM$FECHA_INICIO == as.Date(paste0((as.numeric(año1)-1), "12", "31"), format = '%Y%m%d'))


#Nombramos el folder
folder <- as_id(folder_id)
files <- drive_ls(path = folder)

# Nombres de archivos que quieres descargar
Balance = paste0("Balance_",fecha_corte,".xlsx")
Activos_Fijos_Maimi = paste0("Activos_Fijos_Maimi_", fecha_corte, ".xlsx")
Bonos_ME = paste0("Bonos_ME_",fecha_corte,".xlsx")
Borrowing = paste0("Borrowing_",fecha_corte,".xlsx")
F351 = paste0("F351_",fecha_corte,".xlsx")
Miami = paste0("Miami_", fecha_corte, ".xlsx")
MCCME = paste0("MCCME_", fecha_corte, ".TXT")
TDS = paste0("TDS_", fecha_corte, ".xlsx")
TZSaldos = paste0("TZSaldos_", fecha_corte, ".txt")
Activos_Intangibles_MM = paste0("Activos_Intangibles_MM_", fecha_corte, ".xlsx")

#Hacemos un vector con los nombres de los archivos
file_names <- c(Balance, Activos_Fijos_Maimi, Bonos_ME, Borrowing, F351, Miami, MCCME,TDS, TZSaldos, Activos_Intangibles_MM)

#Directorio local donde deseas guardar los archivos descargados
local_directory <- "user_direccion"

# Descargar los archivos por nombre
for (file_name in file_names) {
  file_to_download <- files[files$name == file_name,]
  if (nrow(file_to_download) > 0) {
    drive_download(file = file_to_download, path = file.path(local_directory, file_name), overwrite = TRUE)
  } else {
    cat("El archivo", file_name, "no se encontró en la carpeta de Google Drive.\n")
  }
}

#Vamos limpiando la memoria del R eliminando datas que no requerimos 
rm(file_to_download, files)
  
#------------------------------------------ Importacion a R y limpieza de insumos
setwd(local_directory)

#Para que los datos no esten en notación cientifica
options(scipen=999)

#Primer Importación de insumos 
Balance <- read_excel(Balance, sheet = "Consulta_Financiera", col_types = c("numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), skip = 10) 
names(Balance) = c("CUENTA","DESCRIPCION","Saldo_Inicial","Mov_Debitos","Mov_Creditos","Neto","Moneda_Base","Moneda_Extranjera", "Moneda_Total")   
Balance = Balance[,c("CUENTA","DESCRIPCION", "Moneda_Extranjera","Moneda_Total")]

#Intrumenstos financieros
DATA_BALANCE_INSTRUMENTOS = filter(Balance, Balance$CUENTA == 1351 | Balance$CUENTA == 1352 | Balance$CUENTA ==1354 | Balance$CUENTA == 1355 | Balance$CUENTA == 139005)
DATA_BALANCE_INSTRUMENTOS = DATA_BALANCE_INSTRUMENTOS %>%  mutate(CUENTA = as.numeric(CUENTA),
                                                        DESCRIPCION = ifelse(CUENTA != 139005,"Instrumentos financieros",'MM DETERIORO INVERSIONES MIAMI'), 
                                                        NEGOCIO = "0",
                                                        MONEDA = "COP",
                                                        FECHA_INICIO = as.Date(fecha_corte, format = '%Y%m%d'), 
                                                        TRM = 0,
                                                        SALDO_ACTUAL_USD = 0,
                                                        SALDO_K_PESOS = Moneda_Extranjera,
                                                        FECHA_CORTE= as.Date(fecha_corte, format = '%Y%m%d')) %>% select(-c(Moneda_Extranjera,Moneda_Total, DESCRIPCION))

                                                   
#Nota: Agregar esta parte al final


#======================================== Segundo insumo F351 =================================
F351 <- read_excel(F351, sheet = "F351", col_types = c("text", "numeric", "numeric", "numeric", "text", "text", "text", "numeric", "text", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text"), skip = 1)
names(F351) = c("NEGOCIO","CUENTA", "AVAL", "NO_RAZON_SOCIAL","RAZON_SOCIAL","CLASE_INV","NEMOT","CUPON","FECHA_EMISION","FECHA_VENCIMIENTO","FECHA_INICIO","MONEDA","VALOR_NOMINAL","AMORT_CAP","VLR_NOMINAL_RESIDUAL","NO_ACCIONES","CLASE_ACCIONES","VLR_COMPRA_MD_ORG","VLR_COMPRA_MD_COP","TASA_FACIAL","TASA_SPREAD","BASE_CAL_INTE","PERIODO_PAGO_REN","MODALIDAD_PAGO_INT","IND_TASA_VARIABLE","SALDO_K_PESOS","VLR_PRESENTE_COP","VLOR_RAZONABLE_DIF_COP","TASA_NEGOCIO","DIAS_VTO","VLOR_TASA_VARIABLE_1MER_FLUJO","TASA_DESCUENTO","PRECIO","METODO_VALORACION","FECHA_ULTIMO_REPRECIO","VALOR_PRESENTE_ULTIMO_REPRECIO","IND_BURSATIBILIDAD","INTERES_CAPITAL_VENCIDO","PUC_DETERIORO","BASE_DETERIORO","VLOR_DETERIORO","CALIF_TITU_VLOR","ENTIDAD_CALIF","CALIF_RIES_EMISOR","DEP_VALORES","IDENT_ASIG_DEPO_VALORES","PUC_VALORACION_RESULTADO","CAUSACION_VALORACION_RESULTA","PUC_CAUSACION_ORI","CAUSACION_VALORACION_ORI","RESTRICC","NO_ASIG_ENTIDAD","COD_PAIS_ORIGEN_EMISOR","NA","UNIDAD_CAPTURA","NIT","EMISOR")
F351 = F351[,c("NEGOCIO","CUENTA","FECHA_INICIO","MONEDA","SALDO_K_PESOS")]

#cambiar formato de fechas - Agregamos el cero al inicio
F351$FECHA_INICIO = case_when (nchar(F351$FECHA_INICIO) == 7 ~  paste0("0", F351$FECHA_INICIO),
                               nchar(F351$FECHA_INICIO) == 8 ~ F351$FECHA_INICIO,
                               FALSE ~ 'Invalido') 

#Reorganizar la fecha AA/MM/DD
F351 = F351 %>% mutate(FECHA_INICIO = paste0(substr(F351$FECHA_INICIO,5,8),substr(F351$FECHA_INICIO,3,4),substr(F351$FECHA_INICIO,1,2)))

#Filtrar cuentas
F351 = filter(F351, F351$CUENTA != 1315 & ( F351$MONEDA == "USD" | F351$MONEDA == "CAD" ))

DATA_FINAL_F351 = F351 %>% mutate(CUENTA = as.numeric(substr(CUENTA,1,4)),
                                  DESCRIPCION = 'Inversiones Renta Fija y Variable', 
                                  TRM = 0,
                                  SALDO_ACTUAL_USD = 0,
                                  FECHA_CORTE= as.Date(fecha_corte, format = '%Y%m%d'),
                                  FECHA_INICIO = as.Date(FECHA_INICIO , format = '%Y%m%d')) 
DATA_FINAL_F351 = DATA_FINAL_F351 [,c("CUENTA", "DESCRIPCION", "NEGOCIO",  "MONEDA", "FECHA_INICIO", "TRM", "SALDO_ACTUAL_USD", "SALDO_K_PESOS", "FECHA_CORTE")]

sum(DATA_FINAL_F351$SALDO_K_PESOS)
#======================================== Tercer insumo  TZsaldos =========================== 
TZSaldos <- read_table(TZSaldos, col_types = cols_only(SUCURSAL = col_character(),RUBRO_DAV = col_number(),NEGOCIO = col_character(), MONE = col_number(), F_INICIO = col_date(format = "%Y%m%d"),  F_VCTO = col_date(format = "%Y%m%d"), SALD_ACT_USD = col_character(),SALD_ACT_MN = col_character()))

#Remplazamos las comas (,) por espacios y transformamos a numeric
names(TZSaldos) = c("SUCURSAL", "CUENTA", "MONEDA", "NEGOCIO", "FECHA_INICIO","FECHA_VENCIMIENTO",  "SALDO_ACTUAL_USD", "SALDO_K_PESOS")

TZSaldos_p = filter(TZSaldos, TZSaldos$SUCURSAL == '58' & substr(TZSaldos$CUENTA, 1,4) == '2440')
TZSaldos = anti_join(TZSaldos,TZSaldos_p)

TZSaldos = merge(TZSaldos, Balance[,1:2], by = "CUENTA")

TZSaldos = TZSaldos %>% mutate(across(c(7:8), ~ str_replace_all(. , "[,]", " ")), 
                                 across(c(7:8), ~ str_remove_all(. , " ")),
                                 across(c(7:8), ~ as.numeric(.)),
                                 CUENTA_2 =  substr(CUENTA, 1,4),
                                 MONEDA = case_when(MONEDA == 2 ~ 'COP',
                                                    MONEDA == 6 ~ 'GPB',
                                                    MONEDA == 8 ~ 'SEK',
                                                    MONEDA == 9 ~ 'DKK',
                                                    MONEDA == 10 ~ 'CHF',
                                                    MONEDA == 11 ~ 'JPY',
                                                    MONEDA == 12 ~ 'USD',
                                                    MONEDA == 13 ~ 'CAD',
                                                    MONEDA == 14 ~ 'BRL',
                                                    MONEDA == 18 ~ 'EUR',
                                                    MONEDA == 20 ~ 'MXM',
                                                    MONEDA == 21 ~ 'AUD',
                                                    MONEDA == 22 ~ 'CLP',
                                                    MONEDA == 23 ~ 'PEN',
                                                    MONEDA == 24 ~ 'HNL',
                                                    MONEDA == 25 ~ 'CRC'),
                                 DESCRIPCION = case_when(CUENTA_2 == '2440' ~ 'Obligaciones financieras',
                                                         CUENTA_2 == '2558' ~ 'Impuestos diferidos por pagar',
                                                         TRUE ~ DESCRIPCION),
                                 TRM = 0,
                                 FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d'))

#Filtramos a 10 digitos y a 4 digitos
TZSaldos_a_10 = filter(TZSaldos, TZSaldos$CUENTA == 1940058017 | TZSaldos$CUENTA == 1940058108 |TZSaldos$CUENTA == 1925958017 | TZSaldos$CUENTA == 1925958082 | TZSaldos$CUENTA == 1910000064 | TZSaldos$CUENTA == 1925958074 |TZSaldos$CUENTA == 1925950097 | TZSaldos$CUENTA == 1925958041 |TZSaldos$CUENTA == 1925058040 | TZSaldos$CUENTA == 1925058016 | TZSaldos$CUENTA == 1925058057 | TZSaldos$CUENTA == 1925058032 |TZSaldos$CUENTA == 1925058081 |TZSaldos$CUENTA == 2990058014 |TZSaldos$CUENTA == 2990950285 |TZSaldos$CUENTA == 2745008017 ) 
TZSaldos_a_4 = filter(TZSaldos, TZSaldos$CUENTA_2 == '2440' | TZSaldos$CUENTA_2 == '2558')

DATA_FINAL_TZSaldos = rbind(TZSaldos_a_10, TZSaldos_a_4)
DATA_FINAL_TZSaldos = DATA_FINAL_TZSaldos [,c("CUENTA", "DESCRIPCION", "NEGOCIO",  "MONEDA", "FECHA_INICIO", "TRM", "SALDO_ACTUAL_USD", "SALDO_K_PESOS", "FECHA_CORTE")]



#======================================== Cuarto insumo Miami ==========================
Miami <- read_excel(Miami, sheet = "Miami")

#Encabezados
names(Miami) = c("IDENTIF", "TIPOID", "A1", "NEGOCIO", "NOMBRE", "INDAPLIC", "PRODUCTO","CLASE",      "CALIFICACI", "DIASMORA",   "NUMREEST",   "RANGOCOL",  "FECHA_INICIO",   "FECHAVEN",   "VALORINI",   "CLASEGTIA",  "SALDOK",     "KEMPL",     "INTCTES" ,   "OTROS",      "PROVK",      "PROVKEMP",   "PROVINT",    "PROVOTROS", "UVREXIG",    "CALIFSARC",  "SEGMENTO",   "PI_MT_B",   "PI_MT_A",    "PDI",       "TASAINTCTE", "UNIDAVALOR", "VALORGTIA",  "CONTRA_K",   "CONTRA_I",   "CONTRA_O",  "CONTRAK_AN", "CONTRAI_AN", "CONTRAO_AN", "MAX_MORA",   "SALDOK_ANT", "SALDOI_ANT","SALDOO_ANT", "ALTURA",     "OFICINA",    "PROVKPCICL", "PROVIPCICL", "PROVOCICLI","PROVKADMPC", "PROVKNADPC", "GTIA_DEFEC", "GTIA_ADMIS", "TIPOGAR",    "SUBJETIVA", "COSTAS",     "DAVIPLAN",   "CUPO_DISPO", "CUPO_APROB", "IND_IMPROD", "CALIF_REES","CALIF_CAST", "FECH_INCUM", "FECH_AVALU", "ALTURA_MA",  "CIUU",       "SDOUVRK",   "SDOUVRINT",  "SDOINTSUSP", "SDOINTMORA", "CODSEG",     "CIA",       "VALOR_VAL", "CALIF_INCU", "PROB_INC",   "PER_INC_K",  "USOFUTURO6", "B1",         "VALORGTIAG","LINEA",      "ZONA",       "PI_A_AVQ",   "PI_B_AVQ",   "NOMBRE_APL", "DIF",    "MARCA",      "CNT_OBLIGA", "DIFCAPITAL", "AMORTIZACI", "NOMBRE_AMO", "MARCA2",    "SUPER",      "PROVSUPER",  "PROVANTERI", "ORLANDO",    "CONSECUTIV")

#Extración de un sub-dataset Y creación de columas con mutate 
CAPITAL2 = Miami[,c("NEGOCIO","FECHA_INICIO","SALDOK")]
CAPITAL2  = CAPITAL2 %>% mutate(MONEDA = "USD", CUENTA = 14 )

INTERES2 = Miami[,c("NEGOCIO","FECHA_INICIO","INTCTES")]
INTERES2  = INTERES2 %>% mutate(MONEDA = "USD", CUENTA = 16 )

OBLIGACION2 = Miami[,c("NEGOCIO","FECHA_INICIO","OTROS")]
OBLIGACION2  = OBLIGACION2 %>% mutate(MONEDA = "USD", CUENTA =14 )

#COP
PROVK = Miami[,c("NEGOCIO","FECHA_INICIO","PROVK")]
PROVK  = PROVK %>% mutate(MONEDA = "COP", CUENTA = 14)

PROVOTROS = Miami[,c("NEGOCIO","FECHA_INICIO","PROVOTROS")]
PROVOTROS  = PROVOTROS %>% mutate(MONEDA = "COP", CUENTA = 14)

PROVINT = Miami[,c("NEGOCIO","FECHA_INICIO","PROVINT")]
PROVINT  = PROVINT %>% mutate(MONEDA = "COP", CUENTA = 16)

#Creación de función
encabezados = function(x) { 
  names(x) = c("NEGOCIO","FECHA_INICIO", "SALDO_K_PESOS", "MONEDA", "CUENTA")
  x = data.frame(x)}

CAPITAL2 = encabezados(CAPITAL2)
INTERES2 = encabezados(INTERES2)
OBLIGACION2 = encabezados(OBLIGACION2)
PROVK = encabezados(PROVK)
PROVOTROS = encabezados(PROVOTROS)
PROVINT = encabezados(PROVINT)

#Vamos unir a unir una debajo de la otra 
DATA_FINAL_MIAMI = rbind(CAPITAL2, INTERES2, OBLIGACION2, PROVK, PROVOTROS, PROVINT)
DATA_FINAL_MIAMI = DATA_FINAL_MIAMI %>% mutate(DESCRIPCION = 'Cartera', 
                                               TRM = 0,
                                               SALDO_ACTUAL_USD = 0,
                                               SALDO_K_PESOS = ifelse(MONEDA == "COP", SALDO_K_PESOS * -1, SALDO_K_PESOS),
                                               FECHA_CORTE = as.Date(paste0(año1, mes1, dia1), format = '%Y%m%d'),
                                               FECHA_INICIO = as.Date(paste0(substr(FECHA_INICIO,1,4), substr(FECHA_INICIO,5,6), substr(FECHA_INICIO,7,8)), format = '%Y%m%d'))

#names(DATA_FINAL_MIAMI) = c("NEGOCIO", "FECHA_INICIO",  "SALDO_K_PESOS", "MONEDA", "CUENTA", "DESCRIPCION", "TRM",  "SALDO_ACTUAL_USD", "FECHA_CORTE")
DATA_FINAL_MIAMI = DATA_FINAL_MIAMI [,c("CUENTA", "DESCRIPCION", "NEGOCIO",  "MONEDA", "FECHA_INICIO", "TRM", "SALDO_ACTUAL_USD", "SALDO_K_PESOS", "FECHA_CORTE")]



#======================================== Quinto insumo Borrowing ==========================
Borrowing <- read_excel(Borrowing, sheet ="Borrowing",  skip = 2, n_max = 9, col_types = c("text","text","numeric","numeric","date","date","numeric","numeric","numeric","text","date","text","text","text","text","text"))
names(Borrowing) =  c("NEGOCIO","Bank_Name","Principal","Rate","FECHA_INICIO","Maturity","outstanding","SALDO_ACTUAL_USD","Term_Days","Int_payment_Days","Next_Interest_Pmt","Fixed_or_Variable","RATE_INDEX","RATE_INDEX M", "RATE_INDEX_MAS_SPREAD", "Short_term_Long_Term")
Borrowing = Borrowing[,c("NEGOCIO","FECHA_INICIO","SALDO_ACTUAL_USD")]
Borrowing = na.omit(Borrowing)
DATA_FINAL_BORROWING = Borrowing %>% mutate( CUENTA = 24,  
                                             DESCRIPCION = 'Crédito de Banco y Otras Obligaciones', 
                                             NEGOCIO = as.character(NEGOCIO),
                                             MONEDA = 'USD',
                                             FECHA_INICIO = as.Date(FECHA_INICIO, format = "%Y%m%d"),
                                             TRM = 0,
                                             SALDO_ACTUAL_USD = as.numeric(SALDO_ACTUAL_USD),
                                             SALDO_K_PESOS = 0,
                                             FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d'))
DATA_FINAL_BORROWING = DATA_FINAL_BORROWING [,c("CUENTA", "DESCRIPCION", "NEGOCIO",  "MONEDA", "FECHA_INICIO", "TRM", "SALDO_ACTUAL_USD", "SALDO_K_PESOS", "FECHA_CORTE")]


#======================================== Sexto insumo MCCME ===============================
MCCME <- read.table(MCCME, row.names=NULL, quote="\"", comment.char="")

names(MCCME) <- c("ID_APLICATIVO","TIPO_ID","N_IDENTIFICACION","NEGOCIO","VLOR_ORIGINAL","CUPO_DISP","CLASE_CARTERA","PRODUCTO","FECHA_INICIO","SALDO_CAPITAL","SALDO_INTERES","SLD_CUOTA_MANEJO","SLD_SEGUROS","SLD_CUOTA_MANEJO_2","SALDO_OTROS_CARGOS","FECHA_CORTE")
MCCME = MCCME %>% mutate(CALIFICACION_DEFINI = substr(MCCME$FECHA_INICIO, 9, 9), 
                         FECHA_INICIO = substr (FECHA_INICIO, 1,8))
MCCME = filter(MCCME, MCCME$ID_APLICATIVO == 6) 
MCCME = filter(MCCME, MCCME$SALDO_CAPITAL != 0)

MCCME_CAPITAL = MCCME[,c("NEGOCIO", "FECHA_INICIO", "SALDO_CAPITAL")]
MCCME_CAPITAL$CUENTA = 14 
names(MCCME_CAPITAL) = c("NEGOCIO", "FECHA_INICIO", "SALDO_K_PESOS", "CUENTA")

MCCME_INTERES = MCCME[,c("NEGOCIO", "FECHA_INICIO", "SALDO_INTERES")]
MCCME_INTERES$CUENTA = 16
names(MCCME_INTERES) = c("NEGOCIO", "FECHA_INICIO", "SALDO_K_PESOS", "CUENTA")

DATA_FINAL_MCCME = rbind(MCCME_CAPITAL, MCCME_INTERES)

DATA_FINAL_MCCME = DATA_FINAL_MCCME %>% mutate(DESCRIPCION = case_when(CUENTA == 14 ~ "Cartera de créditos y operaciones leasing", CUENTA == 16 ~ "Cuentas por cobrar"), 
                                        NEGOCIO = as.character(NEGOCIO),
                                        MONEDA = "USD",
                                        TRM = 0,
                                        FECHA_INICIO = as.Date(FECHA_INICIO, format = '%Y%m%d'),
                                        SALDO_ACTUAL_USD = 0,
                                        FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d'))
DATA_FINAL_MCCME = DATA_FINAL_MCCME [,c("CUENTA", "DESCRIPCION", "NEGOCIO",  "MONEDA", "FECHA_INICIO", "TRM", "SALDO_ACTUAL_USD", "SALDO_K_PESOS", "FECHA_CORTE")]



#======================================== Septimo insumo TDS ==============================
TDS <- read_excel(TDS, sheet = "TDS", col_types = c("text", "text", "numeric", "numeric", "text", "text", "numeric", "numeric", "numeric", "numeric"))

names(TDS) <- c("ACCNUMB","nombre","ppal","rate","FECHA_INICIO","mat_date","mont_int","int_balanc","SALDO_ACTUAL_USD","dat_inter","dat_inter")
TDS = TDS[,c("FECHA_INICIO","SALDO_ACTUAL_USD")]

DATA_FINAL_TDS = TDS %>%
  mutate(across(c(1), ~ str_remove_all(. ,"/")),
         FECHA_INICIO = case_when(nchar(FECHA_INICIO) == 7 ~  paste0("0", FECHA_INICIO),
                                 nchar(FECHA_INICIO) == 6 ~  paste0("0",substr(FECHA_INICIO,1,1), "0",substr(FECHA_INICIO,2,2), substr(FECHA_INICIO,3,6) ),
                                 nchar(FECHA_INICIO) == 8 ~ FECHA_INICIO,
                                 FALSE ~ 'Invalido') ,
         across(c(1), ~ as.Date(., format = "%m%d%Y" )),
         MONEDA = 'USD', 
         CUENTA = 21, 
         DESCRIPCION = "Depositos a plazo",
         NEGOCIO = NA_character_,
         TRM = 0,
         FECHA_INICIO = as.Date(FECHA_INICIO, format = '%Y%m%d'),
         SALDO_K_PESOS = 0,
         FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d')) 

DATA_FINAL_TDS = DATA_FINAL_TDS [,c("CUENTA", "DESCRIPCION", "NEGOCIO",  "MONEDA", "FECHA_INICIO", "TRM", "SALDO_ACTUAL_USD", "SALDO_K_PESOS", "FECHA_CORTE")]


#======================================== Octavo insumo Bonos_ME ==========================
Bonos_ME <- read_excel(Bonos_ME, sheet = "Bonos_ME", range = "C9:AE10",  col_types = c("text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",  "numeric", "numeric", "numeric"))

names(Bonos_ME) = c("CUENTA_INTERESES_GL", "CUENTA_CAPITAL_GL", "PORTAFOLIO", "CUENTA_INTERESES_SIF", "CUENTA_CAPITAL_SIF","NEGOCIO", "IDENTIFIC",  "NOMBRE", "Tipo_de_Inversion", "FECHA_INICIO", "FECHA_VENCIM", "VALOR_NOMINAL", "SALDO_POR_CAPITAL","TASA_INTERES_NOM_EFEC", "FECHA_DEL_ULTIMO_PAGO_DE_INTERESES", "MODALIDAD_PAGO_INT", "PLAZO", "MODALIDAD","PERIOD_PAGO","INTERESES_POR_PAGAR","GASTO_INTERESES","Blanco","SALDO_COLGAAP","Blanco","COSTOS_TRANSACCIONALES","Blanco","Costo_Amortizado_Hasta_la_Fecha","Blanco","Costo_Por_Amortizar")
BONOS_ME_1 = Bonos_ME[,c("NEGOCIO","FECHA_INICIO","SALDO_POR_CAPITAL")]
BONOS_ME_2 = Bonos_ME[,c("NEGOCIO","FECHA_DEL_ULTIMO_PAGO_DE_INTERESES","INTERESES_POR_PAGAR")]
BONOS_ME_3 = Bonos_ME[,c("NEGOCIO","Costo_Por_Amortizar")]

BONOS_ME_1 = BONOS_ME_1 %>%
  mutate(CUENTA = 2130, 
         DESCRIPCION = "Instrumento de deuda emitidos",
         NEGOCIO = as.character(NEGOCIO), 
         MONEDA = 'USD',
         FECHA_INICIO = as.Date(FECHA_INICIO, format = '%Y%m%d'),
         TRM = 0, 
         SALDO_ACTUAL_USD = as.numeric(SALDO_POR_CAPITAL), 
         SALDO_K_PESOS = 0,
         FECHA_CORTE =  as.Date(fecha_corte, format = '%Y%m%d')) %>% select(-c(SALDO_POR_CAPITAL))

BONOS_ME_2 = BONOS_ME_2 %>%
  mutate(CUENTA = 2130, 
         DESCRIPCION = "Instrumento de deuda emitidos",
         NEGOCIO = as.character(NEGOCIO), 
         MONEDA = 'USD',
         FECHA_INICIO = as.Date(FECHA_DEL_ULTIMO_PAGO_DE_INTERESES, format = '%Y%m%d'),
         TRM = 0, 
         SALDO_ACTUAL_USD = as.numeric(INTERESES_POR_PAGAR), 
         SALDO_K_PESOS = 0,
         FECHA_CORTE =  as.Date(fecha_corte, format = '%Y%m%d')) %>% select(-c(FECHA_DEL_ULTIMO_PAGO_DE_INTERESES,INTERESES_POR_PAGAR))

BONOS_ME_3 = BONOS_ME_3 %>%
  mutate(CUENTA = 2130, 
         DESCRIPCION = "Instrumento de deuda emitidos",
         NEGOCIO = as.character(NEGOCIO), 
         MONEDA = 'COP',
         FECHA_INICIO = as.Date(paste0(año1, mes1, dia1), format = '%Y%m%d'),
         TRM = 0, 
         SALDO_ACTUAL_USD = 0, 
         SALDO_K_PESOS = as.numeric(Costo_Por_Amortizar),
         FECHA_CORTE =  as.Date(fecha_corte, format = '%Y%m%d')) %>% select(-c(Costo_Por_Amortizar))


DATA_FINAL_BONOS = rbind(BONOS_ME_1, BONOS_ME_2, BONOS_ME_3) 


#======================================== Noveno Insumo Activos fijos Miami ================
Activos_Computo <- read_excel(Activos_Fijos_Maimi, sheet = "Eq_Computo", skip = 11, col_types = c("text", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "text", "numeric", "numeric", "text", "text",  "numeric", "numeric", "numeric",  "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
Activos_Oficina <- read_excel(Activos_Fijos_Maimi, sheet = "Eq_Oficina", skip = 11, col_types = c("text", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "text", "numeric", "numeric", "date", "date", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

USD = 'USD'
COP = 'COP'
encabezados_1 = function(x, moneda) { 
  names(x) = c("NEGOCIO", "FECHA_INICIO", "SALDO_K")
  x = data.frame(x)
  x = x %>% mutate(CUENTA = 18,
                   DESCRIPCION = "Propiedades y  equipo", 
                   NEGOCIO = as.character(NEGOCIO),
                   MONEDA = moneda,
                   FECHA_INICIO = as.Date(FECHA_INICIO, format = '%Y%m%d'), 
                   TRM = 0,
                   SALDO_ACTUAL_USD = ifelse(MONEDA == 'USD', SALDO_K, 0), 
                   SALDO_K_PESOS = ifelse(MONEDA == 'COP', SALDO_K, 0) , 
                   FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d')) %>% select(-c(SALDO_K))
  
}

names(Activos_Computo) = c("OBLIGACION","DESCRIPTION","TY","FECHA_INICIAL","PRICE EUR","VALOR_COMPRA","MTHS","DEP","RUN","DEPRC","VALUE","DATE","BLANCO1","PUC SIF","COLOMBIA","COMPRA COP","DEPREC COP","FECHA COMPRA","FECHA DEPRECIACION","MESES DESDE COMPRA","BLANCO2","BLANCO3","OBSERVACION","BLANCO4","depreciar","usd colombia","cop_colombia","Control","depreciación mes anterior","diferencia","control2")               
ACTIVOS_COMPUTO_1 = Activos_Computo[,c("OBLIGACION", "FECHA_INICIAL", "VALOR_COMPRA")]
ACTIVOS_COMPUTO_1 = encabezados_1(ACTIVOS_COMPUTO_1, USD)

ACTIVOS_COMPUTO_2 = Activos_Computo[,c("OBLIGACION", "FECHA_INICIAL", "DEPRC")]
ACTIVOS_COMPUTO_2 = encabezados_1(ACTIVOS_COMPUTO_2, USD)

ACTIVOS_COMPUTO_3 = Activos_Computo[,c("OBLIGACION", "FECHA_INICIAL", "cop_colombia")]
ACTIVOS_COMPUTO_3 = encabezados_1(ACTIVOS_COMPUTO_3, COP)


names(Activos_Oficina) = c("OBLIGACION","DESCRIPTION","TY","FECHA_INICIAL","PRICE EUR","VALOR_COMPRA","MTHS","DEP","RUN","DEPRC","VALUE","DATE","BLANCO1","PUC SIF","COLOMBIA","COMPRA COP","DEPREC COP","FECHA COMPRA","FECHA DEPRECIACION","MESES DESDE COMPRA","BLANCO2","BLANCO3","OBSERVACION","BLANCO4","depreciar","usd colombia","cop_colombia","Control","depreciación mes anterior","diferencia","control2")
ACTIVOS_OFICINA_1 = Activos_Oficina[,c("OBLIGACION", "FECHA_INICIAL", "VALOR_COMPRA")]
ACTIVOS_OFICINA_1 = encabezados_1(ACTIVOS_OFICINA_1, USD)

ACTIVOS_OFICINA_2 = Activos_Oficina[,c("OBLIGACION", "FECHA_INICIAL", "DEPRC")]
ACTIVOS_OFICINA_2 = encabezados_1(ACTIVOS_OFICINA_2, USD)

ACTIVOS_OFICINA_3 = Activos_Oficina[,c("OBLIGACION", "FECHA_INICIAL", "cop_colombia")]
ACTIVOS_OFICINA_3 = encabezados_1(ACTIVOS_OFICINA_3, COP)

DATA_FINAL_ACTIVOS_OFICINA_COMPUTO = rbind(ACTIVOS_COMPUTO_1, ACTIVOS_COMPUTO_2,ACTIVOS_COMPUTO_3,ACTIVOS_OFICINA_1, ACTIVOS_OFICINA_2,ACTIVOS_OFICINA_3) 


# ======================================= Decimo insumo Intangibles Miami ====================================
C1911358040 <- read_excel(Activos_Intangibles_MM, sheet = '1911358040', col_types = c("text",  "numeric", "numeric", "numeric",  "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), skip = 5)
C1911308037 <- read_excel(Activos_Intangibles_MM, sheet = '1911308037', col_types = c("text",  "numeric", "numeric", "numeric",  "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), skip = 5)
C1911308029 <- read_excel(Activos_Intangibles_MM, sheet = "1911308029", col_types = c("text", "numeric", "text", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",  "numeric", "numeric", "numeric",  "numeric", "numeric"), skip = 5)
C1911358040_1 <- read_excel(Activos_Intangibles_MM, sheet = "1911358040_1", col_types = c("text", "text", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), skip = 5)
C1911358032 <- read_excel(Activos_Intangibles_MM,  sheet = "1911358032", col_types = c("text", "numeric", "numeric", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), skip = 5)
C1911358008 <- read_excel(Activos_Intangibles_MM, sheet = "1911358008", col_types = c("text", "text", "numeric", "numeric", "numeric"), skip = 5)
C1632008015 <- read_excel(Activos_Intangibles_MM, sheet = "1632008015", col_types = c("text", "text", "numeric", "numeric", "numeric"),  skip = 5)
C1632008023 <- read_excel(Activos_Intangibles_MM, sheet = "1632008023", col_types = c("text", "text", "numeric", "numeric", "numeric"),  skip = 5)


limpieza_miami = function(x) { 
  names(x) = c("NEGOCIO","FECHA_INICIO", "SALDO_ACTUAL_USD")
  x = data.frame(x) 
  x = x[!is.na(x$FECHA_INICIO),]
  x = x %>% mutate(CUENTA = 1911, 
                   NEGOCIO = NEGOCIO , 
                   DESCRIPCION = "Intangibles" , 
                   MONEDA = "USD", 
                   FECHA_INICIO = as.Date(FECHA_INICIO, format = '%d/%m/%y'),
                   TRM = 0, 
                   SALDO_ACTUAL_USD = as.numeric(SALDO_ACTUAL_USD),
                   SALDO_K_PESOS = 0,
                   FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d'))
  }
limpieza_miami_2 = function(x) { 
  names(x) = c("FECHA_INICIO","NEGOCIO", "SALDO_ACTUAL_USD")
  x = data.frame(x) 
  x = x[!is.na(x$FECHA_INICIO),]
  x = x %>% mutate(CUENTA = 1911, 
                   NEGOCIO = NEGOCIO , 
                   DESCRIPCION = "Intangibles", 
                   MONEDA = "USD", 
                   FECHA_INICIO = as.Date(FECHA_INICIO, format = '%d/%m/%y'),
                   TRM = 0, 
                   SALDO_ACTUAL_USD = as.numeric(SALDO_ACTUAL_USD),
                   SALDO_K_PESOS = 0,
                   FECHA_CORTE = as.Date(fecha_corte, format = '%Y%m%d'))
}

C1911358040 = C1911358040[,c(1,5,18)]
C1911308037 = C1911308037[,c(1,5,18)]
C1911308029 = C1911308029 [,c(1,7,20)]
C1911358040_1 = C1911358040_1 [,c(1,6,19)]
C1911358032 = C1911358032 [,c(1,5,18)]
C1911358008 = C1911358008 [,c(1,2,5)]
C1632008015 = C1632008015 [,c(1,2,5)]
C1632008023 = C1632008023 [,c(1,2,5)]

#Encabezados
C1911358040 = limpieza_miami(C1911358040)
C1911308037 = limpieza_miami(C1911308037)
C1911308029 = limpieza_miami(C1911308029) 
C1911358040_1 = limpieza_miami(C1911358040_1) 
C1911358032 = limpieza_miami(C1911358032) 
C1911358008 = limpieza_miami_2(C1911358008) 
C1632008015 = limpieza_miami_2(C1632008015) 
C1632008023 = limpieza_miami_2(C1632008023) 

DATA_FINAL_INTANGIBLES_MIAMI = rbind(C1911358040, C1911308037, C1911308029, C1911358040_1,C1911358032,C1911358008,C1632008015,C1632008023)


#=========================================== Data final consolidada ========================
#UNIR DATA final 
DATA_FINAL = rbind(DATA_FINAL_F351, DATA_FINAL_TZSaldos, DATA_FINAL_MIAMI, DATA_FINAL_BORROWING,
                   DATA_FINAL_MCCME, DATA_FINAL_TDS, DATA_FINAL_BONOS, DATA_FINAL_ACTIVOS_OFICINA_COMPUTO, DATA_FINAL_INTANGIBLES_MIAMI)


DATA_FINAL = DATA_FINAL %>% mutate(SALDO_ACTUAL_USD = ifelse(is.na(SALDO_ACTUAL_USD), 0, SALDO_ACTUAL_USD),
                                   SALDO_K_PESOS = ifelse(is.na(SALDO_K_PESOS), 0,SALDO_K_PESOS)) %>% select(-TRM)

#Aquí por la prueba indicamos que fecha inicio si esta vacia es fecha de corte pero deben corregir insumos
DATA_FINAL = DATA_FINAL[!is.na(DATA_FINAL$FECHA_INICIO),]

#Aquí traemos la TRM de la fecha inicio, luego hacemos un condicional para indicarle, si la TRM es del año corriente conservela, si es de años anteriores traiga la del ultimo día del año anterior
DATA_FINAL = left_join(DATA_FINAL, Base_TRM, by = "FECHA_INICIO") 

DATA_FINAL = DATA_FINAL %>% mutate(TRM = ifelse( substr(DATA_FINAL$FECHA_INICIO, 1,4) == año1, TRM, TRM_FECHA_ANTERIOR[1,2]),
                                   TRM = as.numeric(TRM),
                                   TRM_CORTE = as.numeric(TRM_FECHA_CORTE[1,2]),
                                   SALDO_ACTUAL_USD = ifelse(SALDO_ACTUAL_USD == 0, SALDO_K_PESOS / TRM_CORTE, SALDO_ACTUAL_USD),
                                   SALDO_K_PESOS = ifelse(SALDO_K_PESOS == 0, SALDO_ACTUAL_USD * TRM_CORTE, SALDO_K_PESOS),
                                   Valor_COP_TRM_INICIAL = TRM * SALDO_ACTUAL_USD,
                                   Diferencia_Cambio_No_Realizada = ifelse(MONEDA != "COP", SALDO_K_PESOS - Valor_COP_TRM_INICIAL, 0))
  
names(DATA_FINAL) = c("CUENTA","DESCRIPCION","NEGOCIO","MONEDA", "FECHA_INICIO","SALDO_ACTUAL_USD", "SALDO_K_PESOS",  "FECHA_CORTE","TRM INICIAL","TRM_CORTE", "Valor En Pesos TRM Inicial", "Diferencia En Cambio No Realizada")

#Eliminar los insumos de la corrida pasada del escritorio
unlink(local_directory, recursive = TRUE)

#Exportamos
#Creamos el libro
wb = createWorkbook()

#Agregamos una hoja al libro
addWorksheet(wb, "Base_Datos")

#Exportamos la base que queremos
writeData(wb, sheet = "Base_Datos", x = DATA_FINAL, startCol = 1, startRow = 1)

#Guardamos el libro
saveWorkbook(wb, 'Salidas_DC.xlsx', overwrite = TRUE)

#Enviamos a la carpeta drive 
drive_upload("user_direccion/Salidas_DC.xlsx", path = as_id(folder_id), name = paste0("Salida_Diferencial_Cambiario",fecha_corte,".xlsx"))









