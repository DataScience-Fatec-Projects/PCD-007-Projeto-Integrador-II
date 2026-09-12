#Wellington Torres
#Tarefa 004 - Filtrar Região Metropolitanada de São Paulo
# =========================================================================
# SOLUCAO 1 - EM AULA USANDO RBIND
# =========================================================================

#Limpeza
rm(list=ls())

#Definição da pasta
PATH<-"C:/git/fatec/PCD-007-Projeto-Integrador-II/Aulas_R/Aula05/Tareafa004/fonte_de_dados"

#Ativar a pasta
setwd(PATH)

#carregar biblioteca usada
library("openxlsx")


#Ler pib
pib_est_sp<- read.csv ("pib_municipal_2002_2020.csv", 
                      header = T,
                      sep =";",
                      dec = ",",
                      encoding = "latin1")

reg_metro_jd<-read.xlsx("RM JUNDIAI.xlsx",
                startRow = 1, 
                colNames = T)


# Tratar arquivo pib_municipal_2002_2020.csv
pib_est_sp

## Imprimir colunas
names(pib_est_sp)
str(pib_est_sp)

# remove tudo que nao eh numero
Valor_tratado<-gsub("[^0-9,]", "", pib_est_sp$Valor)

# troca virgula do centavos por ponto
Valor_tratado<-gsub(",", ".", Valor_tratado)

# converter para numerico
pib_est_sp$Valor<-as.numeric(Valor_tratado)

# verificar com "is" e forçar com "as"
is.numeric(pib_est_sp$Valor)

str(pib_est_sp)


reg_metro_jd
names(reg_metro_jd)
str(reg_metro_jd)
dim(reg_metro_jd)
reg_metro_jd$IBGE<-as.integer(reg_metro_jd$IBGE)

#recorte pib_est_sp
a<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[1],]
a[1,]
b<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[2],]
c<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[3],]
d<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[4],]
e<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[5],]
f<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[6],]
g<-pib_est_sp[pib_est_sp$Cod_Ibge==reg_metro_jd$IBGE[7],]

# censoreg_metro_jd<-rbind(a[1,],b[1,],c[1,],d[1,],e[1,],f[1,],g[1,])
censoreg_metro_jd<-rbind(a,b,c,d,e,f,g)


#Analise
censoreg_metro_jd


#gravar o arquivo

write.table(censoreg_metro_jd, 
            file = "C:/git/fatec/PCD-007-Projeto-Integrador-II/Aulas_R/Aula05/Tareafa004/resultado_RMJD.csv",
            sep =";",
            col.names = NA,
            fileEncoding = "UTF-16LE")


# =========================================================================
# SOLUCAO 2 - MESMO RECORTE USANDO INNER JOIN (merge)
# -------------------------------------------------------------------------
# A solucao 1 (acima) faz 7 recortes manuais e empilha com rbind.
# Aqui o mesmo resultado sai de uma unica operacao de juncao entre as
# duas tabelas, usando o codigo do IBGE como chave.
# =========================================================================

# INNER JOIN: ficam apenas os municipios que existem NAS DUAS tabelas
#   by.x  = nome da chave na tabela da esquerda  (PIB  -> Cod_Ibge)
#   by.y  = nome da chave na tabela da direita   (RMJD -> IBGE)
#   all   = FALSE -> inner join (padrao do merge)
pib_rmjd<-merge(pib_est_sp,
                reg_metro_jd,
                by.x = "Cod_Ibge",
                by.y = "IBGE",
                all = FALSE)

# Conferencia do join
dim(pib_rmjd)                                 # linhas x colunas do resultado
str(pib_rmjd)
length(unique(pib_rmjd$Cod_Ibge))             # tem que dar 7 municipios
table(pib_rmjd$Localidade)                    # quantas linhas por municipio

# Confere se os 7 codigos da RM de Jundiai vieram todos
setdiff(reg_metro_jd$IBGE, pib_rmjd$Cod_Ibge) # tem que voltar vazio -> integer(0)

# Ordenar por municipio / ano / setor
pib_rmjd<-pib_rmjd[order(pib_rmjd$Localidade,
                         pib_rmjd$Ano,
                         pib_rmjd$Setor),]

#Analise
head(pib_rmjd)

# Comparacao com a solucao 1: a primeira linha de cada municipio
# (o rbind de a[1,]...g[1,]) sai daqui com um unico comando
primeira_linha_rmjd<-pib_rmjd[!duplicated(pib_rmjd$Cod_Ibge),]
primeira_linha_rmjd

#gravar o arquivo da solucao 2 (base completa do recorte)

write.table(pib_rmjd,
            file = "C:/git/fatec/PCD-007-Projeto-Integrador-II/Aulas_R/Aula05/Tareafa004/resultado_RMJD_innerjoin.csv",
            sep =";",
            col.names = NA,
            fileEncoding = "UTF-16LE")
