#trabalho vetorial
x <- c(2/3,8.7,9.2,5.66666)   #carrega o vetor em x (c - componentes)
x 		                        #apresenta o vetor
sum(x)                      	#somar o vetor
length(x) 	                  #tamanho do vetor
sort (x)                    	#ordena em ordem crescente
sort (x, decreasing = T)      #ordena em ordem decrescente
x < 8.7                     	#retorna verdadeiro ou falso 
x [3] 	                    	#retorna o valor pos 3
x [3:4]                     	#retorna o valor pos 3 e 4 
x[c(1,4)] 	                  #retorna o valor 1 e o valor 4
NOTA.CORTE <-8.7              #variável
x[x <= 8.7] 	                #retorna valores da condição
which(x <= 8.7)               #localiza a condição
which(x <= NOTA.CORTE)        #localiza a condição
y <- which(x <= NOTA.CORTE)   #armazena a condição
y			                        #mosttra o vetor resultante
x[y] 		                      #mostra os valores da cond y
x[which(x <= NOTA.CORTE)]




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


