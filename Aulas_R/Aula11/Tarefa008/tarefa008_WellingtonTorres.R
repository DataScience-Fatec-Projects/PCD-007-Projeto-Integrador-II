#Wellington Torres
#Tarefa 008 - Correlação e Regressão Linear Simples (exercícios 1 a 10)
#Bases: ISLR::Auto, ISLR::Credit, ISLR::Wage, ISLR::Carseats e ISLR2::Boston
# =========================================================================
#Roteiro de cada exercício (o mesmo do exemplo da aula, com mtcars):
#  1) cor()        -> força e sentido da relação entre X e Y
#  2) lm()         -> ajusta a reta  y = a*x + b
#  3) summary()    -> R², p-valor e erro padrão do modelo
#  4) a e b        -> tirados de modelo$coefficients, calcula o yaproximado
#  5) previsão     -> usa a reta para um valor de X escolhido
#  6) ggplot       -> pontos + reta de regressão (geom_smooth, method = "lm")
#  7) interpretação
# =========================================================================

#limpeza
rm(list = ls())

#Pasta da tarefa, relativa a raiz do projeto
#Abrir o RStudio pelo Aulas_R.Rproj: o wd ja nasce em .../Aulas_R
BASE<-"Aula11/Tarefa008"
SAIDA<-file.path(BASE, "graficos")
dir.create(SAIDA, showWarnings = FALSE, recursive = TRUE)

#bibliotecas
#install.packages(c("ISLR2", "corrplot"))   # rodar uma vez, se ainda não tiver
library("ISLR")
library("ISLR2")
library("corrplot")
library("ggplot2")

#carregar dados
#O ISLR2 também tem Auto e Credit (e "mascara" os do ISLR ao ser carregado).
#Por isso o pacote é sempre indicado com :: (ISLR::Auto), como pede o enunciado.
auto<-ISLR::Auto          # 392 carros: mpg, horsepower, weight, acceleration, displacement...
credit<-ISLR::Credit       # 400 clientes de cartão: Balance (dívida), Income, Age...
wage<-ISLR::Wage           # 3000 trabalhadores: wage (salário), age...
carseats<-ISLR::Carseats   # 400 lojas de cadeirinhas infantis: Sales, Price...
boston<-ISLR2::Boston      # 506 bairros de Boston: medv (valor do imóvel), lstat, rm...

#Unidades (importante para interpretar a inclinação "a"):
# Auto     : mpg = milhas por galão | horsepower = HP | weight = libras
#            acceleration = segundos de 0 a 60 mph (MENOR = carro mais rápido)
#            displacement = cilindrada em polegadas cúbicas
# Credit   : Balance = saldo devedor médio no cartão (US$) | Income = renda (mil US$)
# Wage     : wage = salário (mil US$/ano) | age = idade (anos)
# Carseats : Sales = vendas (mil unidades) | Price = preço cobrado (US$)
# Boston   : medv = valor mediano do imóvel (mil US$)
#            lstat = % da população de baixa renda | rm = nº médio de cômodos


# =========================================================================
# VERIFICANDO AS VARIÁVEIS
# cor() só aceita colunas numéricas. Auto tem "name" (fator), Credit tem
# Gender, Student, Married e Ethnicity, Wage tem várias colunas de texto...
# =========================================================================
str(auto)
str(credit)
str(wage)
str(carseats)
str(boston)

sapply(auto, is.numeric)   # name = FALSE
#cor(auto)                 # Erro: 'x' must be numeric

#ficar só com as colunas numéricas de cada base
auto_num<-auto[, sapply(auto, is.numeric)]
credit_num<-credit[, sapply(credit, is.numeric)]
credit_num$ID<-NULL        # ID é só o número da linha, não é medida
wage_num<-wage[, sapply(wage, is.numeric)]
carseats_num<-carseats[, sapply(carseats, is.numeric)]
boston_num<-boston         # Boston já é toda numérica

#todas as variáveis usadas nos exercícios são numéricas?
is.numeric(auto$horsepower); is.numeric(credit$Balance); is.numeric(wage$age)


# =========================================================================
# MATRIZES DE CORRELAÇÃO (corrplot)
# Mostra de uma vez a correlação de todas as variáveis numéricas da base.
# Azul = correlação positiva, vermelho = negativa; quanto maior o círculo,
# mais forte. Uma função para mostrar na tela e gravar o PNG.
# =========================================================================
salvar_corrplot<-function(dados, arquivo){
  m<-cor(dados)
  corrplot(m, type = "upper", addCoef.col = "black", number.cex = 0.7, tl.col = "black")
  png(file.path(SAIDA, arquivo), width = 900, height = 900, res = 120)
  corrplot(m, type = "upper", addCoef.col = "black", number.cex = 0.7, tl.col = "black")
  dev.off()
}

cor(auto_num)
salvar_corrplot(auto_num, "corr_auto.png")
#mpg: weight -0.83 | displacement -0.81 | horsepower -0.78 | cylinders -0.78

cor(credit_num)
salvar_corrplot(credit_num, "corr_credit.png")
#Balance: Rating 0.86 | Limit 0.86 | Income 0.46 | Age 0.00

cor(wage_num)
salvar_corrplot(wage_num, "corr_wage.png")
#wage: age 0.20 | year 0.07 (logwage é o próprio wage em log)

cor(carseats_num)
salvar_corrplot(carseats_num, "corr_carseats.png")
#Sales: Price -0.45 | Advertising 0.27 | Age -0.23

cor(boston_num)
salvar_corrplot(boston_num, "corr_boston.png")
#medv: lstat -0.74 | rm 0.70 | ptratio -0.51


#Função auxiliar: texto da equação e do R² para o subtítulo dos gráficos
equacao<-function(modelo){
  coefs<-modelo$coefficients
  nomes<-all.vars(formula(modelo))
  sprintf("%s = %.4f %s %.4f * %s   |   R² = %.3f",
          nomes[1], coefs[1], ifelse(coefs[2] < 0, "-", "+"), abs(coefs[2]), nomes[2],
          summary(modelo)$r.squared)
}


# =========================================================================
# EXERCÍCIO 1 | ISLR::Auto - mpg ~ horsepower
# Prever o consumo (mpg) pela potência (horsepower).
# =========================================================================
cor(auto$horsepower, auto$mpg)          # -0.778

modelo01<-lm(mpg ~ horsepower, data = auto)
summary(modelo01)
formula(modelo01)

#Regressão linear simples calculando yaproximado = a*x + b
modelo01$coefficients
b<-as.numeric(modelo01$coefficients[1])
b                                       # 39.936
a<-as.numeric(modelo01$coefficients[2])
a                                       # -0.1578

x<-auto$horsepower
yaproximado<-a*x+b
head(data.frame(real = auto$mpg, aproximado = round(yaproximado, 2)))

#previsão: carro de 100 HP
a*100+b                                         # 24.15 mpg
predict(modelo01, data.frame(horsepower = 100)) # mesma conta, feita pelo R

g01<-ggplot(auto, aes(x = horsepower, y = mpg)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 1 - Regressão Linear: consumo x potência (Auto)",
       subtitle = equacao(modelo01),
       x = "Potência (HP)", y = "Milhas por galão (mpg)")
g01

#Interpretação:
# - r = -0,78: correlação negativa forte. Carro mais potente faz menos milhas por galão.
# - mpg = 39,94 - 0,158*horsepower: cada 1 HP a mais tira 0,158 mpg (10 HP = -1,6 mpg).
# - R² = 0,606: a potência explica 60,6% da variação do consumo.
# - p-valor < 2e-16: a relação é estatisticamente significativa.
# - Um carro de 100 HP deve fazer cerca de 24,2 mpg.
# - O gráfico mostra uma CURVA: a reta erra para baixo nas pontas (HP muito baixo
#   ou muito alto) e para cima no meio. Uma reta é uma boa 1ª aproximação, mas não perfeita.


# =========================================================================
# EXERCÍCIO 2 | ISLR::Auto - mpg ~ weight
# Prever mpg pelo peso do veículo (weight).
# =========================================================================
cor(auto$weight, auto$mpg)              # -0.832

modelo02<-lm(mpg ~ weight, data = auto)
summary(modelo02)
formula(modelo02)

modelo02$coefficients
b<-as.numeric(modelo02$coefficients[1])
b                                       # 46.217
a<-as.numeric(modelo02$coefficients[2])
a                                       # -0.007647

x<-auto$weight
yaproximado<-a*x+b
head(data.frame(real = auto$mpg, aproximado = round(yaproximado, 2)))

#previsão: carro de 3000 libras
a*3000+b                                # 23.27 mpg

g02<-ggplot(auto, aes(x = weight, y = mpg)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 2 - Regressão Linear: consumo x peso (Auto)",
       subtitle = equacao(modelo02),
       x = "Peso (libras)", y = "Milhas por galão (mpg)")
g02

#Interpretação:
# - r = -0,83: correlação negativa forte, a mais forte das quatro do Auto.
# - mpg = 46,22 - 0,00765*weight: cada 1000 libras a mais tiram 7,6 mpg.
# - R² = 0,693: o peso explica 69,3% da variação do consumo. É o melhor preditor
#   isolado de mpg entre os testados (peso > cilindrada > potência).
# - p-valor < 2e-16: significativo.
# - Um carro de 3000 libras deve fazer cerca de 23,3 mpg.


# =========================================================================
# EXERCÍCIO 3 | ISLR::Auto - acceleration ~ horsepower
# Prever a aceleração pela potência.
# =========================================================================
cor(auto$horsepower, auto$acceleration) # -0.689

modelo03<-lm(acceleration ~ horsepower, data = auto)
summary(modelo03)
formula(modelo03)

modelo03$coefficients
b<-as.numeric(modelo03$coefficients[1])
b                                       # 20.702
a<-as.numeric(modelo03$coefficients[2])
a                                       # -0.0494

x<-auto$horsepower
yaproximado<-a*x+b
head(data.frame(real = auto$acceleration, aproximado = round(yaproximado, 2)))

#previsão: carro de 100 HP
a*100+b                                 # 15.76 segundos

g03<-ggplot(auto, aes(x = horsepower, y = acceleration)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 3 - Regressão Linear: aceleração x potência (Auto)",
       subtitle = equacao(modelo03),
       x = "Potência (HP)", y = "Tempo de 0 a 60 mph (segundos)")
g03

#Interpretação:
# - Cuidado com a unidade: acceleration é o TEMPO para ir de 0 a 60 mph.
#   Valor menor = carro mais rápido.
# - r = -0,69: correlação negativa moderada/forte. Mais potência, menos segundos.
# - acceleration = 20,70 - 0,0494*horsepower: cada 100 HP a mais tiram 4,9 s do 0-60.
# - R² = 0,475: a potência explica 47,5% da variação do tempo de aceleração.
#   O resto depende de outros fatores (peso, câmbio...).
# - p-valor < 2e-16: significativo.
# - Um carro de 100 HP deve levar cerca de 15,8 s de 0 a 60 mph.


# =========================================================================
# EXERCÍCIO 4 | ISLR::Auto - mpg ~ displacement
# =========================================================================
cor(auto$displacement, auto$mpg)        # -0.805

modelo04<-lm(mpg ~ displacement, data = auto)
summary(modelo04)
formula(modelo04)

modelo04$coefficients
b<-as.numeric(modelo04$coefficients[1])
b                                       # 35.121
a<-as.numeric(modelo04$coefficients[2])
a                                       # -0.0601

x<-auto$displacement
yaproximado<-a*x+b
head(data.frame(real = auto$mpg, aproximado = round(yaproximado, 2)))

#previsão: motor de 200 polegadas cúbicas
a*200+b                                 # 23.11 mpg

g04<-ggplot(auto, aes(x = displacement, y = mpg)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 4 - Regressão Linear: consumo x cilindrada (Auto)",
       subtitle = equacao(modelo04),
       x = "Cilindrada (pol³)", y = "Milhas por galão (mpg)")
g04

#Interpretação:
# - r = -0,81: correlação negativa forte. Motor maior, menos milhas por galão.
# - mpg = 35,12 - 0,0601*displacement: cada 100 pol³ a mais tiram 6,0 mpg.
# - R² = 0,648: a cilindrada explica 64,8% da variação do consumo.
# - p-valor < 2e-16: significativo.
# - Um motor de 200 pol³ deve fazer cerca de 23,1 mpg.
# - Comparando os exercícios 1, 2 e 4: weight (69%) > displacement (65%) > horsepower (61%).
#   As três variáveis medem, no fundo, "tamanho do carro", por isso são parecidas.


# =========================================================================
# EXERCÍCIO 5 | ISLR::Credit - Balance ~ Income
# =========================================================================
cor(credit$Income, credit$Balance)      # 0.464

modelo05<-lm(Balance ~ Income, data = credit)
summary(modelo05)
formula(modelo05)

modelo05$coefficients
b<-as.numeric(modelo05$coefficients[1])
b                                       # 246.515
a<-as.numeric(modelo05$coefficients[2])
a                                       # 6.048

x<-credit$Income
yaproximado<-a*x+b
head(data.frame(real = credit$Balance, aproximado = round(yaproximado, 2)))

#previsão: cliente com renda de 50 mil US$
a*50+b                                  # 548.93 US$

sum(credit$Balance == 0)                # 90 clientes sem dívida nenhuma

g05<-ggplot(credit, aes(x = Income, y = Balance)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 5 - Regressão Linear: saldo do cartão x renda (Credit)",
       subtitle = equacao(modelo05),
       x = "Renda (mil US$)", y = "Saldo devedor no cartão (US$)")
g05

#Interpretação:
# - r = 0,46: correlação positiva moderada. Quem ganha mais tende a ter saldo maior no cartão.
# - Balance = 246,51 + 6,05*Income: cada 10 mil US$ de renda somam cerca de US$ 60 de saldo.
# - R² = 0,215: a renda explica só 21,5% da variação do saldo. A relação existe
#   (p-valor < 2e-16), mas a renda sozinha prevê mal. O corrplot mostra que
#   Limit e Rating (r = 0,86) explicam muito mais.
# - 90 dos 400 clientes têm saldo zero: formam uma "linha" no chão do gráfico que a reta
#   não consegue acompanhar.
# - Um cliente com renda de 50 mil US$ deve ter saldo de cerca de US$ 549.


# =========================================================================
# EXERCÍCIO 6 | ISLR::Credit - Balance ~ Age
# =========================================================================
cor(credit$Age, credit$Balance)         # 0.002

modelo06<-lm(Balance ~ Age, data = credit)
summary(modelo06)
formula(modelo06)

modelo06$coefficients
b<-as.numeric(modelo06$coefficients[1])
b                                       # 517.292
a<-as.numeric(modelo06$coefficients[2])
a                                       # 0.0489

x<-credit$Age
yaproximado<-a*x+b
head(data.frame(real = credit$Balance, aproximado = round(yaproximado, 2)))

#previsão: cliente de 50 anos
a*50+b                                  # 519.74 US$
mean(credit$Balance)                    # 520.02 US$ (praticamente a mesma coisa)

g06<-ggplot(credit, aes(x = Age, y = Balance)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  geom_hline(yintercept = mean(credit$Balance), linetype = "dashed", color = "blue") +
  labs(title = "Ex. 6 - Regressão Linear: saldo do cartão x idade (Credit)",
       subtitle = equacao(modelo06),
       caption = "Linha azul tracejada = média do saldo",
       x = "Idade (anos)", y = "Saldo devedor no cartão (US$)")
g06

#Interpretação:
# - r = 0,002: correlação praticamente ZERO.
# - Balance = 517,29 + 0,049*Age: a inclinação é quase nula (5 centavos por ano de idade).
# - R² = 0,0000034 e p-valor = 0,97: a idade NÃO explica o saldo do cartão.
#   Não dá para rejeitar a hipótese de que a inclinação seja zero.
# - A reta vermelha fica em cima da média (linha azul): usar o modelo é o mesmo que
#   chutar a média para todo mundo. É o exemplo de um modelo que não serve.


# =========================================================================
# EXERCÍCIO 7 | ISLR::Wage - wage ~ age
# No conjunto Wage, modele salário pela idade.
# =========================================================================
cor(wage$age, wage$wage)                # 0.196

modelo07<-lm(wage ~ age, data = wage)
summary(modelo07)
formula(modelo07)

modelo07$coefficients
b<-as.numeric(modelo07$coefficients[1])
b                                       # 81.705
a<-as.numeric(modelo07$coefficients[2])
a                                       # 0.7073

x<-wage$age
yaproximado<-a*x+b
head(data.frame(real = wage$wage, aproximado = round(yaproximado, 2)))

#previsão: trabalhador de 40 anos
a*40+b                                  # 110.00 mil US$/ano

#salário médio por faixa de idade (para ver a curva)
aggregate(wage ~ cut(age, c(17, 25, 35, 45, 55, 65, 80)), data = wage, FUN = mean)

g07<-ggplot(wage, aes(x = age, y = wage)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 7 - Regressão Linear: salário x idade (Wage)",
       subtitle = equacao(modelo07),
       x = "Idade (anos)", y = "Salário (mil US$/ano)")
g07

#Interpretação:
# - r = 0,20: correlação positiva FRACA.
# - wage = 81,70 + 0,707*age: cada ano a mais soma cerca de 707 dólares no salário anual.
# - R² = 0,038: a idade explica só 3,8% da variação do salário.
# - p-valor < 2e-16 mesmo assim. Com 3000 pessoas, até um efeito pequeno vira
#   "significativo". Significativo quer dizer "provavelmente não é zero", não "forte".
# - A relação não é uma reta: o salário médio sobe de 76 (até 25 anos) para ~119
#   (35 a 45 anos), fica parado até 65 e cai para ~103 depois. Há ainda um grupo de
#   79 salários acima de 250 mil, separado do resto.
# - Um trabalhador de 40 anos deve ganhar cerca de 110 mil US$/ano.


# =========================================================================
# EXERCÍCIO 8 | ISLR::Carseats - Sales ~ Price
# =========================================================================
cor(carseats$Price, carseats$Sales)     # -0.445

modelo08<-lm(Sales ~ Price, data = carseats)
summary(modelo08)
formula(modelo08)

modelo08$coefficients
b<-as.numeric(modelo08$coefficients[1])
b                                       # 13.642
a<-as.numeric(modelo08$coefficients[2])
a                                       # -0.0531

x<-carseats$Price
yaproximado<-a*x+b
head(data.frame(real = carseats$Sales, aproximado = round(yaproximado, 2)))

#previsão: loja que cobra US$ 100
a*100+b                                 # 8.33 mil unidades

g08<-ggplot(carseats, aes(x = Price, y = Sales)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 8 - Regressão Linear: vendas x preço (Carseats)",
       subtitle = equacao(modelo08),
       x = "Preço da cadeirinha (US$)", y = "Vendas (mil unidades)")
g08

#Interpretação:
# - r = -0,45: correlação negativa moderada. Preço maior, vendas menores (lei da demanda).
# - Sales = 13,64 - 0,0531*Price: cada US$ 10 a mais no preço tiram ~530 cadeirinhas vendidas.
# - R² = 0,198: o preço explica 19,8% da variação das vendas. Significativo
#   (p-valor < 2e-16), mas os pontos ficam bem espalhados em volta da reta:
#   outros fatores pesam (qualidade da prateleira, propaganda, idade da população...).
# - Uma loja que cobra US$ 100 deve vender cerca de 8,3 mil unidades.


# =========================================================================
# EXERCÍCIO 9 | ISLR2::Boston - medv ~ lstat
# =========================================================================
cor(boston$lstat, boston$medv)          # -0.738

modelo09<-lm(medv ~ lstat, data = boston)
summary(modelo09)
formula(modelo09)

modelo09$coefficients
b<-as.numeric(modelo09$coefficients[1])
b                                       # 34.554
a<-as.numeric(modelo09$coefficients[2])
a                                       # -0.9500

x<-boston$lstat
yaproximado<-a*x+b
head(data.frame(real = boston$medv, aproximado = round(yaproximado, 2)))

#previsão: bairro com 10% de população de baixa renda
a*10+b                                  # 25.05 mil US$

g09<-ggplot(boston, aes(x = lstat, y = medv)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 9 - Regressão Linear: valor do imóvel x % baixa renda (Boston)",
       subtitle = equacao(modelo09),
       x = "População de baixa renda (%)", y = "Valor mediano do imóvel (mil US$)")
g09

#Interpretação:
# - r = -0,74: correlação negativa forte. Bairro com mais população de baixa renda
#   tem imóveis mais baratos.
# - medv = 34,55 - 0,950*lstat: cada ponto percentual a mais de lstat tira
#   cerca de US$ 950 do valor mediano.
# - R² = 0,544: lstat explica 54,4% da variação do valor dos imóveis.
# - p-valor < 2e-16: significativo.
# - O gráfico é uma CURVA: a reta subestima os bairros nos extremos (lstat muito baixo
#   ou muito alto) e superestima os do meio. Para lstat acima de 36,4% a reta daria
#   valor negativo, o que não existe (2 bairros da base estão nessa faixa).
# - Um bairro com 10% de baixa renda deve ter imóvel mediano de cerca de US$ 25 mil.


# =========================================================================
# EXERCÍCIO 10 | ISLR2::Boston - medv ~ rm
# =========================================================================
cor(boston$rm, boston$medv)             # 0.695

modelo10<-lm(medv ~ rm, data = boston)
summary(modelo10)
formula(modelo10)

modelo10$coefficients
b<-as.numeric(modelo10$coefficients[1])
b                                       # -34.671
a<-as.numeric(modelo10$coefficients[2])
a                                       # 9.102

x<-boston$rm
yaproximado<-a*x+b
head(data.frame(real = boston$medv, aproximado = round(yaproximado, 2)))

#previsão: imóvel com 6 cômodos em média
a*6+b                                   # 19.94 mil US$

g10<-ggplot(boston, aes(x = rm, y = medv)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Ex. 10 - Regressão Linear: valor do imóvel x nº de cômodos (Boston)",
       subtitle = equacao(modelo10),
       x = "Número médio de cômodos", y = "Valor mediano do imóvel (mil US$)")
g10

#Interpretação:
# - r = 0,70: correlação positiva forte. Mais cômodos, imóvel mais caro.
# - medv = -34,67 + 9,10*rm: cada cômodo a mais soma cerca de US$ 9.100 ao valor mediano.
# - R² = 0,484: o número de cômodos explica 48,4% da variação do valor.
# - p-valor < 2e-16: significativo.
# - O intercepto negativo (-34,67) não tem significado prático: seria o valor de um imóvel
#   com ZERO cômodos, que não existe na base (o mínimo é 3,6). Só vale dentro da faixa
#   observada de rm (3,6 a 8,8).
# - Há 16 bairros "travados" em medv = 50 (teto da base), que aparecem como uma linha
#   no topo do gráfico.
# - Um imóvel com 6 cômodos deve valer cerca de US$ 19,9 mil (valores de 1970).


# =========================================================================
# RESUMO DOS 10 MODELOS
# Em regressão linear simples, R² = r². Por isso r = sinal(a) * raiz(R²).
# =========================================================================
modelos<-list(ex01 = modelo01, ex02 = modelo02, ex03 = modelo03, ex04 = modelo04,
              ex05 = modelo05, ex06 = modelo06, ex07 = modelo07, ex08 = modelo08,
              ex09 = modelo09, ex10 = modelo10)

resumo<-data.frame(
  modelo     = sapply(modelos, function(m) deparse(formula(m))),
  b          = sapply(modelos, function(m) round(m$coefficients[1], 4)),
  a          = sapply(modelos, function(m) round(m$coefficients[2], 4)),
  r          = sapply(modelos, function(m) round(sign(m$coefficients[2]) * sqrt(summary(m)$r.squared), 3)),
  R2         = sapply(modelos, function(m) round(summary(m)$r.squared, 3)),
  p_valor    = sapply(modelos, function(m) signif(summary(m)$coefficients[2, 4], 3))
)
resumo[order(-resumo$R2), ]

#Conclusão geral:
# - Melhores retas: mpg ~ weight (R² 0,69), mpg ~ displacement (0,65), mpg ~ horsepower (0,61)
#   e medv ~ lstat (0,54). São relações fortes, mas várias têm curvatura.
# - Relações reais, porém fracas: Balance ~ Income (0,22), Sales ~ Price (0,20) e
#   wage ~ age (0,04). Uma variável só não basta para prever bem.
# - Sem relação: Balance ~ Age (R² = 0,00 e p = 0,97).
# - Olhar SEMPRE o gráfico, não só o R²: a reta pode ser significativa e mesmo assim
#   não ser a forma certa da relação (ex. 1, 7, 9 e 10).


# =========================================================================
# GRAVAR OS GRÁFICOS (para anexar na entrega)
# =========================================================================
graficos<-list(ex01_auto_mpg_horsepower        = g01,
               ex02_auto_mpg_weight            = g02,
               ex03_auto_acceleration_horsepower = g03,
               ex04_auto_mpg_displacement      = g04,
               ex05_credit_balance_income      = g05,
               ex06_credit_balance_age         = g06,
               ex07_wage_wage_age              = g07,
               ex08_carseats_sales_price       = g08,
               ex09_boston_medv_lstat          = g09,
               ex10_boston_medv_rm             = g10)

for (nome in names(graficos)) {
  ggsave(file.path(SAIDA, paste0(nome, ".png")), graficos[[nome]],
         width = 8, height = 5, bg = "white")
}
