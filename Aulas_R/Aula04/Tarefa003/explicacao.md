# Tarefa 003 - Explicacao do que foi feito

Arquivo com o codigo: `tarefa003.R`
Base usada: `Carseats`, do pacote `ISLR` (400 linhas e 11 colunas).

## Como a base e organizada

Antes de filtrar qualquer coisa rodei um `str(dados001)` para conferir os tipos das
colunas. Isso importa porque duas colunas do enunciado nao sao texto comum:

- `ShelveLoc` e um **factor** com 3 niveis: `Bad`, `Good` e `Medium`
- `Urban` e um **factor** com 2 niveis: `No` e `Yes`

Ou seja, a comparacao precisa usar exatamente esses nomes, com a mesma
maiuscula/minuscula. O enunciado escreveu `shelveloc`, `medium` e `Urbancarseats`
de forma informal, mas no R eu tive que escrever `ShelveLoc`, `"Medium"` e `Urban`,
senao o R nao encontra a coluna (`NULL`) ou nao encontra o nivel (0 linhas).

## A ideia do filtro

Todos os exercicios usam a mesma ideia: colchetes com **linha e coluna**, no formato
`dataframe[condicao_das_linhas, ]`.

```r
dados001[dados001$ShelveLoc == "Bad", ]
```

A condicao dentro do colchete devolve um vetor de `TRUE`/`FALSE` com 400 posicoes
(uma por loja). O R fica so com as linhas onde deu `TRUE`. A virgula antes do
fechamento e importante: ela diz "todas as colunas". Sem a virgula o R acha que
estou selecionando colunas e o resultado sai errado.

Quando sao duas condicoes ao mesmo tempo eu uso o `&` (E logico), que so devolve
`TRUE` quando as duas condicoes valem **na mesma linha**.

## Exercicio por exercicio

| # | Pedido | Objeto criado | Codigo | Linhas |
|---|--------|---------------|--------|--------|
| 1 | ShelveLoc == Bad | `badcarseats` | `dados001[dados001$ShelveLoc == "Bad", ]` | 96 |
| 2 | Urban == Yes | `Urbancarseats` | `dados001[dados001$Urban == "Yes", ]` | 282 |
| 3 | CompPrice > 110 | `compPrice110` | `dados001[dados001$CompPrice > 110, ]` | 334 |
| 4 | CompPrice > 110 e ShelveLoc == Good | `goodCompPrice110` | `dados001[dados001$CompPrice > 110 & dados001$ShelveLoc == "Good", ]` | 73 |
| 5 | CompPrice > 110 e ShelveLoc == Medium | `mediumCompPrice110` | `dados001[dados001$CompPrice > 110 & dados001$ShelveLoc == "Medium", ]` | 182 |
| 6 | Juntar 1 e 2 num df unico | `badUrbancarseats` | `rbind(badcarseats, Urbancarseats)` | 378 (304 sem repetir) |

Nos exercicios 1 a 3 o filtro e direto. Nos exercicios 4 e 5 a diferenca e so o `&`,
que estreita o resultado: dos 334 produtos com `CompPrice > 110`, 73 estao em
prateleira `Good` e 182 em prateleira `Medium` (os 79 restantes estao em `Bad`).

## Exercicio 6 - o detalhe da linha repetida

Para juntar os dois data.frames usei `rbind()`, que **empilha as linhas** um embaixo
do outro. Ele funciona aqui porque `badcarseats` e `Urbancarseats` sairam da mesma
base, entao tem as mesmas 11 colunas, na mesma ordem e com os mesmos tipos.
(`cbind` nao serviria: ele colaria lado a lado, criando colunas duplicadas.)

So que 96 + 282 = **378**, e a base inteira so tem 400 linhas. O motivo e que os dois
filtros se sobrepoem: uma loja urbana com prateleira ruim atende as duas condicoes e
por isso aparece duas vezes no `rbind`.

Para tratar isso apliquei `unique()`, que remove as linhas identicas:

```r
badUrbancarseatsSemRepetir <- unique(badUrbancarseats)
```

Resultado: **74 linhas repetidas removidas**, sobrando **304 linhas**. O numero fecha
com a regra de conjuntos (uniao = A + B - interseccao): 96 + 282 - 74 = 304. Ou seja,
existem 74 lojas que sao `Bad` e `Urban` ao mesmo tempo.

Deixei os dois objetos no script (`badUrbancarseats` com repeticao e
`badUrbancarseatsSemRepetir` sem repeticao) porque o enunciado pede so a juncao, mas
a versao sem duplicata e a que representa de verdade "um data.frame unico".

## Saida do script

No fim o script monta uma tabela de resumo com a contagem de linhas de cada filtro:

```
                            filtro linhas
1                      badcarseats     96
2                    Urbancarseats    282
3                     compPrice110    334
4                 goodCompPrice110     73
5               mediumCompPrice110    182
6 badUrbancarseats (com repeticao)    378
7 badUrbancarseats (sem repeticao)    304
```

## Resumo - o que a atividade ensina

O tema da tarefa e **filtrar linhas de um data.frame**, a operacao mais basica de
manipulacao de dados em R. Os pontos que ficam:

1. **Indexacao `[linha, coluna]`** - `dados[condicao, ]`, com a virgula: filtra linhas
   e mantem todas as colunas. E o que separa "escolher registros" de "escolher variaveis".

2. **Vetor logico como filtro** - `dados001$ShelveLoc == "Bad"` nao devolve dados,
   devolve 400 `TRUE`/`FALSE`. O R fica so com as posicoes `TRUE`. O filtro e uma
   *mascara*, nao uma busca.

3. **Operadores logicos** - os exercicios 4 e 5 existem para exercitar o `&` (E), que
   exige as duas condicoes verdadeiras na mesma linha. Na mesma linha de raciocinio
   vem o `|` (OU) e o `!` (negacao).

4. **Factor nao e texto** - `ShelveLoc` e `Urban` sao factors com niveis fixos.
   Comparar com `"medium"` minusculo devolve zero linhas **sem dar erro**, o que
   engana. Dai o habito de rodar `str()` antes de filtrar.

5. **`rbind()` e sobreposicao de filtros** - empilhar exige as mesmas colunas, e somar
   dois filtros nao e o mesmo que uni-los: 96 + 282 = 378 numa base de 400 linhas
   porque 74 registros atendem as duas condicoes. E nocao de conjuntos
   (uniao = A + B - interseccao) aplicada a dados, e o motivo de existir o `unique()`.

Como pano de fundo, tudo isso e a versao em R base do que depois vira o `filter()` do
dplyr ou o `WHERE` do SQL - mesma ideia, escrita de outro jeito.

## Como rodar

O pacote `ISLR` precisa estar instalado uma vez:

```r
install.packages("ISLR")
```

Depois e so abrir o `tarefa003.R` no RStudio e rodar. Foi testado no R 4.6.1 com
`ISLR` 1.4 e rodou sem erro nem warning.
