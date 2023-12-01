#======================================== Parte 1 =================================
#-------------------------------- Instalación de paquetes 
#install.packages("googlesheets4")
#install.packages("tidyverse")
#install.packages("remotes")
#install.packages(c("FRACTION","dplyr","tidyverse","stringr","lubridate","tidyr","openxlsx","readxl","shiny","miniUI","timechange","taskscheduleR","openxlsx","writexl"))

#abrimos las librerias 
library(googledrive)
library(googlesheets4)
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

#Para que los datos no esten en anotación cientifica
options(scipen=999)


#------------------------------------------ Conceder permisos 
#autenticación pasar a google chrome para dar permisos al r 
gs4_auth()
drive_auth()

#======================================== Parte 2 ==================================
#Importamos la estructura 
comprobante_1 = read_sheet("ID_FOLDER", sheet = 'Estructura', col_names = TRUE, range = "A3:I115")
names(comprobante_1) = c("Consecutivo","MOTIVO","DESCRIPCION", "Numero_de_semana" ,"SEMANA","BASE","CALCULO_CONTR","CONTR_ASUMIDA","TOT_CONTRIB")

#Importamos las fechas para hacer las semana 
mes = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B2"))
año = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D2"))

#Semana 1 
De_1 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B6"))
De_Mes_1 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "C6"))
Hasta_1 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D6"))
Hasta_Mes_1 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "E6"))

#Semana 2
De_2 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B7"))
De_Mes_2 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "C7"))
Hasta_2 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D7"))
Hasta_Mes_2 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "E7"))

#Semana 3
De_3 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B8"))
De_Mes_3 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "C8"))
Hasta_3 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D8"))
Hasta_Mes_3 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "E8"))

#Semana 4
De_4 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B9"))
De_Mes_4 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "C9"))
Hasta_4 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D9"))
Hasta_Mes_4 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "E9"))

#Semana 5
De_5 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B10"))
De_Mes_5= as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "C10"))
Hasta_5 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D10"))
Hasta_Mes_5 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "E10"))

#Mes completo
De_6 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B11"))
De_Mes_6= as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "C11"))
Hasta_6 = as.numeric(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "D11"))
Hasta_Mes_6 = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "E11"))


#Parametros
parametros_cheques_girados = read_sheet("ID_FOLDER", sheet = 'Parametro_Cheques_Girados', col_names = TRUE)
names(parametros_cheques_girados) = c("ID_COMPROBANTE", "ID_DE_ASIENTO", "Concepto")
parametros_cheques_girados = parametros_cheques_girados %>% mutate(ID_COMPROBANTE = as.character(ID_COMPROBANTE), 
                                                                   ID_DE_ASIENTO = as.character(ID_DE_ASIENTO),
                                                                   Concepto = as.character(Concepto))


#Colocamos las fechas de las semanas en el comprobante 
mes_letra  = case_when(mes == 1 ~ "Enero",mes == 2 ~ "Febrero", mes == 3 ~ "Marzo",mes == 4 ~ "Abril",mes == 5 ~ "Mayo",mes == 6 ~ "Junio",mes == 7 ~ "Julio",mes == 8 ~ "Agosto",mes == 9 ~ "Septiembre",mes == 10 ~ "Octubre",mes == 11 ~ "Noviembre",mes == 11 ~ "Diciembre",TRUE ~ "Error")
fecha_semana_1 = paste(De_1,"de",De_Mes_1,"al", Hasta_1, "de", Hasta_Mes_1 )
fecha_semana_2 = paste(De_2,"de",De_Mes_2,"al", Hasta_2, "de", Hasta_Mes_2)
fecha_semana_3 = paste(De_3,"de",De_Mes_3,"al", Hasta_3, "de", Hasta_Mes_3)
fecha_semana_4 = paste(De_4,"de",De_Mes_4,"al", Hasta_4, "de", Hasta_Mes_4)
fecha_semana_5 = paste(De_5,"de",De_Mes_5,"al", Hasta_5, "de", Hasta_Mes_5)
fecha_completa = paste(De_6,"de",De_Mes_6,"al", Hasta_6, "de", Hasta_Mes_6)

comprobante_1[c(1,9, 17, 25,33,41,49,57,65,73,81,89,97,105),5] <- fecha_semana_1
comprobante_1[c(2,10, 18,26,34,42,50,58,66,74,82,90,98,106),5] <- fecha_semana_2
comprobante_1[c(3,11, 19,27,35,43,51,59,67,75,83,91,99,107),5] <- fecha_semana_3
comprobante_1[c(4,12, 20,28,36,44,52,60,68,76,84,92,100,108),5] <- fecha_semana_4
comprobante_1[c(5,13, 21,29,37,45,53,61,69,77,85,93,101,109),5] <- fecha_semana_5
comprobante_1[c(6,14, 22,30,38,46,54,62,70,78,86,94,102,110),5] <- "Total"
comprobante_1[c(7,15, 23,31,39,47,55,63,71,79,87,95,103,111),5] <- fecha_completa
comprobante_1[c(8,16, 24,32,40,48,56,64,72,80,88,96,104,112),5] <- "Control"

#Limpiar el comprobante
comprobante_1 <- comprobante_1 %>% 
  mutate(across(c(6:9), ~ 0))


#=========================================== De drive al escritorio automaticamente =======================
# ID de la carpeta en Google Drive
folder_id = as.character(read_sheet("ID_FOLDER", sheet = 'Datos_Variables', col_names = FALSE, range = "B14"))

# Listar archivos en la carpeta
folder <- as_id(folder_id)
files <- drive_ls(path = folder)

# Nombres de archivos que quieres descargar
file_names <- c("CDAT_Semana_1.csv","CDAT_Semana_2.csv", "CDAT_Semana_3.csv","CDAT_Semana_4.csv","CDAT_Semana_5.csv","CDAT_Completo.csv",
                "CDT_Semana_1.csv","CDT_Semana_2.csv", "CDT_Semana_3.csv","CDT_Semana_4.csv","CDT_Semana_5.csv","CDT_Completo.csv",
                "Cheques_Oficina_Semana_1.xlsx","Cheques_Oficina_Semana_2.xlsx","Cheques_Oficina_Semana_3.xlsx","Cheques_Oficina_Semana_4.xlsx","Cheques_Oficina_Semana_5.xlsx","Cheques_Oficina_Completo.xlsx", 
                "Pago_Proveedores_Semana_1.xlsx","Pago_Proveedores_Semana_2.xlsx","Pago_Proveedores_Semana_3.xlsx","Pago_Proveedores_Semana_4.xlsx","Pago_Proveedores_Semana_5.xlsx","Pago_Proveedores_Completo.xlsx",
                "Cheques_Girados_Semana_1.xlsx", "Cheques_Girados_Semana_2.xlsx", "Cheques_Girados_Semana_3.xlsx", "Cheques_Girados_Semana_4.xlsx","Cheques_Girados_Semana_5.xlsx", "Cheques_Girados_Completo.xlsx",
                "Pago_Intereses_Semana_1.xlsx", "Pago_Intereses_Semana_2.xlsx","Pago_Intereses_Semana_3.xlsx","Pago_Intereses_Semana_4.xlsx","Pago_Intereses_Semana_5.xlsx","Pago_Intereses_Completo.xlsx", 
                "Timbre_Semana_1.xlsx", "Timbre_Semana_2.xlsx", "Timbre_Semana_3.xlsx", "Timbre_Semana_4.xlsx", "Timbre_Semana_5.xlsx", "Timbre_Completo.xlsx")

# Directorio local donde deseas guardar los archivos descargados
local_directory <- "USER"

#Eliminar los insumos de la corrida pasada
#unlink(local_directory, recursive = TRUE)

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

#================================= GMF cheques y proveedores ===============================
Cheques_oficina = function(data,i) {
  tryCatch(
    {
      datos = read_excel(data, skip = 9) 
      colnames(datos) = c("Cuenta", "Descripcion_Cuenta" , "Sucursal" ,"Descripcion_Sucursal","Oficina","Descripcion_Oficina","Tipo_Comprobante", "Descripcion_Tipo_Comprobante", "Numero_de_Transaccion", "Descripcion_Transaccion","Fecha_Transaccion","Fecha_de_grabacion","Descripcion_Origen", "Numero_de_Identificacion","Digito_de_Verificacion","Razon_Social", "Documento", "Referencia_1", "Dependencia", "Subproyecto", "Auxiliar_de_Conciliacion", "Tipo_de_Evento", "Clase_Contable", "Numero_de_Linea", "Saldo_Dia_Anterior", "Debito", "Credito", "Asiento_Reversado") 
      datos = data.frame(datos) %>% 
        mutate(concepto = substr(Descripcion_Transaccion, start = 6, stop = 14),
               concepto3 = substr(concepto, start = 6, stop = 9),
               neto = Debito - Credito)
      
      datos = datos[,c("Fecha_Transaccion", "Descripcion_Transaccion","Debito","Credito", "Documento", "concepto", "neto", "Oficina", "concepto3", "Tipo_Comprobante")]
      
      #Llamamos para hacer un marge y que salga cheques con la fecha
      datos_cheques = read_excel(data, skip = 9)
      colnames(datos_cheques) = c("Cuenta", "Descripcion_Cuenta" , "Sucursal" ,"Descripcion_Sucursal","Oficina","Descripcion_Oficina","Tipo_Comprobante", "Descripcion_Tipo_Comprobante", "Numero_de_Transaccion", "Descripcion_Transaccion","Fecha_Transaccion","Fecha_de_grabacion","Descripcion_Origen", "Numero_de_Identificacion","Digito_de_Verificacion","Razon_Social", "Documento", "Referencia_1", "Dependencia", "Subproyecto", "Auxiliar_de_Conciliacion", "Tipo_de_Evento", "Clase_Contable", "Numero_de_Linea", "Saldo_Dia_Anterior", "Debito", "Credito", "Asiento_Reversado") 
      datos_cheques  = datos_cheques[,c("Oficina", "Fecha_Transaccion", "Descripcion_Transaccion", "Documento","Numero_de_Transaccion")]
      
      #-------------------------------  resultados 1  Cheques oficina 40-28-29 ------------------------ --------------
      #Filtramos por el concepto ='0098 0040'- '0099 0028'- '0099 0029'
      conceptos = filter(datos, datos$concepto == "0098 0040" | datos$concepto == "0099 0028" | datos$concepto == "0099 0029" )
      
      #Creamos la tabla con la sumatoria por concepto 
      las40 = filter(conceptos, conceptos$concepto == "0098 0040")
      las28 = filter(conceptos, conceptos$concepto == "0099 0028")
      las29 = filter(conceptos, conceptos$concepto == "0099 0029")
      
      las40_debito = sum(las40$Debito)
      las40_credito = sum(las40$Credito)
      
      las28_debito = sum(las28$Debito)
      las28_credito = sum(las28$Credito)
      
      las29_debito = sum(las29$Debito)
      las29_credito = sum(las29$Credito)
      
      Cuentas = c("Total 9710 Concepto 40", "Total 9610 Concepto 28","Total 9610 Concepto 29")
      debito = c(las40_debito, las28_debito, las29_debito)
      credito = c(las40_credito, las28_credito, las29_credito)
      
      resultado_cheques_oficina = data.frame(Cuentas, debito, credito)
      
      #Añadimos el total de todos los conceptos
      Cuentas = "Total concepto 40 + 28 +29"
      debito = sum(las40_debito, las28_debito, las29_debito)
      credito = sum(las40_credito, las28_credito, las29_credito)
      resultado_total = data.frame(Cuentas, debito, credito)
      
      resultado_cheques_oficina = rbind(resultado_cheques_oficina, resultado_total)
      resultado_cheques_oficina$neto = resultado_cheques_oficina$debito -  resultado_cheques_oficina$credito
      
      #añadimos el total de reposiciones
      Cuentas = "Total reposiciones 28 + 29"
      debito = sum(las28_debito, las29_debito)
      credito = sum(las28_credito, las29_credito)
      resultado_reposiciones = data.frame(Cuentas, debito, credito)
      
      resultado_reposiciones$neto = resultado_reposiciones$debito -  resultado_reposiciones$credito
      resultado_cheques_oficina = rbind(resultado_cheques_oficina, resultado_reposiciones)
      
      #---------------------------- Resultado 2 cheques de oficina Pagos ISA y Sobrantes FM  ------
      #NG - solo credito 
      #Pagos ISA - 0099 
      #Pagos sobrantes - 0053 
      
      #Filtamos por NG 
      isa_sobrantes = filter(datos, datos$Tipo_Comprobante == "NG")
      
      #Filtramos por 0099 en concepto 
      #Sum de credito 
      isa = filter(isa_sobrantes, isa_sobrantes$concepto3 == "0099")
      isa_credito = sum(isa$Credito)
      
      #Filtramos por 0053 en concepto 
      #Sum de credito 
      sobrantes = filter(isa_sobrantes, isa_sobrantes$concepto3 == "0053")
      sobrantes_credito = sum(sobrantes$Credito)
      
      #creamos la data 
      Concepto = c("Pagos ISA", "Sobrantes Fm")
      Credito = c(isa_credito, sobrantes_credito)
      
      resultado_sobrante_isa = data.frame(cbind(Concepto, Credito))
      
      #---------------------------- creamos el archivo cheques -------------------
      #extraemos los datos que se necesitan unicamente de la tabal "conceptos" que ya esta filtrada
      df = conceptos[,c("Fecha_Transaccion", "Descripcion_Transaccion","Documento", "neto", "Oficina")]
      
      prueba = data.frame(df %>%
                            mutate(s1 = sign(neto), absneto = abs(neto)) %>% 
                            arrange(Oficina, desc(absneto), s1 == -1) %>% 
                            group_by(Oficina,Fecha_Transaccion, Documento) %>% 
                            mutate(grp = cumsum(s1 > 0)) %>% 
                            group_by(grp, .add = TRUE) %>% 
                            filter(n_distinct(absneto) > 1|n_distinct(s1) == 1) %>% 
                            group_by(s1, .add = TRUE) %>% 
                            summarise(neto = sum(neto), .groups = "drop") %>%   
                            select(-grp, -s1))
      
      cheques = data.frame (prueba %>%
                              mutate(abs_neto=abs(neto)) %>%
                              group_by(Oficina, Fecha_Transaccion, abs_neto) %>%
                              mutate(one_plus_one_minus= any(neto>=0) & any(neto<=0))%>%
                              filter(n()==1 | !one_plus_one_minus) %>%
                              ungroup %>%
                              select(- abs_neto, - one_plus_one_minus))
      
      
      #merge con el df para traer los otros datos 
      cheques = merge(cheques, df, by = c("Oficina", "Fecha_Transaccion", "Documento" ,"neto"))
      cheques = cheques[,c("Oficina" , "Fecha_Transaccion" , "Descripcion_Transaccion", "Documento", "neto")]
      
      cheques = left_join(cheques, datos_cheques, by = c("Oficina", "Fecha_Transaccion", "Descripcion_Transaccion", "Documento"))
      cheques = cheques[,c("Numero_de_Transaccion", "Oficina","Fecha_Transaccion","Descripcion_Transaccion", "Documento","neto")]
      
      #Aqui agregamos lo que faltaba en calculos del GMF para no tocar el codigo más arriba de lo que ya se tenia
      resultado_cheques_oficina = resultado_cheques_oficina %>% mutate(
        neto =abs(neto),
        GMF = neto * 0.004
      )
      resultado_cheques_oficina[5,4]  = resultado_cheques_oficina[5,4] * -1
      resultado_cheques_oficina[5,5]  = resultado_cheques_oficina[5,5] * -1
      
      resultado_sobrante_isa = resultado_sobrante_isa %>% mutate(
        Credito =as.numeric(Credito),
        Credito =abs(Credito),
        GMF = Credito * 0.004
      )
      
      #Calculamos los cheques mayores a COP 15.000.000 
      cheques_mayor_a = filter(cheques, abs(cheques$neto) >= 15000000)
      
      #Exportamos al ambiente globlal 
      #Creamos indices
      index <- i
      var_name_1 <- paste("R_cheques_oficina_", index, sep = "")
      var_name_2 <- paste("R_ISA_sobrantes_", index, sep = "")
      var_name_3 <- paste("Cheques_", index, sep = "")
      var_name_4 <- paste("Nombre_R_cheques_", index, sep = "")
      var_name_5 <- paste("Nombre_R_ISA_", index, sep = "")
      var_name_6 <- paste("Cheques_Oficina_", index, sep = "")

      assign(var_name_1, resultado_cheques_oficina  , envir = .GlobalEnv)
      assign(var_name_2, resultado_sobrante_isa, envir = .GlobalEnv)
      assign(var_name_3, cheques, envir = .GlobalEnv)
      assign(var_name_4, var_name_1, envir = .GlobalEnv)
      assign(var_name_5, var_name_2, envir = .GlobalEnv)
      assign(var_name_6, cheques_mayor_a, envir = .GlobalEnv)

      
    },
    error = function(e){ 
      mensaje = paste('El archivo', data, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

Cheques_Oficina_Semana_1 = "Cheques_Oficina_Semana_1.xlsx"
Cheques_Oficina_Semana_2 = "Cheques_Oficina_Semana_2.xlsx"
Cheques_Oficina_Semana_3 = "Cheques_Oficina_Semana_3.xlsx"
Cheques_Oficina_Semana_4 = "Cheques_Oficina_Semana_4.xlsx"
Cheques_Oficina_Semana_5 = "Cheques_Oficina_Semana_5.xlsx"
Cheques_Oficina_Completo = "Cheques_Oficina_Completo.xlsx"

Cheques_oficina (Cheques_Oficina_Semana_1, 1)
Cheques_oficina (Cheques_Oficina_Semana_2, 2)
Cheques_oficina (Cheques_Oficina_Semana_3, 3)
Cheques_oficina (Cheques_Oficina_Semana_4, 4)
Cheques_oficina (Cheques_Oficina_Semana_5, 5)
Cheques_oficina (Cheques_Oficina_Completo, 6)


#Funciones pago provedores
Pago_proveedores = function(datos, i) {
  tryCatch(
    {
      datos = read_excel(datos, skip = 9) 
      colnames(datos) = c("Cuenta", "Descripcion_Cuenta" , "Sucursal" , "Descripcion_Sucursal","Oficina","Descripcion_Oficina", "Tipo_Comprobante", "Descripcion_Tipo_Comprobante", "Numero_de_Transaccion","Descripcion_Transaccion","Fecha_Transaccion","Fecha_de_grabacion","Descripcion_Origen", "Numero_de_Identificacion","Digito_de_Verificacion","Razon_Social", "Documento", "Referencia_1","Dependencia", "Subproyecto", "Auxiliar_de_Conciliacion", "Tipo_de_Evento", "Clase_Contable", "Numero_de_Linea", "Saldo_Dia_Anterior", "Debito", "Credito", "Asiento_Reversado")  
      datos = data.frame(datos) 

      AH = filter(datos, datos$Tipo_Comprobante == "AH")
      FD = filter(datos, datos$Tipo_Comprobante == "FD")
      MB = filter(datos, datos$Tipo_Comprobante == "MB")
      
      AH_debito = sum(AH$Debito)
      AH_credito = sum(AH$Credito)
      
      FD_debito = sum(FD$Debito)
      FD_credito = sum(FD$Credito)
      
      MB_debito = sum(MB$Debito)
      MB_credito = sum(MB$Credito)
      
      
      Cuentas = c("Pago proveedores Damas","Pago proveedores Fijo Diario","Pago proveedores Cuenta Corriente")
      Descripcion = c("AH", "FD", "MB")
      Debito = c(AH_debito, FD_debito, MB_debito)
      Credito = c(AH_credito, FD_credito, MB_credito)
      
      resultado_pago_proveedores = data.frame(Cuentas, Descripcion, Debito, Credito)
      
      #Aqui agregamos lo que faltaba en calculos del GMF para no tocar el codigo más arriba de lo que ya se tenia
      resultado_pago_proveedores = resultado_pago_proveedores %>% mutate(
        neto = abs (Debito + Credito),
        GMF = neto * 0.004
      )
      
      # Generar un nombre de variable con un índice
      index <- i
      var_name_1 <- paste("R_pago_proveedores_", index, sep = "")
      var_name_2 <- paste("Nombre_R_Provedores_", index, sep = "")
      
      # Asignar la data al entorno global con el nombre dinámico
      assign(var_name_1, resultado_pago_proveedores, envir = .GlobalEnv)
      assign(var_name_2, var_name_1, envir = .GlobalEnv)
    },
    error = function(e){ 
      mensaje = paste('El archivo', datos, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

Pago_Proveedores_Semana_1 = "Pago_Proveedores_Semana_1.xlsx"
Pago_Proveedores_Semana_2 = "Pago_Proveedores_Semana_2.xlsx"
Pago_Proveedores_Semana_3 = "Pago_Proveedores_Semana_3.xlsx"
Pago_Proveedores_Semana_4 = "Pago_Proveedores_Semana_4.xlsx"
Pago_Proveedores_Semana_5 = "Pago_Proveedores_Semana_5.xlsx"
Pago_Proveedores_Completo = "Pago_Proveedores_Completo.xlsx"

Pago_proveedores(Pago_Proveedores_Semana_1, 1) 
Pago_proveedores(Pago_Proveedores_Semana_2, 2) 
Pago_proveedores(Pago_Proveedores_Semana_3, 3) 
Pago_proveedores(Pago_Proveedores_Semana_4, 4) 
Pago_proveedores(Pago_Proveedores_Semana_5, 5) 
Pago_proveedores(Pago_Proveedores_Completo, 6) 


#================================= GMF - CDT - CDAT ===============================
#Función CDAT 
CDAT = function(datos, i) {
  tryCatch(
    {
      datos = read_csv (datos, col_types = cols_only(op_num_banco3 = col_character(), rpt_tran = col_character(), rpt_valor = col_character(), rpt_nombre_cliente = col_character(), rpt_concepto = col_character(), rpt_num_id = col_character()), skip = 2,locale = readr::locale(encoding = "latin1"))
      
      datos$rpt_valor <- parse_number(gsub("[^0-9.-]", "", datos$rpt_valor)) * 
        ifelse(grepl("\\(", datos$rpt_valor), -1, 1)
      
      datos = data.frame(datos) 
      
      #Creamos los grupos 
      G1_CDAT = filter(datos, (datos$rpt_tran == 14903 & datos$rpt_concepto == 'CANCELACION DE PLAZO FIJO') | (datos$rpt_tran == 14943 & datos$rpt_concepto == 'PAGO DE INTERESES Y OTROS'))
      G2_CDAT = filter(datos, (datos$rpt_tran == 14919 & datos$rpt_concepto == 'APERTURA POR REINVERSION') | (datos$rpt_tran == 14919 & datos$rpt_concepto == 'CANCELACION POR REINVERSION'))
      
      #Realiazamos las 'tablas dinamicas' por numerido de indentificación
      tabla_dinamica_G1_CDAT = data.frame(G1_CDAT %>% group_by(rpt_num_id, rpt_nombre_cliente, rpt_tran) %>% summarise(valor_G1 = sum(rpt_valor)))
      tabla_dinamica_G2_CDAT = data.frame(G2_CDAT %>% group_by(rpt_num_id, rpt_nombre_cliente, rpt_tran) %>% summarise(valor_G2 = sum(rpt_valor)))
      
      CRUCE_1_CDAT = full_join(tabla_dinamica_G1_CDAT, tabla_dinamica_G2_CDAT, by= "rpt_num_id")
      
      #Colocamos con ceros todo lo que esta en NA de las filas en valor para poder sumar 
      CRUCE_1_CDAT$valor_G1[is.na(CRUCE_1_CDAT$valor_G1)] <- 0
      CRUCE_1_CDAT$valor_G2[is.na(CRUCE_1_CDAT$valor_G2)] <- 0
      
      #Creamos la columna de suma para hacer la separación de los que dan cero y diferente de cero 
      CRUCE_1_CDAT$suma_valorG1_valorG2 = CRUCE_1_CDAT$valor_G1 + CRUCE_1_CDAT$valor_G2
      
      #Creamos dos dataSets: 'diferentes_de_cero' (lo que no da cero)  y 'cruzan' (lo que da cero) 
      diferentes_de_cero_CDAT = filter (CRUCE_1_CDAT, CRUCE_1_CDAT$suma_valorG1_valorG2 != 0)
      cruzan_CDAT = filter (CRUCE_1_CDAT, CRUCE_1_CDAT$suma_valorG1_valorG2 == 0)
      
      #Sobre las que son diferentes de cero tomamos solo el grupo 1 
      cancelacion_G1_CDAT = filter (diferentes_de_cero_CDAT, diferentes_de_cero_CDAT$rpt_tran.x == 14903 )
      intereses_otros_G1_CDAT = filter (diferentes_de_cero_CDAT, diferentes_de_cero_CDAT$rpt_tran.x == 14943)
      
      #Sacamos la tabal resumen
      resumen_G1_CDAT = data.frame(Concepto = c('CANCELACION DE PLAZO FIJO', 'PAGO DE INTERESES Y OTROS'),
                                   Total = c(sum(cancelacion_G1_CDAT$valor_G1), sum(intereses_otros_G1_CDAT$valor_G1)))
      
      #Aqui agregamos lo que faltaba en calculos del GMF para no tocar el codigo más arriba de lo que ya se tenia
      resumen_G1_CDAT = resumen_G1_CDAT %>% mutate(
        Total =abs(Total),
        GMF = Total * 0.004
      )
      

      # Generar un nombre de variable con un índice
      index <- i
      var_name_1 <- paste("resumen_CDAT_", index, sep = "")
      var_name_2 <- paste("Nombre_R_CDAT_", index, sep = "")
      
      # Asignar la data al entorno global con el nombre dinámico
      assign(var_name_1, resumen_G1_CDAT, envir = .GlobalEnv)
      assign(var_name_2, var_name_1, envir = .GlobalEnv)
      
      
    },
    error = function(e){ 
      mensaje = paste('El archivo', datos, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

CDAT_Semana_1 = "CDAT_Semana_1.csv"
CDAT_Semana_2 = "CDAT_Semana_2.csv"
CDAT_Semana_3 = "CDAT_Semana_3.csv"
CDAT_Semana_4 = "CDAT_Semana_4.csv"
CDAT_Semana_5 = "CDAT_Semana_5.csv"
CDAT_Completo = "CDAT_Completo.csv"

CDAT(CDAT_Semana_1, 1) 
CDAT(CDAT_Semana_2, 2) 
CDAT(CDAT_Semana_3, 3) 
CDAT(CDAT_Semana_4, 4) 
CDAT(CDAT_Semana_5, 5) 
CDAT(CDAT_Completo, 6) 

#Función CDT 
CDT = function(datos, i) {
  tryCatch(
    {
      datos_1 <- read_csv(datos, col_types = cols(pd_fecha_proceso = col_date(format = "%d/%m/%Y"), 
                                                    op_num_banco3 = col_character(), rpt_tran = col_number(), 
                                                    rpt_fecha_aplicacion = col_date(format = "%d/%m/%Y"), 
                                                    rpt_nombre_cliente = col_character(), 
                                                    rpt_concepto = col_character(), rpt_num_id = col_character()), skip = 2,locale = readr::locale(encoding = "latin1"))
      
      datos = read_csv (datos, col_types = cols_only(op_num_banco3 = col_character(), rpt_tran = col_number(), rpt_valor = col_character(), rpt_nombre_cliente = col_character(), rpt_concepto = col_character(), rpt_num_id = col_character()), skip = 2,locale = readr::locale(encoding = "latin1"))
 
      #Pasamos rpt_valor a dato numerico
      datos$rpt_valor <- parse_number(gsub("[^0-9.-]", "", datos$rpt_valor)) * 
        ifelse(grepl("\\(", datos$rpt_valor), -1, 1)
      
      datos_1$rpt_valor <- parse_number(gsub("[^0-9.-]", "", datos_1$rpt_valor)) * 
        ifelse(grepl("\\(", datos_1$rpt_valor), -1, 1)
      
      datos = data.frame(datos) 
      datos_1 = data.frame(datos_1) 
      
      #============================================ CDT =========================================
      #Filtramos quitando Depositos y banco davivienda
      CDT_2 = filter (datos, datos$rpt_num_id != "8001820912" & datos$rpt_num_id != "8600343137")
      CDT_3 = filter (datos_1, datos_1$rpt_num_id == "8001820912" | datos_1$rpt_num_id == "8600343137")
      
      #Adición posterior a entrega sacando algunos datos
      CDT_3_2 = filter (CDT_3, CDT_3$en_nomlar2 != 'SEB' & CDT_3$rpt_num_id != "8600343137")
      CDT_3_2 = filter (CDT_3_2, CDT_3_2$rpt_concepto == "PAGO DE INTERESES Y OTROS")
      
      CDT_3_1 = anti_join(CDT_3, CDT_3_2)
      
      total_cdt_deceval = sum(CDT_3_2$rpt_valor)
      
      #Creamos los usb grupos por cuenta y concepto 
      G1_CDT = filter(CDT_2, (CDT_2$rpt_tran == 14543 & CDT_2$rpt_concepto == 'ANULACION POR CHEQUE DEVUELTO') | (CDT_2$rpt_tran == 14875 & CDT_2$rpt_concepto == 'ANULACION DE PLAZO FIJO') | (CDT_2$rpt_tran == 14943 & CDT_2$rpt_concepto == 'DEVOLUCION REMANENTE POR CHEQUE DEVUELTO'))
      G2_CDT = filter(CDT_2, CDT_2$rpt_tran == 14901 & CDT_2$rpt_concepto == 'APERTURA DPF')
      G3_CDT = filter(CDT_2, (CDT_2$rpt_tran == 14903 & CDT_2$rpt_concepto == 'CANCELACION DE PLAZO FIJO') | (CDT_2$rpt_tran == 14943 & CDT_2$rpt_concepto == 'PAGO DE INTERESES Y OTROS'))
      G4_CDT = filter(CDT_2, (CDT_2$rpt_tran == 14919 & CDT_2$rpt_concepto == 'APERTURA POR REINVERSION') | (CDT_2$rpt_tran == 14919 & CDT_2$rpt_concepto == 'CANCELACION POR REINVERSION'))
      
      #============================= Primera parte: G1 vs G2 ===================================
      #Creamos una data organizando los grupo 1vs2
      CRUCE_1_CDT = rbind(G1_CDT, G2_CDT)
      
      #Haremos un group_by para totalizar todo lo que tenga coincidente en: op_num_banco3, rpt_num_id, rpt_tran,rpt_nombre_cliente,rpt_concepto
      Primera_agrupacion_cruce_1 = CRUCE_1_CDT %>% 
        group_by(op_num_banco3, rpt_num_id, rpt_tran,rpt_nombre_cliente,rpt_concepto) %>% summarise(rpt_valor = sum(rpt_valor))
      
      #Añadimos la columna 'codigo' que pondra todo lo diferente a las 14901 con codigo -14901, para que me permita filtrar.
      Primera_agrupacion_cruce_1$codigo = case_when(Primera_agrupacion_cruce_1$rpt_tran == 14543 | Primera_agrupacion_cruce_1$rpt_tran == 14875 | Primera_agrupacion_cruce_1$rpt_tran == 14943 ~ -14901, TRUE ~ 14901)
      
      #======================== Primera limpieza: Revisar que se puede cancelar teniendo en cuenta por 'op_num_banco3' 
      muertos1 <- Primera_agrupacion_cruce_1 %>%
        semi_join(Primera_agrupacion_cruce_1 %>%
                    mutate(rpt_valor = -rpt_valor, codigo = -codigo), 
                  by = c("rpt_nombre_cliente", "rpt_num_id", "op_num_banco3","rpt_valor", "codigo"))
      
      # Obtener la tabla "vivos1" con las filas que no tienen contrapartes
      vivos1 <- Primera_agrupacion_cruce_1 %>%
        anti_join(muertos1, by = c("op_num_banco3", "rpt_tran", "rpt_valor", "rpt_nombre_cliente", "rpt_concepto", "rpt_num_id", "codigo"))
      
      
      #======================== Segunda limpieza: Revisar que se puede cancelar sin tener en cuenta 'op_num_banco3'
      #Sobre vivos1 vamos a hacer una segunda limpieza  sin tener en cuenta op_num_banco3 para ver que se puede cancelar o tiene contraparte
      muertos2 <- vivos1 %>%
        semi_join(vivos1 %>%
                    mutate(rpt_valor = -rpt_valor, codigo = -codigo), 
                  by = c("rpt_nombre_cliente", "rpt_num_id", "rpt_valor", "codigo"))
      
      # Obtener la tabla "vivos1" con las filas que no tienen contrapartes
      vivos2 <- vivos1 %>%
        anti_join(muertos2, by = c("op_num_banco3", "rpt_tran", "rpt_valor", "rpt_nombre_cliente", "rpt_concepto", "rpt_num_id", "codigo"))
      
      #========================= Tercera limpieza: Desagrupar para ver que podemos cancelar nuevamente  
      #Hacemos un merge por "op_num_banco3","rpt_num_id",  "rpt_tran", "rpt_nombre_cliente", "rpt_concepto" -- así en 'rpt_valor.y' tendremos los datos originales sin agrupar para ver que podemos cancelar sin tener en cuenta 'op_num_banco3'
      desagrupado_vivo <- merge(vivos2, CRUCE_1_CDT, by = c("op_num_banco3","rpt_num_id",  "rpt_tran", "rpt_nombre_cliente", "rpt_concepto"))
      
      #Volvimos a limpiar muertos3 y vivos3 sin tener en cuenta 'op_num_banco3' 
      muertos3 <- desagrupado_vivo %>%
        semi_join(desagrupado_vivo %>%
                    mutate(rpt_valor.y = -rpt_valor.y, codigo = -codigo), 
                  by = c("rpt_nombre_cliente", "rpt_num_id", "rpt_valor.y", "codigo"))
      
      #Finalmente es la tabla que queda ya con las operaciones vivas
      vivos3 <- desagrupado_vivo %>%
        anti_join(muertos3, by = c("op_num_banco3", "rpt_tran", "rpt_valor.y", "rpt_nombre_cliente", "rpt_concepto", "rpt_num_id", "codigo"))
      
      
      #Unimos los 3 que quedan muertos, quitando las columnas que no usamos para exportar un 'muertos_final_cruce_1_CDT' 
      muertos1 = muertos1 %>% select(-c('codigo'))
      muertos2 = muertos2 %>% select(-c('codigo'))
      muertos3 = muertos3 %>% mutate(rpt_valor = rpt_valor.y) %>% select(-c('codigo', 'rpt_valor.x', 'rpt_valor.y'))
      
      muertos_final_cruce_1_CDT = rbind(muertos1, muertos2, muertos3) #Este se exporta 
      
      #Ahora limpiamos vivos3 y separamos por codigos 
      vivos3 = vivos3 %>% mutate(rpt_valor = rpt_valor.y) %>% select(-c('codigo', 'rpt_valor.x', 'rpt_valor.y'))
      
      #Hacemos vivos_G1_CDT y vivos_G2_CDT
      vivos_G1_CDT = filter(vivos3, vivos3$rpt_tran == 14543 | vivos3$rpt_tran == 14875 | vivos3$rpt_tran == 14943)
      vivos_G2_CDT = filter(vivos3, vivos3$rpt_tran == 14901 )
      
      
      #============================= Segunda parte: G3 vs G4 ===================================
      Tabla_dinamica_G3  = data.frame(G3_CDT %>% group_by(rpt_num_id) %>% summarise(valor_G3 = sum(rpt_valor)))
      Tabla_dinamica_G4  = data.frame(G4_CDT %>% group_by(rpt_num_id) %>% summarise(valor_G4 = sum(rpt_valor)))
      
      #Juntamos las doa agrupaciones anteriores para poder sumar sus valores totalizados
      CRUCE_2_CDT = full_join(Tabla_dinamica_G3, Tabla_dinamica_G4, by= "rpt_num_id")
      
      #Colocamos con ceros todo lo que esta en NA de las filas en valor para poder sumar 
      CRUCE_2_CDT$valor_G3[is.na(CRUCE_2_CDT$valor_G3)] <- 0
      CRUCE_2_CDT$valor_G4[is.na(CRUCE_2_CDT$valor_G4)] <- 0
      
      #Creamos la columna de suma para hacer la separación de los que dan cero y diferente de cero 
      CRUCE_2_CDT$suma_valorG3_valorG4 = CRUCE_2_CDT$valor_G3 + CRUCE_2_CDT$valor_G4
      
      #Creamos dos dataSets: 'diferentes_de_cero' (lo que no da cero)  y 'cruzan' (lo que da cero) 
      diferentes_de_cero = filter (CRUCE_2_CDT, CRUCE_2_CDT$suma_valorG3_valorG4 != 0)
      cruzan = filter (CRUCE_2_CDT, CRUCE_2_CDT$suma_valorG3_valorG4 == 0)
      
      #De diferente de cero tomamos la columna de 'rpt_nombre_cliente', 'rpt_num_id' y 'valor_G3' (14903 y 14943) para hacer el siguente cruce (vivos_G2_CDT vs vivos_G3_CDT)
      vivos_G3_CDT = diferentes_de_cero[,1:3]
      
      #Quitamos todo lo que este en ceros en la columna 'valor_G3'
      vivos_G3_CDT = filter(vivos_G3_CDT, vivos_G3_CDT$valor_G3 != 0)
      
      #============================= Tercera parte: vivos_G2_CDT vs vivos_G3_CDT ===================================
      #Agrupamos por 'rpt_num_id' de vivos_G2_CDT
      vivos_G2_CDT_1  = data.frame(vivos_G2_CDT %>% group_by(rpt_num_id) %>% summarise(valor_G2 = sum(rpt_valor)))
      vivos_G3_CDT_1 = vivos_G3_CDT
      
      #Juntamos para hacer 'CONTROL' y 'GMF' 
      Activaciones_VS_Redenciones = full_join(vivos_G2_CDT_1, vivos_G3_CDT_1, by= "rpt_num_id")
      
      #Primera separamos por las no coindicentes 
      no_coincidente <- Activaciones_VS_Redenciones[complete.cases(Activaciones_VS_Redenciones) == FALSE, ]
      
      #Obtenemos la tabla 'coincidentes'
      coincidentes <- anti_join(Activaciones_VS_Redenciones, no_coincidente)
      
      #Creamos control y GFM
      coincidentes =coincidentes %>% mutate(Control = valor_G2 + valor_G3, 
                                            GMF = case_when(Control < 0 ~ Control * 0.004 ,
                                                            TRUE ~ 0))
      
      coincidentes <- coincidentes[order(coincidentes$Control), ]
      
      
      #Separamos dos datos 
      coincidentes_cero_negativo = filter(coincidentes, coincidentes$Control <= 0)
      coincidentes_positivo = filter(coincidentes, coincidentes$Control > 0)
      
      
      #Totalizamos los valores y lo colocamos en una tabla 
      resumen = data.frame(
        Total_G2 = c(sum(coincidentes_cero_negativo$valor_G2), sum(coincidentes_positivo$valor_G2)),
        Total_G3 = c(sum(coincidentes_cero_negativo$valor_G3), sum(coincidentes_positivo$valor_G3)),
        Total_control = c(sum(coincidentes_cero_negativo$Control), sum(coincidentes_positivo$Control)),
        Total_GMF = c(sum(coincidentes_cero_negativo$Control), sum(coincidentes_positivo$GMF)))
      
      resumen = resumen %>% mutate(GMF_Total_G2 = Total_G2*0.004, 
                                   GMF_Total_G3 = Total_G3 * 0.004)
      
      resumen = resumen %>% mutate(Contribución_Asumida = c(resumen[1,5] , (resumen[2,6]*-1)))
      
      #Totalizamos 
      total = resumen[1,] + resumen[2,]
      resumen = rbind(resumen, total)
      
      #Colocamos nombres a las filas
      row.names(resumen) = c('Igual o Menores a cero','Mayores a cero','Total')
      
      resumen = resumen %>% select(-c(Total_GMF, GMF_Total_G2, GMF_Total_G3))
      
      
      #============================= Sacar totales de cancelaciones y pagos de interes y otros (G3)
      prueba3 = merge (vivos_G3_CDT, G3_CDT, by = c('rpt_num_id'))
      
      cancelacion_G3 = filter(prueba3, prueba3$rpt_tran == 14903)
      intereses_otros_G3 = filter(prueba3, prueba3$rpt_tran == 14943)
      
      resumen_G3 = data.frame(Concepto = c('CANCELACION DE PLAZO FIJO', 'PAGO DE INTERESES Y OTROS', 'PAGO DE INTERESES Y OTROS DECEVAL'),
                              Total = c(sum(cancelacion_G3$rpt_valor), sum(intereses_otros_G3$rpt_valor), total_cdt_deceval))
      
      resumen_G3$GMF = resumen_G3$Total * 0.004
      
      #================================= Limpiar para sacar las redenciones y activaciones y sus demas datos
      redenciones = prueba3 %>% select(-c(valor_G3)) 
      
      #Limpiar para sacar activaciones
      activaciones = vivos_G2_CDT
      
      #Sacamos con los datos completos
      redenciones_completo = left_join(redenciones, datos_1, by =c("rpt_nombre_cliente", "rpt_num_id","op_num_banco3","rpt_tran","rpt_concepto","rpt_valor"), multiple = "first")
      activaciones_completo  = left_join(activaciones, datos_1, by =c("rpt_nombre_cliente", "rpt_num_id","op_num_banco3","rpt_tran","rpt_concepto","rpt_valor"), multiple = "first")
      
      #Aqui agregamos lo que faltaba en calculos del GMF para no tocar el codigo más arriba de lo que ya se tenia
      fila = data.frame(resumen_G3[2,c(2,3)] + resumen_G3[3,c(2,3)]) %>% mutate(Concepto = "Total Intereses y otros")
      resumen_G3 = rbind(resumen_G3, fila) %>% mutate(Total = abs(Total), GMF = abs(GMF) )
      

      # Generar un nombre de variable con un índice
      index <- i
      var_name_1 <- paste("resumen_CDT_", index, sep = "")
      var_name_2 <- paste("Tabla_Conceptos_CDT_", index, sep = "")
      var_name_3 <- paste("Nombre_R_CDT_", index, sep = "")
      var_name_4 <- paste("Nombre_R_CDT_Conceptos_", index, sep = "")
      
      # Asignar la data al entorno global con el nombre dinámico
      assign(var_name_1, resumen, envir = .GlobalEnv)
      assign(var_name_2, resumen_G3, envir = .GlobalEnv)
      assign(var_name_3, var_name_1, envir = .GlobalEnv)
      assign(var_name_4, var_name_2, envir = .GlobalEnv)
      
    },
    error = function(e){ 
      mensaje = paste('El archivo', datos, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

CDT_Semana_1 = "CDT_Semana_1.csv"
CDT_Semana_2 = "CDT_Semana_2.csv"
CDT_Semana_3 = "CDT_Semana_3.csv"
CDT_Semana_4 = "CDT_Semana_4.csv"
CDT_Semana_5 = "CDT_Semana_5.csv"
CDT_Completo = "CDT_Completo.csv"

CDT(CDT_Semana_1, 1) 
CDT(CDT_Semana_2, 2) 
CDT(CDT_Semana_3, 3) 
CDT(CDT_Semana_4, 4) 
CDT(CDT_Semana_5, 5) 
CDT(CDT_Completo, 6) 

#================================= Cheques girados (CH gastos) ===============================
cheques_girados = function(datos, i, parametros_cheques_girados) {
  tryCatch(
    {
      datos = read_excel (datos, skip = 11)
      names(datos) = c("UN", "G_LIBROS","LIBRO","CUENTA", "SUCURSAL","DEPENDENCIA","ID_DE_ASIENTO","FECHA_COMPROBANTE","FECHA_PROCESO","DESCRIPCION","DEBITO","CREDITO","AUXILIAR","REFERENCIA","USUARIO","ID_COMPROBANTE" , "ESTADO","REAL")  
      datos = datos[,c("DEBITO","CREDITO", "ID_COMPROBANTE", "ID_DE_ASIENTO")]
      datos = datos %>% mutate( across(c(1:2), ~ as.numeric(.)),
                                 ID_COMPROBANTE = substr(ID_COMPROBANTE, 1,2),
                                 ID_DE_ASIENTO = substr(ID_DE_ASIENTO, 1,2))
      datos = data.frame(datos)
      
      #Hacemos un join para traer los datos 
      datos = left_join(datos, parametros_cheques_girados, by = c("ID_COMPROBANTE", "ID_DE_ASIENTO"))
      datos = data.frame(datos)
      
      #Aqui hacemos un control para cheques por si resulta alguna otra combinacion 
      datos_sif  = filter(datos, datos$Concepto == "Sif")
      datos_cheques_girados = filter(datos, datos$Concepto == "Cheques Girados") 
      
      Conceptos = c("Cheques girados", "Sif", "Total_por_conceptos", "Total_Base")
      totales_debito = c(abs(sum(datos_cheques_girados$DEBITO)), abs(sum(datos_sif$DEBITO)), abs(sum(datos_cheques_girados$DEBITO) + sum(datos_sif$DEBITO)), abs(sum(datos$DEBITO)))
      totales_credito = c(abs(sum(datos_cheques_girados$CREDITO)), abs(sum(datos_sif$CREDITO)), abs(sum(datos_cheques_girados$CREDITO) + sum(datos_sif$CREDITO)), abs(sum(datos$CREDITO)))
      Control_cheques_girados = data.frame(Concepto = Conceptos , Debito = totales_debito , Credito = totales_credito)
      
      # Generar un nombre de variable con un índice
      index <- i
      var_name_1 <- paste("cheques_girados_", index, sep = "")
      var_name_2 <- paste("R_cheques_girados_", index, sep = "")
      var_name_3 <- paste("Nombre_cheques_girados_", index, sep = "")
      
      # Asignar la data al entorno global con el nombre dinámico
      assign(var_name_1, datos, envir = .GlobalEnv)
      assign(var_name_2, Control_cheques_girados, envir = .GlobalEnv)
      assign(var_name_3, var_name_2, envir = .GlobalEnv)
      
    },
    error = function(e){ 
      mensaje = paste('El archivo', datos, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

Cheques_Girados_Semana_1 = "Cheques_Girados_Semana_1.xlsx"
Cheques_Girados_Semana_2 = "Cheques_Girados_Semana_2.xlsx"
Cheques_Girados_Semana_3 = "Cheques_Girados_Semana_3.xlsx"
Cheques_Girados_Semana_4 = "Cheques_Girados_Semana_4.xlsx"
Cheques_Girados_Semana_5 = "Cheques_Girados_Semana_5.xlsx"
Cheques_Girados_Completo = "Cheques_Girados_Completo.xlsx"

cheques_girados(Cheques_Girados_Semana_1, 1, parametros_cheques_girados) 
cheques_girados(Cheques_Girados_Semana_2, 2, parametros_cheques_girados) 
cheques_girados(Cheques_Girados_Semana_3, 3, parametros_cheques_girados) 
cheques_girados(Cheques_Girados_Semana_4, 4, parametros_cheques_girados) 
cheques_girados(Cheques_Girados_Semana_5, 5, parametros_cheques_girados) 
cheques_girados(Cheques_Girados_Completo, 6, parametros_cheques_girados) 



#================================= Pago de Intereses ===============================
Pago_Intereses = function(datos, i) {
  tryCatch(
    {
      datos <- read_excel(datos, col_types = c("text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "numeric", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "numeric", "text"), skip = 9)
      names(datos) = c("Cuenta", "Descripcion_Cuenta","Sucursal","Descripcion_Sucursal","Oficina",  "Descripcion_Oficina","Tipo_Comprobante","Descripcion_Tipo_Comprobante","Numero_de_Transaccion","Descripcion_Transaccion","Fecha_Transaccion","Fecha_de_grabacion","Descripcion_Cabecera", "Numero_de_Identificacion","Digito_de_Verificacion","Razon_Social","Documento","Referencia_1","Dependencia","Subproyecto","Auxiliar_de_Conciliacion", "Tipo_de_Evento","Clase_Contable", "Numero_de_Linea","Saldo_Dia_Anterior","Debito","Credito","Asiento_Reversado")
      datos = datos[,c("Cuenta","Debito","Credito")]
      datos = datos %>% mutate(across(c(2:3), ~ as.numeric(.)),
                               Debito  = ifelse(is.na(Debito), 0, Debito),
                               Credito = ifelse(is.na(Credito), 0, Credito),
                               Neto = Debito - Credito)
      datos = data.frame(datos)
      
      #Hacemos una agrupación por cuentas 
      datos = data.frame(datos  %>% group_by(Cuenta) %>% summarise(Debito = sum(Debito), Credito = sum(Credito), Neto =sum(Neto))) %>% mutate(GMF = Neto * 0.004)
      datos = filter(datos, datos$Cuenta == "5102050010" | datos$Cuenta == "5102050028" | datos$Cuenta == "5102950011" )
      
      C5102050010 = filter(datos, datos$Cuenta == "5102050010")
      C5102050028 = filter(datos, datos$Cuenta == "5102050028")
      C5102950011 = filter(datos, datos$Cuenta == "5102950011")
      
      # Generar un nombre de variable con un índice
      index <- i
      var_name_1 <- paste("Pago_Intereses_", index, sep = "")
      var_name_2 <- paste("C5102050010_", index, sep = "")
      var_name_3 <- paste("C5102050028_", index, sep = "")
      var_name_4 <- paste("C5102950011_", index, sep = "")
      var_name_5 <- paste("Nombre_Damas_", index, sep = "")
      var_name_6 <- paste("Nombre_Fijo_Diario_", index, sep = "")
      var_name_7 <- paste("Nombre_Cuenta_Corriente_", index, sep = "")
      
      
      # Asignar la data al entorno global con el nombre dinámico
      assign(var_name_1, datos, envir = .GlobalEnv)
      assign(var_name_2, C5102050010, envir = .GlobalEnv)
      assign(var_name_3, C5102050028, envir = .GlobalEnv)
      assign(var_name_4, C5102950011, envir = .GlobalEnv)
      assign(var_name_5, var_name_3, envir = .GlobalEnv)
      assign(var_name_6, var_name_2, envir = .GlobalEnv)
      assign(var_name_7, var_name_4, envir = .GlobalEnv)

      
    },
    error = function(e){ 
      mensaje = paste('El archivo', datos, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

Pago_Intereses_Semana_1 = "Pago_Intereses_Semana_1.xlsx"
Pago_Intereses_Semana_2 = "Pago_Intereses_Semana_2.xlsx"
Pago_Intereses_Semana_3 = "Pago_Intereses_Semana_3.xlsx"
Pago_Intereses_Semana_4 = "Pago_Intereses_Semana_4.xlsx"
Pago_Intereses_Semana_5 = "Pago_Intereses_Semana_5.xlsx"
Pago_Intereses_Completo = "Pago_Intereses_Completo.xlsx"

Pago_Intereses(Pago_Intereses_Semana_1, 1) 
Pago_Intereses(Pago_Intereses_Semana_2, 2) 
Pago_Intereses(Pago_Intereses_Semana_3, 3) 
Pago_Intereses(Pago_Intereses_Semana_4, 4) 
Pago_Intereses(Pago_Intereses_Semana_5, 5) 
Pago_Intereses(Pago_Intereses_Completo, 6) 





#================================= Timbre ===============================

Timbre = function(datos, i) {
  tryCatch(
    {
      datos <- read_excel(datos, sheet = "Timbre_0098", col_types = c("text", "text", "date", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text"))
      names(datos) = c("COMPROBANTE","CODOFIC","FECHA", "DESCRIPCION","DOCUMENTO","VALOR","MOTIVO","Otro_Cual", "No_CHEQUE_ANULADO_No_DE_CREDITO_GIRADO","No_CHEQUE_REPOSICION","No_CHEQUERA","BENEFICIARIO_TITULAR","NIT","GMF_ASUMIDO")
      datos = datos[,c("VALOR","GMF_ASUMIDO")]
      datos = datos %>% mutate(VALOR = str_replace_all(VALOR,"[,]", ""),
                               VALOR  = as.numeric(VALOR),
                               GMF_ASUMIDO = toupper(GMF_ASUMIDO),
                               GMF_ASUMIDO = str_remove_all(GMF_ASUMIDO, " "))
      datos = data.frame(datos)
      
      #Filtramos por lo que digan que SI
      datos = filter(datos, datos$GMF_ASUMIDO == "SI")
      Contribucion_Asumida = sum(datos$VALOR) * 0.004
      
      
      # Generar un nombre de variable con un índice
      index <- i
      var_name_1 <- paste("Contribucion_Asumida_", index, sep = "")
      var_name_2 <- paste("Nombre_Contribucion_Asumida_", index, sep = "")
      

      # Asignar la data al entorno global con el nombre dinámico
      assign(var_name_1, Contribucion_Asumida, envir = .GlobalEnv)
      assign(var_name_2, var_name_1, envir = .GlobalEnv)
      
    },
    error = function(e){ 
      mensaje = paste('El archivo', datos, 'no esta disponible')
      cat(mensaje, "\n")
    }
  )
}

Timbre_Semana_1 = "Timbre_Semana_1.xlsx"
Timbre_Semana_2 = "Timbre_Semana_2.xlsx"
Timbre_Semana_3 = "Timbre_Semana_3.xlsx"
Timbre_Semana_4 = "Timbre_Semana_4.xlsx"
Timbre_Semana_5 = "Timbre_Semana_5.xlsx"
Timbre_Completo = "Timbre_Completo.xlsx"

Timbre(Timbre_Semana_1, 1) 
Timbre(Timbre_Semana_2, 2) 
Timbre(Timbre_Semana_3, 3) 
Timbre(Timbre_Semana_4, 4) 
Timbre(Timbre_Semana_5, 5) 
Timbre(Timbre_Completo, 6) 



#================================= Datos en el comprobante ===============================
#Cheques
R_cheques_funcion = function (data, nombre_data, fila1, fila2){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[1,4]
    comprobante_1[fila1,7] <<- data[1,5]
    comprobante_1[fila2,6] <<- data[5,4]
    comprobante_1[fila2,7] <<- data[5,5]
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("R_cheques_oficina_1")){R_cheques_funcion(R_cheques_oficina_1, Nombre_R_cheques_1,  1, 41)} else {print("No esta disponible 1")}
if (exists("R_cheques_oficina_2")){R_cheques_funcion(R_cheques_oficina_2, Nombre_R_cheques_2,  2, 42)} else {print("No esta disponible 2")}
if (exists("R_cheques_oficina_3")){R_cheques_funcion(R_cheques_oficina_3, Nombre_R_cheques_3,  3, 43)} else {print("No esta disponible 3")}
if (exists("R_cheques_oficina_4")){R_cheques_funcion(R_cheques_oficina_4, Nombre_R_cheques_4,  4, 44)} else {print("No esta disponible 4")}
if (exists("R_cheques_oficina_5")){R_cheques_funcion(R_cheques_oficina_5, Nombre_R_cheques_5,  5, 45)} else {print("No esta disponible 5")}
if (exists("R_cheques_oficina_6")){R_cheques_funcion(R_cheques_oficina_6, Nombre_R_cheques_6,  7, 47)} else {print("No esta disponible 6")}

#ISA
R_ISA_funcion = function (data, nombre_data, fila1, fila2){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[1,2]
    comprobante_1[fila1,7] <<- data[1,3]
    comprobante_1[fila2,6] <<- data[2,2]
    comprobante_1[fila2,7] <<- data[2,3]
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("R_ISA_sobrantes_1")){R_ISA_funcion(R_ISA_sobrantes_1, Nombre_R_ISA_1, 57 , 49)} else {print("No esta disponible 1")}
if (exists("R_ISA_sobrantes_2")){R_ISA_funcion(R_ISA_sobrantes_2, Nombre_R_ISA_2, 58 , 50)} else {print("No esta disponible 2")}
if (exists("R_ISA_sobrantes_3")){R_ISA_funcion(R_ISA_sobrantes_3, Nombre_R_ISA_3, 59 , 51)} else {print("No esta disponible 3")}
if (exists("R_ISA_sobrantes_4")){R_ISA_funcion(R_ISA_sobrantes_4, Nombre_R_ISA_4, 60 , 52)} else {print("No esta disponible 4")}
if (exists("R_ISA_sobrantes_5")){R_ISA_funcion(R_ISA_sobrantes_5, Nombre_R_ISA_5, 61 , 53)} else {print("No esta disponible 5")}
if (exists("R_ISA_sobrantes_6")){R_ISA_funcion(R_ISA_sobrantes_6, Nombre_R_ISA_6, 63 , 55)} else {print("No esta disponible 6")}

#Provedores
R_Provedores_funcion = function (data, nombre_data, fila1, fila2, fila3){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[1,5]
    comprobante_1[fila1,7] <<- data[1,6]
    comprobante_1[fila2,6] <<- data[2,5]
    comprobante_1[fila2,7] <<- data[2,6]
    comprobante_1[fila3,6] <<- data[3,5]
    comprobante_1[fila3,7] <<- data[3,6]
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("R_pago_proveedores_1")){R_Provedores_funcion(R_pago_proveedores_1, Nombre_R_Provedores_1, 89 , 97, 105)} else {print("No esta disponible 1")}
if (exists("R_pago_proveedores_2")){R_Provedores_funcion(R_pago_proveedores_2, Nombre_R_Provedores_2, 90 , 98, 106)} else {print("No esta disponible 2")}
if (exists("R_pago_proveedores_3")){R_Provedores_funcion(R_pago_proveedores_3, Nombre_R_Provedores_3, 91 , 99, 107)} else {print("No esta disponible 3")}
if (exists("R_pago_proveedores_4")){R_Provedores_funcion(R_pago_proveedores_4, Nombre_R_Provedores_4, 92 , 100, 108)} else {print("No esta disponible 4")}
if (exists("R_pago_proveedores_5")){R_Provedores_funcion(R_pago_proveedores_5, Nombre_R_Provedores_5, 93 , 101, 109)} else {print("No esta disponible 5")}
if (exists("R_pago_proveedores_6")){R_Provedores_funcion(R_pago_proveedores_6, Nombre_R_Provedores_6, 95 , 103, 111)} else {print("No esta disponible 6")}

#CDAT
R_CDAT_funcion = function (data, nombre_data, fila1){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[2,2]
    comprobante_1[fila1,7] <<- data[2,3]
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("resumen_CDAT_1")){R_CDAT_funcion(resumen_CDAT_1, Nombre_R_CDAT_1, 25)} else {print("No esta disponible 1")}
if (exists("resumen_CDAT_2")){R_CDAT_funcion(resumen_CDAT_2, Nombre_R_CDAT_2, 26)} else {print("No esta disponible 2")}
if (exists("resumen_CDAT_3")){R_CDAT_funcion(resumen_CDAT_3, Nombre_R_CDAT_3, 27)} else {print("No esta disponible 3")}
if (exists("resumen_CDAT_4")){R_CDAT_funcion(resumen_CDAT_4, Nombre_R_CDAT_4, 28)} else {print("No esta disponible 4")}
if (exists("resumen_CDAT_5")){R_CDAT_funcion(resumen_CDAT_5, Nombre_R_CDAT_5, 29)} else {print("No esta disponible 5")}
if (exists("resumen_CDAT_6")){R_CDAT_funcion(resumen_CDAT_6, Nombre_R_CDAT_6, 31)} else {print("No esta disponible 6")}

#CDT
R_CDT_resumen_funcion = function (data, nombre_data, fila1){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,8] <<- data[3,4]
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("resumen_CDT_1")){R_CDT_resumen_funcion(resumen_CDT_1, Nombre_R_CDT_1, 17)} else {print("No esta disponible 1")}
if (exists("resumen_CDT_2")){R_CDT_resumen_funcion(resumen_CDT_2, Nombre_R_CDT_2, 18)} else {print("No esta disponible 2")}
if (exists("resumen_CDT_3")){R_CDT_resumen_funcion(resumen_CDT_3, Nombre_R_CDT_3, 19)} else {print("No esta disponible 3")}
if (exists("resumen_CDT_4")){R_CDT_resumen_funcion(resumen_CDT_4, Nombre_R_CDT_4, 20)} else {print("No esta disponible 4")}
if (exists("resumen_CDT_5")){R_CDT_resumen_funcion(resumen_CDT_5, Nombre_R_CDT_5, 21)} else {print("No esta disponible 5")}
if (exists("resumen_CDT_6")){R_CDT_resumen_funcion(resumen_CDT_6, Nombre_R_CDT_6, 23)} else {print("No esta disponible 6")}

#CDT
R_CDT_conceptos_funcion = function (data, nombre_data, fila1,fila2){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[1,2]
    comprobante_1[fila1,7] <<- data[1,3]
    
    comprobante_1[fila2,6] <<- data[4,2]
    comprobante_1[fila2,7] <<- data[4,3]
    
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("Tabla_Conceptos_CDT_1")){R_CDT_conceptos_funcion(Tabla_Conceptos_CDT_1, Nombre_R_CDT_Conceptos_1, 17 , 33)} else {print("No esta disponible 1")}
if (exists("Tabla_Conceptos_CDT_2")){R_CDT_conceptos_funcion(Tabla_Conceptos_CDT_2, Nombre_R_CDT_Conceptos_2, 18 , 34)} else {print("No esta disponible 2")}
if (exists("Tabla_Conceptos_CDT_3")){R_CDT_conceptos_funcion(Tabla_Conceptos_CDT_3, Nombre_R_CDT_Conceptos_3, 19 , 35)} else {print("No esta disponible 3")}
if (exists("Tabla_Conceptos_CDT_4")){R_CDT_conceptos_funcion(Tabla_Conceptos_CDT_4, Nombre_R_CDT_Conceptos_4, 20 , 36)} else {print("No esta disponible 4")}
if (exists("Tabla_Conceptos_CDT_5")){R_CDT_conceptos_funcion(Tabla_Conceptos_CDT_5, Nombre_R_CDT_Conceptos_5, 21 , 37)} else {print("No esta disponible 5")}
if (exists("Tabla_Conceptos_CDT_6")){R_CDT_conceptos_funcion(Tabla_Conceptos_CDT_6, Nombre_R_CDT_Conceptos_6, 23 , 39)} else {print("No esta disponible 6")}

#Cheques girados
R_Cheques_Girados_funcion = function (data, nombre_data, fila1){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[1,3]
    comprobante_1[fila1,7] <<- data[1,2] * 0.004
    
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("R_cheques_girados_1")){R_Cheques_Girados_funcion(R_cheques_girados_1, Nombre_cheques_girados_1, 9)} else {print("No esta disponible 1")}
if (exists("R_cheques_girados_2")){R_Cheques_Girados_funcion(R_cheques_girados_2, Nombre_cheques_girados_2, 10)} else {print("No esta disponible 2")}
if (exists("R_cheques_girados_3")){R_Cheques_Girados_funcion(R_cheques_girados_3, Nombre_cheques_girados_3, 11)} else {print("No esta disponible 3")}
if (exists("R_cheques_girados_4")){R_Cheques_Girados_funcion(R_cheques_girados_4, Nombre_cheques_girados_4, 12)} else {print("No esta disponible 4")}
if (exists("R_cheques_girados_5")){R_Cheques_Girados_funcion(R_cheques_girados_5, Nombre_cheques_girados_5, 13)} else {print("No esta disponible 5")}
if (exists("R_cheques_girados_6")){R_Cheques_Girados_funcion(R_cheques_girados_6, Nombre_cheques_girados_6, 15)} else {print("No esta disponible 6")}

#Pago de intereses
R_Pago_Intereses_funcion = function (data, nombre_data, fila1){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,6] <<- data[1,4]
    comprobante_1[fila1,7] <<- data[1,5]
    
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}
if (exists("C5102050028_1")){R_Pago_Intereses_funcion(C5102050028_1, Nombre_Damas_1, 65)} else {print("No esta disponible 1")}
if (exists("C5102050028_2")){R_Pago_Intereses_funcion(C5102050028_2, Nombre_Damas_2, 66)} else {print("No esta disponible 2")}
if (exists("C5102050028_3")){R_Pago_Intereses_funcion(C5102050028_3, Nombre_Damas_3, 67)} else {print("No esta disponible 3")}
if (exists("C5102050028_4")){R_Pago_Intereses_funcion(C5102050028_4, Nombre_Damas_4, 68)} else {print("No esta disponible 4")}
if (exists("C5102050028_5")){R_Pago_Intereses_funcion(C5102050028_5, Nombre_Damas_5, 69)} else {print("No esta disponible 5")}
if (exists("C5102050028_6")){R_Pago_Intereses_funcion(C5102050028_6, Nombre_Damas_6, 71)} else {print("No esta disponible 6")}

if (exists("C5102050010_1")){R_Pago_Intereses_funcion(C5102050010_1, Nombre_Fijo_Diario_1, 73)} else {print("No esta disponible 1")}
if (exists("C5102050010_2")){R_Pago_Intereses_funcion(C5102050010_2, Nombre_Fijo_Diario_2, 74)} else {print("No esta disponible 2")}
if (exists("C5102050010_3")){R_Pago_Intereses_funcion(C5102050010_3, Nombre_Fijo_Diario_3, 75)} else {print("No esta disponible 3")}
if (exists("C5102050010_4")){R_Pago_Intereses_funcion(C5102050010_4, Nombre_Fijo_Diario_4, 76)} else {print("No esta disponible 4")}
if (exists("C5102050010_5")){R_Pago_Intereses_funcion(C5102050010_5, Nombre_Fijo_Diario_5, 77)} else {print("No esta disponible 5")}
if (exists("C5102050010_6")){R_Pago_Intereses_funcion(C5102050010_6, Nombre_Fijo_Diario_6, 79)} else {print("No esta disponible 6")}

if (exists("C5102950011_1")){R_Pago_Intereses_funcion(C5102950011_1, Nombre_Cuenta_Corriente_1, 81)} else {print("No esta disponible 1")}
if (exists("C5102950011_2")){R_Pago_Intereses_funcion(C5102950011_2, Nombre_Cuenta_Corriente_2, 82)} else {print("No esta disponible 2")}
if (exists("C5102950011_3")){R_Pago_Intereses_funcion(C5102950011_3, Nombre_Cuenta_Corriente_3, 83)} else {print("No esta disponible 3")}
if (exists("C5102950011_4")){R_Pago_Intereses_funcion(C5102950011_4, Nombre_Cuenta_Corriente_4, 84)} else {print("No esta disponible 4")}
if (exists("C5102950011_5")){R_Pago_Intereses_funcion(C5102950011_5, Nombre_Cuenta_Corriente_5, 85)} else {print("No esta disponible 5")}
if (exists("C5102950011_6")){R_Pago_Intereses_funcion(C5102950011_6, Nombre_Cuenta_Corriente_6, 87)} else {print("No esta disponible 6")}

#Pago de intereses
R_Contribucion_Asumida_funcion = function (data, nombre_data, fila1){ 
  if (exists(nombre_data)) {
    comprobante_1[fila1,8] <<- data
    
  } else {
    print(paste("Aún no esta disponible", nombre_data))
  }}

if (exists("Contribucion_Asumida_1")){R_Contribucion_Asumida_funcion(Contribucion_Asumida_1, Nombre_Contribucion_Asumida_1, 1)} else {print("No esta disponible 1")}
if (exists("Contribucion_Asumida_2")){R_Contribucion_Asumida_funcion(Contribucion_Asumida_2, Nombre_Contribucion_Asumida_2, 2)} else {print("No esta disponible 2")}
if (exists("Contribucion_Asumida_3")){R_Contribucion_Asumida_funcion(Contribucion_Asumida_3, Nombre_Contribucion_Asumida_3, 3)} else {print("No esta disponible 3")}
if (exists("Contribucion_Asumida_4")){R_Contribucion_Asumida_funcion(Contribucion_Asumida_4, Nombre_Contribucion_Asumida_4, 4)} else {print("No esta disponible 4")}
if (exists("Contribucion_Asumida_5")){R_Contribucion_Asumida_funcion(Contribucion_Asumida_5, Nombre_Contribucion_Asumida_5, 5)} else {print("No esta disponible 5")}
if (exists("Contribucion_Asumida_6")){R_Contribucion_Asumida_funcion(Contribucion_Asumida_6, Nombre_Contribucion_Asumida_6, 7)} else {print("No esta disponible 6")}


#Hacemos que todo lo que este nulo se convierta en cero 
comprobante_1 <- comprobante_1 %>% 
  mutate(across(c(6:9), ~ as.numeric(.)),
         across(c(6:9), ~ ifelse(is.na(.), 0, .)),
         TOT_CONTRIB = CALCULO_CONTR - CONTR_ASUMIDA)

#Hacemos el calculo de los controles
control = function(fila) {
  comprobante_1[fila,6] <<- sum(comprobante_1[c((fila - 5): (fila-1)),6])
  comprobante_1[fila,7] <<- sum(comprobante_1[c((fila - 5): (fila-1)),7])
  comprobante_1[fila,8] <<- sum(comprobante_1[c((fila - 5): (fila-1)),8])
  comprobante_1[fila,9] <<- sum(comprobante_1[c((fila - 5): (fila-1)),9])
  comprobante_1[(fila + 2),c(6:9)] <<- comprobante_1[fila, c(6:9)] - comprobante_1[(fila + 1),c(6:9) ] 
  }

control(6)
control(14)
control(22)
control(30)
control(38)
control(46)
control(54)
control(62)
control(70)
control(78)
control(86)
control(94)
control(102)
control(110)


#================================= Exportacion ============
#Eliminar los insumos de la corrida pasada
unlink(local_directory, recursive = TRUE)

#Creamos el libro
wb = createWorkbook()

#Creamos las hojas
addWorksheet(wb, "Comprobante")

#Comprobante Mary
writeData(wb, sheet = "Comprobante", x = "CONTRIBUCIÓN GRAVAMEN A LOS MOVIMIENTOS FINANCIEROS PAGADA POR EL BANCO", startCol = 1, startRow = 1)
writeData(wb, sheet = "Comprobante", x = fecha_completa, startCol = 1, startRow = 2)
writeData(wb, sheet = "Comprobante", x = comprobante_1, startCol = 1, startRow = 3)

#Guardamos el libro
saveWorkbook(wb, 'Salidas.xlsx', overwrite = TRUE)

#Enviamos a la carpeta drive 
drive_upload("USER/Salidas.xlsx", path = as_id(folder_id), name = "Salidas.xlsx", overwrite = TRUE)


#CONTROLES
#Cheques girados
wb = createWorkbook()
addWorksheet(wb, "Control_CH_1")
addWorksheet(wb, "Control_CH_2")
addWorksheet(wb, "Control_CH_3")
addWorksheet(wb, "Control_CH_4")
addWorksheet(wb, "Control_CH_5")
addWorksheet(wb, "Control_CH_Completo")

tryCatch({writeData(wb, sheet = "Control_CH_1", x = R_cheques_girados_1, startCol = 1, startRow = 1) 
  writeData(wb, sheet = "Control_CH_1", x = cheques_girados_1, startCol = 1, startRow = 7)},error = function(e){ 
    mensaje = paste('El archivo', "1", 'no esta disponible')
    cat(mensaje, "\n")})

tryCatch({writeData(wb, sheet = "Control_CH_2", x = R_cheques_girados_2, startCol = 1, startRow = 1) 
   writeData(wb, sheet = "Control_CH_2", x = cheques_girados_2, startCol = 1, startRow = 7)},error = function(e){ 
      mensaje = paste('El archivo', "2", 'no esta disponible')
      cat(mensaje, "\n")})

tryCatch({writeData(wb, sheet = "Control_CH_3", x = R_cheques_girados_3, startCol = 1, startRow = 1) 
  writeData(wb, sheet = "Control_CH_3", x = cheques_girados_3, startCol = 1, startRow = 7)},error = function(e){ 
    mensaje = paste('El archivo', "3", 'no esta disponible')
    cat(mensaje, "\n")})

tryCatch({writeData(wb, sheet = "Control_CH_4", x = R_cheques_girados_2, startCol = 1, startRow = 1) 
  writeData(wb, sheet = "Control_CH_4", x = cheques_girados_2, startCol = 1, startRow = 7)},error = function(e){ 
    mensaje = paste('El archivo', "4", 'no esta disponible')
    cat(mensaje, "\n")})

tryCatch({writeData(wb, sheet = "Control_CH_5", x = R_cheques_girados_2, startCol = 1, startRow = 1) 
  writeData(wb, sheet = "Control_CH_5", x = cheques_girados_2, startCol = 1, startRow = 7)},error = function(e){ 
    mensaje = paste('El archivo', "5", 'no esta disponible')
    cat(mensaje, "\n")})

tryCatch({writeData(wb, sheet = "Control_CH_6", x = R_cheques_girados_2, startCol = 1, startRow = 1) 
  writeData(wb, sheet = "Control_CH_6", x = cheques_girados_2, startCol = 1, startRow = 7)},error = function(e){ 
    mensaje = paste('El archivo', "6", 'no esta disponible')
    cat(mensaje, "\n")})

saveWorkbook(wb, 'Control_Cheques_Girados.xlsx', overwrite = TRUE)

drive_upload("USER/Control_Cheques_Girados.xlsx", path = as_id(folder_id), name = "Control_Cheques_Girados.xlsx", overwrite = TRUE)


#Cheques 
wb = createWorkbook()
addWorksheet(wb, "Control_Cheques_1")
addWorksheet(wb, "Enviar_a_Oficinas_1")
addWorksheet(wb, "Control_Cheques_2")
addWorksheet(wb, "Enviar_a_Oficinas_2")
addWorksheet(wb, "Control_Cheques_3")
addWorksheet(wb, "Enviar_a_Oficinas_3")
addWorksheet(wb, "Control_Cheques_4")
addWorksheet(wb, "Enviar_a_Oficinas_4")
addWorksheet(wb, "Control_Cheques_5")
addWorksheet(wb, "Enviar_a_Oficinas_5")
addWorksheet(wb, "Control_Cheques_Completo")
addWorksheet(wb, "Enviar_a_Oficinas_Completo")


tryCatch({writeData(wb, sheet = "Control_Cheques_1", x = Cheques_1, startCol = 1, startRow = 1) },error = function(e){ 
    mensaje = paste('El archivo', "1", 'no esta disponible')
    cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Enviar_a_Oficinas_1", x = Cheques_Oficina_1, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "1", 'no esta disponible')
  cat(mensaje, "\n")})


tryCatch({writeData(wb, sheet = "Control_Cheques_2", x = Cheques_2, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "2", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Enviar_a_Oficinas_2", x = Cheques_Oficina_2, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "2", 'no esta disponible')
  cat(mensaje, "\n")})


tryCatch({writeData(wb, sheet = "Control_Cheques_3", x = Cheques_3, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "3", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Enviar_a_Oficinas_3", x = Cheques_Oficina_3, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "3", 'no esta disponible')
  cat(mensaje, "\n")})


tryCatch({writeData(wb, sheet = "Control_Cheques_4", x = Cheques_4, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "4", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Enviar_a_Oficinas_4", x = Cheques_Oficina_4, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "4", 'no esta disponible')
  cat(mensaje, "\n")})


tryCatch({writeData(wb, sheet = "Control_Cheques_5", x = Cheques_5, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "5", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Enviar_a_Oficinas_5", x = Cheques_Oficina_5, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "5", 'no esta disponible')
  cat(mensaje, "\n")})

tryCatch({writeData(wb, sheet = "Control_Cheques_Completo", x = Cheques_6, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "6", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Enviar_a_Oficinas_Completo", x = Cheques_Oficina_6, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "6", 'no esta disponible')
  cat(mensaje, "\n")})

saveWorkbook(wb, 'Control_Cheques.xlsx', overwrite = TRUE)
drive_upload("USER/Control_Cheques.xlsx", path = as_id(folder_id), name = "Control_Cheques.xlsx", overwrite = TRUE)


#Pagos de intereses
wb = createWorkbook()
addWorksheet(wb, "Control_PIntereses_1")
addWorksheet(wb, "Control_PIntereses_2")
addWorksheet(wb, "Control_PIntereses_3")
addWorksheet(wb, "Control_PIntereses_4")
addWorksheet(wb, "Control_PIntereses_5")
addWorksheet(wb, "Control_PIntereses_Completo")

tryCatch({writeData(wb, sheet = "Control_PIntereses_1", x = Pago_Intereses_1, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "1", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Control_PIntereses_2", x = Pago_Intereses_2, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "2", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Control_PIntereses_3", x = Pago_Intereses_3, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "3", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Control_PIntereses_4", x = Pago_Intereses_4, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "4", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Control_PIntereses_5", x = Pago_Intereses_5, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "5", 'no esta disponible')
  cat(mensaje, "\n")})
tryCatch({writeData(wb, sheet = "Control_PIntereses_Completo", x = Pago_Intereses_6, startCol = 1, startRow = 1) },error = function(e){ 
  mensaje = paste('El archivo', "6", 'no esta disponible')
  cat(mensaje, "\n")})

saveWorkbook(wb, 'Control_PIntereses.xlsx', overwrite = TRUE)
drive_upload("USER/Control_PIntereses.xlsx", path = as_id(folder_id), name = "Control_PIntereses.xlsx", overwrite = TRUE)

