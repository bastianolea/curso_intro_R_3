
# transformación de estructura de datos

library(readxl)
library(dplyr)
library(tidyr) # install.packages("tidyr")
# library(tidyverse)

poblacion <- read_xlsx("estimaciones_poblacion.xlsx")

poblacion

poblacion |> glimpse()

poblacion
poblacion |> count(sexo)
poblacion |> count(edad) |> print(n = Inf)
poblacion |> distinct(edad) |> pull()
poblacion |> names()
poblacion |> dim()
poblacion |> View()

poblacion |> 
  select(`2026`)

# poblacion |> 
  # pivot_longer(cols = c(`1992`, `1993`, `1994`

1:10

poblacion |>
  pivot_longer(cols = `1992`:`2070`)

poblacion |>
  pivot_longer(cols = where(is.numeric))

poblacion |>
  pivot_longer(cols = 3:81)

poblacion |>
  pivot_longer(cols = where(is.numeric),
               names_to = "año",
               values_to = "poblacion")

poblacion_largo <- poblacion |>
  pivot_longer(cols = where(is.numeric)) |> 
  rename(año = name, poblacion = value)

poblacion_largo |> 
  filter(año == 2026) |> 
  filter(edad == 33)

# poblacion_largo |> 
#   mutate(prueba = 2026)

poblacion_total <- poblacion_largo |> 
  group_by(año) |> 
  summarise(total = sum(poblacion))

poblacion_total

poblacion_sexo <- poblacion_largo |> 
  group_by(año, sexo) |> 
  summarise(total = sum(poblacion)) |> 
  filter(año >= 2010, año <= 2030)

poblacion_sexo

poblacion_sexo_ancho <- poblacion_sexo |> 
  pivot_wider(names_from = sexo,
              values_from = total)


library(writexl)

poblacion_sexo_ancho |> 
  write_xlsx("poblacion_proyeccion_2010-2030_sexo.xlsx")





library(ggplot2)

ggplot()

datos_rank |> 
  ggplot()

datos_rank |> 
  filter(region == "Antofagasta") |> 
  ggplot() +
  aes(x = personas, y = comuna) +
  geom_point()

datos_rank |> 
  filter(region == "Antofagasta") |> 
  ggplot() +
  aes(x = personas, y = comuna) +
  geom_col()


datos_rank |> 
  filter(region == "Maule") |> 
  ggplot() +
  aes(x = personas, y = comuna) +
  geom_col()


datos_rank |> 
  filter(region == "Maule") |> 
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col()

datos_rank |> 
  filter(region == "Maule") |> 
  ggplot() +
  aes(x = personas, y = comuna, fill = nivel) +
  geom_col()


library(forcats)

datos_rank |> 
  mutate(clasificacion = fct_relevel(clasificacion,
                                     "Rural", "Mixta", "Urbana")) |>
  mutate(comuna = fct_reorder(comuna, personas)) |>
  filter(region == "Biobío") |> 
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col()


datos_rank |> 
  mutate(clasificacion = fct_relevel(clasificacion,
                                     "Rural", "Mixta", "Urbana")) |>
  mutate(comuna = fct_reorder(comuna, personas)) |>
  filter(region == "Biobío") |>
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col() +
  facet_wrap(~clasificacion)


datos_rank |> 
  mutate(clasificacion = fct_relevel(clasificacion,
                                     "Rural", "Mixta", "Urbana")) |>
  mutate(comuna = fct_reorder(comuna, personas)) |>
  filter(region == "Biobío") |> 
  ggplot() +
  aes(x = personas, y = comuna, fill = clasificacion) +
  geom_col() +
  scale_fill_discrete(
    palette = c("#AC558A", 
                "#666BC7",
                "#553A74")) +
  theme_minimal(
    paper = "#feeafa",
    ink = "#cbc0d3",
    accent = "#da627d"
    )
