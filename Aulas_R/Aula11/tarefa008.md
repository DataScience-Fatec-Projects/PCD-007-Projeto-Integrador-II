Tarefa 008 Correlação e Regressão linear Simples
Data de conclusão 14 de novembro de 2026 às 23:59
•
Vários envios permitidos
Instruções
#Exercícios
#1) Auto – mpg ~ horsepower
#Utilize o conjunto Auto e ajuste um modelo simples
#prevendo o consumo (mpg) pela potência (horsepower).
#________________________________________
ISLR::Auto
#2) Auto – mpg ~ weight
#Ajuste um modelo prevendo mpg pelo peso do veículo (weight).
#________________________________________
ISLR::Auto

#3) Auto – acceleration ~ horsepower
#Ajuste um modelo prevendo aceleração (acceleration) pela potência.
#________________________________________
ISLR::Auto


#4) Auto – mpg ~ displacement
#________________________________________
ISLR::Auto


#5) Credit – Balance ~ Income (ISLR)
#Utilize o conjunto Credit
#________________________________________
ISLR::Credit


#6) Credit – Balance ~ Age
#________________________________________
ISLR::Credit


#7) Wage – wage ~ age (ISLR / ISLR2)
#No conjunto Wage, modele salário pela idade.
#________________________________________
ISLR::Wage



#8) Carseats – Sales ~ Price (ISLR)
#________________________________________
ISLR::Carseats

#9) Boston – medv ~ lstat (ISLR2)
#________________________________________
ISLR2::Boston

#10) Boston – medv ~ rm (ISLR2)

ISLR2::Boston

#Exemplo sobre as atividades acima
#limpeza
rm(list = ls())

#bibliotecas
library("ISLR")
library("corrplot")
library("ggplot2")

#carregar dados
dados001 <-mtcars
dados001
names(dados001)
str(dados001)

#verificando as variáveis

dados001$cyl

dados001$cyl<-as.character(dados001$cyl)
str(dados001)

is.numeric(dados001$cyl)

dados001$cyl<-as.numeric(dados001$cyl)
str(dados001)

is.numeric(dados001$cyl)

#verificar correlação
cor(dados001)
corrplot(cor(dados001))

#Construir o modelo
modelo001 <- lm(mpg ~ disp, data = dados001)
summary(modelo001)
formula(modelo001)

modelo001$coefficients[2]

#Regressão linear simples calculando yaproximado = a*x + b
modelo001$coefficients
b<-as.numeric(modelo001$coefficients[1])
b
a<-as.numeric(modelo001$coefficients[2])
a

x<-dados001$disp

yaproximado<-a*x+b

mpg1<-yaproximado
mpg1

dados001$mpg

#grafico
ggplot(dados001, aes(x = disp, y = mpg)) +
  geom_point()+
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Regressão Linear",
       subtitle = "MPG x DISP",
       x = "disp",
       y = "Mpg")

dados002<-ISLR::Auto
