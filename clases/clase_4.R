# Clase 4: Transformación con tidyr y visualización con ggplot2
# Introducción al análisis de datos con R para ciencias sociales
# 2026-06-29
# Bastián Olea Herrera - https://bastianolea.rbind.io - bastianolea@gmail.com

# diapositivas: https://bastianolea.github.io/curso_intro_R_3/

# en esta clase veremos:
# 1) transformar la estructura de los datos con {tidyr} (pivotar)
# 2) crear gráficos con {ggplot2}

# cargar paquetes ----
library("readxl") # para cargar archivos Excel
library("dplyr") # para manipular datos
library("stringr") # para trabajar con texto

# install.packages("tidyr")
library("tidyr") # para transformar la estructura de los datos


# transformar estructura de datos ----
# {tidyr} nos permite cambiar la forma de una tabla:
# - de formato ancho (variables en columnas) a largo (variables en filas): pivot_longer()
# - de largo a ancho: pivot_wider()

# cargamos estimaciones de población (viene en formato ancho: una columna por año)
poblacion <- read_xlsx("estimaciones_poblacion.xlsx")

# exploramos su estructura
poblacion |> glimpse()
poblacion |> count(sexo)
poblacion |> distinct(edad) |> pull()
poblacion |> names()
poblacion |> dim()

# tener un año por columna es cómodo para leer, pero no para procesar datos
# (por ejemplo, no podemos filtrar o agrupar fácilmente por año)

## de ancho a largo: pivot_longer() ----
# pivot_longer() junta muchas columnas en dos: una de nombres y otra de valores

# indicando el rango de columnas por nombre
poblacion |> pivot_longer(cols = `1992`:`2070`)

# o tomando todas las columnas numéricas (los años)
poblacion |> pivot_longer(cols = where(is.numeric))

# con names_to y values_to elegimos los nombres de las columnas resultantes
poblacion |>
  pivot_longer(
    cols = where(is.numeric),
    names_to = "año",
    values_to = "poblacion"
  )

# guardamos el resultado en un objeto en formato largo
poblacion_largo <- poblacion |>
  pivot_longer(
    cols = where(is.numeric),
    names_to = "año",
    values_to = "poblacion"
  )

poblacion_largo

# ahora sí podemos filtrar por año y edad fácilmente
poblacion_largo |>
  filter(año == 2026) |>
  filter(edad == 33)


## resumir los datos en formato largo ----

# población total proyectada por año
poblacion_total <- poblacion_largo |>
  group_by(año) |>
  summarise(total = sum(poblacion))

poblacion_total

# población por año y sexo, entre 2010 y 2030
poblacion_sexo <- poblacion_largo |>
  group_by(año, sexo) |>
  summarise(total = sum(poblacion)) |>
  filter(año >= 2010, año <= 2030)

poblacion_sexo


## de largo a ancho: pivot_wider() ----
# pivot_wider() hace lo contrario: crea una columna por cada valor de "sexo"
poblacion_sexo_ancho <- poblacion_sexo |>
  pivot_wider(names_from = sexo, values_from = total)

poblacion_sexo_ancho


## guardar resultados en Excel ----
# install.packages("writexl")
library("writexl")

poblacion_sexo_ancho |>
  write_xlsx("poblacion_proyeccion_2010-2030_sexo.xlsx")


# visualización de datos: {ggplot2} ----
# ggplot2 construye gráficos por capas, que se van sumando con el operador +

# install.packages("ggplot2")
library("ggplot2")

# un ggplot() vacío produce un lienzo en blanco
ggplot()

# usaremos el objeto "datos_rank" que construimos en la clase 3.
# si ya ejecutaste la clase 3, lo tienes en tu entorno; si no, lo recreamos aquí:
datos <- read_xlsx("estimaciones_pobreza.xlsx")
clasificacion <- read_xlsx("clasificacion.xlsx")

datos_rank <- datos |>
  rename(censo = personas_proy) |>
  select(region, comuna, censo, personas) |>
  mutate(porcentaje = (personas / censo) * 100) |>
  mutate(nivel = ifelse(porcentaje > 20, "Alto", "Bajo")) |>
  # unir con la clasificación comunal (arreglando los nombres de comuna)
  left_join(
    clasificacion |>
      select(comuna, clasificacion) |>
      mutate(comuna = str_to_title(comuna)) |>
      mutate(comuna = str_replace(comuna, "O'higgins", "O’higgins"))
  ) |>
  arrange(region, desc(personas)) |>
  group_by(region) |>
  mutate(ranking = 1:n()) |>
  ungroup()


## gráfico de puntos y de barras ----
# aes() define qué variable va en cada eje (x, y)

# gráfico de puntos: personas en pobreza por comuna en Antofagasta
datos_rank |>
  filter(region == "Antofagasta") |>
  ggplot() +
  aes(x = personas, y = comuna) +
  geom_point()

# el mismo gráfico con barras: geom_col() dibuja barras según el valor
datos_rank |>
  filter(region == "Antofagasta") |>
  ggplot() +
  aes(x = personas, y = comuna) +
  geom_col()


## color según una variable ----
# cuando fill va dentro de aes(), el color se asigna según los valores de una variable

# colorear las barras según la clasificación de la comuna
datos_rank |>
  filter(region == "Maule") |>
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col()

# colorear según el nivel de pobreza
datos_rank |>
  filter(region == "Maule") |>
  ggplot() +
  aes(x = personas, y = comuna, fill = nivel) +
  geom_col()


## ordenar categorías con {forcats} ----
# las variables de texto se ordenan alfabéticamente por defecto;
# para cambiar el orden de las categorías las convertimos en factores

# install.packages("forcats")
library("forcats")

# fct_relevel() define un orden manual de las categorías
# fct_reorder() ordena una variable según los valores de otra (aquí, personas)
datos_rank |>
  mutate(
    clasificacion = fct_relevel(clasificacion, "Rural", "Mixta", "Urbana")
  ) |>
  mutate(comuna = fct_reorder(comuna, personas)) |>
  filter(region == "Biobío") |>
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col()


## personalizar colores y tema ----
# scale_fill_discrete() define los colores de las categorías
# theme_minimal() cambia la apariencia general (aquí, con colores personalizados)
datos_rank |>
  mutate(
    clasificacion = fct_relevel(clasificacion, "Rural", "Mixta", "Urbana")
  ) |>
  mutate(comuna = fct_reorder(comuna, personas)) |>
  filter(region == "Biobío") |>
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col() +
  scale_fill_discrete(palette = c("#AC558A", "#666BC7", "#553A74")) +
  theme_minimal(
    paper = "#feeafa", # color de fondo
    ink = "#553A74", # color del texto
    accent = "#da627d" # color de acento
  )


# gráficos de dispersión ----
# geom_point() dibuja un punto por observación;
# sirve para ver la relación entre dos variables numéricas

# para este gráfico cruzaremos pobreza con escolaridad (datos de educación)
educacion <- read_xlsx("educacion.xlsx")

# nos quedamos con el total comunal y las columnas de escolaridad,
# y renombramos "codigo_comuna" para que coincida con la tabla de pobreza
educacion_comuna <- educacion |>
  filter(sexo == "Total Comuna") |>
  select(codigo_comuna, starts_with("escolaridad")) |>
  rename(codigo = codigo_comuna)

# unimos pobreza y educación por el código de comuna
pobreza_educ <- datos |>
  mutate(codigo = as.numeric(codigo)) |>
  select(codigo:porcentaje) |>
  left_join(educacion_comuna, by = "codigo")

pobreza_educ

# dispersión básica: personas en pobreza vs. años de escolaridad (un punto por comuna)
# alpha controla la transparencia (0 = invisible, 1 = opaco), útil cuando hay muchos puntos
pobreza_educ |>
  ggplot() +
  aes(x = personas, y = escolaridad) +
  geom_point(alpha = 0.3)

# podemos mapear una tercera variable al tamaño de los puntos (size)
pobreza_educ |>
  ggplot() +
  aes(x = porcentaje, y = escolaridad, size = personas_proy) +
  geom_point(alpha = 0.3)


## construir un gráfico por capas ----
# podemos guardar un gráfico en un objeto e ir sumándole capas paso a paso

# capa base: puntos, color fijo y un tema minimalista
grafico <- pobreza_educ |>
  ggplot() +
  aes(x = porcentaje, y = escolaridad, size = personas_proy) +
  geom_point(color = "#553A74", alpha = 0.5) +
  theme_minimal(
    paper = "#feeafa", # color de fondo
    ink = "#553A74", # color del texto
    accent = "#da627d" # color de acento
  )

grafico

# el paquete {scales} permite formatear los números de los ejes y leyendas
# install.packages("scales")
library("scales")

# formateamos la leyenda de tamaño con separador de miles
grafico_2 <- grafico +
  scale_size_continuous(labels = label_comma())

grafico_2

# agregamos títulos y nombres de ejes con labs()
# labs() define título, subtítulo, nombres de ejes, leyendas y fuente (caption)
grafico_3 <- grafico_2 +
  labs(
    title = "Relación entre escolaridad y pobreza",
    subtitle = "Comunas de Chile",
    x = "Porcentaje de población en situación de pobreza",
    y = "Años promedio de escolaridad",
    size = "Población",
    caption = "Fuente: Casen 2022, Censo 2024"
  )

grafico_3

# guardamos el gráfico como imagen con ggsave()
# guarda el último gráfico mostrado; width y height van en pulgadas, dpi es la resolución
ggsave("pobreza_educacion.png", width = 8, height = 5, dpi = 300)


## destacar un grupo con color ----
# creamos una variable para distinguir la Región Metropolitana del resto
datos_grafico <- pobreza_educ |>
  mutate(
    destacar = ifelse(
      region == "Metropolitana",
      "Metropolitana",
      "Resto del país"
    )
  )

# gráfico final integrando todas las capas: mapeos, geometría, escalas, tema y textos
datos_grafico |>
  ggplot() +
  aes(x = porcentaje, y = escolaridad, size = personas_proy, color = destacar) +
  geom_point(alpha = 0.5) +
  scale_size_continuous(labels = label_comma()) +
  scale_color_manual(values = c("#da627d", "#D7A8CF")) +
  theme_minimal(
    paper = "#feeafa",
    ink = "#553A74",
    accent = "#da627d"
  ) +
  labs(
    title = "Relación entre escolaridad y pobreza",
    subtitle = "Comunas de Chile",
    x = "Porcentaje de población en situación de pobreza",
    y = "Años promedio de escolaridad",
    size = "Población",
    color = "Región",
    caption = "Fuente: Censo 2024, Casen 2022"
  )

# guardamos este gráfico
ggsave("pobreza_educacion_region.png", width = 8, height = 5, dpi = 300)


# gráficos de líneas: proyección de población ----
# para mostrar una cantidad a lo largo del tiempo usamos líneas (geom_line)
# reutilizamos "poblacion_largo", que creamos antes en la sección de {tidyr}

# población total proyectada por año
# la columna "año" es texto, así que la convertimos a número para usarla en el eje x
poblacion_largo |>
  group_by(año) |>
  summarise(poblacion = sum(poblacion)) |>
  mutate(año = as.numeric(año)) |>
  filter(año > 1990, año < 2030) |> # nos quedamos con un rango de años
  ggplot() +
  aes(x = año, y = poblacion) +
  geom_line() +
  geom_point() +
  theme_minimal()

# gráfico completo, agregando capas:
# - geom_vline() dibuja una línea vertical para marcar el año del censo (2024)
# - scale_y_continuous() con label_number() muestra el eje Y en millones
poblacion_largo |>
  group_by(año) |>
  summarise(poblacion = sum(poblacion)) |>
  mutate(año = as.numeric(año)) |>
  filter(año > 1990, año < 2030) |>
  ggplot() +
  aes(x = año, y = poblacion) +
  geom_vline(xintercept = 2024, linetype = "dashed") + # marca del censo
  geom_line(linewidth = 1, alpha = 0.6) +
  geom_point(size = 1.3, alpha = 0.6) +
  scale_y_continuous(
    labels = label_number(scale = 0.000001, suffix = " millones"),
    limits = c(0, NA) # el eje parte desde 0
  ) +
  theme_minimal(
    paper = "#feeafa",
    ink = "#553A74",
    accent = "#da627d"
  ) +
  labs(
    title = "Proyecciones de población",
    subtitle = "Censo 2024, Chile",
    x = NULL, # NULL elimina la etiqueta del eje
    y = "Proyección de población"
  )

ggsave("proyeccion_poblacion.png", width = 8, height = 5, dpi = 300)


## una línea por sexo ----
# es el mismo código, pero agregamos "sexo" al group_by() y al color (aes)
poblacion_largo |>
  group_by(año, sexo) |>
  summarise(poblacion = sum(poblacion)) |>
  mutate(año = as.numeric(año)) |>
  filter(año > 1990, año < 2030) |>
  ggplot() +
  aes(x = año, y = poblacion, color = sexo) + # una línea de color por sexo
  geom_vline(xintercept = 2024, linetype = "dashed") +
  geom_line(linewidth = 1, alpha = 0.6) +
  geom_point(size = 1.3, alpha = 0.6) +
  scale_y_continuous(
    labels = label_number(scale = 0.000001, suffix = " millones"),
    limits = c(0, NA)
  ) +
  scale_color_manual(values = c("Mujeres" = "#da627d", "Hombres" = "#553A74")) +
  theme_minimal(
    paper = "#feeafa",
    ink = "#553A74",
    accent = "#da627d"
  ) +
  labs(
    title = "Proyecciones de población por sexo",
    subtitle = "Censo 2024, Chile",
    x = NULL,
    y = "Proyección de población",
    color = "Sexo"
  )

ggsave("proyeccion_poblacion_sexo.png", width = 8, height = 5, dpi = 300)
