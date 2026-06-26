# instalar paquete
# install.packages("readxl")

library("readxl") # cargar paquete para usarlo
library("dplyr")
library("stringr")

# cargar datos excel
datos <- read_xlsx("estimaciones_pobreza.xlsx")

datos

# previsualizar datos en una nueva pestaña
View(datos)

datos



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


datos |> 
  select(codigo)

datos |> 
  select(1, 2, 3)

datos |> 
  select(1:4)

datos |> 
  select(1:3, 8)

datos |> 
  select(-codigo)

datos |> 
  select(where(is.numeric))

datos |> 
  select(comuna, where(is.numeric))

datos |> 
  select(starts_with("limite"))

datos |> 
  select(-starts_with("limite"))

datos |> 
  filter(region == "Tarapacá")

datos |> 
  filter(region != "Tarapacá")

datos |> 
  filter_out(region == "Tarapacá")

# 4 == 5 # comparar
# edad = 34 # objetos y argumentos de funciones

datos |> 
  rename(censo = personas_proy)

datos |>
  relocate(personas_proy, .after = porcentaje)

datos |>
  rename(censo = personas_proy) |> 
  relocate(censo, .after = porcentaje)

datos |>
  rename(censo = personas_proy) |> 
  relocate(censo, .after = 4)


datos |> 
  select(1:3, 5) |> 
  mutate(ejemplo = "hola")

datos |> 
  select(1:3, 5) |> 
  mutate(ejemplo = "hola") |> 
  mutate(copia = personas)

datos |> 
  select(1:3, 5) |> 
  mutate(ejemplo = "hola") |> 
  mutate(copia = personas) |> 
  mutate(miles = personas/1000)

# ordenar datos
datos_m <- datos |> 
  rename(censo = personas_proy) |> 
  select(region, comuna, censo, personas) |> 
  mutate(miles = personas/1000)

# calcular porcentar
datos_p <- datos_m |> 
  mutate(porcentaje = personas/censo) |> 
  mutate(porcentaje = porcentaje * 100)

datos_p |> 
  mutate(personas = 0) -> datos_p2 # cursed

datos_p |> 
  mutate(miles = round(miles, 0))


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

library(stringr)

trabajos |> 
  mutate(sociologx = empleo == "sociólogo")

trabajos |> 
  mutate(sociologx = str_detect(empleo, "sociólogo"))

trabajos |> 
  mutate(empleo = str_to_lower(empleo)) |> 
  mutate(sociologx = str_detect(empleo, "sociólog"))

trabajos |> 
  mutate(empleo = str_to_lower(empleo)) |> 
  mutate(sociologx = str_detect(empleo, "sociólog|socioloco"))

trabajos |> 
  mutate(empleo = str_to_lower(empleo)) |> 
  mutate(empleo = str_replace(empleo, "socio", "soció")) |> 
  mutate(empleo = str_replace(empleo, "socióloco", "sociólogo")) |> 
  mutate(sociologx = str_detect(empleo, "sociólog"))


datos_cat <- datos_p |> 
  mutate(nivel = ifelse(
    porcentaje > 20,
    yes = "Alto",
    no = "Bajo"
  )
  )

datos_cat |> 
  count(nivel)

datos_cat |> 
  count(region, nivel) |> 
  filter(nivel == "Alto") |> 
  arrange(desc(n)) |> 
  rename(n_comunas_alta_pobreza = n)


datos_cat |> 
  slice_sample(n = 10) |> 
  mutate(feas = case_when(
    region == "Metropolitana" ~ "Fea"
  )
  )


datos_cat |> 
  # slice_sample(n = 10) |> 
  mutate(feas = case_when(
    region == "Metropolitana" ~ "Fea",
    region == "Los Lagos" ~ "Linda",
    region == "Valparaíso" ~ "Horrible"
  )
  )

datos_cat |> 
  # slice_sample(n = 10) |> 
  mutate(nivel_2 = case_when(
    porcentaje > 30 ~ "Alto",
    porcentaje > 20 ~ "Medio",
    porcentaje > 10 ~ "Bajo",
    porcentaje <= 10 ~ "Muy bajo")
  ) # |> count(nivel_2)

datos_cat_2 <- datos_cat |> 
  mutate(nivel_2 = case_when(
    porcentaje > 30 ~ "Alto",
    porcentaje > 20 ~ "Medio",
    porcentaje > 10 ~ "Bajo",
    porcentaje <= 10 ~ "Muy bajo")
  )



edad <- 30

ifelse(edad > 18, "mayor", "menor")

edades <- c(17, 30, 31, 32, 44)

ifelse(edades > 18, "mayor", "menor")

datos_cat$porcentaje
datos_cat |> pull(porcentaje)

datos_cat |> 
  mutate(total = sum(personas))

datos_cat |> 
  summarise(sum(personas))

datos_cat |> 
  group_by(region) |> 
  summarise(total_personas = sum(personas))

datos_cat |> 
  group_by(region) |> 
  summarise(
    total_personas = sum(personas),
    total_censo = sum(censo),
    )

datos_cat_2 |> 
  group_by(nivel_2) |> 
  summarise(
    total_personas = sum(personas),
    total_censo = sum(censo),
  )

datos_cat_2 |> 
  group_by(nivel_2) |> 
  summarise(
    total_personas = sum(personas),
    total_censo = sum(censo),
    n_comunas = n()
  )

datos_cat_2



educacion <- read_xlsx("educacion.xlsx")

educacion |> glimpse()

educacion |> 
  count(region)

educacion |> 
  count(sexo)

educacion_2 <- educacion |> 
  filter_out(region == "País") |> 
  filter_out(sexo == "Total Comuna") |> 
  filter_out(sexo == "Total País")

educacion_2 |> 
  filter(comuna == "Puente Alto")

educacion |> 
  filter(sexo == "Total Comuna") |> 
  group_by(region) |> 
  summarize(escolaridad = mean(escolaridad))


clasificacion <- read_xlsx("clasificacion.xlsx")

clasificacion_2 <- clasificacion |> 
  select(comuna, clasificacion)

clasificacion_2

datos_cat |> 
  left_join(clasificacion_2)




clasificacion_3 <- clasificacion_2 |> 
  mutate(comuna = str_to_title(comuna)) |> 
  mutate(comuna = str_replace(comuna, "O’higgins", "O’Higgins"))

datos_cat |>
  filter(str_detect(comuna, "higgins"))
# 
clasificacion_3 |>
  filter(str_detect(comuna, "higgins"))


datos_cat


datos_3 <- datos_cat |> 
  left_join(clasificacion_3)

datos_3 |> 
  count(clasificacion)

datos_3 |> 
  filter(is.na(clasificacion))

datos_3 |> 
  group_by(clasificacion) |> 
  summarize(sum(personas))
  
