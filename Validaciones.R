library(dplyr)

#===================================== CONS_OMM ========================================
  #-------------------------------------- DIC -22 -----
#Datos DIC- 2022
REAL <- read.csv("user/Conglomerados_396 y 397/2022/Diciembre/Salidas_Reales_Producción/CONS_OMM_20221231_REAL.csv", sep=";")
SALIDA_DAVIBOX <- read.csv("user/Conglomerados_396 y 397/2022/Diciembre/SALIDAS_SERGIO/CONS_OMM_20221231.csv", sep=";")

#Comparamos que salgan los mismos nombres en columnas
names(REAL) == names(SALIDA_DAVIBOX)

# ---------------------------------------- Data Frame total
#Son iguales = TRUE | son diferentes = FALSE 
prueba1 = identical(REAL, SALIDA_DAVIBOX)

#buscará las filas en df1 que no están presentes en df2 --> si esta vacio estan igual 
prueba2 <- setdiff(REAL, SALIDA_DAVIBOX)

#Me devuelve los datos que no estan igual en los dos data frame  --> Si esta vacio preuba 3 las datas son iguales 
prueba3<- anti_join(REAL, SALIDA_DAVIBOX)


#----------------- SI primeras Pruebas false compareme columna a columna 
num_cols <- ncol(REAL)

if (prueba1 == TRUE){ print("Todo es igual")
  
} else { 
  for(i in 1:num_cols) {
    if(identical(REAL[,i], SALIDA_DAVIBOX[,i])) {
      print(paste0("Columna ", i, " es igual"))
    } else {
      print(paste0("Columna ", i, " es diferente"))
    }
  }
}



  #-------------------------------------- ENE -23 --------
REAL <- read.csv("user/Conglomerados_396 y 397/2023/Enero/Salidas_Reales/CONS_OMM_20230131_REAL.csv", sep=";")
SALIDA_DAVIBOX <- read.csv("user/Conglomerados_396 y 397/2023/Enero/SALIDAS_SERGIO/CONS_OMM_20230131.csv", sep=";")

#Comparamos que salgan los mismos nombres en columnas
names(REAL) == names(SALIDA_DAVIBOX)

# ---------------------------------------- Data Frame total
#Son iguales = TRUE | son diferentes = FALSE 
prueba1 = identical(REAL, SALIDA_DAVIBOX)

#buscará las filas en df1 que no están presentes en df2 --> si esta vacio estan igual 
prueba2 <- setdiff(REAL, SALIDA_DAVIBOX)

#Me devuelve los datos que no estan igual en los dos data frame  --> Si esta vacio preuba 3 las datas son iguales 
prueba3<- anti_join(REAL, SALIDA_DAVIBOX)


#----------------- SI primeras Pruebas false compareme columna a columna 
num_cols <- ncol(REAL)

if (prueba1 == TRUE){ print("Todo es igual")
  
} else { 
  for(i in 1:num_cols) {
    if(identical(REAL[,i], SALIDA_DAVIBOX[,i])) {
      print(paste0("Columna ", i, " es igual"))
    } else {
      print(paste0("Columna ", i, " es diferente"))
    }
  }
}







#===================================== CONS_INTERBANCARIA ========================================
  #-------------------------------------- DIC -22 --------------------------------------
REAL <- read.csv("user/Conglomerados_396 y 397/2022/Diciembre/Salidas_Reales_Producción/CONS_INTERBANCARIA_20221231_REAL.csv", sep=";")
SALIDA_DAVIBOX <- read.csv("user/Conglomerados_396 y 397/2022/Diciembre/SALIDAS_SERGIO/CONS_INTERBANCARIA_20221231.csv", sep=";")


#Comparamos que salgan los mismos nombres en columnas
names(REAL) == names(SALIDA_DAVIBOX)

# ---------------------------------------- Data Frame total
#Son iguales = TRUE | son diferentes = FALSE 
prueba1 = identical(REAL, SALIDA_DAVIBOX)

#buscará las filas en df1 que no están presentes en df2 --> si esta vacio estan igual 
prueba2 <- setdiff(REAL, SALIDA_DAVIBOX)

#Me devuelve los datos que no estan igual en los dos data frame  --> Si esta vacio preuba 3 las datas son iguales 
prueba3<- anti_join(REAL, SALIDA_DAVIBOX)


#----------------- SI primeras Pruebas false compareme columna a columna 
num_cols <- ncol(REAL)

if (prueba1 == TRUE){ print("Todo es igual")
  
} else { 
  for(i in 1:num_cols) {
    if(identical(REAL[,i], SALIDA_DAVIBOX[,i])) {
      print(paste0("Columna ", i, " es igual"))
    } else {
      print(paste0("Columna ", i, " es diferente"))
    }
  }
}

  #-------------------------------------- ENE -23 --------------------------------------
REAL <- read.csv("user/Conglomerados_396 y 397/2023/Enero/Salidas_Reales/CONS_INTERBANCARIA_20230131_REAL.csv", sep=";")
SALIDA_DAVIBOX <- read.csv("user/Conglomerados_396 y 397/2023/Enero/SALIDAS_SERGIO/CONS_INTERBANCARIA_20230131.csv", sep=";")

#Comparamos que salgan los mismos nombres en columnas
names(REAL) == names(SALIDA_DAVIBOX)

# ---------------------------------------- Data Frame total
#Son iguales = TRUE | son diferentes = FALSE 
prueba1 = identical(REAL, SALIDA_DAVIBOX)

#buscará las filas en df1 que no están presentes en df2 --> si esta vacio estan igual 
prueba2 <- setdiff(REAL, SALIDA_DAVIBOX)

#Me devuelve los datos que no estan igual en los dos data frame  --> Si esta vacio preuba 3 las datas son iguales 
prueba3<- anti_join(REAL, SALIDA_DAVIBOX)


#----------------- SI primeras Pruebas false compareme columna a columna 
num_cols <- ncol(REAL)

if (prueba1 == TRUE){ print("Todo es igual")
  
} else { 
  for(i in 1:num_cols) {
    if(identical(REAL[,i], SALIDA_DAVIBOX[,i])) {
      print(paste0("Columna ", i, " es igual"))
    } else {
      print(paste0("Columna ", i, " es diferente"))
    }
  }
}










#===================================== CONS_INVERSIONES ========================================
  #----------------------------------- DIC - 22 -----------------------------
REAL <- read_delim("user/Conglomerados_396 y 397/2022/Diciembre/Salidas_Reales_Producción/CONS_INVERSIONES_20221231_REAL.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
SALIDA_DAVIBOX <- read_delim("user/Conglomerados_396 y 397/2022/Diciembre/SALIDAS_SERGIO/CONS_INVERSIONES_20221231.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)

#Comparamos que salgan los mismos nombres en columnas
nombreColumnas = names(REAL) == names(SALIDA_DAVIBOX)
table(nombreColumnas)

#quitamos COL PARCIALMENTE del real 
table (REAL$PAIS_REPORTANTE) 
table (SALIDA_DAVIBOX$PAIS_REPORTANTE)

#filtramos por  Costa Rica El Salvador    Honduras      Panama 
REAL = filter(REAL, REAL$PAIS_REPORTANTE == "Costa Rica" | REAL$PAIS_REPORTANTE == "El Salvador" | REAL$PAIS_REPORTANTE == "Honduras" | REAL$PAIS_REPORTANTE == "Panama")

# ---------------------------------------- Data Frame total
#Son iguales = TRUE | son diferentes = FALSE 
prueba1 = identical(REAL, SALIDA_DAVIBOX)

#buscará las filas en df1 que no están presentes en df2 --> si esta vacio estan igual 
prueba2 <- setdiff(REAL, SALIDA_DAVIBOX)

#Me devuelve los datos que no estan igual en los dos data frame  --> Si esta vacio preuba 3 las datas son iguales 
prueba3<- anti_join(REAL, SALIDA_DAVIBOX)


#----------------- SI primeras Pruebas false compareme columna a columna 
num_cols <- ncol(REAL)

if (prueba1 == TRUE){ print("Todo es igual")
  
} else { 
  for(i in 1:num_cols) {
    if(identical(REAL[,i], SALIDA_DAVIBOX[,i])) {
      print(paste0("Columna ", i, " es igual"))
    } else {
      print(paste0("Columna ", i, " es diferente"))
    }
  }
}
