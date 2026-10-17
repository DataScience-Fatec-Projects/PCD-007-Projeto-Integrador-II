# AULAS 07 e 08 - Parte 4: respostas dos exercícios de ggplot2
# Respostas do professor (resumo.txt), com correções marcadas como "CORRIGIDO"
# e interpretações conferidas com os números reais das bases.
# ------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(ISLR)

# ------------------- RESPOSTA DO EXERCÍCIO 1 -------------------
ggplot(ISLR::Auto, aes(x = horsepower, y = mpg)) +
  geom_point() +
  labs(title = "Potência e consumo", x = "Potência", y = "Milhas por galão")
# Tendência negativa: mais potência -> menos milhas por galão (correlação = -0,78).

# ------------------- RESPOSTA DO EXERCÍCIO 2 -------------------
ggplot(ISLR::Auto, aes(x = weight, y = mpg, color = factor(origin))) +
  geom_point() +
  labs(title = "Peso e consumo por origem", color = "Origem") +
  theme(plot.title = element_text(hjust = 0, size = 11, face = "bold", color = "darkblue"))
# Mais pesado -> menor mpg em todas as origens. Os carros americanos (1) ficam
# concentrados na região pesada e de baixo mpg; europeus (2) e japoneses (3) são leves e econômicos.

# ------------------- RESPOSTA DO EXERCÍCIO 3 -------------------
ggplot(ISLR::Auto, aes(x = weight, y = mpg, size = horsepower)) +
  geom_point(alpha = 0.6) +
  labs(title = "Peso, consumo e potência", size = "Potência")
# Pontos maiores (mais potência) aparecem no canto pesado e de baixo mpg:
# peso, potência e consumo andam juntos.

# ------------------- RESPOSTA DO EXERCÍCIO 4 -------------------
ggplot(ISLR::Carseats, aes(x = Urban)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Lojas por localização", x = "Urbana", y = "Quantidade")
# Há mais lojas urbanas: 282 (Yes) contra 118 (No).

# ------------------- RESPOSTA DO EXERCÍCIO 5 -------------------
# Opção 1: R base
medias_vendas <- aggregate(Sales ~ ShelveLoc, data = ISLR::Carseats, FUN = mean)

# Opção 2: dplyr (mesmo resultado)
medias_vendas1 <- ISLR::Carseats %>%
  group_by(ShelveLoc) %>%
  summarise(Sales = mean(Sales))
medias_vendas1

ggplot(medias_vendas1, aes(x = reorder(ShelveLoc, Sales), y = Sales)) +
  geom_col(fill = "lightblue") +          # geom_col = geom_bar(stat = "identity")
  coord_flip() +
  labs(title = "Média de vendas por prateleira", x = "Qualidade", y = "Vendas médias")

# Mesma coisa com ordem invertida
ggplot(medias_vendas1, aes(x = reorder(ShelveLoc, Sales, decreasing = TRUE), y = Sales)) +
  geom_col(fill = "lightblue") +
  coord_flip() +
  labs(title = "Média de vendas por prateleira", x = "Qualidade", y = "Vendas médias")
# Good tem a maior média (10,2), depois Medium (7,3) e Bad (5,5).

# ------------------- RESPOSTA DO EXERCÍCIO 6 -------------------
ggplot(ISLR::Carseats, aes(x = Urban, fill = ShelveLoc)) +
  geom_bar(position = "dodge") +
  labs(title = "Lojas por localização e prateleira",   # CORRIGIDO: título dizia "país"
       x = "Urbana", y = "Quantidade")
# Nas duas localizações Medium é a categoria mais comum (68 e 151).
# Nas urbanas Bad (74) supera Good (57); nas não urbanas Good (28) supera Bad (22).

# ------------------- RESPOSTA DO EXERCÍCIO 7 -------------------
ggplot(ISLR::Carseats, aes(x = Urban, fill = ShelveLoc)) +
  geom_bar(position = "stack") +
  labs(title = "Lojas por localização e prateleira (empilhado)", x = "Urbana", y = "Quantidade")
# Lado a lado (dodge) facilita comparar os grupos entre si;
# empilhado (stack) evidencia o total de cada barra (118 vs 282).

# ------------------- RESPOSTA DO EXERCÍCIO 8 -------------------
ggplot(ISLR::Wage, aes(x = wage)) +
  geom_histogram(binwidth = 20, fill = "salmon", color = "black") +
  labs(title = "Distribuição dos salários", x = "Salário", y = "Frequência")
# Experimente binwidth = 10 e 30.
# Assimétrica à direita: média (111,7) maior que a mediana (104,9), com uma
# cauda/grupo separado de salários altos perto de 280-320.

# ------------------- RESPOSTA DO EXERCÍCIO 9 -------------------
ggplot(ISLR::Wage, aes(x = education, y = wage)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Salários por escolaridade", x = "Escolaridade", y = "Salário") +
  coord_flip()
# A mediana cresce com a escolaridade: de 81,3 (< HS Grad) até 141,8 (Advanced Degree).
# Há valores atípicos (pontos isolados) de salários altos em todos os grupos.

# ------------------- RESPOSTA DO EXERCÍCIO 10 -------------------
ggplot(ISLR::Wage, aes(x = education, y = wage)) +
  geom_violin(fill = "lightgreen") +
  labs(title = "Distribuição salarial por escolaridade", x = "Escolaridade", y = "Salário") +
  coord_flip()
# O violino mostra o formato: onde os salários se concentram e o "segundo morro"
# de salários altos, que o boxplot reduz a pontos atípicos.

# ------------------- RESPOSTA DO EXERCÍCIO 11 -------------------
ggplot(ISLR::Smarket, aes(x = Today, fill = Direction)) +
  geom_density(alpha = 0.5) +
  labs(title = "Retornos por direção do mercado", x = "Retorno diário")
# Down fica toda nos retornos negativos e Up nos positivos - por definição,
# já que Direction é calculada a partir do sinal de Today.

# ------------------- RESPOSTA DO EXERCÍCIO 12 -------------------
volume_anual <- aggregate(Volume ~ Year, data = ISLR::Smarket, FUN = mean)

volume_anual_1 <- ISLR::Smarket %>%
  group_by(Year) %>%
  summarise(Volume = mean(Volume))
volume_anual_1

ggplot(volume_anual_1, aes(x = Year, y = Volume)) +
  geom_line(color = "purple") +
  geom_point() +
  labs(title = "Volume médio anual", x = "Ano", y = "Volume médio")
# Tendência geral de aumento (1,23 em 2001 -> 1,92 em 2005),
# com leve queda em 2003 e salto forte em 2005.

# ------------------- RESPOSTA DO EXERCÍCIO 13 -------------------
ggplot(volume_anual_1, aes(x = Year, y = Volume)) +
  geom_area(fill = "skyblue") +
  labs(title = "Volume médio anual (área)", x = "Ano", y = "Volume médio")
# A área enfatiza a magnitude (o "tamanho" do volume desde o zero);
# a linha destaca as variações de um ano para o outro.

# ------------------- RESPOSTA DO EXERCÍCIO 14 -------------------
ggplot(ISLR::Auto, aes(x = horsepower, y = mpg)) +
  geom_point() +
  geom_smooth(method = "loess", color = "red") +
  labs(title = "Tendência de consumo por potência")
# Relação negativa, mas curva: o mpg cai rápido até ~150 HP e depois se achata.

# ------------------- RESPOSTA DO EXERCÍCIO 15 -------------------
ggplot(ISLR::Auto, aes(x = horsepower, y = mpg)) +
  geom_point() +
  facet_wrap(~origin) +           # CORRIGIDO: o resumo usava ~cylinders, mas o enunciado pede ~origin
  labs(title = "Potência e consumo por origem")
# Mesma direção (negativa) nos três painéis, mas perfis diferentes:
# EUA (1) tem 245 carros espalhados até 230 HP; Europa (2) e Japão (3)
# têm carros menos potentes (~80 HP em média) e mpg mais alto.

# ------------------- RESPOSTA DO EXERCÍCIO 16 -------------------
ggplot(ISLR::Carseats, aes(x = Sales)) +
  geom_histogram(binwidth = 2, fill = "steelblue", color = "white") +
  facet_grid(ShelveLoc ~ Urban) +
  labs(title = "Vendas por prateleira e localização")
# A prateleira muda a posição das vendas (Good à direita, Bad à esquerda);
# a localização (Urban) muda mais a quantidade de lojas do que o formato.

# ------------------- RESPOSTA DO EXERCÍCIO 17 -------------------
ggplot(ISLR::Wage, aes(x = age, y = wage, color = education)) +
  geom_point(alpha = 0.6) +
  theme_minimal() +
  labs(title = "Idade e salário por escolaridade", x = "Idade", y = "Salário", color = "Escolaridade")
# Muita dispersão; maior escolaridade tende a ficar mais acima. A relação
# com idade e escolaridade existe, mas não é determinística.

# ------------------- RESPOSTA DO EXERCÍCIO 18 -------------------
ggplot(ISLR::Auto, aes(x = weight, y = mpg)) +
  geom_point() +
  annotate("text", x = 2000, y = 40, label = "Leves e econômicos", color = "blue") +
  labs(title = "Peso e consumo com anotação")
# A anotação chama atenção para a região de carros leves e com mpg alto.

# ------------------- RESPOSTA DO EXERCÍCIO 19 -------------------
auto_potentes <- subset(ISLR::Auto, horsepower > 200)   # R base

auto_potentes_1 <- ISLR::Auto %>%                       # dplyr
  filter(horsepower > 200)
auto_potentes_1

ggplot(auto_potentes_1, aes(x = horsepower, y = mpg, label = name)) +
  geom_point() +
  geom_text(size = 3, vjust = -0.5, check_overlap = TRUE) +
  labs(title = "Automóveis com potência acima de 200 HP")
# 10 carros, todos americanos e beberrões (10 a 16 mpg). O pontiac grand prix
# é o mais potente (230 HP) e o mais econômico do grupo (16 mpg); ford f250 é o pior (10 mpg).

# ------------------- RESPOSTA DO EXERCÍCIO 20 -------------------
ggplot(ISLR::Auto, aes(x = weight, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "darkgreen") +
  labs(title = "Regressão linear: peso e consumo")
# Inclinação negativa (-0,0076): cada 1.000 lb a mais custam ~7,6 milhas por galão.
