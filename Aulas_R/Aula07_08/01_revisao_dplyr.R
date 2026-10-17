# AULAS 07 e 08 - Parte 1: revisão do dplyr
# Base: mtcars (já vem com o R)
# ------------------------------------------------------------
# Funções principais do dplyr:
# - filter(): filtrar linhas
# - select(): selecionar colunas
# - mutate(): criar novas colunas
# - arrange(): ordenar linhas
# - summarise(): resumir dados
# - group_by(): agrupar dados
# - %>% : encadeia operações (pipe)
# ------------------------------------------------------------

library(dplyr)

# Visualizando as primeiras linhas do dataset mtcars
head(mtcars)

# 1. Selecionar colunas
mtcars %>%
  select(mpg, cyl)

# 2. Filtrar linhas
mtcars %>%
  filter(cyl > 6)

mtcars %>%
  filter(mpg > 20, cyl == 4)   # vírgula dentro do filter() = E lógico (&)

# 3. Criar novas colunas com mutate
mtcars %>%
  mutate(km_litro = mpg * 0.4251)   # 1 milha/galão = 0,4251 km/litro

# 4. Ordenar linhas com arrange
mtcars %>%
  arrange(mpg)        # ordem crescente

mtcars %>%
  arrange(desc(mpg))  # ordem decrescente

# 5. Resumo simples com summarise
mtcars %>%
  summarise(media_mpg = mean(mpg))

# 6. Agrupar e resumir
mtcars %>%
  group_by(cyl) %>%
  summarise(media_mpg = mean(mpg))

mtcars %>%
  group_by(am) %>%
  summarise(qtd = n())

mtcars %>%
  group_by(am) %>%
  summarise(media = mean(wt))

# Funções úteis dentro do summarise():
# Centro:    mean(), median()
# Dispersão: sd(), IQR(), mad()
# Extremos:  min(), max()
# Posição:   first(), last(), nth()
# Contagem:  n(), n_distinct()
# Lógicas:   any(), all()

# 7. Encadeando múltiplas operações
mtcars %>%
  filter(mpg > 20) %>%
  mutate(km_litro = mpg * 0.4251) %>%
  group_by(cyl) %>%
  summarise(media_km_l = mean(km_litro))

# 8. Renomear colunas (novo_nome = nome_antigo)
mtcars %>%
  rename(milhas_por_galao = mpg)
