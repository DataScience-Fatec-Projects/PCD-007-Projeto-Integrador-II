#Wellington Torres
#Tarefa 005 - Exercícios de dplyr com a estimativa de população do SEADE
# =========================================================================

#Limpeza
rm(list=ls())

#Pasta da tarefa, relativa a raiz do projeto
#Abrir o RStudio pelo Aulas_R.Rproj: o wd ja nasce em .../Aulas_R
BASE<-"Aula06/Tarefa005"

#Conferencia do caminho (tem que dar TRUE)
file.exists(file.path(BASE, "estimativa_pop_idade_sexo_esp.csv"))

# Carregar os pacotes necessários
library(dplyr)
library(readr)


# Lê os dados populacionais (com separador ; e encoding LATIN1 por causa dos acentos)
dados001 <- read_csv2(file.path(BASE, "estimativa_pop_idade_sexo_esp.csv"),
                      locale = locale(encoding = "LATIN1"),
                      show_col_types = FALSE)

str(dados001)


# ------------------------------------------------------------
# 0. Preparação: limpar a base antes dos exercícios
# ------------------------------------------------------------
# Cuidados com esta base:
#  - o fim do arquivo tem 1290 linhas vazias (";;;;;") -> viram NA
#  - cada municipio/ano/sexo tem uma linha idade == "Total" com a soma das
#    faixas; se ficar junto, qualquer soma de populacao sai DOBRADA
table(is.na(dados001$ano))
table(dados001$idade)

pop <- dados001 %>%
  filter(!is.na(ano), idade != "Total")

dim(dados001)   # 577920 linhas
dim(pop)        # 545670 linhas


# ------------------------------------------------------------
# 1. Filtrar por município: Jundiaí
pop_jundiai <- pop %>%
  filter(nome_mun == "Jundiaí")

pop_jundiai
nrow(pop_jundiai)        # 24 anos x 2 sexos x 16 ou 19 faixas = 846 linhas


# ------------------------------------------------------------
# 2. Selecionar colunas: nome_mun, sexo, populacao
pop %>%
  select(nome_mun, sexo, populacao)


# ------------------------------------------------------------
# 3. Filtrar por ano e sexo: 2023 e Mulheres
mulheres_2023 <- pop %>%
  filter(ano == 2023, sexo == "Mulheres")

mulheres_2023
sum(mulheres_2023$populacao)   # total de mulheres no estado em 2023


# ------------------------------------------------------------
# 4. Criar nova coluna: população em milhares
pop %>%
  mutate(pop_milhares = populacao / 1000)


# ------------------------------------------------------------
# 5. Ordenar por população: top 10

# 5a. Literal: os 10 registros (linhas) com maior população
#     -> todos são de São Paulo, que é muito maior que os outros municípios
pop %>%
  arrange(desc(populacao)) %>%
  head(10)

# 5b. Mais útil: os 10 municípios mais populosos em 2023
top10_2023 <- pop %>%
  filter(ano == 2023) %>%
  group_by(nome_mun) %>%
  summarise(populacao = sum(populacao)) %>%
  arrange(desc(populacao)) %>%
  head(10)

top10_2023


# ------------------------------------------------------------
# 6. Agrupar por município e somar população (2023)
pop_mun_2023 <- pop %>%
  filter(ano == 2023) %>%
  group_by(nome_mun) %>%
  summarise(populacao = sum(populacao))

pop_mun_2023
nrow(pop_mun_2023)              # 645 municípios
sum(pop_mun_2023$populacao)     # população do estado em 2023

# Conferencia: a soma tem que bater com as linhas "Total" que tiramos no passo 0
dados001 %>%
  filter(ano == 2023, idade == "Total") %>%
  summarise(populacao = sum(populacao))


# ------------------------------------------------------------
# 7. Média de população por faixa etária (2023)
# Cada linha é um município + sexo, então a média é "população média de
# uma faixa num município, para um sexo"
media_faixa_2023 <- pop %>%
  filter(ano == 2023) %>%
  group_by(idade) %>%
  summarise(media_pop = mean(populacao))

media_faixa_2023


# ------------------------------------------------------------
# 8. Contagem de registros por sexo
pop %>%
  group_by(sexo) %>%
  summarise(qtd = n())

# Mesmo resultado, atalho do dplyr
pop %>%
  count(sexo)


# ------------------------------------------------------------
# 9. Filtrar registros com população acima de 5000
acima_5000 <- pop %>%
  filter(populacao > 5000)

acima_5000
nrow(acima_5000)


# ------------------------------------------------------------
# 10. Renomear coluna nome_mun para municipio
pop %>%
  rename(municipio = nome_mun)
