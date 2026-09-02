#Wellington Torres
# 1) As tres tabelas como data.frame

tabelaA <- data.frame(xi = c(2, 3, 4, 5),
                      fi = c(2, 3, 6, 1))

tabelaB <- data.frame(xi = c(1, 3, 5, 7),
                      fi = c(6, 3, 8, 1))

tabelaC <- data.frame(xi = c(2, 4, 6, 8),
                      fi = c(4, 5, 5, 3))

# 2) Funcao da media (media ponderada pela frequencia)
#    x barra = soma(xi * fi) / soma(fi)

mediaFunc <- function(tabela) {
  somaXiFi <- sum(tabela$xi * tabela$fi)
  somaFi <- sum(tabela$fi)
  return(somaXiFi / somaFi)
}


# 3) Funcao da moda
#    a moda e o xi que tem a maior frequencia fi

modaFunc <- function(tabela) {
  maiorFi <- max(tabela$fi)
  moda <- tabela$xi[tabela$fi == maiorFi]
  return(moda)
}


# 4) Funcao para mostrar a tabela completa (coluna xi*fi e a linha do somatorio)

montaTabela <- function(tabela) {
  tabela$xifi <- tabela$xi * tabela$fi
  somatorio <- data.frame(xi = NA,
                          fi = sum(tabela$fi),
                          xifi = sum(tabela$xifi))
  return(rbind(tabela, somatorio))
}


# 5) Resultados

# Tabela A
print("----- Tabela A -----")
print(montaTabela(tabelaA))
print(paste("Media =", mediaFunc(tabelaA)))
print(paste("Moda  =", paste(modaFunc(tabelaA), collapse = " e ")))

# Tabela B
print("----- Tabela B -----")
print(montaTabela(tabelaB))
print(paste("Media =", mediaFunc(tabelaB)))
print(paste("Moda  =", paste(modaFunc(tabelaB), collapse = " e ")))

# Tabela C
print("----- Tabela C -----")
print(montaTabela(tabelaC))
print(paste("Media =", mediaFunc(tabelaC)))
print(paste("Moda  =", paste(modaFunc(tabelaC), collapse = " e ")))
