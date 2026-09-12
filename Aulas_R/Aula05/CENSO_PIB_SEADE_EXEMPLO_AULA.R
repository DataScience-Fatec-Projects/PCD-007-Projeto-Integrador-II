#Limpeza
rm(list=ls())

#Definição da pasta
PATH<-"C:/Users/dougl/Desktop/DOUGLAS/2026/2 SEMESTRE/2s2026 CD PROJETO INTEGRADOR II/PI II AULA 004"

#ativar a pasta
setwd(PATH)

#carregar biblioteca usada
library("openxlsx")


#ler as cidades RMS
censo2022<- read.csv ("censo2022_populacao.csv", 
                      header = T,
                      sep =";",
                      dec = ",",
                      encoding = "latin1")

rmjd<-read.xlsx("RM JUNDIAI.xlsx",
                startRow = 1, 
                colNames = T)


#tratamento do arquivo
censo2022
names(censo2022)
str(censo2022)

#verificar com "is" e forçar com "as"
is.numeric(censo2022$censo2000)
1000*as.numeric(censo2022$censo2000)
censo2022$censo2000
censo2022$censo2000<-1000*as.numeric(censo2022$censo2000)
censo2022$censo2010<-1000*as.numeric(censo2022$censo2010)
censo2022$censo2022<-1000*as.numeric(censo2022$censo2022)
str(censo2022)


rmjd
names(rmjd)
str(rmjd)
dim(rmjd)
rmjd$IBGE<-as.integer(rmjd$IBGE)

#recorte censo2022
a<-censo2022[censo2022$cod_ibge==rmjd$IBGE[1],]
a[1,]
b<-censo2022[censo2022$cod_ibge==rmjd$IBGE[2],]
c<-censo2022[censo2022$cod_ibge==rmjd$IBGE[3],]
d<-censo2022[censo2022$cod_ibge==rmjd$IBGE[4],]
e<-censo2022[censo2022$cod_ibge==rmjd$IBGE[5],]
f<-censo2022[censo2022$cod_ibge==rmjd$IBGE[6],]
g<-censo2022[censo2022$cod_ibge==rmjd$IBGE[7],]

censormjd<-rbind(a[1,],b[1,],c[1,],d[1,],e[1,],f[1,],g[1,])

#Analise
censormjd


#gravar o arquivo

write.table(censormjd, 
            file = "testeaula2026.csv",
            sep =";",
            col.names = NA,
            fileEncoding = "UTF-16LE")