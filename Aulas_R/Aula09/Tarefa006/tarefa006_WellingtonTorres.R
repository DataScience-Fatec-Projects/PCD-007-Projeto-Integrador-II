#Wellington Torres
#Tarefa 006 - Exercícios sobre o GGPLOT (exercícios 1 a 8)
#Bases do pacote ISLR: Auto, Carseats e Wage
# =========================================================================

#Limpeza
rm(list=ls())

#Pasta da tarefa, relativa a raiz do projeto
#Abrir o RStudio pelo Aulas_R.Rproj: o wd ja nasce em .../Aulas_R
BASE<-"Aula09/Tarefa006"
SAIDA<-file.path(BASE, "graficos")
dir.create(SAIDA, showWarnings = FALSE)

#carregar bibliotecas
library(ggplot2)
library(ISLR)

#carregar os dados
auto<-ISLR::Auto           # carros: mpg, horsepower, weight, origin...
carseats<-ISLR::Carseats   # lojas de cadeirinhas infantis: Sales, ShelveLoc, Urban...
wage<-ISLR::Wage           # salarios: wage, education, age...

str(auto)
str(carseats)
str(wage)

#origin no Auto é numero: 1 = EUA, 2 = Europa, 3 = Japao


# =========================================================================
# EXERCÍCIO 1 | ISLR::Auto
# Crie um gráfico de dispersão com horsepower no eixo X e mpg no eixo Y.
# Interprete: carros mais potentes tendem a ter maior ou menor mpg?
# =========================================================================
g1<-ggplot(auto, aes(x = horsepower, y = mpg)) +
  geom_point() +
  labs(title = "Potência e consumo",
       x = "Potência (HP)", y = "Milhas por galão (mpg)")
g1

cor(auto$horsepower, auto$mpg)   # -0.78

# =========================================================================
# EXERCÍCIO 2 | ISLR::Auto
# Relacione weight (X) e mpg (Y), colorindo os pontos por factor(origin).
# Interprete: a relação entre peso e consumo parece variar por origem?
# =========================================================================
g2<-ggplot(auto, aes(x = weight, y = mpg, color = factor(origin))) +
  geom_point() +
  labs(title = "Peso e consumo por origem",
       x = "Peso (kg)", y = "Milhas por galão (mpg)", color = "Origem") +
  scale_color_discrete(labels = c("1" = "EUA", "2" = "Europa", "3" = "Japão"))
g2

aggregate(cbind(weight, mpg) ~ origin, data = auto, FUN = mean)

# =========================================================================
# EXERCÍCIO 3 | ISLR::Auto
# Faça weight (X) versus mpg (Y), usando size = horsepower e alpha = 0.6.
# Interprete: o tamanho dos pontos ajuda a identificar padrões?
# =========================================================================
g3<-ggplot(auto, aes(x = weight, y = mpg, size = horsepower)) +
  geom_point(alpha = 0.6) +
  labs(title = "Peso, consumo e potência",
       x = "Peso (kg)", y = "Milhas por galão (mpg)", size = "Potência (HP)")
g3

# =========================================================================
# EXERCÍCIO 4 | ISLR::Carseats
# Conte as lojas de cada categoria da variável Urban com geom_bar().
# Interprete: existem mais lojas urbanas ou não urbanas?
# =========================================================================
g4<-ggplot(carseats, aes(x = Urban)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Lojas por localização",
       x = "Loja em área urbana?", y = "Quantidade de lojas")
g4

table(carseats$Urban)   # No = 118, Yes = 282

# =========================================================================
# EXERCÍCIO 5 | ISLR::Carseats
# Calcule a média de Sales por ShelveLoc usando aggregate().
# Faça barras horizontais com as médias, ordenadas por reorder().
# Interprete: qual categoria tem maior média de vendas?
# =========================================================================
medias_vendas<-aggregate(Sales ~ ShelveLoc, data = carseats, FUN = mean)
medias_vendas
#   ShelveLoc     Sales
# 1       Bad  5.522917
# 2      Good 10.214000
# 3    Medium  7.306575

g5<-ggplot(medias_vendas, aes(x = reorder(ShelveLoc, Sales), y = Sales)) +
  geom_col(fill = "lightblue") +    # geom_col = geom_bar(stat = "identity")
  coord_flip() +
  labs(title = "Média de vendas por qualidade da prateleira",
       x = "Qualidade da prateleira", y = "Vendas médias (mil unidades)")
g5

# =========================================================================
# EXERCÍCIO 6 | ISLR::Carseats
# Compare Urban no eixo X e ShelveLoc como preenchimento das barras.
# Utilize geom_bar(position = "dodge").
# Interprete: como se distribuem as lojas nas combinações dessas categorias?
# =========================================================================
g6<-ggplot(carseats, aes(x = Urban, fill = ShelveLoc)) +
  geom_bar(position = "dodge") +
  labs(title = "Lojas por localização e qualidade da prateleira",
       x = "Loja em área urbana?", y = "Quantidade de lojas", fill = "Prateleira")
g6

table(carseats$Urban, carseats$ShelveLoc)
#       Bad Good Medium
#   No   22   28     68
#   Yes  74   57    151

# =========================================================================
# EXERCÍCIO 7 | ISLR::Carseats
# Refaça o exercício 6 com geom_bar(position = "stack").
# Interprete: qual formato facilita mais comparar os grupos? Justifique.
# =========================================================================
g7<-ggplot(carseats, aes(x = Urban, fill = ShelveLoc)) +
  geom_bar(position = "stack") +
  labs(title = "Lojas por localização e qualidade da prateleira (empilhado)",
       x = "Loja em área urbana?", y = "Quantidade de lojas", fill = "Prateleira")
g7


# =========================================================================
# EXERCÍCIO 8 | ISLR::Wage
# Faça um histograma da variável wage; teste diferentes binwidth.
# =========================================================================
summary(wage$wage)

# binwidth = largura de cada faixa (barra), na unidade da variável
# (wage está em milhares de dólares por ano)
g8a<-ggplot(wage, aes(x = wage)) +
  geom_histogram(binwidth = 5, fill = "salmon", color = "black") +
  labs(title = "Distribuição dos salários - binwidth = 5",
       x = "Salário (mil R$/ano)", y = "Frequência")
g8a

g8b<-ggplot(wage, aes(x = wage)) +
  geom_histogram(binwidth = 20, fill = "salmon", color = "black") +
  labs(title = "Distribuição dos salários - binwidth = 20",
       x = "Salário (mil R$/ano)", y = "Frequência")
g8b

g8c<-ggplot(wage, aes(x = wage)) +
  geom_histogram(binwidth = 50, fill = "salmon", color = "black") +
  labs(title = "Distribuição dos salários - binwidth = 50",
       x = "Salário (mil R$/ano)", y = "Frequência")
g8c

# =========================================================================
# GRAVAR OS GRAFICOS (para anexar na entrega)
# =========================================================================
graficos<-list(ex1 = g1, ex2 = g2, ex3 = g3, ex4 = g4, ex5 = g5, ex6 = g6, ex7 = g7,
               ex8a_bin05 = g8a, ex8b_bin20 = g8b, ex8c_bin50 = g8c)

for (nome in names(graficos)) {
  ggsave(file.path(SAIDA, paste0(nome, ".png")), graficos[[nome]],
         width = 7, height = 5, bg = "white")
}
