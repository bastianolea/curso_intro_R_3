# instalar paquete
# install.packages("readxl")

library("readxl") # cargar paquete para usarlo

# cargar datos excel
datos <- read_xlsx("estimaciones_pobreza.xlsx")

datos

# previsualizar datos en una nueva pestaña
View(datos)

datos

library(dplyr)

datos |> select(comuna, personas, porcentaje)

datos |> 
  # ordenar observaciones
  arrange(desc(porcentaje)) |> 
  # seleccionar columnas relevantes
  select(region, comuna, porcentaje)

datos |> 
  select(comuna, region, personas, porcentaje) |> 
  arrange(porcentaje)


46 > 1

edad <- 33

edad > 20

edad < 30


4 == 3
4 == 4
4 != 2

edades <- c(54, 34, 65, 21, 32)
edades > 40


datos |> 
  filter(personas > 90000)

datos |> 
  filter(personas < 900)


datos |> 
  filter(comuna == "La Florida")

umbral_pobreza <- 0.3

0.3 >= 0.3

datos |> 
  filter(porcentaje >= umbral_pobreza)

datos |> 
  select(personas, porcentaje)

datos |> 
  filter(region == 'Biobío')


datos |> glimpse()

datos |> slice(100)

1:4
c(1, 2, 3, 4)
1:999999
datos |> slice(5:15)
1990:2026

datos |> slice(1, 2, 3)

datos |> slice(1:10)


datos |> pull(comuna)

datos_mini <- datos |> 
  select(region, comuna, porcentaje, personas)

datos_mini




top <- 3

top_comunas <- datos |> 
  arrange(desc(porcentaje)) |> 
  select(region, comuna, porcentaje, personas) |> 
  slice(1:top) |> 
  pull(comuna)

top_comunas

texto_comunas <- paste(top_comunas, collapse = ", ")

paste("las", 
      top, 
      "comunas con mayor porcentaje de pobreza son:", 
      texto_comunas
      )

datos |> 
  count(region)

datos |> 
  count(comuna) |> 
  filter(n > 1)

datos |> 
  count(comuna) |> 
  print(n = 1000)

datos |> 
  print(n = Inf)


# install.packages("stringr")
library(stringr)

texto <- "mapache"

str_detect(texto, "a")

datos |> 
  filter(str_detect(region, "Metro"))

datos |> 
  filter(str_detect(comuna, "Florida"))

datos |> 
  filter(str_detect(comuna, "Alto"))


texto <- "Región Metropolitana de Santiago"

texto |> 
  str_remove("Región") |> 
  str_remove("de Santiago") |> 
  str_remove_all(" ")


comunas <- c("Cerrillos", "Maipú", "Nunoa")

str_replace(comunas, "Nunoa", "Ñuñoa")

str_replace(comunas, "a", "o")
