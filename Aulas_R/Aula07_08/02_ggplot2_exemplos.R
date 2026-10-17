# AULAS 07 e 08 - Parte 2: exemplos de ggplot2 dados em aula
# Bases de exemplo (já vêm com o R / ggplot2): mtcars, iris, diamonds, economics
#
# Receita de todo gráfico:
#   ggplot(DADOS, aes(x = ..., y = ..., color/fill/size = ...)) +
#     geom_TIPO() +          # que forma desenhar (ponto, barra, linha...)
#     labs(title = ...) +    # títulos e rótulos
#     facet_/theme_/...      # opcionais: painéis, aparência
# ------------------------------------------------------------

library(ggplot2)

# =================== 1. Dispersão simples ===================
ggplot(mtcars, aes(x = wt, y = mpg)) +        # Define dados e mapeia eixos
  geom_point() +                              # Adiciona os pontos
  labs(title = "Peso vs Consumo")             # Título

# =================== 2. Dispersão com cor por categoria ===================
# factor(cyl) -> cores distintas (legenda por categoria)
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  labs(title = "Dispersão por Número de Cilindros")

# cyl numérico -> degradê contínuo (compare com o gráfico acima)
ggplot(mtcars, aes(x = wt, y = mpg, color = cyl)) +
  geom_point() +
  labs(title = "Dispersão por Número de Cilindros")

# =================== 3. Dispersão com variação de tamanho ===================
ggplot(mtcars, aes(x = wt, y = mpg, size = hp)) +     # Tamanho do ponto = hp
  geom_point(alpha = 0.3) +                           # alpha = transparência (0 a 1)
  labs(title = "Dispersão com Tamanho por HP")

# =================== 4. Gráfico de barras (contagem) ===================
ggplot(mtcars, aes(x = factor(cyl))) +        # geom_bar conta as linhas sozinho
  geom_bar(fill = "steelblue") +
  labs(title = "Contagem de Cilindros")

# =================== 5. Barras horizontais (valor pronto) ===================
ggplot(mtcars, aes(x = reorder(row.names(mtcars), mpg), y = mpg)) +  # Ordena modelos por mpg
  geom_bar(stat = "identity", fill = "lightblue") +                  # Usa o valor de y (= geom_col)
  coord_flip() +                                                     # Inverte os eixos
  labs(title = "MPG por Modelo", x = "Modelo")

# =================== 6. Barras lado a lado ===================
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge") +                     # Lado a lado
  labs(title = "Clareza por Tipo de Corte")

# =================== 7. Barras empilhadas ===================
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "stack") +                     # Empilhadas
  labs(title = "Corte de Diamantes (Empilhado)")

# =================== 8. Histograma ===================
ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram(binwidth = 0.3, fill = "salmon", color = "black") +  # binwidth = largura da faixa
  labs(title = "Histograma do Comprimento da Sépala")

# =================== 9. Boxplot ===================
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Boxplot por Espécie")

# =================== 10. Violin plot ===================
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin(fill = "lightgreen") +
  labs(title = "Violin Plot por Espécie")

# =================== 11. Densidade ===================
ggplot(iris, aes(x = Petal.Length, fill = Species)) +
  geom_density(alpha = 0.5) +
  labs(title = "Densidade por Espécie")

# =================== 12. Linha (série temporal) ===================
ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line(color = "purple") +
  labs(title = "Desemprego ao Longo do Tempo")

# =================== 13. Área ===================
ggplot(economics, aes(x = date, y = psavert)) +
  geom_area(fill = "skyblue") +
  labs(title = "Poupança Pessoal nos EUA")

# =================== 14. Tendência com LOESS ===================
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "loess", color = "red") +     # Curva suavizada (pode curvar)
  labs(title = "Tendência: Peso vs MPG")

# =================== 15. Facetas com wrap ===================
ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
  geom_point() +
  facet_wrap(~Species) +                             # Um painel por espécie
  labs(title = "Facetas por Espécie")

# =================== 16. Facetas em grade ===================
ggplot(diamonds, aes(x = price, fill = cut)) +
  geom_histogram(binwidth = 500) +
  facet_grid(cut ~ clarity) +                        # linhas ~ colunas
  labs(title = "Preço por Corte e Clareza")

# =================== 17. Tema minimalista ===================
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "Gráfico com Tema Minimal")

# =================== 18. Anotação com texto ===================
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  annotate("text", x = 5, y = 30, label = "Exemplo anotado", color = "blue") +
  labs(title = "Gráfico com Anotação")

# =================== 19. Rótulos nos pontos ===================
ggplot(mtcars, aes(x = wt, y = mpg, label = rownames(mtcars))) +
  geom_point() +
  geom_text(size = 3, vjust = -0.5) +                # vjust negativo = texto acima do ponto
  labs(title = "Labels nos Pontos")

# =================== 20. Regressão linear ===================
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "darkgreen") +  # Reta (se = FALSE tira a faixa)
  labs(title = "Regressão Linear: HP vs MPG")
