#Wellington Torres
#Tarefa 003 - Filtros em data.frame (base de dados Carseats)

#Biblioteca
library(ISLR)


#carregar os dados
dados001 <- ISLR::Carseats


# Espiada inicial na base para saber com o que estamos lidando
print("----- Estrutura da base Carseats -----")
str(dados001)
print(paste("Total de linhas:", nrow(dados001)))


# 1) Filtro ShelveLoc == "Bad" -> badcarseats

badcarseats <- dados001[dados001$ShelveLoc == "Bad", ]

print("----- 1) badcarseats (ShelveLoc == Bad) -----")
print(paste("Linhas:", nrow(badcarseats)))
print(head(badcarseats))


# 2) Filtro Urban == "Yes" -> Urbancarseats

Urbancarseats <- dados001[dados001$Urban == "Yes", ]

print("----- 2) Urbancarseats (Urban == Yes) -----")
print(paste("Linhas:", nrow(Urbancarseats)))
print(head(Urbancarseats))


# 3) Filtro CompPrice > 110

compPrice110 <- dados001[dados001$CompPrice > 110, ]

print("----- 3) compPrice110 (CompPrice > 110) -----")
print(paste("Linhas:", nrow(compPrice110)))
print(head(compPrice110))


# 4) Filtro CompPrice > 110 E ShelveLoc == "Good"
#    o & exige que as duas condicoes sejam verdadeiras na mesma linha

goodCompPrice110 <- dados001[dados001$CompPrice > 110 & dados001$ShelveLoc == "Good", ]

print("----- 4) goodCompPrice110 (CompPrice > 110 e ShelveLoc == Good) -----")
print(paste("Linhas:", nrow(goodCompPrice110)))
print(head(goodCompPrice110))


# 5) Filtro CompPrice > 110 E ShelveLoc == "Medium"

mediumCompPrice110 <- dados001[dados001$CompPrice > 110 & dados001$ShelveLoc == "Medium", ]

print("----- 5) mediumCompPrice110 (CompPrice > 110 e ShelveLoc == Medium) -----")
print(paste("Linhas:", nrow(mediumCompPrice110)))
print(head(mediumCompPrice110))


# 6) Um data.frame unico com badcarseats e Urbancarseats
#    rbind empilha as linhas dos dois data.frames (as colunas sao as mesmas)

badUrbancarseats <- rbind(badcarseats, Urbancarseats)

print("----- 6) badUrbancarseats (badcarseats + Urbancarseats) -----")
print(paste("Linhas apos o rbind:", nrow(badUrbancarseats)))

#    as lojas que sao Bad E Urban ao mesmo tempo aparecem duas vezes no rbind,
#    entao o unique() deixa cada loja uma vez so
badUrbancarseatsSemRepetir <- unique(badUrbancarseats)

print(paste("Linhas repetidas removidas:",
            nrow(badUrbancarseats) - nrow(badUrbancarseatsSemRepetir)))
print(paste("Linhas sem repeticao:", nrow(badUrbancarseatsSemRepetir)))
print(head(badUrbancarseatsSemRepetir))


# Resumo geral dos filtros
print("----- Resumo -----")
resumo <- data.frame(
  filtro = c("badcarseats",
             "Urbancarseats",
             "compPrice110",
             "goodCompPrice110",
             "mediumCompPrice110",
             "badUrbancarseats (com repeticao)",
             "badUrbancarseats (sem repeticao)"),
  linhas = c(nrow(badcarseats),
             nrow(Urbancarseats),
             nrow(compPrice110),
             nrow(goodCompPrice110),
             nrow(mediumCompPrice110),
             nrow(badUrbancarseats),
             nrow(badUrbancarseatsSemRepetir))
)
print(resumo)
