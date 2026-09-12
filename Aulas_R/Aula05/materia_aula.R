#Limpeza
rm(list=ls())

#Definição da pasta
PATH<-"C:/git/fatec/PCD-007-Projeto-Integrador-II/Aulas_R/Aula05"

#ativar a pasta
setwd(PATH)

#carregar biblioteca usada
library("openxlsx")


#ler as cidades RMS
censo2022<- read.csv ("censo2022_populacao.csv", 
                      header = T,
                      sep =";",
                      encoding = "latin1")

rmjd<-read.xlsx("RM JUNDIAI.xlsx",
                startRow = 1, 
                colNames = T)


#tratamento do arquivo
censo2022
names(censo2022)
str(censo2022)


rmjd
names(rmjd)
str(rmjd)

#Analise
censormjd<-rmjd


#gravar o arquivo

write.table(censormjd, 
            file = "testeaula1.csv",
            sep =";",
            col.names = NA,
            fileEncoding = "UTF-16LE")


#verificar com "is" e forçar com "as"

is.numeric(censo2022$censo2000)

1000*as.numeric(censo2022$censo2000)

censo2022$censo2000
censo2022$censo2000<-1000*as.numeric(censo2022$censo2000)
censo2022$censo2010<-1000*as.numeric(censo2022$censo2010)
censo2022$censo2022<-1000*as.numeric(censo2022$censo2022)
str(censo2022)



