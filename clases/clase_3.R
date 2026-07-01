# Clase 3: Resumir datos, cruces y transformación
# Introducción al análisis de datos con R para ciencias sociales
# 2026-06-25
# Bastián Olea Herrera - https://bastianolea.rbind.io - bastianolea@gmail.com

# diapositivas: https://bastianolea.github.io/curso_intro_R_3/

# en esta clase veremos:
# 1) crear y modificar columnas con mutate()
# 2) crear variables condicionales con ifelse() y case_when()
# 3) resumir datos con summarize() y group_by()
# 4) unir dos tablas con left_join()
# 5) crear rankings por grupo

# cargar paquetes ----
# recuerda: install.packages() solo la primera vez; library() cada vez que abres R

library("readxl") # para cargar archivos Excel
library("dplyr") # para manipular datos
library("stringr") # para trabajar con texto


# cargar datos ----
datos <- read_xlsx("estimaciones_pobreza.xlsx")

datos |> glimpse()


# crear y modificar columnas ----
# mutate() crea columnas nuevas o modifica columnas existentes

# crear una columna de texto con un valor fijo (igual para todas las filas)
datos |>
  select(1:3, 5) |>
  mutate(ejemplo = "hola")

# podemos crear una columna a partir de otra columna
datos |>
  select(1:3, 5) |>
  mutate(ejemplo = "hola") |>
  mutate(copia = personas) |>
  mutate(miles = personas / 1000)

# ordenamos los datos: renombramos, seleccionamos y creamos "miles"
datos_m <- datos |>
  rename(censo = personas_proy) |>
  select(region, comuna, censo, personas) |>
  mutate(miles = personas / 1000)

datos_m

# calculamos un porcentaje a partir de dos columnas
# (personas en pobreza dividido por la población del censo, multiplicado por 100)
datos_p <- datos_m |>
  mutate(porcentaje = personas / censo) |>
  mutate(porcentaje = porcentaje * 100)

datos_p


# redondear números ----
# round() redondea al número de decimales que indiquemos
datos_p |>
  mutate(miles = round(miles, 0))


# limpiar texto con {stringr} ----
# creamos una pequeña tabla de ejemplo con tibble() para practicar
trabajos <- tibble(
  persona = c(1, 2, 3, 4, 5),
  empleo = c(
    "sociólogo",
    "Socióloga",
    "soy sociólogo",
    "socioloco",
    "Sociólogx"
  )
)

# detectar quiénes son sociólog@s es difícil por las variantes de escritura
trabajos |>
  mutate(sociologx = str_detect(empleo, "sociólogo"))

# solución: primero pasamos todo a minúsculas y luego detectamos la raíz "sociólog"
trabajos |>
  mutate(empleo = str_to_lower(empleo)) |>
  mutate(sociologx = str_detect(empleo, "sociólog"))

# también podemos corregir el texto antes de detectar
trabajos |>
  mutate(empleo = str_to_lower(empleo)) |>
  mutate(empleo = str_replace(empleo, "socio", "soció")) |>
  mutate(empleo = str_replace(empleo, "socióloco", "sociólogo")) |>
  mutate(sociologx = str_detect(empleo, "sociólog"))


# variables condicionales con ifelse() ----
# ifelse(condición, valor_si_se_cumple, valor_si_no_se_cumple)

# antes de usarlo en una tabla, veamos cómo funciona por sí solo
edad <- 30
ifelse(edad > 18, "mayor", "menor")

# también funciona sobre un vector, evaluando cada elemento
edades <- c(17, 30, 31, 32, 44)
ifelse(edades > 18, "mayor", "menor")

# clasificamos las comunas según su porcentaje en "Alto" o "Bajo"
datos_cat <- datos_p |>
  mutate(nivel = ifelse(porcentaje > 20, yes = "Alto", no = "Bajo"))

datos_cat

# contamos cuántas comunas quedaron en cada nivel
datos_cat |> count(nivel)

# también podemos contar combinaciones de dos variables
datos_cat |>
  count(region, nivel) |>
  filter(nivel == "Alto") |>
  arrange(desc(n))


# variables con múltiples categorías: case_when() ----
# case_when() permite crear más de dos categorías
# se evalúa de arriba hacia abajo: gana la primera condición que se cumple

datos_cat_2 <- datos_cat |>
  mutate(
    nivel_2 = case_when(
      porcentaje > 30 ~ "Alto",
      porcentaje > 20 ~ "Medio",
      porcentaje > 10 ~ "Bajo",
      porcentaje <= 10 ~ "Muy bajo"
    )
  )

datos_cat_2

datos_cat_2 |> count(nivel_2)


# resumir datos ----
# summarize() reduce muchas filas a un solo resultado (suma, promedio, máximo, etc.)

# suma total de personas en situación de pobreza
datos_cat |> summarise(total = sum(personas))

# group_by() calcula el resumen por separado para cada grupo
# total de personas por región
datos_cat |>
  group_by(region) |>
  summarise(total_personas = sum(personas))

# podemos calcular varios resúmenes a la vez, incluyendo n() para contar filas
datos_cat_2 |>
  group_by(nivel_2) |>
  summarise(
    total_personas = sum(personas),
    total_censo = sum(censo),
    n_comunas = n()
  )


# resumir otra base: educación ----
# practiquemos con los datos de escolaridad del Censo 2024

educacion <- read_xlsx("educacion.xlsx")

educacion |> glimpse()

# exploramos las categorías de sus columnas
educacion |> count(region)
educacion |> count(sexo)

# la columna "sexo" trae filas de totales que no queremos al analizar por sexo;
# las eliminamos con filter_out()
educacion_2 <- educacion |>
  filter_out(region == "País") |>
  filter_out(sexo == "Total Comuna") |>
  filter_out(sexo == "Total País")

# promedio de escolaridad por región (usando los totales comunales)
educacion |>
  filter(sexo == "Total Comuna") |>
  group_by(region) |>
  summarize(escolaridad = mean(escolaridad))


# cruzar tablas: left_join() ----
# left_join() combina dos tablas a partir de una columna en común
# mantiene todas las filas de la tabla de la izquierda y pega columnas de la derecha

# cargamos la clasificación de comunas (urbana, mixta, rural)
clasificacion <- read_xlsx("clasificacion.xlsx")

# nos quedamos con las columnas que necesitamos
clasificacion_2 <- clasificacion |>
  select(comuna, clasificacion)

clasificacion_2

# para poder cruzar por "comuna", los nombres deben coincidir exactamente
# arreglamos el formato de los nombres de comuna en la tabla de clasificación
clasificacion_3 <- clasificacion_2 |>
  mutate(comuna = str_to_title(comuna)) |>
  mutate(comuna = str_replace(comuna, "O'higgins", "O’higgins"))

# conviene revisar que ambas tablas tengan la misma cantidad de comunas
n_comunas_a <- datos_cat |> distinct(comuna) |> nrow()
n_comunas_b <- clasificacion_3 |> distinct(comuna) |> nrow()
n_comunas_a == n_comunas_b

# cruzamos las tablas: dplyr detecta que la columna en común es "comuna"
datos_cruce <- datos_cat |>
  left_join(clasificacion_3)

datos_cruce

# revisamos si quedaron comunas sin clasificación (valores NA)
# esto ocurre cuando un nombre no coincidió entre las dos tablas
datos_cruce |> filter(is.na(clasificacion))

# ya podemos resumir usando la nueva columna
datos_cruce |>
  group_by(clasificacion) |>
  summarize(total = sum(personas))


# group_by() + mutate(): calcular por grupo sin resumir ----
# a diferencia de summarize(), mutate() con group_by() conserva todas las filas
# y agrega una columna con el resultado del cálculo por grupo

# total de personas por región, repetido en cada fila de la región
datos_cruce |>
  group_by(region) |>
  mutate(total = sum(personas))

# crear un ranking de comunas dentro de cada región
# 1:n() genera un número correlativo (1, 2, 3...) dentro de cada grupo
datos_rank <- datos_cruce |>
  arrange(region, desc(personas)) |>
  group_by(region) |>
  mutate(ranking = 1:n()) |>
  ungroup()

datos_rank

# las 3 comunas con más personas de cada región
datos_rank |> filter(ranking <= 3)
