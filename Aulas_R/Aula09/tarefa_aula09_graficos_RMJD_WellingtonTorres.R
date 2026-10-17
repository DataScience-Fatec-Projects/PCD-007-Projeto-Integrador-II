#Wellington Torres
#Tarefa Aula 09 - Criar 5 gráficos da Região Metropolitana de Jundiaí (RMJD)
#Base: estimativa de população por idade e sexo - SEADE (2000 a 2023)
# =========================================================================

#Limpeza
rm(list=ls())

#Pasta da tarefa, relativa a raiz do projeto
#Abrir o RStudio pelo Aulas_R.Rproj: o wd ja nasce em .../Aulas_R
BASE<-"Aula09"
SAIDA<-file.path(BASE, "graficos")
dir.create(SAIDA, showWarnings = FALSE)

#Conferencia dos caminhos (tem que dar TRUE nos dois)
file.exists(file.path(BASE, "estimativa_pop_idade_sexo_esp (2).csv"))
file.exists(file.path(BASE, "RM JUNDIAI (2).xlsx"))

#carregar bibliotecas
library(readr)
library(openxlsx)
library(dplyr)
library(ggplot2)


# =========================================================================
# 1. LEITURA
# =========================================================================

#CSV do SEADE: separador ";" e encoding latin1 (conferido com readr::guess_encoding)
pop_est_sp<-read_csv2(file.path(BASE, "estimativa_pop_idade_sexo_esp (2).csv"),
                      locale = locale(encoding = "latin1"),
                      show_col_types = FALSE)

reg_metro_jd<-read.xlsx(file.path(BASE, "RM JUNDIAI (2).xlsx"),
                        startRow = 1,
                        colNames = T)

str(pop_est_sp)
reg_metro_jd

#IBGE vem como texto no Excel; no CSV cod_ibge é número -> igualar para o join
reg_metro_jd$IBGE<-as.numeric(reg_metro_jd$IBGE)


# =========================================================================
# 2. TRATAMENTO
# -------------------------------------------------------------------------
# Cuidados com esta base:
#  - o fim do arquivo tem 1290 linhas vazias (";;;;;") -> viram NA
#  - cada municipio/ano/sexo tem uma linha idade == "Total" com a soma das
#    faixas; se ficar junto, a populacao sai DOBRADA
#  - de 2000 a 2010 a ultima faixa é "75 e +"; de 2011 em diante ela é
#    aberta em "75 a 79" ... "90 e +"
# =========================================================================

table(is.na(pop_est_sp$ano))      # linhas vazias
table(pop_est_sp$idade)           # repare no "Total" e no "75 e +"

#Recorte RMJD: inner join pelo codigo do IBGE (mesma ideia da Tarefa 004)
pop_rmjd<-pop_est_sp %>%
  filter(!is.na(ano), idade != "Total") %>%
  inner_join(reg_metro_jd, by = c("cod_ibge" = "IBGE"))

#Conferencia: tem que dar 7 municipios e 24 anos
n_distinct(pop_rmjd$cod_ibge)
n_distinct(pop_rmjd$ano)
unique(pop_rmjd$nome_mun)

#Faixas amplas, usadas nos graficos 4 e 5
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


# =========================================================================
# GRAFICO 1 - Barras horizontais: populacao por municipio em 2023
# =========================================================================
pop_mun_2023<-pop_rmjd %>%
  filter(ano == 2023) %>%
  group_by(nome_mun) %>%
  summarise(populacao = sum(populacao))
pop_mun_2023

g1<-ggplot(pop_mun_2023, aes(x = reorder(nome_mun, populacao), y = populacao)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = format(populacao, big.mark = ".", decimal.mark = ",")), hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE),
                     expand = expansion(mult = c(0, 0.15))) +
  theme_minimal() +
  labs(title = "População dos municípios da RM de Jundiaí - 2023",
       x = "Município", y = "População", caption = "Fonte: SEADE")
g1
# Jundiaí concentra cerca de metade dos moradores da região (448 mil de 853 mil).


# =========================================================================
# GRAFICO 2 - Linhas: crescimento de 2000 a 2023 (indice 2000 = 100)
# -------------------------------------------------------------------------
# Jundiaí é muito maior que os outros, entao em valores absolutos as outras
# linhas ficariam "achatadas" no fundo. O indice divide cada ano pelo valor
# de 2000: 150 quer dizer que a populacao cresceu 50% desde 2000.
# =========================================================================
pop_mun_ano<-pop_rmjd %>%
  group_by(nome_mun, ano) %>%
  summarise(populacao = sum(populacao), .groups = "drop") %>%
  group_by(nome_mun) %>%
  mutate(indice = populacao / populacao[ano == 2000] * 100)

pop_mun_ano %>% filter(ano == 2023) %>% arrange(desc(indice))

g2<-ggplot(pop_mun_ano, aes(x = ano, y = indice, color = nome_mun)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "grey50") +
  theme_minimal() +
  labs(title = "Crescimento da população na RM de Jundiaí (2000 = 100)",
       x = "Ano", y = "Índice (2000 = 100)", color = "Município", caption = "Fonte: SEADE")
g2
# Itupeva quase triplicou (278); Jarinu e Louveira mais que dobraram. Jundiaí,
# a maior, cresceu 39%; Várzea e Campo Limpo, menos de 25%.


# =========================================================================
# GRAFICO 3 - Piramide etaria da RMJD em 2023
# -------------------------------------------------------------------------
# Truque da piramide: a populacao dos homens vira NEGATIVA para a barra ir
# para a esquerda; o eixo mostra o valor absoluto (abs) para nao aparecer "-".
# =========================================================================
piramide_2023<-pop_rmjd %>%
  filter(ano == 2023) %>%
  group_by(idade, sexo) %>%
  summarise(populacao = sum(populacao), .groups = "drop") %>%
  mutate(pop_grafico = ifelse(sexo == "Homens", -populacao, populacao))

g3<-ggplot(piramide_2023, aes(x = idade, y = pop_grafico, fill = sexo)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = function(x) format(abs(x), big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
  scale_fill_manual(values = c("Homens" = "steelblue", "Mulheres" = "salmon")) +
  theme_minimal() +
  labs(title = "Pirâmide etária da RM de Jundiaí - 2023",
       x = "Faixa etária", y = "População", fill = "Sexo", caption = "Fonte: SEADE")
g3
# Base estreita e meio largo (30 a 44 anos): menos nascimentos e populacao
# envelhecendo. A partir dos 25 anos ha mais mulheres que homens; com 90+
# elas sao mais que o dobro (2.198 x 1.018).


# =========================================================================
# GRAFICO 4 - Barras empilhadas 100%: composicao por idade em 2023
# =========================================================================
faixas_2023<-pop_rmjd %>%
  filter(ano == 2023) %>%
  group_by(nome_mun, faixa) %>%
  summarise(populacao = sum(populacao), .groups = "drop")

g4<-ggplot(faixas_2023, aes(x = nome_mun, y = populacao, fill = faixa)) +
  geom_col(position = position_fill(reverse = TRUE)) +  # "fill" = cada barra soma 100%; reverse = 0 a 14 primeiro
  coord_flip() +
  scale_y_continuous(labels = function(x) paste0(x * 100, "%")) +
  theme_minimal() +
  labs(title = "Composição etária dos municípios da RM de Jundiaí - 2023",
       x = "Município", y = "Participação na população", fill = "Faixa", caption = "Fonte: SEADE")
g4
# Jundiaí tem a maior fatia de idosos (18,6%) e a menor de criancas (16,8%).
# Itupeva e Louveira, as que mais cresceram, sao as mais jovens (~12% de idosos).


# =========================================================================
# GRAFICO 5 - Barras lado a lado: % de idosos (60+) em 2000 e 2023
# -------------------------------------------------------------------------
# A diferenca de faixas antes de 2011 nao atrapalha aqui: "75 e +" começa
# em 75, entao entra em "60 anos ou mais" do mesmo jeito.
# =========================================================================
idosos<-pop_rmjd %>%
  filter(ano %in% c(2000, 2023)) %>%
  group_by(nome_mun, ano) %>%
  summarise(pct_idosos = sum(populacao[faixa == "60 anos ou mais"]) / sum(populacao) * 100,
            .groups = "drop")
idosos

g5<-ggplot(idosos, aes(x = reorder(nome_mun, pct_idosos), y = pct_idosos, fill = factor(ano))) +
  geom_col(position = "dodge") +
  geom_text(aes(label = round(pct_idosos, 1)), position = position_dodge(width = 0.9),
            hjust = -0.1, size = 3) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  scale_fill_manual(values = c("2000" = "grey70", "2023" = "darkorange")) +
  theme_minimal() +
  labs(title = "Envelhecimento na RM de Jundiaí: % da população com 60 anos ou mais",
       x = "Município", y = "% de idosos", fill = "Ano", caption = "Fonte: SEADE")
g5
# A fatia de idosos subiu em todos os municipios: de 1,7x (Jundiaí, Louveira)
# a 2,8x (Várzea Paulista, de 5,3% para 14,8%).


# =========================================================================
# GRAVAR OS GRAFICOS
# =========================================================================
ggsave(file.path(SAIDA, "g1_populacao_2023.png"), g1, width = 8, height = 5, bg = "white")
ggsave(file.path(SAIDA, "g2_crescimento_2000_2023.png"), g2, width = 8, height = 5, bg = "white")
ggsave(file.path(SAIDA, "g3_piramide_etaria_2023.png"), g3, width = 8, height = 6, bg = "white")
ggsave(file.path(SAIDA, "g4_composicao_etaria_2023.png"), g4, width = 8, height = 5, bg = "white")
ggsave(file.path(SAIDA, "g5_idosos_2000_2023.png"), g5, width = 8, height = 5, bg = "white")
