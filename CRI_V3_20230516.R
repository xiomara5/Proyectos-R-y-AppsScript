#t <- proc.time()
#--------------------------------------------- Automatizacion ficheros ------------------------------
#instalación de paquetes una unica vez
#install.packages("FRACTION")
#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("stringr")
#install.packages("lubridate")
#install.packages("tidyr")
#install.packages("openxlsx")
#install.packages("readxl")
#install.packages("shiny")
#install.packages("miniUI")
#install.packages("timechange")
#install.packages("taskscheduleR")
#install.packages("openxlsx")
#install.packages("writexl")

#abrimos las librerias 
library(FRACTION)
library(dplyr)
#library(tidyverse)
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

#------------------------------------------------ importacion de archivos -----------------
#parte variable 
carpeta= Sys.getenv("HOME")

#cambiamos los diagonales
carpeta = gsub("\\\\", "/", carpeta)    

#definimos la parte fija --> cambiar en el escritorio de equipo CR -->  ojo con los / 
input = paste(carpeta, "/costa_rica/ficheros/input", sep = "") 
output = paste(carpeta, "/costa_rica/ficheros/output", sep = "")
parametros = paste(carpeta, "/costa_rica/ficheros/parametros", sep = "")

#acordamos la dirección de entrada (input) de los archivos 
setwd(input)

#importar las datas variables
fecha = read_excel ("curva_soberana_colones.xlsx", col_types = c("text", "date")) 
curva_soberana_colones <- read_excel("curva_soberana_colones.xlsx", col_types = c("text", "numeric"))
curva_soberana_dolares = read_excel("curva_soberana_dolares.xlsx", col_types = c("text", "numeric"))
tipo_de_cambio <- read_excel("tipo_de_cambio.xlsx", col_types = c("text", "numeric", "numeric"))
oynr_desempleo_500 = read_excel("oynr_desempleo_500.xlsx", col_types = c("text", "text", "text", "text", "date", "date", "text", "text", "text", "text", "text", "date", "text"))
oynr_desempleo_501 = read_excel("oynr_desempleo_501.xlsx", col_types = c("text", "text", "text", "text", "date", "date", "text", "text", "text", "text", "text", "date", "text"))
oynr_incendio_143 = read_excel("oynr_incendio_143.xlsx", col_types = c("text", "text", "text", "text", "date", "date", "text", "text", "text", "text", "text", "date", "text"))
oynr_incendio_153 = read_excel("oynr_incendio_153.xlsx",  col_types = c("text", "text", "text", "text", "date", "date", "text", "text", "text", "text", "text", "date", "text"))
oynr_prf_230_232 = read_excel("oynr_prf_230_232.xlsx", col_types = c("text", "text", "text", "text", "date", "date", "text", "text", "text", "text", "text", "date", "text"))
oynr_vida = read_excel("oynr_vida.xlsx", col_types = c("text", "text", "date", "date", "text", "text", "numeric", "date", "numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
anexo4_isc_rcs3 = read_excel("anexo4_isc.xlsx", sheet = "RCS-3", range = "A16:G41")
anexo4_isc_rcs4 = read_excel("anexo4_isc.xlsx", sheet = "RCS-4", range = "A26:G93")
auxiliar_cesion_1060 <- read_excel("auxiliar_cesion_1060.xlsx", col_types = c("text",      "text",    "text",     "text",   "text",    "text",       "text",         "text",       "numeric",    "date",       "date",        "date",       "date",      "date",       "date",     "numeric",    "numeric",    "numeric",     "numeric",     "numeric",    "text",  "text",  "text",  "text", "text",    "numeric",       "numeric",     "numeric",    "numeric",     "numeric",   "numeric",        "numeric",      "numeric",    "numeric",     "numeric",    "numeric",    "numeric",       "text",           "numeric",   "numeric",     "numeric"))
auxiliar_ppnd <- read_excel("auxiliar_ppnd.xlsx", col_types = c("text", "text", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "numeric", "numeric", "text"))
bordero_recuperacion_siniestros <- read_excel("bordero_recuperacion_siniestros.xlsx", sheet = "SALDO_PRODUCTO", range = "B1:E80")
mov_ramos <- read_excel("mov_ramos.xlsx", col_types = c("numeric", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "text", "numeric"))
reserva_siniestro_disponible <- read_excel("reserva_siniestro_disponible.xlsx", col_types = c("text", "text", "text", "text", "text", "text", "date", "date", "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "text", "text"))
saldos_rcat = read_excel("saldos_rcat.xlsx", col_types = c("text", "text", "text", "numeric"))
saldos_pip = read_excel("saldos_pip.xlsx", col_types = c("text", "text", "text", "numeric"))
distribucion = read_excel("distribucion.xlsx", col_types = c("text", "text", "numeric"))
Reservas_Ultimo_Periodo <- read_excel("Reservas_Ultimo_Periodo.xlsx", col_types = c("text", "text", "text", "text", "text", "text", "date", "date", "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "date", "text"))

#acordamos la dirección para los parametros
setwd(parametros)
productos_ramo = read_excel("productos_ramo.xlsx")
cuentas_tipo = read_excel("cuentas_tipo.xlsx")
Reservas_Acumuladas <- read_excel("Reservas_Acumuladas.xlsx", col_types = c("text", "text", "text", "text", "text", "date", "date", "numeric", "numeric", "numeric", "numeric", "text", "text", "text", "date", "text", "text"))


#Para la salida que pidieron 
dm_productos <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "dm_productos")
dm_cta_contables <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "dm_cta_contables")
dm_duration <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "dm_duration")
dm_factor_cap <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "dm_factor_cap")
dm_patron <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "dm_patron")
dm_ajuste_onerosidad <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "dm_ajuste_onerosidad")
flujo_PRI_anterior <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "flujo_PRI_anterior")
cuentas_contables <- read_excel("Excel_Input_Actuarial_CR.xlsx", sheet = "cuentas_contables")


#================================================ Parametrizamos los nombres de las columnas
names(fecha) = c("Curva", "CurvaCeroCuponEnColones")
names(curva_soberana_colones) = c("Curva", "CurvaCeroCuponEnColones")
names(curva_soberana_dolares) = c("Curva", "CurvaCeroCuponEnColones")
names(tipo_de_cambio) = c("fec","TipoCambioCompra","TipoCambioVenta")
names(oynr_desempleo_500) = c("IDNumber", "Nombre", "Producto", "Poliza", "FechaDeOcurrencia", "FechaDeRecibido", "MontoEnDolares", "TipoDeCambio", "MontoEnColones", "NoOperacion","NoSiniestro","FecheDePago","DiasRec" )
names(oynr_desempleo_501) = c("IDNumber", "Nombre", "Producto", "Poliza", "FechaDeOcurrencia", "FechaDeRecibido", "MontoEnDolares", "TipoDeCambio", "MontoEnColones", "NoOperacion","NoSiniestro","FecheDePago","DiasRec" )
names(oynr_incendio_143) = c("IDNumber", "Nombre", "Producto", "Poliza", "FechaDeOcurrencia", "FechaDeRecibido", "MontoEnDolares", "TipoDeCambio", "MontoEnColones", "NoOperacion","NoSiniestro","FecheDePago","DiasRec" )
names(oynr_incendio_153) = c("IDNumber", "Nombre", "Producto", "Poliza", "FechaDeOcurrencia", "FechaDeRecibido", "MontoEnDolares", "TipoDeCambio", "MontoEnColones", "NoOperacion","NoSiniestro","FecheDePago","DiasRec" )
names(oynr_prf_230_232) = c("IDNumber", "Nombre", "Producto", "Poliza", "FechaDeOcurrencia", "FechaDeRecibido", "MontoEnDolares", "TipoDeCambio", "MontoEnColones", "NoOperacion","NoSiniestro","FecheDePago","DiasRec" )
names(oynr_vida) = c("ID", "Nombre","FechaDeOcurrencia", "FechaDeRecibido",   "Producto", "PolizaAfectada",  "MontoPagado", "FechaDePago", "DiasRec" ,"MesAñoOcur", "MesAñoPag", "AvisoOcurr","AñoOcur","AñoPag", "AñoOcur1", "AñoPag1")
names(auxiliar_cesion_1060) = c("FEC_PROCESO", "SECCION","PRODUCTO","POLIZA", "ENDOSO", "RIESGO", "COD_AGRUP_CONT",   "PRIRET_ORI",       "PRICED_ORI",       "FECEMI_END",      "FEC_VIGPOL",       "FEC_VENCPOL",      "FEC_INIEND",       "FEC_VENCEND",      "FEC_ANULA",       "TP_CAMBIO",        "TIP_RIES",         "PRIRET_LOC",       "PRICED_LOC",       "Comisión_RE",     "4040",             "1060",            "4080",             "5070",             "2080",            "Retroactividad",   "Devg_del_Mes",     "Dias_Vig",         "Dias_No_Devg",     "Dias_Devg",       "Prima_Devg_Mes",   "Prima_No_Deng",    "Prima_Devg",       "Com_Devg_Mes",     "Com_No_Devg",     "Com_Devg",         "Verifica_Dev",     "Verifica_Dev_Mes", "Aj_dias",          "verifica_Dias" ,  "DIF_DIAS")
names(auxiliar_ppnd) = c("CO", "AGEN","AGRUPACIO","MO","NUMERO_POLIZA","ENDOS","CLAVE","COA", "%_COA","TASA_CAMBI","VALOR_PRIMA","VALOR_COMISION","PRIMA_REASEGURO","ANTE","RESERVA_PRIMA_ANTER", "RESERVA_REASE_ANTER","RESERVA_MES_ANTERIO", "COMISION_DEVE_ANTER", "ACTU","RESERVA_PRIMA_ACTUA","RESERVA_REASE_ACTUA", "RESERVA_MES_ACTUAL","COMISION_DEVE_ACTUA", "CAMBIO_EN_LA_RESERV","FEC_EMIS", "FEC_INIC","FEC_VENC","DIAS","FEC_EQUI","RAMO")
names(bordero_recuperacion_siniestros) = c("CUENTA","TIPO_MOVIMIENTO","PRODUCTO","SALDO")
names(mov_ramos) = c("Ref.", "Cuenta", "CuentaContable", "ImporteDebito",  "ImporteCredito", "Fecha","NoDeDiario" , "LDeDiario", "TipoDeDiario", "Descripcion", "Referencia","Documento", "Localidad", "NitDeTercero","NombreNit", "Ramo","NombreRamo" )
names(reserva_siniestro_disponible) = c("ID NUMBER", "NOMBRE","PRODUCTO", "POLIZA MADRE","POLIZA AFECTADA","# DE OPERACIÓN","FECHA EVENTO","FECHA AVISO","RESERVA DISPONIBLE EN DOLARES","TIPO DE CAMBIO", "RESERVA EN DOLARES COLONIZADA", "RESERVA DISPONIBLE","ESTATUS","Analista Encargado", "# DE SINIESTRO" ,"TIPO","CUENTA CONTABLE")
names(saldos_rcat) = c("Cuenta","Detalle","Producto","Saldo" )
names(saldos_pip) = c("Cuenta","Detalle","Producto","Saldo" )
names(distribucion) = c("Cuenta",  "Detalle", "Saldo")
names(Reservas_Ultimo_Periodo) = c("ID NUMBER","NOMBRE", "PRODUCTO", "POLIZA MADRE", "POLIZA AFECTADA","# DE OPERACIÓN", "FECHA EVENTO", "FECHA AVISO","RESERVA DISPONIBLE EN DOLARES","TIPO DE CAMBIO", "RESERVA DE DOLARES COLONIZADA", "RESERVA DISPONIBLE COLONES",  "ESTATUS","Analista Encargado","Cuenta Contable", "fecha de Reserva", "TIPO DE CREDITO") 
names(Reservas_Acumuladas) = c ("ID NUMBER","NOMBRE",  "PRODUCTO","POLIZA AFECTADA", "# DE OPERACIÓN" ,"FECHA EVENTO" , "FECHA AVISO", "RESERVA DISPONIBLE EN DOLARES", "TIPO DE CAMBIO" , "RESERVA DE DOLARES COLONIZADA", "RESERVA DISPONIBLE COLONES","ESTATUS" , "Analista Encargado","Cuenta Contable","fecha de Reserva" ,  "TIPO DE CREDITO", "POLIZA MADRE")


#------------------------------------------------ dm_tasa_de_descuento  -------------------------------------------------------------------
#Columnas a consturir: 
#                     fec_data   -       moneda    -     periodo   -    rfr
#Creamos la data de la fecha
fec_data = data.frame(as.Date(fecha$CurvaCeroCuponEnColones, format = '%d/%m/%y'))
names(fec_data)[1] = c("fec_data")
fec_data = fec_data[1,]

#Limpiamos las datas de la primera columna 
curva_soberana_dolares = curva_soberana_dolares[-1,]
curva_soberana_colones = curva_soberana_colones[-1,]

#Agregamos el codigo de la moneda dependiendo del archivo 
curva_soberana_colones$moneda = "CRC"
curva_soberana_dolares$moneda = "USD"

#agregamos la columna de fecha data a las bases
curva_soberana_colones$fec_data = fec_data
curva_soberana_dolares$fec_data = fec_data

#ordenamos las columnas del data frame 
curva_soberana_dolares = curva_soberana_dolares[,c(4,3,1,2)]
curva_soberana_colones = curva_soberana_colones[,c(4,3,1,2)]

#Renombramos las columnas 
names(curva_soberana_dolares) = c("fec_data","moneda", "periodo", "rfr" )
names(curva_soberana_colones) = c("fec_data","moneda", "periodo", "rfr" )

# Union base colones y dolares --> creación del dm_tasa_descuento
dm_tasa_descuento = rbind(curva_soberana_colones,curva_soberana_dolares) 
dm_tasa_descuento$rfr[is.na(dm_tasa_descuento$rfr)] = 0

#------------------------------------------------ dm_tc  -------------------------------------------------------------------
#Columnas a consturir: 
#              fecha    -     tc 

#creamos una columana dia-mes-año porque al importar desde el BCCR no esta en un formato adminito por r
tipo_de_cambio$año = substr(tipo_de_cambio$fec, start = 7, stop = 11)
tipo_de_cambio$mes = substr(tipo_de_cambio$fec, start = 3, stop = 6)
tipo_de_cambio$dia = substr(tipo_de_cambio$fec, start = 1, stop = 2)

#colocamos con formato número el día y el año y eliminamos espacios en blanco de mes
tipo_de_cambio$año = as.numeric(tipo_de_cambio$año)
tipo_de_cambio$dia = as.numeric(tipo_de_cambio$dia)
tipo_de_cambio$mes =trimws(tipo_de_cambio$mes)

#cambiamos a formato numerico el mes 
tipo_de_cambio$MES_1 = case_when(
  tipo_de_cambio$mes == "Ene" ~ "01",
  tipo_de_cambio$mes == "Feb" ~ "02",
  tipo_de_cambio$mes == "Mar" ~ "03",
  tipo_de_cambio$mes == "Abr" ~ "04",
  tipo_de_cambio$mes == "May" ~ "05",
  tipo_de_cambio$mes == "Jun" ~ "06",
  tipo_de_cambio$mes == "Jul" ~ "07",
  tipo_de_cambio$mes == "Ago" ~ "08",
  tipo_de_cambio$mes == "Set" ~ "09",
  tipo_de_cambio$mes == "Oct" ~ "10",
  tipo_de_cambio$mes == "Nov" ~ "11",
  tipo_de_cambio$mes == "Dic" ~ "12",
  TRUE ~ "Error"
)
tipo_de_cambio$MES_1 = as.numeric(tipo_de_cambio$MES_1)

#creamos una nueva variable de fecha
tipo_de_cambio$fecha = paste(tipo_de_cambio$dia,"/",tipo_de_cambio$MES_1,"/",tipo_de_cambio$año) 
tipo_de_cambio$fecha = str_remove_all(tipo_de_cambio$fecha," ")
tipo_de_cambio$fecha = as.Date(tipo_de_cambio$fecha,format = "%d/%m/%Y")

#cambiamos el nombre de la varibale tipo de cambio venta por tc
names(tipo_de_cambio)[3] = "tc"

#creamos el dm_tc
dm_tc = tipo_de_cambio[,c(8,3)]


#------------------------------------------------ dm_siniestros  -------------------------------------------------------------------
#------- PARTE QUE REQUIERE JHON PARA EL CODIGO
#se limpian las datas con los datos que se necesitan unicamente
oynr_desempleo_500_2 = oynr_desempleo_500[,c(3:6,9,11,12)]
oynr_desempleo_501_2 = oynr_desempleo_501[,c(3:6,9,11,12)]
oynr_incendio_143_2 = oynr_incendio_143[,c(3:6,9,11,12)]
oynr_incendio_153_2 = oynr_incendio_153[,c(3:6,9,11,12)]
oynr_prf_230_232_2 = oynr_prf_230_232[,c(3:6,9,11,12)]
oynr_vida_2 = oynr_vida[,c(1,3,4,5:8)]

#Colocamos los nombres de las columnas iguales y hacemos que todos tengan el mismo orden
names(oynr_desempleo_500_2) = c("producto","poliza","fecha_ocurrencia","fecha_recibido","monto","siniestro","fecha")
names(oynr_desempleo_501_2) = c("producto","poliza","fecha_ocurrencia","fecha_recibido","monto","siniestro","fecha")
names(oynr_incendio_143_2) = c("producto","poliza","fecha_ocurrencia","fecha_recibido","monto","siniestro","fecha")
names(oynr_incendio_153_2) = c("producto","poliza","fecha_ocurrencia","fecha_recibido","monto","siniestro","fecha")
names(oynr_prf_230_232_2) = c("producto","poliza","fecha_ocurrencia","fecha_recibido","monto","siniestro","fecha")
names(oynr_vida_2)= c("siniestro","fecha_ocurrencia","fecha_recibido","producto","poliza","monto","fecha")
oynr_vida_2 = oynr_vida_2[,c(4,5,2,3,6,1,7)]

#Lo primero que se hace es excluir los datos anteriores al 2016 en la columna: "fecha de pago"
oynr_desempleo_500_2 =subset(oynr_desempleo_500_2, fecha  > "2016-12-31")
oynr_desempleo_501_2 =subset(oynr_desempleo_501_2, fecha  > "2016-12-31")
oynr_incendio_143_2 =subset(oynr_incendio_143_2, fecha  > "2016-12-31")
oynr_incendio_153_2 =subset(oynr_incendio_153_2, fecha  > "2016-12-31")
oynr_prf_230_232_2 =subset(oynr_prf_230_232_2, fecha  > "2016-12-31")
oynr_vida_2 =subset(oynr_vida_2, fecha  > "2016-12-31")

#Volvemos los montos datos de tipo numerico para poder sumar 
oynr_desempleo_500_2$monto = as.numeric(oynr_desempleo_500_2$monto)
oynr_desempleo_501_2$monto = as.numeric(oynr_desempleo_501_2$monto)
oynr_incendio_143_2$monto = as.numeric(oynr_incendio_143_2$monto)
oynr_incendio_153_2$monto = as.numeric(oynr_incendio_153_2$monto)
oynr_prf_230_232_2$monto = as.numeric(oynr_prf_230_232_2$monto)
oynr_vida_2$monto = as.numeric(oynr_vida_2$monto)


# Para oynr_vida vamos agrupar todos los que son 781 y 782 
oynr_vida_2$producto = case_when(
  str_detect(toupper(oynr_vida_2$producto), "782", negate = FALSE) ~ "782",
  str_detect(toupper(oynr_vida_2$producto), "781", negate = FALSE) ~ "781",
  TRUE ~ oynr_vida_2$producto)

#Despues agrupar por cod_poliza, cod_siniestro y fec_ocurrencia 
oynr_desempleo_500_2  = data.frame(oynr_desempleo_500_2  %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto, fecha_recibido) %>% summarise(monto = sum(monto)))
oynr_desempleo_501_2  = data.frame(oynr_desempleo_501_2  %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto,fecha_recibido) %>% summarise(monto = sum(monto)))
oynr_incendio_143_2   = data.frame(oynr_incendio_143_2   %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto,fecha_recibido) %>% summarise(monto = sum(monto)))
oynr_incendio_153_2   = data.frame(oynr_incendio_153_2   %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto,fecha_recibido) %>% summarise(monto = sum(monto)))
oynr_prf_230_232_2    = data.frame(oynr_prf_230_232_2    %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto,fecha_recibido) %>% summarise(monto = sum(monto)))
oynr_vida_2           = data.frame(oynr_vida_2           %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto,fecha_recibido) %>% summarise(monto = sum(monto)))

#Traemos la tasa de cambio de la dm_tc 
oynr_desempleo_500_2 = left_join (oynr_desempleo_500_2,dm_tc, by = "fecha")
oynr_desempleo_501_2 = left_join (oynr_desempleo_501_2,dm_tc, by = "fecha")
oynr_incendio_143_2  = left_join (oynr_incendio_143_2 ,dm_tc, by = "fecha")
oynr_incendio_153_2  = left_join (oynr_incendio_153_2 ,dm_tc, by = "fecha")
oynr_prf_230_232_2   = left_join (oynr_prf_230_232_2 ,dm_tc, by = "fecha")
oynr_vida_2          = left_join (oynr_vida_2  ,dm_tc, by = "fecha")

#construimos la columna en moneda extranjera
oynr_desempleo_500_2$pago_bruto_me = oynr_desempleo_500_2$monto / oynr_desempleo_500_2$tc
oynr_desempleo_501_2$pago_bruto_me = oynr_desempleo_501_2$monto / oynr_desempleo_501_2$tc
oynr_incendio_143_2$pago_bruto_me  = oynr_incendio_143_2$monto / oynr_incendio_143_2$tc
oynr_incendio_153_2$pago_bruto_me  = oynr_incendio_153_2$monto / oynr_incendio_153_2$tc
oynr_prf_230_232_2$pago_bruto_me   = oynr_prf_230_232_2$monto / oynr_prf_230_232_2$tc
oynr_vida_2$pago_bruto_me  = oynr_vida_2$monto / oynr_vida_2$tc

#unimos las bases de datos 
dm_siniestros_2 = rbind(oynr_desempleo_500_2, oynr_desempleo_501_2,oynr_incendio_143_2,oynr_incendio_153_2,oynr_prf_230_232_2,oynr_vida_2) 

#cambiamos el nombre de las columnas
names(dm_siniestros_2) = c("cod_poliza","cod_siniestro","fec_ocurrencia", "fec_pago", "cod_producto","fecha_recibido" ,"pago_bruto_mn", "tc","pago_bruto_me" )

#agregamos la columna fec_data, pago_cedido_mn y pago_cedido_me
dm_siniestros_2$fec_data = fec_data
dm_siniestros_2$pago_cedido_mn = 0
dm_siniestros_2$pago_cedido_me = 0

#ordenamos y limpiamos la data 
dm_siniestros_2 = dm_siniestros_2 [,-8]
dm_siniestros_2 = dm_siniestros_2[,c("fec_data","cod_producto","cod_poliza","cod_siniestro","fec_ocurrencia","fec_pago","pago_bruto_mn", "pago_bruto_me", "pago_cedido_mn", "pago_cedido_me","fecha_recibido")]

#colocamos la fecha en formato estandar 
dm_siniestros_2$fec_data = as.Date(dm_siniestros_2$fec_data) 
dm_siniestros_2$fec_ocurrencia= as.Date(dm_siniestros_2$fec_ocurrencia) 
dm_siniestros_2$fec_pago = as.Date(dm_siniestros_2$fec_pago) 
dm_siniestros_2$fecha_recibido = as.Date(dm_siniestros_2$fecha_recibido)



#------------------------------ Construcción original dm_siniestros ----------------------------
#se limpian las datas con los datos que se necesitan unicamente
oynr_desempleo_500 = oynr_desempleo_500[,c(3:5,9,11,12)]
oynr_desempleo_501 = oynr_desempleo_501[,c(3:5,9,11,12)]
oynr_incendio_143 = oynr_incendio_143[,c(3:5,9,11,12)]
oynr_incendio_153 = oynr_incendio_153[,c(3:5,9,11,12)]
oynr_prf_230_232 = oynr_prf_230_232[,c(3:5,9,11,12)]
oynr_vida = oynr_vida[,c(1,3,5:8)]

#Colocamos los nombres de las columnas iguales y hacemos que todos tengan el mismo orden
names(oynr_desempleo_500) = c("producto","poliza","fecha_ocurrencia","monto","siniestro","fecha")
names(oynr_desempleo_501) = c("producto","poliza","fecha_ocurrencia","monto","siniestro","fecha")
names(oynr_incendio_143) = c("producto","poliza","fecha_ocurrencia","monto","siniestro","fecha")
names(oynr_incendio_153) = c("producto","poliza","fecha_ocurrencia","monto","siniestro","fecha")
names(oynr_prf_230_232) = c("producto","poliza","fecha_ocurrencia","monto","siniestro","fecha")
names(oynr_vida)= c("siniestro","fecha_ocurrencia","producto","poliza","monto","fecha")
oynr_vida = oynr_vida[,c(3,4,2,5,1,6)]

#Lo primero que se hace es excluir los datos anteriores al 2016 en la columna: "fecha de pago"
oynr_desempleo_500 =subset(oynr_desempleo_500, fecha  > "2016-12-31")
oynr_desempleo_501 =subset(oynr_desempleo_501, fecha  > "2016-12-31")
oynr_incendio_143 =subset(oynr_incendio_143, fecha  > "2016-12-31")
oynr_incendio_153 =subset(oynr_incendio_153, fecha  > "2016-12-31")
oynr_prf_230_232 =subset(oynr_prf_230_232, fecha  > "2016-12-31")
oynr_vida =subset(oynr_vida, fecha  > "2016-12-31")

#Volvemos los montos datos de tipo numerico para poder sumar 
oynr_desempleo_500$monto = as.numeric(oynr_desempleo_500$monto)
oynr_desempleo_501$monto = as.numeric(oynr_desempleo_501$monto)
oynr_incendio_143$monto = as.numeric(oynr_incendio_143$monto)
oynr_incendio_153$monto = as.numeric(oynr_incendio_153$monto)
oynr_prf_230_232$monto = as.numeric(oynr_prf_230_232$monto)
oynr_vida$monto = as.numeric(oynr_vida$monto)


# Para oynr_vida vamos agrupar todos los que son 781 y 782 
oynr_vida$producto = case_when(
  str_detect(toupper(oynr_vida$producto), "782", negate = FALSE) ~ "782",
  str_detect(toupper(oynr_vida$producto), "781", negate = FALSE) ~ "781",
  TRUE ~ oynr_vida$producto)

#Despues agrupar por cod_poliza, cod_siniestro y fec_ocurrencia 
oynr_desempleo_500  = data.frame(oynr_desempleo_500  %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto) %>% summarise(monto = sum(monto)))
oynr_desempleo_501  = data.frame(oynr_desempleo_501  %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto) %>% summarise(monto = sum(monto)))
oynr_incendio_143   = data.frame(oynr_incendio_143   %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto) %>% summarise(monto = sum(monto)))
oynr_incendio_153   = data.frame(oynr_incendio_153   %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto) %>% summarise(monto = sum(monto)))
oynr_prf_230_232    = data.frame(oynr_prf_230_232    %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto) %>% summarise(monto = sum(monto)))
oynr_vida           = data.frame(oynr_vida           %>% group_by(poliza, siniestro,fecha_ocurrencia, fecha, producto) %>% summarise(monto = sum(monto)))

#Traemos la tasa de cambio de la dm_tc 
oynr_desempleo_500 = left_join (oynr_desempleo_500,dm_tc, by = "fecha")
oynr_desempleo_501 = left_join (oynr_desempleo_501,dm_tc, by = "fecha")
oynr_incendio_143  = left_join (oynr_incendio_143 ,dm_tc, by = "fecha")
oynr_incendio_153  = left_join (oynr_incendio_153 ,dm_tc, by = "fecha")
oynr_prf_230_232   = left_join (oynr_prf_230_232 ,dm_tc, by = "fecha")
oynr_vida          = left_join (oynr_vida  ,dm_tc, by = "fecha")

#construimos la columna en moneda extranjera
oynr_desempleo_500$pago_bruto_me = oynr_desempleo_500$monto / oynr_desempleo_500$tc
oynr_desempleo_501$pago_bruto_me = oynr_desempleo_501$monto / oynr_desempleo_501$tc
oynr_incendio_143$pago_bruto_me  = oynr_incendio_143$monto / oynr_incendio_143$tc
oynr_incendio_153$pago_bruto_me  = oynr_incendio_153$monto / oynr_incendio_153$tc
oynr_prf_230_232$pago_bruto_me   = oynr_prf_230_232$monto / oynr_prf_230_232$tc
oynr_vida$pago_bruto_me  = oynr_vida$monto / oynr_vida$tc

#unimos las bases de datos 
dm_siniestros = rbind(oynr_desempleo_500, oynr_desempleo_501,oynr_incendio_143,oynr_incendio_153,oynr_prf_230_232,oynr_vida) 

#cambiamos el nombre de las columnas
names(dm_siniestros) = c("cod_poliza","cod_siniestro","fec_ocurrencia", "fec_pago", "cod_producto", "pago_bruto_mn", "tc","pago_bruto_me" )

#agregamos la columna fec_data, pago_cedido_mn y pago_cedido_me
dm_siniestros$fec_data = fec_data
dm_siniestros$pago_cedido_mn = 0
dm_siniestros$pago_cedido_me = 0

#ordenamos y limpiamos la data 
dm_siniestros = dm_siniestros [,-7]
dm_siniestros = dm_siniestros[,c("fec_data","cod_producto","cod_poliza","cod_siniestro","fec_ocurrencia","fec_pago","pago_bruto_mn", "pago_bruto_me", "pago_cedido_mn", "pago_cedido_me")]

#colocamos la fecha en formato estandar 
dm_siniestros$fec_data = as.Date(dm_siniestros$fec_data) 
dm_siniestros$fec_ocurrencia= as.Date(dm_siniestros$fec_ocurrencia) 
dm_siniestros$fec_pago = as.Date(dm_siniestros$fec_pago) 


#------------------------------------------------ dm_capital -------------------------------------------------------------------
#Columnas a consturir: 
#                    fec_data	 -  des_ramo	-  cap_bruto_primas	- cap_bruto_reservas

#construimos el vector fijo
desc_ramo = c("vida","accidentes","incendios y líneas aliadas (excepto industrial y comercial)", "otros daños a los bienes", "pérdidas pecuniarias")

#Construimos el data frame 
dm_capital = data.frame(fec_data,desc_ramo)

#empezamos a extraer cada dato para construir "cap_bruto_primas"	
#rcs3
vida_bruta = anexo4_isc_rcs3[3,7]
accidentes_bruta = anexo4_isc_rcs3[19,7]
#rcs4
incendios_bruta = anexo4_isc_rcs4[2,7]
otros_bruta = anexo4_isc_rcs4[46,7]
perdidas_brutas = anexo4_isc_rcs4[60,7]

cap_bruto_primas = c(vida_bruta,accidentes_bruta,incendios_bruta,otros_bruta,perdidas_brutas)

#empezamos a extraer cada dato para construir "cap_bruto_reservas"
#rcs3
vida_reservas = anexo4_isc_rcs3[4,7]
accidentes_reservas = anexo4_isc_rcs3[20,7]
#rcs4
incendios_reservas = anexo4_isc_rcs4[3,7]
otros_reservas = anexo4_isc_rcs4[47,7]
perdidas_reservas = anexo4_isc_rcs4[61,7]

cap_bruto_reservas = c(vida_reservas,accidentes_reservas,incendios_reservas,otros_reservas,perdidas_reservas)

#unimos los datos 
dm_capital$cap_bruto_primas = as.numeric(cap_bruto_primas)
dm_capital$cap_bruto_reservas = as.numeric(cap_bruto_reservas)

#------------------------------------------------ dm_polizas -------------------------------------------------------------------
#Limpiamos y extraemos solo los datos a usar de auxiliar_ppnd
auxiliar_ppnd_polizas = auxiliar_ppnd[,c("NUMERO_POLIZA", "ENDOS", "VALOR_PRIMA", "RESERVA_MES_ACTUAL", "FEC_INIC", "FEC_VENC", "RAMO")]

#re-nombramos las columnas
names(auxiliar_ppnd_polizas) = c("cod_poliza","cod_endoso", "prima_bruta", "ppnd_bruta", "fec_ini_vigencia", "fec_fin_vigencia", "cod_producto")

auxiliar_ppnd_polizas$cod_poliza = as.character(auxiliar_ppnd_polizas$cod_poliza)
auxiliar_ppnd_polizas$cod_endoso = as.character(auxiliar_ppnd_polizas$cod_endoso)
auxiliar_ppnd_polizas$cod_producto = as.character(auxiliar_ppnd_polizas$cod_producto)

#añadimos cumulo 
cod_poliza = c("Cumulo", "Cumulo") 
cod_endoso = c("0","0")
prima_bruta = c(0,0) 
ppnd_bruta = c(0,0)
fec_ini_vigencia = c("20230101", "20230101")
fec_fin_vigencia = c("20230101", "20230101")
cod_producto = c("718", "754")

cumulo = data.frame(cod_poliza,cod_endoso,prima_bruta,ppnd_bruta,fec_ini_vigencia,fec_fin_vigencia,cod_producto)
auxiliar_ppnd_polizas = rbind(auxiliar_ppnd_polizas,cumulo)

#Despues agrupar por cod_prodcuto, cod_poliza, y cod_endoso 
dm_poliza = data.frame(auxiliar_ppnd_polizas  %>% group_by(cod_producto, cod_poliza, cod_endoso, fec_ini_vigencia, fec_fin_vigencia) %>% summarise(prima_bruta = sum(prima_bruta), ppnd_bruta = sum(ppnd_bruta)))

#Limpiamos y extraemos solo los datos a usar de auxiliar_cesion_1060 
auxiliar_cesion_1060_polizas = auxiliar_cesion_1060[,c(3:5,13,14,19,32)]

#nombramos las columnas
names(auxiliar_cesion_1060_polizas) = c("cod_producto", "cod_poliza","cod_endoso", "FEC_INIC", "FEC_VENC", "prima_cedida", "ppnd_cedida")

#Despues agrupar por cod_prodcuto, cod_poliza, y cod_endoso 
cedido = data.frame(auxiliar_cesion_1060_polizas  %>% group_by(cod_producto, cod_poliza, cod_endoso) %>% summarise(prima_cedida = sum(prima_cedida), ppnd_cedida = sum(ppnd_cedida)))

#cambiamos el nombre a cod_producto en dm_poliza
names(dm_poliza)[1] = "cod_producto"

#unimos las bases de datos usando la llave cod_poliza y cod_endoso
dm_poliza$cod_poliza = as.character(dm_poliza$cod_poliza)
dm_poliza$cod_endoso = as.character(dm_poliza$cod_endoso)
dm_poliza$cod_producto = as.character(dm_poliza$cod_producto)
cedido$cod_poliza = as.character(cedido$cod_poliza)
cedido$cod_endoso = as.character(cedido$cod_endoso)
cedido$cod_producto = as.character(cedido$cod_producto)

dm_poliza = left_join(dm_poliza, cedido, by = c("cod_producto","cod_poliza", "cod_endoso"))

#organizamos la data con las columnas que vamos a usar y el orden especifico 
dm_poliza$fec_data = fec_data

#rellenamos con cero cualquier dato NULL
dm_poliza[is.na(dm_poliza)] = 0

#construimos la columna ppnd_neto
dm_poliza$ppnd_neto = dm_poliza$ppnd_bruta - dm_poliza$ppnd_cedida

#dm_poliza final
dm_poliza = dm_poliza[,c("fec_data","cod_producto","cod_poliza","cod_endoso","fec_ini_vigencia","fec_fin_vigencia","prima_bruta","prima_cedida","ppnd_bruta","ppnd_cedida","ppnd_neto")]

#colocar los de cumulo con fecha del de auxiliar 
prueba = filter(dm_poliza, dm_poliza$cod_poliza == "Cumulo")
prueba2 = filter(dm_poliza, dm_poliza$cod_poliza != "Cumulo")
auxiliar_cumulo = filter(auxiliar_cesion_1060_polizas, auxiliar_cesion_1060_polizas$cod_poliza == "Cumulo")

prueba$cod_producto = as.character(prueba$cod_producto)
prueba$cod_poliza = as.character(prueba$cod_poliza)
prueba$cod_endoso = as.character(prueba$cod_endoso)
auxiliar_cumulo$cod_producto =  as.character(auxiliar_cumulo$cod_producto)
auxiliar_cumulo$cod_poliza =  as.character(auxiliar_cumulo$cod_poliza)
auxiliar_cumulo$cod_endoso =  as.character(auxiliar_cumulo$cod_endoso)

prueba_1 = merge(prueba, auxiliar_cumulo, by = c("cod_producto", "cod_poliza", "cod_endoso", "prima_cedida", "ppnd_cedida"))
prueba_1 = prueba_1[,c("fec_data","cod_producto","cod_poliza","cod_endoso","prima_bruta","prima_cedida","ppnd_bruta","ppnd_cedida","ppnd_neto", "FEC_INIC", "FEC_VENC")]

prueba_1$año = substr(prueba_1$FEC_INIC, start = 1, stop = 4)
prueba_1$mes = substr(prueba_1$FEC_INIC, start = 6, stop = 7)
prueba_1$dia = substr(prueba_1$FEC_INIC, start = 9, stop = 10)

#creamos una nueva variable de fecha
prueba_1$fec_ini_vigencia = paste(prueba_1$año,prueba_1$mes,prueba_1$dia) 
prueba_1$fec_ini_vigencia = str_remove_all(prueba_1$fec_ini_vigencia ," ")


prueba_1$año = substr(prueba_1$FEC_VENC, start = 1, stop = 4)
prueba_1$mes = substr(prueba_1$FEC_VENC, start = 6, stop = 7)
prueba_1$dia = substr(prueba_1$FEC_VENC, start = 9, stop = 10)
#creamos una nueva variable de fecha
prueba_1$fec_fin_vigencia = paste(prueba_1$año,prueba_1$mes,prueba_1$dia) 
prueba_1$fec_fin_vigencia = str_remove_all(prueba_1$fec_fin_vigencia ," ")

#cumulo con fecha correcta
prueba_1 = prueba_1[,c("fec_data","cod_producto","cod_poliza","cod_endoso","fec_ini_vigencia","fec_fin_vigencia","prima_bruta","prima_cedida","ppnd_bruta","ppnd_cedida","ppnd_neto")]

#unión y final de dm polizas
dm_poliza = rbind(prueba2, prueba_1)

#------------------------------------------------ dm_reservas -------------------------------------------------------------------
#agrupamos por cod_producto 
dm_reservas = data.frame(auxiliar_ppnd  %>% group_by (RAMO) %>% summarise(ppnd_bruta = sum(RESERVA_MES_ACTUAL)))
names(dm_reservas)[1] = "cod_producto"

#un marge para traer el ramo y la moneda
dm_reservas = merge(dm_reservas, productos_ramo, by = "cod_producto")
dm_reservas = dm_reservas[,-3]

#definimos la variables en una nueva tabla para no modificar la tabla original 
auxiliar_cesion_1060_reservas = auxiliar_cesion_1060

#agrupamos cod_producto 
cesion = data.frame(auxiliar_cesion_1060_reservas  %>% group_by (PRODUCTO) %>% summarise(ppnd_cedida = sum( Prima_No_Deng)))
names(cesion)[1] = "cod_producto"
cesion$cod_producto = as.character(cesion$cod_producto)

#merge cesion con dm_reservas --> revisar que de 0 cuando sea nulo
dm_reservas = left_join(dm_reservas, cesion, by = "cod_producto")
dm_reservas$ppnd_cedida = as.numeric(dm_reservas$ppnd_cedida)

#rellenamos con cero cualquier dato NULL
dm_reservas[is.na(dm_reservas)] = 0

#creamos ppnd_neta
dm_reservas$ppnd_neta = dm_reservas$ppnd_bruta - dm_reservas$ppnd_cedida

#creación pip y rva_catastrofe
#convertimos los NA en 0 
mov_ramos$ImporteDebito[is.na(mov_ramos$ImporteDebito)] = 0
mov_ramos$ImporteCredito[is.na(mov_ramos$ImporteCredito)] = 0

#crear columna de neto = debito - credito 
mov_ramos$neto = mov_ramos$ImporteDebito - mov_ramos$ImporteCredito

#creamos la columna cod_producto de la columna ramo, extrayendo los ultimos 3 digitos 
mov_ramos$cod_producto = substr(mov_ramos$Ramo, start = 7, stop = 9)

#dejamos el archivo con las columnas que necesitamos que son cod_producto, cuenta y neto (debito-credito)
mov_ramos = mov_ramos[,c("Cuenta", "neto", "cod_producto", "NombreRamo" )]

#unimos el archvo detalle de movimiento y cuenta tipo, usando como llave cod_producto y cuenta 
names(cuentas_tipo) = c("tipo", "cod_producto", "Cuenta")
mov_ramos$cod_producto = as.character(mov_ramos$cod_producto)
cuentas_tipo$cod_producto = as.character(cuentas_tipo$cod_producto)
mov_ramos = merge(mov_ramos, cuentas_tipo, by = c("cod_producto", "Cuenta"))
#aquí para uso de esta como de actuals 

#creamos c.pip
pip = saldos_pip[,c("Producto", "Saldo")]
names(pip) = c("cod_producto", "pip")
pip$cod_producto = as.character(pip$cod_producto)

# creamos  c.rcat
rva_catastrofre = saldos_rcat[,c("Producto", "Saldo")]
names(rva_catastrofre) = c("cod_producto", "rva_catastrofe")
rva_catastrofre$cod_producto = as.character(rva_catastrofre$cod_producto)

#unimos con dm_reservas
dm_reservas = left_join(dm_reservas, pip, by = "cod_producto")
dm_reservas = left_join(dm_reservas, rva_catastrofre, by = "cod_producto")

#construcción oynr_bruta
#dejamos unicamente estas dos filas las columnas a usar
#==============================================================================#
Reservas_Consolidadas <- merge(Reservas_Ultimo_Periodo, Reservas_Acumuladas, all = TRUE)

Reservas_Consolidadas <-
  Reservas_Consolidadas %>%
  mutate(
    `RESERVA DISPONIBLE EN DOLARES` = if_else(is.na(`RESERVA DISPONIBLE EN DOLARES`) | round(`RESERVA DISPONIBLE EN DOLARES`, 0) == 0, 0, `RESERVA DISPONIBLE EN DOLARES`),
    `TIPO DE CAMBIO` = if_else(is.na(`TIPO DE CAMBIO`) | round(`TIPO DE CAMBIO`, 0) == 0, 0, `TIPO DE CAMBIO`),
    `RESERVA DE DOLARES COLONIZADA` = if_else(is.na(`RESERVA DE DOLARES COLONIZADA`) | round(`RESERVA DE DOLARES COLONIZADA`, 0) == 0, 0, `RESERVA DE DOLARES COLONIZADA`),
    `RESERVA DISPONIBLE COLONES` = if_else(is.na(`RESERVA DISPONIBLE COLONES`) | round(`RESERVA DISPONIBLE COLONES`, 0) == 0, 0, `RESERVA DISPONIBLE COLONES`)
  )

rm(Reservas_Ultimo_Periodo, Reservas_Acumuladas)

#==============================================================================#

Corte <- dm_siniestros_2$fec_data %>% unique()
Meses_Delay <- month(Corte)

#==============================================================================#

BBDD_Pagos <-
  dm_siniestros_2 %>%
  rename(PRODUCTO = cod_producto,
         FECHA_DE_OCURRENCIA = fec_ocurrencia,
         FECHA_DE_AVISO = fecha_recibido,
         MES = fec_pago,
         MONTO_EN_COLONES = pago_bruto_mn)

BBDD_Reservas <-
  Reservas_Consolidadas %>%
  rename(FECHA_EVENTO = `FECHA EVENTO`,
         FECHA_AVISO = `FECHA AVISO`,
         RESERVA_DISPONIBLE = `RESERVA DISPONIBLE COLONES`) %>%
  mutate(FECHA_CORTE = `fecha de Reserva` %m+% months(1) - 1) %>%
  mutate(FECHA_CORTE = as.Date(FECHA_CORTE, format = "%Y-%m-%d"))

BBDD_Pagos <-
  BBDD_Pagos %>%
  mutate(PRODUCTO_NEW = case_when(
    PRODUCTO == "501" | str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "DESEMPLEO_COL",
    PRODUCTO == "500" ~ "DESEMPLEO_USD",
    PRODUCTO == "143" | PRODUCTO == "109" ~ "HOGAR_COL",
    PRODUCTO == "153" | PRODUCTO == "108" ~ "HOGAR_USD",
    PRODUCTO == "231" ~ "PRF_COL",
    PRODUCTO == "230" | PRODUCTO == "232" ~ "PRF_USD",
    PRODUCTO == "208" | PRODUCTO == "869" ~ "MOMENTOS_VIDA_COL",
    PRODUCTO == "209" | PRODUCTO == "868" ~ "MOMENTOS_VIDA_USD",
    PRODUCTO == "799" ~ "ACCIDENTES_COL",
    PRODUCTO == "798" ~ "ACCIDENTES_USD",
    PRODUCTO == "782" | PRODUCTO == "719" | PRODUCTO == "754" | PRODUCTO == "862" | str_detect(toupper(PRODUCTO), "782", negate = FALSE) | PRODUCTO == "867" ~ "VIDA_COL",
    PRODUCTO == "781" | PRODUCTO == "718" | PRODUCTO == "856" | PRODUCTO == "860" | str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "VIDA_USD",
    PRODUCTO == "199" ~ "TODO_RIESGO_USD",
    TRUE ~ NA_character_
  ))

BBDD_Reservas <-
  BBDD_Reservas %>%
  mutate(PRODUCTO_NEW = case_when(
    PRODUCTO == "501" | str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "DESEMPLEO_COL",
    PRODUCTO == "500" ~ "DESEMPLEO_USD",
    PRODUCTO == "143" | PRODUCTO == "109" ~ "HOGAR_COL",
    PRODUCTO == "153" | PRODUCTO == "108" ~ "HOGAR_USD",
    PRODUCTO == "231" ~ "PRF_COL",
    PRODUCTO == "230" | PRODUCTO == "232" ~ "PRF_USD",
    PRODUCTO == "208" | PRODUCTO == "869" ~ "MOMENTOS_VIDA_COL",
    PRODUCTO == "209" | PRODUCTO == "868" ~ "MOMENTOS_VIDA_USD",
    PRODUCTO == "799" ~ "ACCIDENTES_COL",
    PRODUCTO == "798" ~ "ACCIDENTES_USD",
    PRODUCTO == "782" | PRODUCTO == "719" | PRODUCTO == "754" | PRODUCTO == "862" | str_detect(toupper(PRODUCTO), "782", negate = FALSE) | PRODUCTO == "867" ~ "VIDA_COL",
    PRODUCTO == "781" | PRODUCTO == "718" | PRODUCTO == "856" | PRODUCTO == "860" | str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "VIDA_USD",
    PRODUCTO == "199" ~ "TODO_RIESGO_USD",
    TRUE ~ NA_character_
  ))

aux_1 <-
  BBDD_Pagos %>%
  select(PRODUCTO_NEW,PRODUCTO) %>%
  unique() %>%
  arrange(PRODUCTO_NEW,PRODUCTO)

aux_2 <-
  BBDD_Reservas %>%
  select(PRODUCTO_NEW,PRODUCTO) %>%
  unique() %>%
  arrange(PRODUCTO_NEW,PRODUCTO)

rm(aux_1,aux_2)

#==============================================================================#

BBDD_Pagos <-
  BBDD_Pagos %>%
  mutate(PRODUCTO_NUMBER = case_when(
    str_detect(toupper(PRODUCTO), "782", negate = FALSE) ~ "782",
    str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "781",
    str_detect(toupper(PRODUCTO), "500", negate = FALSE) ~ "500",
    str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "501",
    TRUE ~ PRODUCTO
  ))

BBDD_Reservas <-
  BBDD_Reservas %>%
  mutate(PRODUCTO_NUMBER = case_when(
    str_detect(toupper(PRODUCTO), "782", negate = FALSE) ~ "782",
    str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "781",
    str_detect(toupper(PRODUCTO), "500", negate = FALSE) ~ "500",
    str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "501",
    TRUE ~ PRODUCTO
  ))

#==============================================================================#

Fechas <- 1:12
Fechas <- data.frame(Fechas)
Fechas$Periodo <- str_sub(Corte, 1, 7)
Fechas$To <- Corte
Fechas$Tf <- Corte
Fechas <- Fechas %>% select(-c(Fechas))

Fechas$To[1] <- Fechas$Tf[1] %m+% months(-12)
for (i in 2:12) {
  Fechas$Tf[i] <- Corte %m+% months(-(i-1))
  Fechas$To[i] <- Fechas$Tf[i] %m+% months(-12)
}

rm(i)

#==============================================================================#

i <- 1

BBDD_rsa_Tf_IBNR <-
  BBDD_Reservas %>%
  filter(FECHA_CORTE == Fechas$Tf[i] & FECHA_EVENTO <= Fechas$To[i] & FECHA_AVISO > Fechas$To[i]) %>%
  #
  mutate(tmp_1 = as.integer(str_sub(FECHA_EVENTO, 1, 4)) * 12 + as.integer(str_sub(FECHA_EVENTO, 6, 7)),
         tmp_2 = as.integer(str_sub(Fechas$To[i], 1, 4)) * 12 + as.integer(str_sub(Fechas$To[i], 6, 7)),
         DESARROLLO = tmp_2 - tmp_1) %>%
  group_by(PERIODO=Fechas$Periodo[i],PRODUCTO_NEW,PRODUCTO_NUMBER,DESARROLLO) %>%
  summarise(OYNR_RESERVA = sum(RESERVA_DISPONIBLE, na.rm = TRUE)) %>%
  ungroup()

BBDD_pagos_To_Tf_IBNR <-
  BBDD_Pagos %>%
  filter(FECHA_DE_OCURRENCIA <= Fechas$To[i] & FECHA_DE_AVISO > Fechas$To[i] & MES > Fechas$To[i] & MES <= Fechas$Tf[i]) %>%
  mutate(tmp_1 = as.integer(str_sub(FECHA_DE_OCURRENCIA, 1, 4)) * 12 + as.integer(str_sub(FECHA_DE_OCURRENCIA, 6, 7)),
         tmp_2 = as.integer(str_sub(Fechas$To[i], 1, 4)) * 12 + as.integer(str_sub(Fechas$To[i], 6, 7)),
         DESARROLLO = tmp_2 - tmp_1) %>%
  group_by(PERIODO=Fechas$Periodo[i],PRODUCTO_NEW,PRODUCTO_NUMBER,DESARROLLO) %>%
  summarise(OYNR_PAGOS = sum(MONTO_EN_COLONES, na.rm = TRUE)) %>%
  ungroup()

BBDD_Total_To_Tf_IBNR <-
  merge(BBDD_pagos_To_Tf_IBNR, BBDD_rsa_Tf_IBNR, all = TRUE) %>%
  group_by(PERIODO,PRODUCTO_NEW,PRODUCTO_NUMBER,DESARROLLO) %>%
  summarise(OYNR_PAGOS = sum(OYNR_PAGOS, na.rm = TRUE),
            OYNR_RESERVA = sum(OYNR_RESERVA, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(OYNR_TOTAL = OYNR_PAGOS + OYNR_RESERVA)

rm(BBDD_rsa_Tf_IBNR, BBDD_pagos_To_Tf_IBNR)

for (i in 2:12) {
  BBDD_rsa_Tf_IBNR <-
    BBDD_Reservas %>%
    filter(FECHA_CORTE == Fechas$Tf[i] & FECHA_EVENTO <= Fechas$To[i] & FECHA_AVISO > Fechas$To[i]) %>%
    #
    mutate(tmp_1 = as.integer(str_sub(FECHA_EVENTO, 1, 4)) * 12 + as.integer(str_sub(FECHA_EVENTO, 6, 7)),
           tmp_2 = as.integer(str_sub(Fechas$To[i], 1, 4)) * 12 + as.integer(str_sub(Fechas$To[i], 6, 7)),
           DESARROLLO = tmp_2 - tmp_1) %>%
    group_by(PERIODO=Fechas$Periodo[i],PRODUCTO_NEW,PRODUCTO_NUMBER,DESARROLLO) %>%
    summarise(OYNR_RESERVA = sum(RESERVA_DISPONIBLE, na.rm = TRUE)) %>%
    ungroup()
  
  BBDD_pagos_To_Tf_IBNR <-
    BBDD_Pagos %>%
    filter(FECHA_DE_OCURRENCIA <= Fechas$To[i] & FECHA_DE_AVISO > Fechas$To[i] & MES > Fechas$To[i] & MES <= Fechas$Tf[i]) %>%
    mutate(tmp_1 = as.integer(str_sub(FECHA_DE_OCURRENCIA, 1, 4)) * 12 + as.integer(str_sub(FECHA_DE_OCURRENCIA, 6, 7)),
           tmp_2 = as.integer(str_sub(Fechas$To[i], 1, 4)) * 12 + as.integer(str_sub(Fechas$To[i], 6, 7)),
           DESARROLLO = tmp_2 - tmp_1) %>%
    group_by(PERIODO=Fechas$Periodo[i],PRODUCTO_NEW,PRODUCTO_NUMBER,DESARROLLO) %>%
    summarise(OYNR_PAGOS = sum(MONTO_EN_COLONES, na.rm = TRUE)) %>%
    ungroup()
  
  BBDD_Total_To_Tf_IBNR <-
    merge(BBDD_pagos_To_Tf_IBNR, BBDD_rsa_Tf_IBNR, all = TRUE) %>%
    group_by(PERIODO,PRODUCTO_NEW,PRODUCTO_NUMBER,DESARROLLO) %>%
    summarise(OYNR_PAGOS = sum(OYNR_PAGOS, na.rm = TRUE),
              OYNR_RESERVA = sum(OYNR_RESERVA, na.rm = TRUE)) %>%
    ungroup() %>%
    mutate(OYNR_TOTAL = OYNR_PAGOS + OYNR_RESERVA) %>%
    union_all(BBDD_Total_To_Tf_IBNR)
  
  rm(BBDD_rsa_Tf_IBNR, BBDD_pagos_To_Tf_IBNR)
}

rm(Fechas, i)

#==============================================================================#

TABLA_DISTRIBUCION_OYNR <-
  BBDD_Total_To_Tf_IBNR %>%
  mutate(PERIODO_OYNR = if_else(DESARROLLO < Meses_Delay, "OYNR_UP", "OYNR_PA")) %>%
  group_by(PRODUCTO_NEW,PRODUCTO_NUMBER,PERIODO_OYNR) %>%
  summarise(OYNR_TOTAL = sum(OYNR_TOTAL)) %>%
  ungroup() %>%
  pivot_wider(names_from = PERIODO_OYNR, values_from = OYNR_TOTAL) %>%
  mutate(OYNR_PA = if_else(is.na(OYNR_PA), 0, OYNR_PA),
         OYNR_UP = if_else(is.na(OYNR_UP), 0, OYNR_UP)) %>%
  mutate(Porcentaje_PA = OYNR_PA / (OYNR_PA + OYNR_UP),
         Porcentaje_UP = OYNR_UP / (OYNR_UP + OYNR_PA)) %>%
  mutate(Porcentaje_PA = if_else(is.na(Porcentaje_PA), 0, Porcentaje_PA),
         Porcentaje_UP = if_else(is.na(Porcentaje_UP), 1, Porcentaje_UP))

rm(BBDD_Total_To_Tf_IBNR)

#==============================================================================#

TABLA_DISTRIBUCION_RSA <-
  BBDD_Reservas %>%
  filter(FECHA_CORTE == Corte) %>%
  mutate(tmp_1 = as.integer(str_sub(FECHA_EVENTO, 1, 4)) * 12 + as.integer(str_sub(FECHA_EVENTO, 6, 7)),
         tmp_2 = as.integer(str_sub(Corte, 1, 4)) * 12 + as.integer(str_sub(Corte, 6, 7)),
         DESARROLLO = tmp_2 - tmp_1) %>%
  mutate(PERIODO_RSA = if_else(DESARROLLO < Meses_Delay, "RSA_UP", "RSA_PA")) %>%
  group_by(PRODUCTO_NEW,PRODUCTO_NUMBER,PERIODO_RSA) %>%
  summarise(RSA_TOTAL = sum(RESERVA_DISPONIBLE, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_wider(names_from = PERIODO_RSA, values_from = RSA_TOTAL) %>%
  mutate(RSA_PA = if_else(is.na(RSA_PA), 0, RSA_PA),
         RSA_UP = if_else(is.na(RSA_UP), 0, RSA_UP)) %>%
  mutate(Porcentaje_PA = RSA_PA / (RSA_PA + RSA_UP),
         Porcentaje_UP = RSA_UP / (RSA_UP + RSA_PA)) %>%
  mutate(Porcentaje_PA = if_else(is.na(Porcentaje_PA), 0, Porcentaje_PA),
         Porcentaje_UP = if_else(is.na(Porcentaje_UP), 1, Porcentaje_UP))


#==============================================================================#

Aux_1 <-
  BBDD_Pagos %>% 
  select(PRODUCTO_NEW,PRODUCTO_NUMBER) %>% 
  unique()

Aux_2 <-
  BBDD_Reservas %>% 
  select(PRODUCTO_NEW,PRODUCTO_NUMBER) %>% 
  unique()

Aux_3 <-
  union_all(Aux_1, Aux_2) %>% 
  unique()

rm(Aux_1, Aux_2)

TABLA_DISTRIBUCION_OYNR <-
  merge(TABLA_DISTRIBUCION_OYNR, Aux_3, all = TRUE) %>% 
  mutate(OYNR_PA = if_else(is.na(OYNR_PA), 0, OYNR_PA),
         OYNR_UP = if_else(is.na(OYNR_UP), 0, OYNR_UP),
         Porcentaje_PA = if_else(is.na(Porcentaje_PA), 0, Porcentaje_PA),
         Porcentaje_UP = if_else(is.na(Porcentaje_UP), 1, Porcentaje_UP))

TABLA_DISTRIBUCION_RSA <-
  merge(TABLA_DISTRIBUCION_RSA, Aux_3, all = TRUE) %>% 
  mutate(RSA_PA = if_else(is.na(RSA_PA), 0, RSA_PA),
         RSA_UP = if_else(is.na(RSA_UP), 0, RSA_UP),
         Porcentaje_PA = if_else(is.na(Porcentaje_PA), 0, Porcentaje_PA),
         Porcentaje_UP = if_else(is.na(Porcentaje_UP), 1, Porcentaje_UP))

rm(Aux_3)

rm(Corte, Meses_Delay, BBDD_Pagos, BBDD_Reservas)

#==============================================================================#

TABLA_DISTRIBUCION_OYNR %>%
  write.table("clipboard", sep = "\t", dec = ",", row.names = FALSE)

TABLA_DISTRIBUCION_RSA %>%
  write.table("clipboard", sep = "\t", dec = ",", row.names = FALSE)

#agregamos la fec_data
TABLA_DISTRIBUCION_OYNR$fec_data = fec_data

#Reordenamos
TABLA_DISTRIBUCION_OYNR = TABLA_DISTRIBUCION_OYNR[,c("fec_data", "PRODUCTO_NEW","PRODUCTO_NUMBER","OYNR_PA","OYNR_UP","Porcentaje_PA","Porcentaje_UP")] 

#agregamos la fec_data
TABLA_DISTRIBUCION_RSA$fec_data = fec_data

#Reordenamos
TABLA_DISTRIBUCION_RSA=TABLA_DISTRIBUCION_RSA[,c("fec_data" ,"PRODUCTO_NEW",    "PRODUCTO_NUMBER" ,"RSA_PA" , "RSA_UP", "Porcentaje_PA","Porcentaje_UP")] 

#==============================================================================#
#============================ Fin nuevas tablas ===============================#
#construcción oynr_bruta
#dejamos unicamente estas dos filas las columnas a usar
BBDD_Pagos <-
  dm_siniestros %>%
  mutate(PRODUCTO_NEW = case_when(
    cod_producto == "501" | str_detect(toupper(cod_producto), "501", negate = FALSE) ~ "DESEMPLEO_COL",
    cod_producto == "500" ~ "DESEMPLEO_USD",
    cod_producto == "143" | cod_producto == "109" ~ "HOGAR_COL",
    cod_producto == "153" | cod_producto == "108" ~ "HOGAR_USD",
    cod_producto == "231" ~ "PRF_COL",
    cod_producto == "230" | cod_producto == "232" ~ "PRF_USD",
    cod_producto == "208" | cod_producto == "869" ~ "VIDA",
    cod_producto == "209" | cod_producto == "868" ~ "VIDA",
    cod_producto == "799" ~ "VIDA",
    cod_producto == "798" ~ "VIDA",
    cod_producto == "782" | cod_producto == "719" | cod_producto == "754" | cod_producto == "862" | str_detect(toupper(cod_producto), "782", negate = FALSE) | cod_producto == "867" ~ "VIDA",
    cod_producto == "781" | cod_producto == "718" | cod_producto == "856" | cod_producto == "860" | str_detect(toupper(cod_producto), "781", negate = FALSE) ~ "VIDA",
    cod_producto == "199" ~ "TODO_RIESGO_USD",
    TRUE ~ NA_character_
  )) %>%
  rename(PRODUCTO = cod_producto) %>%
  filter(!is.na(PRODUCTO_NEW))

BBDD_Reservas <-
  reserva_siniestro_disponible %>%
  mutate(PRODUCTO_NEW = case_when(
    PRODUCTO == "501" | str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "DESEMPLEO_COL",
    PRODUCTO == "500" ~ "DESEMPLEO_USD",
    PRODUCTO == "143" | PRODUCTO == "109" ~ "HOGAR_COL",
    PRODUCTO == "153" | PRODUCTO == "108" ~ "HOGAR_USD",
    PRODUCTO == "231" ~ "PRF_COL",
    PRODUCTO == "230" | PRODUCTO == "232" ~ "PRF_USD",
    PRODUCTO == "208" | PRODUCTO == "869" ~ "VIDA",
    PRODUCTO == "209" | PRODUCTO == "868" ~ "VIDA",
    PRODUCTO == "799" ~ "VIDA",
    PRODUCTO == "798" ~ "VIDA",
    PRODUCTO == "782" | PRODUCTO == "719" | PRODUCTO == "754" | PRODUCTO == "862" | str_detect(toupper(PRODUCTO), "782", negate = FALSE) | PRODUCTO == "867" ~ "VIDA",
    PRODUCTO == "781" | PRODUCTO == "718" | PRODUCTO == "856" | PRODUCTO == "860" | str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "VIDA",
    PRODUCTO == "199" ~ "TODO_RIESGO_USD",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(PRODUCTO_NEW))

#==============================================================================#

BBDD_Pagos <-
  BBDD_Pagos %>%
  mutate(PRODUCTO_NUMBER = case_when(
    str_detect(toupper(PRODUCTO), "782", negate = FALSE) ~ "782",
    str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "781",
    str_detect(toupper(PRODUCTO), "500", negate = FALSE) ~ "500",
    str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "501",
    TRUE ~ PRODUCTO
  ))

BBDD_Reservas <-
  BBDD_Reservas %>%
  mutate(PRODUCTO_NUMBER = case_when(
    str_detect(toupper(PRODUCTO), "782", negate = FALSE) ~ "782",
    str_detect(toupper(PRODUCTO), "781", negate = FALSE) ~ "781",
    str_detect(toupper(PRODUCTO), "500", negate = FALSE) ~ "500",
    str_detect(toupper(PRODUCTO), "501", negate = FALSE) ~ "501",
    TRUE ~ PRODUCTO
  ))

#==============================================================================#

Corte = dm_siniestros$fec_data %>% unique()

#==============================================================================#

Aux_1 <-
  BBDD_Pagos %>%
  filter(as.integer(str_sub(fec_ocurrencia,1,4)) > 2016) %>%
  filter(fec_pago <= Corte) %>%
  #
  mutate(tmp_1 = as.integer(str_sub(fec_ocurrencia,1,4)) * 12 + as.integer(str_sub(fec_ocurrencia,6,7)),
         tmp_2 = as.integer(str_sub(Corte,1,4)) * 12 + as.integer(str_sub(Corte,6,7)),
         Desarrollo = tmp_2 - tmp_1) %>%
  filter(Desarrollo < 24) %>%
  #
  mutate(Ocurrido = "24 Meses") %>%
  group_by(Ocurrido,PRODUCTO_NEW,PRODUCTO_NUMBER) %>%
  summarise(Valor_Pagado = sum(pago_bruto_mn)) %>%
  ungroup()

Aux_2 <-
  BBDD_Reservas %>%
  mutate(`RESERVA DISPONIBLE` = case_when(is.na(`RESERVA DISPONIBLE`) ~ `RESERVA EN DOLARES COLONIZADA`, TRUE ~ `RESERVA DISPONIBLE`)) %>%
  mutate(`FECHA EVENTO` = as.numeric(`FECHA EVENTO`)) %>%
  mutate(`FECHA EVENTO` = as.Date(`FECHA EVENTO`, origin = "1899-12-30")) %>%
  #
  mutate(tmp_1 = as.integer(str_sub(`FECHA EVENTO`,1,4)) * 12 + as.integer(str_sub(`FECHA EVENTO`,6,7)),
         tmp_2 = as.integer(str_sub(Corte,1,4)) * 12 + as.integer(str_sub(Corte,6,7)),
         Desarrollo = tmp_2 - tmp_1) %>%
  filter(Desarrollo < 24) %>%
  #
  mutate(Ocurrido = "24 Meses") %>%
  group_by(Ocurrido,PRODUCTO_NEW,PRODUCTO_NUMBER) %>%
  summarise(Reserva = sum(`RESERVA DISPONIBLE`)) %>%
  ungroup()

#---------------------------
Parcial =  left_join(Aux_1,Aux_2, by = c("Ocurrido","PRODUCTO_NEW","PRODUCTO_NUMBER" ))
Parcial$Valor_Pagado[is.na(Parcial$Valor_Pagado)] = 0
Parcial$Reserva[is.na(Parcial$Reserva)] = 0
Parcial$Incurrido_Parcial = Parcial$Valor_Pagado + Parcial$Reserva
Parcial = Parcial[,-c(4,5)]
#------------------------------------
#Parcial <-
#  union_all(Aux_1,Aux_2) %>%
#  group_by(Ocurrido,PRODUCTO_NEW,PRODUCTO_NUMBER) %>%
#  summarise(Valor_Pagado = sum(Valor_Pagado, na.rm = TRUE),
#            Reserva = sum(Reserva, na.rm = TRUE)) %>%
#  ungroup() %>%
#  mutate(Incurrido_Parcial = Valor_Pagado + Reserva) %>%
#  select(-c(Valor_Pagado,Reserva))

rm(Aux_1,Aux_2)

#==============================================================================#

Aux_1 <-
  BBDD_Pagos %>%
  filter(as.integer(str_sub(fec_ocurrencia,1,4)) > 2016) %>%
  filter(fec_pago <= Corte) %>%
  #
  mutate(tmp_1 = as.integer(str_sub(fec_ocurrencia,1,4)) * 12 + as.integer(str_sub(fec_ocurrencia,6,7)),
         tmp_2 = as.integer(str_sub(Corte,1,4)) * 12 + as.integer(str_sub(Corte,6,7)),
         Desarrollo = tmp_2 - tmp_1) %>%
  filter(Desarrollo < 24) %>%
  #
  # mutate(Ocurrido = str_sub(fec_ocurrencia,1,7)) %>%
  mutate(Ocurrido = "24 Meses") %>%
  group_by(Ocurrido,PRODUCTO_NEW) %>%
  summarise(Valor_Pagado = sum(pago_bruto_mn)) %>%
  ungroup()

Aux_2 <-
  BBDD_Reservas %>%
  mutate(`RESERVA DISPONIBLE` = case_when(is.na(`RESERVA DISPONIBLE`) ~ `RESERVA EN DOLARES COLONIZADA`, TRUE ~ `RESERVA DISPONIBLE`)) %>%
  mutate(`FECHA EVENTO` = as.numeric(`FECHA EVENTO`)) %>%
  mutate(`FECHA EVENTO` = as.Date(`FECHA EVENTO`, origin = "1899-12-30")) %>%
  #
  mutate(tmp_1 = as.integer(str_sub(`FECHA EVENTO`,1,4)) * 12 + as.integer(str_sub(`FECHA EVENTO`,6,7)),
         tmp_2 = as.integer(str_sub(Corte,1,4)) * 12 + as.integer(str_sub(Corte,6,7)),
         Desarrollo = tmp_2 - tmp_1) %>%
  filter(Desarrollo < 24) %>%
  #
  mutate(Ocurrido = "24 Meses") %>%
  group_by(Ocurrido,PRODUCTO_NEW) %>%
  summarise(Reserva = sum(`RESERVA DISPONIBLE`)) %>%
  ungroup()

#-------------------
Total =  left_join(Aux_1,Aux_2, by = c("Ocurrido","PRODUCTO_NEW" ))
Total$Valor_Pagado[is.na(Total$Valor_Pagado)] = 0
Total$Reserva[is.na(Total$Reserva)] = 0

Total = Total %>%
  group_by(Ocurrido,PRODUCTO_NEW) %>%
  summarise(Valor_Pagado = sum(Valor_Pagado, na.rm = TRUE),
            Reserva = sum(Reserva, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(Incurrido_Total = Valor_Pagado + Reserva) %>%
  select(-c(Valor_Pagado,Reserva))
#--------------------- 

#Total <-
#  union_all(Aux_1,Aux_2) %>%
#  group_by(Ocurrido,PRODUCTO_NEW) %>%
#  summarise(Valor_Pagado = sum(Valor_Pagado, na.rm = TRUE),
#            Reserva = sum(Reserva, na.rm = TRUE)) %>%
#  ungroup() %>%
#  mutate(Incurrido_Total = Valor_Pagado + Reserva) %>%
#  select(-c(Valor_Pagado,Reserva))

rm(Aux_1,Aux_2)

#==============================================================================#
#Todo <-
#  left_join(Parcial,Total, by = c("Ocurrido", "PRODUCTO_NEW")) %>%
#  mutate(Participacion = Incurrido_Parcial / Incurrido_Total) %>%
#  mutate(Cuenta = case_when(
#    PRODUCTO_NUMBER == "500" ~ "205005001020101",
#    PRODUCTO_NUMBER == "501" ~ "205005001010101",
#    PRODUCTO_NUMBER == "108" | PRODUCTO_NUMBER == "153" ~ "205005001020100",
#    PRODUCTO_NUMBER == "109" | PRODUCTO_NUMBER == "143" ~ "205005001010100",
#    PRODUCTO_NUMBER == "230" | PRODUCTO_NUMBER == "232" ~ "205005001020102",
#    PRODUCTO_NUMBER == "231" ~ "205005001010102",
#    PRODUCTO_NUMBER == "208" | PRODUCTO_NUMBER == "209" | PRODUCTO_NUMBER == "718" | PRODUCTO_NUMBER == "719" | PRODUCTO_NUMBER == "754" | PRODUCTO_NUMBER == "781" | PRODUCTO_NUMBER == "782" | PRODUCTO_NUMBER == "862" | PRODUCTO_NUMBER == "867" | PRODUCTO_NUMBER == "868" | PRODUCTO_NUMBER == "869" ~ "205005001010200"
#  )) %>%
#  left_join(distribucion, by = "Cuenta") %>%
#  mutate(
#    Saldo = case_when(is.na(Saldo) ~ 0.0, TRUE ~ - 1.0 * Saldo),
#    Incurrido_Total = Saldo,
#    Incurrido_Parcial = Saldo * Participacion
#  ) %>%
#  select(-c(Cuenta,Detalle,Saldo))

Todo = left_join(Parcial,Total, by = c("Ocurrido", "PRODUCTO_NEW"))
Todo$Participacion =  Todo$Incurrido_Parcial / Todo$Incurrido_Total
Todo$Cuenta = case_when(
  Todo$PRODUCTO_NUMBER == "500" ~ "205005001020101",
  Todo$PRODUCTO_NUMBER == "501" ~ "205005001010101",
  Todo$PRODUCTO_NUMBER == "108" | Todo$PRODUCTO_NUMBER == "153" ~ "205005001020100",
  Todo$PRODUCTO_NUMBER == "109" | Todo$PRODUCTO_NUMBER == "143" ~ "205005001010100",
  Todo$PRODUCTO_NUMBER == "230" | Todo$PRODUCTO_NUMBER == "232" ~ "205005001020102",
  Todo$PRODUCTO_NUMBER == "231" ~ "205005001010102",
  Todo$PRODUCTO_NUMBER == "208" | Todo$PRODUCTO_NUMBER == "209" | Todo$PRODUCTO_NUMBER == "718" | Todo$PRODUCTO_NUMBER == "719" | Todo$PRODUCTO_NUMBER == "754" | Todo$PRODUCTO_NUMBER == "781" | Todo$PRODUCTO_NUMBER == "782" | Todo$PRODUCTO_NUMBER == "862" | Todo$PRODUCTO_NUMBER == "867" | Todo$PRODUCTO_NUMBER == "868" | Todo$PRODUCTO_NUMBER == "869" ~ "205005001010200")
Todo = left_join(Todo, distribucion, by = "Cuenta")
Todo$Saldo = as.numeric(Todo$Saldo)
Todo$Incurrido_Parcial  = as.numeric(Todo$Incurrido_Parcial)
Todo$Incurrido_Total = as.numeric(Todo$Incurrido_Total)
Todo$Saldo = case_when(is.na(Todo$Saldo) ~ 0, TRUE ~  1 * Todo$Saldo)
Todo$Incurrido_Total = Todo$Saldo
Todo$Incurrido_Parcial = Todo$Saldo * Todo$Participacion
Todo = Todo[,-c(7:9)]
#==============================================================================# 
#==============================================================================#

#seleccionamos las filas que necesitamos y cambiamos el nombre para combinar
Todo = Todo[,c(3,4)]
names(Todo) = c("cod_producto", "oynr_bruta")

# construccion de oynr_bruta - incurrido parcial con el codigo 
dm_reservas = left_join(dm_reservas, Todo, by = "cod_producto")

#para hacer la resta ponemos por datos nulos en ceros
dm_reservas$oynr_bruta[is.na(dm_reservas$oynr_bruta)] = 0

# construccion de oynr_cedida
dm_reservas$oynr_cedida = 0 

# construccion de oynr_cedida --> verificar que oynr_bruta no tenga datos en cero
dm_reservas$oynr_neta = dm_reservas$oynr_bruta - dm_reservas$oynr_cedida  

#construccion rva_aviso_bruta
#agrupamos los datos de 781 y 782
reserva_siniestro_disponible$PRODUCTO = case_when(
  str_detect(toupper(reserva_siniestro_disponible$PRODUCTO), "782", negate = FALSE) ~ "782",
  str_detect(toupper(reserva_siniestro_disponible$PRODUCTO), "781", negate = FALSE) ~ "781",
  TRUE ~ reserva_siniestro_disponible$PRODUCTO)

reserva_siniestro_disponible$PRODUCTO = case_when(
  str_detect(toupper(reserva_siniestro_disponible$PRODUCTO), "500", negate = FALSE) ~ "500",
  str_detect(toupper(reserva_siniestro_disponible$PRODUCTO), "501", negate = FALSE) ~ "501",
  TRUE ~ reserva_siniestro_disponible$PRODUCTO)

reserva_siniestro_disponible$`RESERVA EN DOLARES COLONIZADA`[is.na(reserva_siniestro_disponible$`RESERVA EN DOLARES COLONIZADA`)] = 0
reserva_siniestro_disponible$`RESERVA DISPONIBLE`[is.na(reserva_siniestro_disponible$`RESERVA DISPONIBLE`)] = 0

#agrupamos por producto
disponible_1 = data.frame(reserva_siniestro_disponible  %>% group_by (PRODUCTO) %>% summarise(dolares = sum(`RESERVA EN DOLARES COLONIZADA`), colones = sum(`RESERVA DISPONIBLE`)))
names(disponible_1)[1] = "cod_producto"

#unimos dm_reservas con disponible
dm_reservas = left_join(dm_reservas, disponible_1, by="cod_producto")

#llenamos con ceros los datos nulos
dm_reservas$dolares[is.na(dm_reservas$dolares)] = 0
dm_reservas$colones[is.na(dm_reservas$colones)] = 0

#creamos rva_aviso bruto
dm_reservas$rva_aviso_bruta = dm_reservas$dolares + dm_reservas$colones

#construcion columna rva_aviso_cedida
#Limpiamos la estructura dejando solo el producto y el saldo
bordero_recuperacion_siniestros = bordero_recuperacion_siniestros[,c("PRODUCTO", "SALDO")]
names(bordero_recuperacion_siniestros) = c("cod_producto", "rva_aviso_cedida")
bordero_recuperacion_siniestros = na.omit(bordero_recuperacion_siniestros)

#juntamos con dm_reservas
bordero_recuperacion_siniestros$cod_producto = as.character(bordero_recuperacion_siniestros$cod_producto)
bordero_recuperacion_siniestros$rva_aviso_cedida = as.numeric(bordero_recuperacion_siniestros$rva_aviso_cedida)
bordero_recuperacion_siniestros$rva_aviso_cedida[is.na(bordero_recuperacion_siniestros$rva_aviso_cedida)] = 0
bordero_recuperacion_siniestros$rva_aviso_cedida = as.numeric(bordero_recuperacion_siniestros$rva_aviso_cedida)
bordero_recuperacion_siniestros  = data.frame(bordero_recuperacion_siniestros   %>% group_by (cod_producto) %>% summarise(rva_aviso_cedida = sum(rva_aviso_cedida)))
dm_reservas = left_join(dm_reservas, bordero_recuperacion_siniestros, by = "cod_producto")

#construccion columna rva_gastos_bruta :
dm_reservas$rva_gastos_bruta = 0

#construccion columna rva_gastos_bruta
dm_reservas$rva_gastos_cedida = 0

#construccion columna rva_gastos_neta
dm_reservas$rva_gastos_neta = dm_reservas$rva_gastos_bruta - dm_reservas$rva_gastos_cedida 

#agregamos la fec_data
dm_reservas$fec_data = fec_data

#limpiamos dm_reservas
dm_reservas = dm_reservas[,c("fec_data", "ramo", "cod_producto","moneda", "ppnd_bruta", "ppnd_cedida", "ppnd_neta", "pip", "oynr_bruta", "oynr_cedida", "oynr_neta", "rva_aviso_bruta", "rva_aviso_cedida", "rva_gastos_bruta", "rva_gastos_cedida", "rva_gastos_neta", "rva_catastrofe")]
dm_reservas[is.na(dm_reservas)] = 0

#------------------------------------------------ dm_actuals ----------------------------------------------------------------
#columnas a construir 
# 
mov_ramos_actuals =  data.frame(mov_ramos  %>% group_by (cod_producto, Cuenta, tipo) %>% summarise(neto = sum(neto)))

dm_actuals = mov_ramos_actuals [,c(1:3)]
names(dm_actuals) = c("cod_producto", "cuenta", "tipo")

#----- columna primas
#filtramos por tipo: PRIMAS
primas_emitidas = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "PRIMAS")
names(primas_emitidas) = c("cod_producto", "cuenta", "tipo", "primas_emitidas")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, primas_emitidas, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna cedidas
#filtramos por tipo: CESION
primas_cedidas = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "CESION")
names(primas_cedidas) = c("cod_producto", "cuenta", "tipo", "primas_cedidas")
#unimos dm_actuals y CESION
dm_actuals = left_join(dm_actuals, primas_cedidas, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna c_ppnd
#filtramos por tipo: C.PPND
primas_ppnd = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "C.PPND")
names(primas_ppnd) = c("cod_producto", "cuenta", "tipo", "c_ppnd")
#unimos dm_actuals y primas_ppnd
dm_actuals = left_join(dm_actuals, primas_ppnd, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna c_prpt
#filtramos por tipo: C.PRPT
c_prpt = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "C.PRPT")
names(c_prpt) = c("cod_producto", "cuenta", "tipo", "c_prpt")
#unimos dm_actuals y c_prpt
dm_actuals = left_join(dm_actuals, c_prpt, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna c_pip
#filtramos por tipo: C.PIP
c_pip = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "C.PIP")
names(c_pip) = c("cod_producto", "cuenta", "tipo", "c_pip")
#unimos dm_actuals y c_pip
dm_actuals = left_join(dm_actuals, c_pip, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna l_ppnd
#filtramos por tipo: L.PPND
l_ppnd = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "L.PPND")
names(l_ppnd) = c("cod_producto", "cuenta", "tipo", "l_ppnd")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, l_ppnd, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna l_prpt
#filtramos por tipo: L.PRPT
l_prpt = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "L.PRPT")
names(l_prpt) = c("cod_producto", "cuenta", "tipo", "l_prpt")
#unimos dm_actuals y l_prpt
dm_actuals = left_join(dm_actuals, l_prpt, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna l_pip
#filtramos por tipo: L.PIP
l_pip = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "L.PIP")
names(l_pip) = c("cod_producto", "cuenta", "tipo", "l_pip")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, l_pip, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna costo_reaseg
#filtramos por tipo: XL
costo_reaseg= filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "XL")
names(costo_reaseg) = c("cod_producto", "cuenta", "tipo", "costo_reaseg")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, costo_reaseg, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna prov_primas
#filtramos por tipo: EST. PROV
prov_primas = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "EST. PROV")
names(prov_primas) = c("cod_producto", "cuenta", "tipo", "prov_primas")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, prov_primas, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna comis_reaseg
#filtramos por tipo: COM REA
comis_reaseg = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "COM REA")
names(comis_reaseg) = c("cod_producto", "cuenta", "tipo", "comis_reaseg")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, comis_reaseg, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna serv_adm
#filtramos por tipo: COM ADM
serv_adm = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "COM ADM")
names(serv_adm) = c("cod_producto", "cuenta", "tipo", "serv_adm")
#unimos dm_actuals y serv_adm
dm_actuals = left_join(dm_actuals, serv_adm, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna gastos_prod
#filtramos por tipo: PRODUCTO
gastos_prod = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "PRODUCTO")
names(gastos_prod) = c("cod_producto", "cuenta", "tipo", "gastos_prod")
#unimos dm_actuals y gastos_prod
dm_actuals = left_join(dm_actuals, gastos_prod, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna siniestros_inc
#filtramos por tipo: SINIESTROS
siniestros_inc = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "SINIESTROS")
names(siniestros_inc) = c("cod_producto", "cuenta", "tipo", "siniestros_inc")
#unimos dm_actuals y primas emitidas
dm_actuals = left_join(dm_actuals, siniestros_inc, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna var_rsv_siniestro
#filtramos por tipo: R.SINIESTROS
var_rsv_siniestro = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "R.SINIESTROS")
names(var_rsv_siniestro) = c("cod_producto", "cuenta", "tipo", "var_rsv_siniestro")
#unimos dm_actuals y var_rsv_siniestro
dm_actuals = left_join(dm_actuals, var_rsv_siniestro, by = c("cod_producto", "cuenta", "tipo"))


#---- columna var_rea_rsva_cat
dm_actuals$var_rea_rsva_cat = 0


#---- Columna rec_siniestros
#filtramos por tipo:R.SINIESTROS
rec_siniestros = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "rec_siniestros")
names(rec_siniestros) = c("cod_producto", "cuenta", "tipo", "rec_siniestros")
#unimos dm_actuals y rec_siniestros
dm_actuals = left_join(dm_actuals, rec_siniestros, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna oynr
#filtramos por tipo:OYNR
oynr = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "OYNR")
names(oynr) = c("cod_producto", "cuenta", "tipo", "oynr")
#unimos dm_actuals y oynr
dm_actuals = left_join(dm_actuals, oynr, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna c_pps
#filtramos por tipo:C.PPS
c_pps = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "C.PPS")
names(c_pps) = c("cod_producto", "cuenta", "tipo", "c_pps")
#unimos dm_actuals y c_pps
dm_actuals = left_join(dm_actuals, c_pps, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna l_pps
#filtramos por tipo: L.PPS
l_pps = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "L.PPS")
names(l_pps) = c("cod_producto", "cuenta", "tipo", "l_pps")
#unimos dm_actuals y l_pps
dm_actuals = left_join(dm_actuals, l_pps, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna var_rsva_cat
#filtramos por tipo: C.RCAT
var_rsva_cat = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "C.RCAT")
names(var_rsva_cat) = c("cod_producto", "cuenta", "tipo", "var_rsva_cat")
#unimos dm_actuals y var_rsva_cat
dm_actuals = left_join(dm_actuals, var_rsva_cat, by = c("cod_producto", "cuenta", "tipo"))


#---- Columna g_atr
#filtramos por tipo: ATRIB
g_atr = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "ATRIB")
names(g_atr) = c("cod_producto", "cuenta", "tipo", "g_atr")
#unimos dm_actuals y g_atr
dm_actuals = left_join(dm_actuals, g_atr, by = c("cod_producto", "cuenta", "tipo"))

#---- Columna IMPUESTOS
#filtramos por tipo: IMPUESTOS
IMPUESTOS = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "IMPUESTOS")
names(IMPUESTOS) = c("cod_producto", "cuenta", "tipo", "IMPUESTOS")
#unimos dm_actuals y IMPUESTOS
dm_actuals = left_join(dm_actuals, IMPUESTOS, by = c("cod_producto", "cuenta", "tipo"))


#--- Columna g_natr
dm_actuals$g_natr = 0 

#---- Columna r_fin
#filtramos por tipo: RFIN
r_fin = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "RFIN")
names(r_fin) = c("cod_producto", "cuenta", "tipo", "r_fin")
#unimos dm_actuals y r_fin
dm_actuals = left_join(dm_actuals, r_fin, by = c("cod_producto", "cuenta", "tipo"))

#---- Columna OTR_ING
#filtramos por tipo: OTR_ING
OTR_ING = filter(mov_ramos_actuals, mov_ramos_actuals$tipo == "OTR_ING")
names(OTR_ING) = c("cod_producto", "cuenta", "tipo", "OTR_ING")
#unimos dm_actuals y OTR_ING
dm_actuals = left_join(dm_actuals, OTR_ING, by = c("cod_producto", "cuenta", "tipo"))

#agregamos la fec_data
dm_actuals$fec_data = fec_data

#quitamos los datos nulos de ac_tuals con ceros
dm_actuals[is.na(dm_actuals)] = 0

#organizamos dm_actuals
dm_actuals = dm_actuals [,c ("fec_data","cod_producto","primas_emitidas","primas_cedidas","c_ppnd","c_prpt", "c_pip","l_ppnd","l_prpt","l_pip",
                             "costo_reaseg","prov_primas","comis_reaseg", "serv_adm","gastos_prod","siniestros_inc","var_rsv_siniestro", "var_rea_rsva_cat", "rec_siniestros","oynr","c_pps","l_pps", "var_rsva_cat", "g_atr","IMPUESTOS", "g_natr", "r_fin", "OTR_ING")]


#agrupamos dm_actuals 
dm_actuals =  data.frame(dm_actuals  %>% group_by (fec_data, cod_producto) %>% summarise(primas_emitidas = sum(primas_emitidas),primas_cedidas = sum(primas_cedidas),c_ppnd = sum(c_ppnd),c_prpt = sum(c_prpt),c_pip = sum(c_pip),l_ppnd = sum(l_ppnd), l_prpt = sum (l_prpt), l_pip = sum(l_pip),costo_reaseg = sum(costo_reaseg),prov_primas = sum(prov_primas),comis_reaseg = sum(comis_reaseg),serv_adm = sum(serv_adm),gastos_prod = sum(gastos_prod), 
                                                                                         siniestros_inc = sum(siniestros_inc),var_rsv_siniestro = sum(var_rsv_siniestro),    var_rea_rsva_cat = sum(var_rea_rsva_cat),  rec_siniestros = sum(rec_siniestros),oynr = sum(oynr),c_pps = sum(c_pps),l_pps = sum(l_pps),var_rsva_cat = sum(var_rsva_cat), g_atr = sum(g_atr),IMPUESTOS = sum(IMPUESTOS),g_natr = sum(g_natr),r_fin = sum(r_fin), OTR_ING = sum(OTR_ING)))

#------------------------------------------------ exportacion de archivos -----------------
#direccionamos la salida
setwd(output)

#write.xlsx(dm_tasa_descuento,"dm_tasa_descuento.xlsx") 
#write.xlsx(dm_tc,"dm_tc.xlsx") 
#write.xlsx(dm_siniestros,"dm_siniestros.xlsx") 
#write.xlsx(dm_capital,"dm_capital.xlsx") 
#write.xlsx(dm_poliza,"dm_poliza.xlsx") 
#write.xlsx(dm_reservas,"dm_reservas.xlsx")
#write.xlsx(dm_actuals,"dm_actuals.xlsx") 

#-------------------------------------------------------- 
hoy <- Sys.Date()

dm_tasa_descuento$fec_data = as.Date(dm_tasa_descuento$fec_data, format = '%d/%m/%y')
write.xlsx(dm_tasa_descuento, str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," ") , sheetName = "dm_tasa_descuento")

#Agregamos una pestaña con los resultados de pago_proveedores 
wb <- loadWorkbook(str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "))

dm_tc$fecha = as.Date(dm_tc$fecha, format = '%d/%m/%y')
addWorksheet(wb,"dm_tc")
writeData(wb,"dm_tc",dm_tc)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

dm_siniestros$fec_data = as.Date(dm_siniestros$fec_data , format = '%d/%m/%y')
dm_siniestros$fec_ocurrencia = as.Date(dm_siniestros$fec_ocurrencia , format = '%d/%m/%y')
dm_siniestros$fec_pago = as.Date(dm_siniestros$fec_pago , format = '%d/%m/%y')
addWorksheet(wb,"dm_siniestros")
writeData(wb,"dm_siniestros",dm_siniestros)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

dm_capital$fec_data = as.Date(dm_capital$fec_data , format = '%d/%m/%y')
addWorksheet(wb,"dm_capital")
writeData(wb,"dm_capital",dm_capital)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

dm_poliza$fec_data = as.Date(dm_poliza$fec_data, format = '%d/%m/%y')
addWorksheet(wb,"dm_polizas")
writeData(wb,"dm_polizas",dm_poliza)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

dm_reservas$fec_data = as.Date(dm_reservas$fec_data, format = '%d/%m/%y')
addWorksheet(wb,"dm_reservas")
writeData(wb,"dm_reservas",dm_reservas)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

dm_actuals$fec_data = as.Date(dm_actuals$fec_data, format = '%d/%m/%y')
addWorksheet(wb,"dm_actuals")
writeData(wb,"dm_actuals",dm_actuals)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)


addWorksheet(wb,"dm_productos")
writeData(wb,"dm_productos",dm_productos)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

addWorksheet(wb,"dm_cta_contables")
writeData(wb,"dm_cta_contables",dm_cta_contables)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

addWorksheet(wb,"dm_duration")
writeData(wb,"dm_duration",dm_duration)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

addWorksheet(wb,"dm_factor_cap")
writeData(wb,"dm_factor_cap",dm_factor_cap)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

addWorksheet(wb,"dm_patron")
writeData(wb,"dm_patron",dm_patron)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

dm_ajuste_onerosidad$fec_data = as.Date(dm_ajuste_onerosidad$fec_data, format = '%d/%m/%y')
addWorksheet(wb,"dm_ajuste_onerosidad")
writeData(wb,"dm_ajuste_onerosidad",dm_ajuste_onerosidad)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

flujo_PRI_anterior$fec_data = as.Date(flujo_PRI_anterior$fec_data, format = '%d/%m/%y')
addWorksheet(wb,"flujo_PRI_anterior")
writeData(wb,"flujo_PRI_anterior",flujo_PRI_anterior)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

cuentas_contables$fec_data = as.Date(cuentas_contables$fec_data, format = '%d/%m/%y')
addWorksheet(wb,"cuentas_contables")
writeData(wb,"cuentas_contables",cuentas_contables)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

addWorksheet(wb,"distribucion_oynr")
writeData(wb,"distribucion_oynr",TABLA_DISTRIBUCION_OYNR)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

addWorksheet(wb,"distribucion_rsa")
writeData(wb,"distribucion_rsa",TABLA_DISTRIBUCION_RSA)
saveWorkbook(wb,str_remove_all(paste("Excel_Input_Actuarial_CR_",hoy,".xlsx")," "),overwrite = TRUE)

#proc.time() 
