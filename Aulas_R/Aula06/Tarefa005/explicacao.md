# Tarefa 005 - Explicação do que foi feito

Arquivo com o código: `tarefa005_WellingtonTorres.R`
Base usada: `estimativa_pop_idade_sexo_esp.csv` (SEADE), com a estimativa de população dos
645 municípios de SP, de 2000 a 2023, por sexo e faixa etária. São 577.920 linhas e 6 colunas:
`ano`, `cod_ibge`, `nome_mun`, `sexo`, `idade`, `populacao`.

## Leitura

O arquivo está em **Latin-1** (conferido com `readr::guess_encoding()`) e usa `;` como
separador. Por isso usei `read_csv2()` com `locale(encoding = "LATIN1")`. Sem isso,
`Jundiaí` vira `Jundia�` e o filtro do exercício 1 volta vazio.

## Passo 0 - limpar antes de começar

Antes dos exercícios rodei `table(is.na(dados001$ano))` e `table(dados001$idade)`. Isso
mostrou dois problemas que não dão erro, mas estragam o resultado:

| Problema | Quantidade | Efeito se não tratar |
|----------|------------|----------------------|
| Linhas vazias no fim do arquivo (`;;;;;`) | 1.290 | Aparece um grupo `NA` nos exercícios 7 e 8 |
| Linha `idade == "Total"` para cada município/ano/sexo | 30.960 | Toda soma de população sai **dobrada** |

A linha "Total" já é a soma das faixas daquele município. Se ela fica na base, o
`sum(populacao)` conta cada pessoa duas vezes: uma na faixa dela e outra no "Total".
Por isso todos os exercícios usam a base limpa `pop`:

```r
pop <- dados001 %>%
  filter(!is.na(ano), idade != "Total")
```

## Exercício por exercício

| # | Pedido | Função | Resultado |
|---|--------|--------|-----------|
| 1 | Município = Jundiaí | `filter(nome_mun == "Jundiaí")` | 846 linhas |
| 2 | Colunas nome_mun, sexo, populacao | `select(nome_mun, sexo, populacao)` | 545.670 × 3 |
| 3 | Ano 2023 e Mulheres | `filter(ano == 2023, sexo == "Mulheres")` | 23.103.775 mulheres no estado |
| 4 | População em milhares | `mutate(pop_milhares = populacao / 1000)` | nova coluna `pop_milhares` |
| 5 | Top 10 por população | `arrange(desc(populacao)) %>% head(10)` | ver abaixo |
| 6 | Soma por município em 2023 | `group_by(nome_mun) %>% summarise(sum(...))` | 645 municípios, 44.539.225 habitantes |
| 7 | Média por faixa etária em 2023 | `group_by(idade) %>% summarise(mean(...))` | 19 faixas (ver abaixo) |
| 8 | Contagem por sexo | `count(sexo)` | 272.835 Homens e 272.835 Mulheres |
| 9 | População > 5000 | `filter(populacao > 5000)` | 32.894 registros |
| 10 | Renomear nome_mun | `rename(municipio = nome_mun)` | coluna renomeada |

### Detalhes que valem atenção

**Exercício 1 - por que 846 linhas?** Jundiaí tem 24 anos × 2 sexos, mas o número de faixas
muda: de 2000 a 2010 a última faixa é `75 e +` (16 faixas); de 2011 em diante ela é aberta em
`75 a 79` … `90 e +` (19 faixas). A conta: 11 × 2 × 16 + 13 × 2 × 19 = 352 + 494 = **846**.

**Exercício 5 - "top 10" de quê?** O enunciado não diz, então fiz dos dois jeitos:

- **5a (literal):** ordenando os *registros*, os 10 primeiros são todos de São Paulo, mulheres
  de 20 a 34 anos (o maior é 2010, 25 a 29 anos, com 554.514). Está correto, mas diz pouco.
- **5b (mais útil):** os 10 *municípios* mais populosos em 2023, agrupando antes de ordenar:

| # | Município | População 2023 |
|---|-----------|----------------|
| 1 | São Paulo | 11.429.865 |
| 2 | Guarulhos | 1.293.335 |
| 3 | Campinas | 1.140.133 |
| 4 | São Bernardo do Campo | 811.198 |
| 5 | Santo André | 752.784 |
| 6 | Sorocaba | 733.301 |
| 7 | Osasco | 731.127 |
| 8 | Ribeirão Preto | 704.874 |
| 9 | São José dos Campos | 700.311 |
| 10 | São José do Rio Preto | 485.356 |

**Exercício 6 - conferência.** A soma por município (44.539.225) é igual à soma das linhas
"Total" de 2023 que foram retiradas no passo 0. Isso prova que a limpeza não perdeu nem
duplicou ninguém. Se o "Total" não tivesse sido retirado, o resultado seria o dobro.

**Exercício 7 - o que essa média significa.** Cada linha é *um município + um sexo*, então a
média é "quantas pessoas, em média, um município tem naquela faixa, para um sexo". As faixas
de 35 a 44 anos têm as maiores médias (cerca de 2.800-2.900) e a de 90 anos ou mais, a menor
(144). Essa média é puxada para cima por São Paulo, porque a maioria dos municípios é pequena.

**Exercício 8 - por que deu empate?** Cada município/ano/faixa tem exatamente uma linha de
Homens e uma de Mulheres. Então o `count()` conta **linhas**, não pessoas, e por isso empata.
Para contar pessoas seria `summarise(sum(populacao))`.

**Exercício 9.** Como cada registro é uma faixa de 5 anos de um sexo, passar de 5.000 só
acontece em municípios médios e grandes: são 32.894 dos 545.670 registros (6%).

## group_by + summarise × filter

Os exercícios mostram a diferença entre as duas famílias de funções:

- `filter`, `select`, `mutate`, `arrange` e `rename` **mantêm uma linha por registro**
  (exercícios 1, 2, 3, 4, 9 e 10);
- `group_by` + `summarise` **reduzem a uma linha por grupo** (exercícios 6, 7 e 8). Foi isso
  que permitiu o 5b responder sobre municípios em vez de linhas soltas.
