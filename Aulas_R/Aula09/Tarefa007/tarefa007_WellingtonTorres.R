#Wellington Torres
#Tarefa 007 - Criar 5 gráficos sobre a Região Metropolitana de Jundiaí (RMJD)
#Base: estimativa de população por idade e sexo - SEADE (2000 a 2023)
#Desta vez os formatos vieram trocados: municipios em CSV e populacao em XLSX
# =========================================================================

#Limpeza
rm(list=ls())

#Pasta da tarefa, relativa a raiz do projeto
#Abrir o RStudio pelo Aulas_R.Rproj: o wd ja nasce em .../Aulas_R
BASE<-"Aula09/Tarefa007"
SAIDA<-file.path(BASE, "graficos")
dir.create(SAIDA, showWarnings = FALSE)

#Conferencia dos caminhos (tem que dar TRUE nos dois)
file.exists(file.path(BASE, "estimativa_pop_idade_sexo_esp.xlsx"))
file.exists(file.path(BASE, "RM JUNDIAI.csv"))

#carregar bibliotecas
library(readr)
library(openxlsx)
library(dplyr)
library(ggplot2)


# =========================================================================
# 1. LEITURA
# =========================================================================

#CSV dos municipios: separador ";" e encoding UTF-8 (padrao do readr)
reg_metro_jd<-read_csv2(file.path(BASE, "RM JUNDIAI.csv"),
                        show_col_types = FALSE)

#XLSX do SEADE: arquivo grande (576 mil linhas), demora alguns segundos
pop_est_sp<-read.xlsx(file.path(BASE, "estimativa_pop_idade_sexo_esp.xlsx"),
                      startRow = 1,
                      colNames = T)

str(pop_est_sp)
reg_metro_jd

#Aqui o IBGE ja chega como numero nas duas tabelas, entao o join funciona direto
class(reg_metro_jd$IBGE)
class(pop_est_sp$cod_ibge)


# =========================================================================
# 2. TRATAMENTO
# -------------------------------------------------------------------------
# Cuidados com esta base (os mesmos da tarefa da aula):
#  - cada municipio/ano/sexo tem uma linha idade == "Total" com a soma das
#    faixas; se ficar junto, a populacao sai DOBRADA
#  - de 2000 a 2010 a ultima faixa é "75 e +"; de 2011 em diante ela é
#    aberta em "75 a 79" ... "90 e +"
# No XLSX nao ha as linhas vazias do fim do CSV, mas o filtro nao atrapalha.
# =========================================================================

table(is.na(pop_est_sp$ano))      # linhas vazias (aqui tem que dar so FALSE)
table(pop_est_sp$idade)           # repare no "Total" e no "75 e +"

#Recorte RMJD: inner join pelo codigo do IBGE
#O nome do municipio vem da base do SEADE (no CSV "Várzea Paulista." tem um ponto no fim)
pop_rmjd<-pop_est_sp %>%
  filter(!is.na(ano), idade != "Total") %>%
  inner_join(reg_metro_jd, by = c("cod_ibge" = "IBGE"))

#Conferencia: tem que dar 7 municipios e 24 anos
n_distinct(pop_rmjd$cod_ibge)
n_distinct(pop_rmjd$ano)
unique(pop_rmjd$nome_mun)

#Faixas amplas, usadas nos graficos 3 e 4
#O primeiro numero da faixa ("60 a 64" -> 60) diz a idade inicial
pop_rmjd<-pop_rmjd %>%
  mutate(idade_ini = as.numeric(substr(idade, 1, 2)),
         faixa = case_when(idade_ini < 15 ~ "0 a 14 anos",
                           idade_ini < 60 ~ "15 a 59 anos",
                           TRUE           ~ "60 anos ou mais"))

#Conferencia: soma da RMJD em 2023 bate com a soma das linhas "Total"?
pop_rmjd %>% filter(ano == 2023) %>% summarise(pop = sum(populacao))
pop_est_sp %>%
  filter(ano == 2023, idade == "Total", cod_ibge %in% reg_metro_jd$IBGE) %>%
  summarise(pop = sum(populacao))

#Populacao de cada municipio em cada ano (usada nos graficos 1, 2 e 3)
pop_mun_ano<-pop_rmjd %>%
  group_by(nome_mun, ano) %>%
  summarise(populacao = sum(populacao), .groups = "drop")


# =========================================================================
# GRAFICO 1 - Area empilhada: populacao total da RMJD de 2000 a 2023
# -------------------------------------------------------------------------
# Cada faixa colorida é um municipio; a altura total é a populacao da regiao.
# reorder() coloca o municipio maior (Jundiaí) embaixo, como base da pilha.
# =========================================================================
pop_mun_ano %>% filter(ano %in% c(2000, 2023)) %>%
  group_by(ano) %>% summarise(pop_rmjd = sum(populacao))

g1<-ggplot(pop_mun_ano, aes(x = ano, y = populacao,
                            fill = reorder(nome_mun, populacao))) +
  geom_area() +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
  theme_minimal() +
  labs(title = "População da RM de Jundiaí por município (2000 a 2023)",
       x = "Ano", y = "População", fill = "Município", caption = "Fonte: SEADE")
g1
# A RMJD passou de 578.901 para 853.296 habitantes (+47%) e a area sobe sem
# nenhuma queda. Jundiaí é a base da pilha, mas sua fatia caiu de 56% para 53%:
# as faixas de cima (Itupeva, Louveira, Jarinu) engrossaram mais rapido.


# =========================================================================
# GRAFICO 2 - Boxplot: taxa de crescimento anual por municipio
# -------------------------------------------------------------------------
# lag() pega o valor do ano anterior; a taxa é quanto a populacao mudou em %
# de um ano para o outro. Cada municipio tem 23 taxas (2001 a 2023) e o
# boxplot mostra a mediana, a variacao e os anos fora do padrao (outliers).
# =========================================================================
taxas<-pop_mun_ano %>%
  arrange(nome_mun, ano) %>%
  group_by(nome_mun) %>%
  mutate(taxa = (populacao / lag(populacao) - 1) * 100) %>%
  filter(!is.na(taxa))

taxas %>% summarise(mediana = median(taxa), min = min(taxa), max = max(taxa)) %>%
  arrange(desc(mediana))

g2<-ggplot(taxas, aes(x = reorder(nome_mun, taxa, FUN = median), y = taxa)) +
  geom_boxplot(fill = "orange") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Crescimento anual da população na RM de Jundiaí (2001 a 2023)",
       x = "Município", y = "Taxa de crescimento anual (%)", caption = "Fonte: SEADE")
g2
# Dois grupos bem separados: Itupeva (mediana de 4,7% ao ano), Jarinu (3,6%) e
# Louveira (3,1%) crescem rapido; os outros ficam abaixo de 1,5%. Jundiaí tem a
# caixa mais estreita (entre 1,1% e 1,7%): cresce pouco, mas de forma estavel.
# Campo Limpo Paulista quase parou: em 2021 e 2022 a taxa ficou negativa.
# Em Itupeva as maiores taxas sao as do inicio (6,8% em 2001): o ritmo esta caindo.


# =========================================================================
# GRAFICO 3 - Dispersao: crescimento 2000-2023 x % de idosos em 2023
# -------------------------------------------------------------------------
# Pergunta: quem mais cresceu ficou mais jovem? Cada ponto é um municipio,
# o tamanho é a populacao de 2023 e a reta (lm) mostra a tendencia.
# =========================================================================
cresc_idosos<-pop_mun_ano %>%
  group_by(nome_mun) %>%
  summarise(crescimento = (populacao[ano == 2023] / populacao[ano == 2000] - 1) * 100,
            pop_2023 = populacao[ano == 2023]) %>%
  inner_join(pop_rmjd %>%
               filter(ano == 2023) %>%
               group_by(nome_mun) %>%
               summarise(pct_idosos = sum(populacao[faixa == "60 anos ou mais"]) / sum(populacao) * 100),
             by = "nome_mun")
cresc_idosos

cor(cresc_idosos$crescimento, cresc_idosos$pct_idosos)

g3<-ggplot(cresc_idosos, aes(x = crescimento, y = pct_idosos)) +
  geom_smooth(method = "lm", se = FALSE, color = "grey60", linetype = "dashed") +
  geom_point(aes(size = pop_2023), color = "steelblue", alpha = 0.7) +
  geom_text(aes(label = nome_mun), vjust = -1.2, size = 3.2) +
  scale_size(labels = function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE),
             range = c(3, 12)) +
  scale_x_continuous(expand = expansion(mult = c(0.15, 0.08))) +   # espaco para os nomes nao cortarem
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.12))) +
  theme_minimal() +
  labs(title = "Quem mais cresceu tem menos idosos? RM de Jundiaí",
       x = "Crescimento da população de 2000 a 2023 (%)", y = "% de idosos (60+) em 2023",
       size = "População 2023", caption = "Fonte: SEADE")
g3
# Sim, em geral: a correlacao é negativa (-0,62). Itupeva (+178%, 12,4% de
# idosos) e Louveira (+122%, 12,6%) ficam embaixo a direita; Jundiaí (+39%,
# 18,6%) fica no alto a esquerda. Quem chega para morar sao familias jovens,
# o que "dilui" os idosos. Mas sao so 7 pontos e ha excecoes: Jarinu cresceu
# 127% e tem 15,2% de idosos; Cabreúva cresceu so 44% e tem poucos (13,4%).


# =========================================================================
# GRAFICO 4 - Linhas: indice de envelhecimento de 2000 a 2023
# -------------------------------------------------------------------------
# Indice de envelhecimento = idosos (60+) para cada 100 criancas (0 a 14).
# Acima de 100 quer dizer que ja ha mais idosos que criancas.
# =========================================================================
envelhec<-pop_rmjd %>%
  group_by(nome_mun, ano) %>%
  summarise(indice = sum(populacao[faixa == "60 anos ou mais"]) /
              sum(populacao[faixa == "0 a 14 anos"]) * 100,
            .groups = "drop")

envelhec %>% filter(ano %in% c(2000, 2023)) %>% arrange(nome_mun, ano)

g4<-ggplot(envelhec, aes(x = ano, y = indice, color = nome_mun)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.2) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "grey50") +
  theme_minimal() +
  labs(title = "Índice de envelhecimento na RM de Jundiaí (2000 a 2023)",
       subtitle = "Idosos (60+) para cada 100 crianças (0 a 14 anos)",
       x = "Ano", y = "Idosos por 100 crianças", color = "Município", caption = "Fonte: SEADE")
g4
# Todas as linhas sobem e cada vez mais inclinadas. Jundiaí foi de 46 para 111
# idosos por 100 criancas e passou da linha de 100 em 2021: hoje ja tem mais
# idosos que criancas. Várzea Paulista teve a maior mudanca (18 -> 77, mais de
# 4 vezes) e Campo Limpo chegou a 88. Itupeva, a mais jovem, esta em 60.


# =========================================================================
# GRAFICO 5 - Paineis (facet_wrap): estrutura etaria em 2000 e 2023
# -------------------------------------------------------------------------
# Um painel por municipio, com a % da populacao em cada faixa de idade.
# Para comparar 2000 com 2023, as faixas de 75+ de 2023 ("75 a 79" ...
# "90 e +") sao juntadas em "75 e +", igual a 2000.
# Usar % (e nao populacao) deixa municipios de tamanhos diferentes comparaveis.
# =========================================================================
estrutura<-pop_rmjd %>%
  filter(ano %in% c(2000, 2023)) %>%
  mutate(idade = ifelse(idade_ini >= 75, "75 e +", idade)) %>%
  group_by(nome_mun, ano, idade) %>%
  summarise(populacao = sum(populacao), .groups = "drop") %>%
  group_by(nome_mun, ano) %>%
  mutate(pct = populacao / sum(populacao) * 100)

#Conferencia: 16 faixas por municipio/ano e cada um soma 100%
estrutura %>% summarise(faixas = n(), total = sum(pct), .groups = "drop")

g5<-ggplot(estrutura, aes(x = idade, y = pct, fill = factor(ano))) +
  geom_col(position = "dodge") +
  coord_flip() +
  facet_wrap(~nome_mun, ncol = 4) +
  scale_fill_manual(values = c("2000" = "grey70", "2023" = "darkorange")) +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 6)) +
  labs(title = "Estrutura etária dos municípios da RM de Jundiaí: 2000 x 2023",
       x = "Faixa etária", y = "% da população", fill = "Ano", caption = "Fonte: SEADE")
g5
# O mesmo padrao nos 7 paineis: em 2000 (cinza) as barras maiores sao as dos
# jovens (0 a 24 anos); em 2023 (laranja) as maiores sao de 35 a 44 anos e
# todas as faixas a partir dos 45 cresceram. A faixa de 0 a 4 anos encolheu
# em todos (Várzea Paulista: de 9,7% para 6,0%; Jundiaí: de 7,3% para 5,3%).
# É a "piramide" deixando de ter base larga: menos nascimentos e vida mais longa.


# =========================================================================
# GRAVAR OS GRAFICOS
# =========================================================================
ggsave(file.path(SAIDA, "g1_area_populacao_2000_2023.png"), g1, width = 8, height = 5, bg = "white")
ggsave(file.path(SAIDA, "g2_boxplot_crescimento_anual.png"), g2, width = 8, height = 5, bg = "white")
ggsave(file.path(SAIDA, "g3_crescimento_x_idosos.png"), g3, width = 8, height = 5.5, bg = "white")
ggsave(file.path(SAIDA, "g4_indice_envelhecimento.png"), g4, width = 8, height = 5, bg = "white")
ggsave(file.path(SAIDA, "g5_estrutura_etaria_2000_2023.png"), g5, width = 10, height = 7, bg = "white")
