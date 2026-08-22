# Exercício 1: Calcule a média dos seguintes dados 
# e armazene na variavel mediax, mediay e mediaz
# respectivamente.
#1) x: 2, 2, 5, 7, 8, 9, 20         
#2) y: 3, 3, 4, 5, 5, 7, 8, 9, 9, 14 
#3) z: 2.34, 4.56, 5.35, 6.45 

#1
x <- (2 + 2 + 5 + 7 + 8 + 9 + 20) / 7
print(x)
#2
y <- (3 + 3 + 4 + 5 + 5 + 7 + 8 + 9 + 9 + 1) / 10
print(y)
z <- (2.34 + 4.56 + 5.35 + 6.45 ) / 4
print(z)

# Exercício 2: Criar duas funções, uma para o calculo da media e outra para 
# o calculo da mediana de um vetor qualquer x
#Forma Simples
meuVetor = c(2000, 2500, 3000, 3500, 50000) 
mediaFunc<-function(vetor){
  return(mean(vetor))
}
mediaVetor = mediaFunc(meuVetor)
print(mediaVetor)

medianaFunc<-function(vetor){
  return(median(vetor))
}
medianaVetor = medianaFunc(meuVetor)
print(medianaVetor)
#Forma pedida pelo professor
mediaFunc2<-function(vetor){
  return (sum(vetor) / length(vetor))
}
media2vetor = mediaFunc2(meuVetor)
print(media2vetor)

mediana2Func<-function(vetor){
  vetorOrdenado <- sort(vetor)
  tamanho <- length(vetor)
  #saber se é impar para pegar a posicao do meio correta
  if(tamanho %% 2 == 1){
    meio <- (tamanho + 1) / 2
    return(vetorOrdenado[meio])
  } else {
    meio1 <- tamanho / 2
    meio2 <- (tamanho / 2) + 1
    return((vetorOrdenado[meio1] + vetorOrdenado[meio2]) / 2)
  }
}

mediana2vetor = mediana2Func(meuVetor)
print(mediana2vetor)
