options(scipen=999) 
install.packages("corrplot")
library(corrplot)
library(readxl)

Datos <- read_excel("C:/Users/bxmayorg/Downloads/Datos.xlsx")
Datos <- read_excel("Datos.xlsx")
Datos = Datos[-1,]


Da1 = Datos[-1,c(3,5,7)]

#nivel de confianza 95%
z = 1.96 

#correlacion
corre = cor(Datos[,-1])
cor1 = cor(Da1)

corrplot(corre)
corrplot(cor1)
corrplot(cor1, method = "number")


#------------------------------------------------------ 
#Datos PIB corriente
media_1 = mean(Datos$`PIB corrientes`)
varianza_1 = var(Datos$`PIB corrientes`)
desviacion_1 = sd (Datos$`PIB corrientes`)
n_1 = length (Datos$`PIB corrientes`)
error_1 = desviacion_1 / sqrt(n_1) 

#intervalos de confianza 
#formula :   x(media) +- (z*error)
#error = sd / raiz (n)   
lim_in_1 = media_1 - (z * error_1)  #40589
lim_sup_1 = media_1 + (z * error_1) #55988

#-----------------------------------------------
#Datos PIB corriente crecimiento 
media_2 = mean(Datos$`Variacion PIB corriente`)   #8%
varianza_2 = var(Datos$`Variacion PIB corriente`)
desviacion_2 = sd (Datos$`Variacion PIB corriente`)
n_2 = length (Datos$`Variacion PIB corriente`)
error_2 = desviacion_2 / sqrt(n_2) 

#intervalos de confianza 
#formula :   x(media) +- (z*error)
#error = sd / raiz (n)   
lim_in_2 = media_2 - (z * error_2)  #3.5%
lim_sup_2 = media_2 + (z * error_2) #13.5%

#----------------------------------------------
#Regresion como dependiente los depositos
#H1: Los depositos aumentan cuando aumenta el crecimiento economico 
#H0: los depositos no aumentan o se mantienten cuando aumenta el crecimiento economico

#pvalor: la probabilidad de aceptar la hipostesis (h1) siendo un error - lo que se busque que el p sea cercano a 0 ? maximo 0.05

regre = lm (Datos$DepositosConsolidados ~ Datos$`PIB corrientes`) 
summary(regre)

#es significativo , el p valor es cercano a 0 --> 0.000002297
#se puede asumir que hay una asociaci?n y que los depositos aumentran en 0.3 balboas cuando aumenta en una unidad el PIB 



regre = lm (Datos$`Variacion DC` ~ Datos$`Variacion PIB corriente`) 
summary(regre)



Datos = Datos[-c(14,15),]
mean(Datos$`Crecimiento Real PIB`)


