# Clase 2: Manipulación de datos con dplyr
# Introducción al análisis de datos con R para ciencias sociales
# 2026-06-24
# Bastián Olea Herrera - https://bastianolea.rbind.io - bastianolea@gmail.com

# diapositivas: https://bastianolea.github.io/curso_intro_R_3/

# en esta clase aprenderemos a explorar, seleccionar, ordenar y filtrar datos
# usando el paquete {dplyr}, que vimos brevemente al final de la clase anterior


# cargar paquetes ----
# recuerda: install.packages() solo la primera vez; library() cada vez que abres R

# install.packages("readxl")
library("readxl")  # para cargar archivos Excel

# install.packages("dplyr")
library("dplyr")   # para manipular datos

# install.packages("stringr")
library("stringr") # para trabajar con texto


# cargar datos ----

# creamos el objeto "datos" cargando el archivo Excel
datos <- read_xlsx("estimaciones_pobreza.xlsx")

# ver los datos en la consola
datos

# glimpse() muestra todas las columnas, sus tipos y los primeros valores
datos |> glimpse()

# View() abre los datos en una pestaña, como una planilla (útil para explorar)
# View(datos)


# el conector o pipe |> ----
# el conector |> encadena funciones de forma más legible
# se lee: "al objeto 'datos' luego le aplico esta función"
# se escribe con control + shift + m (o cmd + shift + m)

# seleccionar columnas ----
# select() nos permite quedarnos solo con las columnas que nos interesan

# seleccionar columnas por nombre
datos |> select(comuna, personas, porcentaje)

# seleccionar columnas por posición (número de columna)
datos |> select(1, 2, 3)

# seleccionar un rango de columnas
datos |> select(1:4)

# excluir una columna usando el signo -
datos |> select(-codigo)

# seleccionar solo columnas numéricas
datos |> select(where(is.numeric))

# combinar: la columna "comuna" y todas las numéricas
datos |> select(comuna, where(is.numeric))

# seleccionar columnas cuyo nombre empieza con cierto texto
datos |> select(starts_with("limite"))

# excluir columnas cuyo nombre empieza con cierto texto
datos |> select(-starts_with("limite"))


# ordenar filas ----
# arrange() ordena las filas según los valores de una columna

# ordenar de menor a mayor porcentaje de pobreza
datos |> arrange(porcentaje)

# desc() ordena de mayor a menor
datos |> arrange(desc(porcentaje))

# podemos encadenar funciones con el pipe:
# ordenar de mayor a menor y luego quedarnos con algunas columnas
datos |>
  arrange(desc(porcentaje)) |>
  select(region, comuna, porcentaje)


# operadores lógicos ----
# antes de filtrar, veamos cómo R evalúa condiciones verdaderas (TRUE) o falsas (FALSE)

46 > 1  # mayor que

edad <- 33
edad > 20 # ¿es mayor que 20? -> TRUE
edad < 30 # ¿es menor que 30? -> FALSE

4 == 4  # igual a (se escribe con dos signos ==) -> TRUE
4 == 3  # -> FALSE
4 != 2  # distinto de (!=) -> TRUE

# los operadores también funcionan sobre todos los valores de un vector
edades <- c(54, 34, 65, 21, 32)
edades > 40 # entrega un TRUE o FALSE por cada elemento


# filtrar filas ----
# filter() se queda solo con las filas que cumplen una condición

# comunas con más de 90.000 personas en situación de pobreza
datos |> filter(personas > 90000)

# comunas con menos de 900 personas
datos |> filter(personas < 900)

# filtrar por texto: una comuna específica (usamos == también para texto)
datos |> filter(comuna == "La Florida")

# filtrar por una región
datos |> filter(region == "Biobío")

# podemos usar un objeto como umbral dentro del filtro
umbral_pobreza <- 0.3

datos |> filter(porcentaje >= umbral_pobreza)


# extraer filas y columnas ----

# slice() extrae filas según su posición
datos |> slice(100)   # la fila 100
datos |> slice(1:10)  # de la fila 1 a la 10

# los rangos con : generan una secuencia de números
1:4

# pull() extrae una columna como un vector simple (no como tabla)
datos |> pull(comuna)


# contar categorías ----
# count() cuenta cuántas filas hay en cada categoría de una columna

# cuántas comunas hay por región
datos |> count(region)

# como hay una fila por comuna, el conteo de cada comuna es 1
datos |> count(comuna)

# print(n = ...) permite imprimir más filas de las que se muestran por defecto
datos |> count(comuna) |> print(n = 20)


# crear un ranking encadenando funciones ----
# combinamos varias funciones para obtener las comunas con mayor pobreza

# guardamos en un objeto cuántas comunas queremos en el ranking
top <- 3

# ordenamos, seleccionamos columnas, tomamos las primeras filas y extraemos la comuna
top_comunas <- datos |>
  arrange(desc(porcentaje)) |>
  select(region, comuna, porcentaje) |>
  slice(1:top) |>
  pull(comuna)

top_comunas

# unimos los nombres en un solo texto separado por comas
texto_comunas <- paste(top_comunas, collapse = ", ")

paste("las", top, "comunas con mayor porcentaje de pobreza son:", texto_comunas)


# trabajar con texto: {stringr} ----
# el paquete {stringr} entrega funciones para trabajar con texto

# str_detect() detecta si un texto contiene cierto patrón (TRUE/FALSE)
texto <- "mapache"
str_detect(texto, "a")

# es muy útil dentro de filter() para buscar sin saber el nombre exacto
datos |> filter(str_detect(region, "Metro"))
datos |> filter(str_detect(comuna, "Alto"))

# str_remove() y str_remove_all() eliminan texto que coincida con un patrón
texto <- "Región Metropolitana de Santiago"

texto |>
  str_remove("Región") |>
  str_remove("de Santiago") |>
  str_remove_all(" ")

# str_replace() reemplaza un texto por otro
comunas <- c("Cerrillos", "Maipú", "Nunoa")
str_replace(comunas, "Nunoa", "Ñuñoa")


# excluir filas ----

# filtrar dejando fuera una región: con != o con filter_out()
datos |> filter(region != "Tarapacá")
datos |> filter_out(region == "Tarapacá")


# renombrar y reordenar columnas ----

# rename() cambia el nombre de una columna (nombre_nuevo = nombre_viejo)
datos |> rename(censo = personas_proy)

# relocate() cambia el orden de las columnas
datos |> relocate(personas_proy, .after = porcentaje)

# podemos encadenar ambas
datos |>
  rename(censo = personas_proy) |>
  relocate(censo, .after = porcentaje)
