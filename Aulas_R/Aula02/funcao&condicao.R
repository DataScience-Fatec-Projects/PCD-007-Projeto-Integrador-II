#funcao
#exemplo 1
somaFunc<-function(a,b,c,d,e){
  resposta<-a+b+c+d+e
  return(resposta)
}

somaFunc(2,3,2,3,4)


armazenar<-somaFunc(2,3,2,3,7)

x1<-2
x2<-3
x3<-1
x4<-5
x5<-1

somaFunc(x1,x2,x3,x4,x5)

#exemplo 2
minhafuncao<-function(x,z,w){
  calculo<-x+z-2*w
  return(calculo)
}

x1<-3
x2<-4
x3<-1

res1<-minhafuncao(x1,x2,x3)
res1


#condicional (&& = e) (|| = ou)
x<-1.9
if (x>2&&x<4){
  z<-print("ok")
} else {
  z<-print("nao")
}

y<-3.999999

if (y<=3||y>5) {
  z<-"Verdadeiro"
} else {
  z<-"Falso"
}