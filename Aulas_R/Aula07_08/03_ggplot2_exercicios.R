# AULAS 07 e 08 - Parte 3: exercícios de ggplot2 (para praticar)
# Tente resolver cada um olhando o exemplo de mesmo número em 02_ggplot2_exemplos.R.
# Só depois confira em 04_ggplot2_respostas.R.
#
# Bases do pacote ISLR:
#   Auto     -> carros: mpg, horsepower, weight, origin (1=EUA, 2=Europa, 3=Japão), name...
#   Carseats -> lojas de cadeirinha infantil: Sales, ShelveLoc, Urban, US...
#   Wage     -> salários: wage, age, education...
#   Smarket  -> bolsa (S&P 500, 2001-2005): Year, Volume, Today, Direction...
# ------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(ISLR)

names(ISLR::Auto)
names(ISLR::Carseats)
names(ISLR::Wage)
names(ISLR::Smarket)

# EXERCÍCIO 1 | ISLR::Auto
# Crie um gráfico de dispersão com horsepower no eixo X e mpg no eixo Y.
# Interprete: carros mais potentes tendem a ter maior ou menor mpg?


# EXERCÍCIO 2 | ISLR::Auto
# Relacione weight (X) e mpg (Y), colorindo os pontos por factor(origin).
# Interprete: a relação entre peso e consumo parece variar por origem?


# EXERCÍCIO 3 | ISLR::Auto
# Faça weight (X) versus mpg (Y), usando size = horsepower e alpha = 0.6.
# Interprete: o tamanho dos pontos ajuda a identificar padrões?


# EXERCÍCIO 4 | ISLR::Carseats
# Conte as lojas de cada categoria da variável Urban com geom_bar().
# Interprete: existem mais lojas urbanas ou não urbanas?


# EXERCÍCIO 5 | ISLR::Carseats
# Calcule a média de Sales por ShelveLoc (aggregate() ou group_by + summarise).
# Faça barras horizontais com as médias, ordenadas por reorder().
# Interprete: qual categoria tem maior média de vendas?


# EXERCÍCIO 6 | ISLR::Carseats
# Compare Urban no eixo X e ShelveLoc como preenchimento das barras.
# Utilize geom_bar(position = "dodge").
# Interprete: como se distribuem as lojas nas combinações dessas categorias?


# EXERCÍCIO 7 | ISLR::Carseats
# Refaça o exercício 6 com geom_bar(position = "stack").
# Interprete: qual formato facilita mais comparar os grupos? Justifique.


# EXERCÍCIO 8 | ISLR::Wage
# Faça um histograma da variável wage; teste diferentes binwidth.


# EXERCÍCIO 9 | ISLR::Wage
# Compare wage por education usando geom_boxplot().
# Interprete: qual grupo tem maior mediana? Existem valores atípicos?


# EXERCÍCIO 10 | ISLR::Wage
# Compare a distribuição de wage por education com geom_violin().
# Interprete: o violino mostra detalhes não tão evidentes no boxplot?


# EXERCÍCIO 11 | ISLR::Smarket
# Faça curvas de densidade de Today, preenchidas por Direction.
# Interprete: como diferem as distribuições em dias Up e Down?
# Atenção: Direction é definida a partir do sinal de Today.


# EXERCÍCIO 12 | ISLR::Smarket
# Calcule a média de Volume por Year (aggregate() ou group_by + summarise).
# Represente a evolução anual das médias usando geom_line().
# Interprete: há tendência de crescimento ou redução do volume médio?


# EXERCÍCIO 13 | ISLR::Smarket
# Use as médias anuais de Volume do exercício 12 para criar geom_area().
# Interprete: que diferenças visuais existem entre linha e área?


# EXERCÍCIO 14 | ISLR::Auto
# Relacione horsepower (X) e mpg (Y) e acrescente curva LOESS.
# Interprete: a relação parece linear ou apresenta curvaturas?


# EXERCÍCIO 15 | ISLR::Auto
# Faça horsepower (X) versus mpg (Y), com facet_wrap(~origin).
# Interprete: a relação é semelhante nos três grupos de origem?


# EXERCÍCIO 16 | ISLR::Carseats
# Faça histogramas de Sales com facet_grid(ShelveLoc ~ Urban).
# Interprete: como a distribuição das vendas varia entre os painéis?


# EXERCÍCIO 17 | ISLR::Wage
# Faça age (X) versus wage (Y), com color = education.
# Use theme_minimal() e personalize título e rótulos dos eixos.
# Interprete: há relação aparente entre idade, escolaridade e salário?


# EXERCÍCIO 18 | ISLR::Auto
# Faça weight (X) versus mpg (Y) e adicione annotate("text", ...).
# Escolha coordenadas e texto que destaquem uma região relevante.
# Interprete: que informação a anotação acrescenta ao gráfico?


# EXERCÍCIO 19 | ISLR::Auto
# Filtre Auto para horsepower > 200 (subset() ou filter()).
# Faça horsepower (X) versus mpg (Y), usando label = name e geom_text().
# Interprete: quais modelos se destacam por potência e consumo?


# EXERCÍCIO 20 | ISLR::Auto
# Faça weight (X) versus mpg (Y), adicionando reta com
# geom_smooth(method = "lm", se = FALSE).
# Interprete: a inclinação é positiva ou negativa? O que significa?

