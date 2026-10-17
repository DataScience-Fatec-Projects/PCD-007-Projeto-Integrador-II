# Aulas 07 e 08 - dplyr (revisão) + gráficos com ggplot2

Material original do professor: `resumo.txt` (mantido como veio).
Ele foi dividido nos arquivos abaixo. Estude nesta ordem:

| Arquivo | O que tem |
|---------|-----------|
| `01_revisao_dplyr.R` | Revisão das 6 funções do dplyr + pipe, com `mtcars` (mesmo conteúdo da Aula 06) |
| `02_ggplot2_exemplos.R` | Os 20 tipos de gráfico mostrados em aula, com `mtcars`, `iris`, `diamonds` e `economics` |
| `03_ggplot2_exercicios.R` | Os 20 exercícios **sem resposta**, para tentar sozinho |
| `04_ggplot2_respostas.R` | Respostas corrigidas, com interpretação conferida nos dados |

Pacotes necessários: `dplyr`, `ggplot2`, `ISLR`
(`install.packages(c("dplyr", "ggplot2", "ISLR"))` se faltar algum).

## A ideia central do ggplot2

Todo gráfico é montado em camadas somadas com `+`:

```r
ggplot(DADOS, aes(x = coluna1, y = coluna2, color = coluna3)) +  # dados + mapeamento
  geom_point() +                                                 # forma geométrica
  labs(title = "Título", x = "Eixo X", y = "Eixo Y") +           # rótulos
  theme_minimal()                                                # aparência (opcional)
```

- **`aes()`** liga uma *coluna* a uma propriedade visual (`x`, `y`, `color`, `fill`, `size`, `label`).
- **Fora do `aes()`** é um valor fixo: `geom_bar(fill = "steelblue")` pinta tudo de azul.
- **`color`** pinta contorno/ponto/linha; **`fill`** pinta o interior (barra, área, violino).
- `factor(cyl)` vira categoria (cores separadas); `cyl` numérico vira degradê (exemplo 2).

## Os 20 gráficos e quando usar

| # | Função-chave | Use para | Exercício (base ISLR) |
|---|--------------|----------|------------------------|
| 1 | `geom_point()` | Relação entre 2 números | Auto: horsepower × mpg |
| 2 | `aes(color = factor(...))` | Separar grupos por cor | Auto: weight × mpg por origin |
| 3 | `aes(size = ...)`, `alpha` | Terceira variável numérica | Auto: tamanho = horsepower |
| 4 | `geom_bar()` | **Contar** linhas por categoria | Carseats: Urban |
| 5 | `geom_col()` / `stat = "identity"` + `coord_flip()` + `reorder()` | Barras com **valor já calculado**, ordenadas | Carseats: média de Sales por ShelveLoc |
| 6 | `geom_bar(position = "dodge")` | Comparar subgrupos lado a lado | Carseats: Urban × ShelveLoc |
| 7 | `geom_bar(position = "stack")` | Ver o total e a composição | idem, empilhado |
| 8 | `geom_histogram(binwidth = )` | Distribuição de 1 número | Wage: wage |
| 9 | `geom_boxplot()` | Mediana, quartis e outliers por grupo | Wage: wage × education |
| 10 | `geom_violin()` | Formato da distribuição por grupo | idem |
| 11 | `geom_density()` | Distribuição suavizada, grupos sobrepostos | Smarket: Today por Direction |
| 12 | `geom_line()` | Evolução no tempo | Smarket: volume médio por ano |
| 13 | `geom_area()` | Evolução enfatizando magnitude | idem |
| 14 | `geom_smooth(method = "loess")` | Tendência que pode curvar | Auto: horsepower × mpg |
| 15 | `facet_wrap(~var)` | Um painel por categoria | Auto: por origin |
| 16 | `facet_grid(linha ~ coluna)` | Grade de painéis com 2 categorias | Carseats: ShelveLoc ~ Urban |
| 17 | `theme_minimal()` | Visual limpo | Wage: age × wage |
| 18 | `annotate("text", ...)` | Escrever um texto fixo no gráfico | Auto: weight × mpg |
| 19 | `geom_text(aes(label = ...))` | Nome em cada ponto | Auto com horsepower > 200 |
| 20 | `geom_smooth(method = "lm")` | Reta de regressão linear | Auto: weight × mpg |

### Pegadinhas que caem nos exercícios

- **`geom_bar()` vs `geom_col()`**: `geom_bar()` conta sozinho (só precisa de `x`).
  Se você já calculou a média e tem `y`, use `geom_col()` (ou `geom_bar(stat = "identity")`).
- **Exercícios 5 e 12** pedem para resumir *antes* de plotar. O professor mostrou dois jeitos
  equivalentes: `aggregate(Sales ~ ShelveLoc, data = ..., FUN = mean)` (R base) e
  `group_by(ShelveLoc) %>% summarise(Sales = mean(Sales))` (dplyr).
- **`origin` no Auto é número** (1 = EUA, 2 = Europa, 3 = Japão). Para virar cor por categoria
  precisa de `factor(origin)`.
- **Exercício 11**: `Direction` é derivada do sinal de `Today`, então as densidades Up/Down
  não se sobrepõem por construção - não é uma "descoberta".

## O que foi corrigido em relação ao `resumo.txt`

| Onde | Problema | Correção |
|------|----------|----------|
| Linha 1 | `ibrary(dplyr)` (faltou o `l`) | `library(dplyr)` |
| Antes do exercício 4 | `dados001ISLR::Carseats` dá erro de sintaxe e trava o script inteiro | Removido (não era usado) |
| Resposta 15 | Usava `facet_wrap(~cylinders)`, mas o enunciado pede `~origin` | `facet_wrap(~origin)` |
| Resposta 6 | Título "Lojas por localização e país", mas o gráfico é por prateleira | Título ajustado |
| Resposta 3 | Usava `alpha = 0.2`, o enunciado pede `0.6` | `alpha = 0.6` |

Linhas soltas de inspeção (`mtcars`, `ISLR::Auto`, `MTCARS <- mtcars` etc.) foram
retiradas dos scripts organizados; continuam no `resumo.txt`.

## Respostas com números (resumo)

- **Auto**: correlação potência × mpg = **-0,78**; peso × mpg = **-0,83**. A reta da
  regressão (ex. 20) tem inclinação **-0,0076**: cada 1.000 lb a mais custam ~7,6 mpg.
  Carros americanos pesam em média 3.372 lb contra ~2.200-2.400 dos europeus/japoneses.
- **Carseats**: 282 lojas urbanas × 118 não urbanas. Média de vendas: Good **10,2**,
  Medium **7,3**, Bad **5,5**.
- **Wage**: mediana do salário sobe com a escolaridade, de **81,3** (< HS Grad) a **141,8**
  (Advanced Degree). Distribuição assimétrica à direita (média 111,7 > mediana 104,9), com
  um grupo isolado de salários altos acima de 270.
- **Smarket**: volume médio sobe de **1,23** (2001) para **1,92** (2005), com leve queda em 2003.
- **Auto, potência > 200 HP**: 10 carros, todos com 10 a 16 mpg.

## Entregas pendentes

O `resumo.txt` não traz tarefa para entrega. A última tarefa com enunciado é a
**Tarefa 005** (`../Aula06/Tarefa005/tarefa005_instrucao.txt`), que usa dplyr sobre
`estimativa_pop_idade_sexo_esp.csv` - a revisão do `01_revisao_dplyr.R` cobre tudo o que ela pede.
