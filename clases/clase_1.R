# esta es la primera clase

# 5 + perro

# cargar los datos que vienen en excel

687676 + 3435 # una suma absurda


"ésta es una cadena de texto"

"perro"

" "
34 * 4545

2 + 2
# 
# "2" + "2"

# "gato" + "perro"


# creación de un objeto nuevo
animal <- "gato"

animal

edad <- 43

edad - 2026
2026 - edad

año <- 2029

año - edad

resultado_resta <- año - edad

resultado_resta

c(1, 2, 3)


edades <- c(33, 44, 52, 32, 58, 23, 64, 38, 
            # estas son mas edades
            33, 44, 52, 32, 58, 23, 64, 38, # lalalal 
            33, 44, 52, 32, 58, 23, 64, 38, 
            # y estas son las últimas
            33, 44, 52, 32, 58, 23, 64, 38,
            43,
            54, 78)

edad_maxima <- max(edades)

edad_maxima

paste("la edad máxima es:",
      edad_maxima,
      "años")


edades - año


mean(edades)

median(edades)

sum(edades)

max(edades)

sum(
  c(44534543, 
    345345, 
    345345)
)




# install.packages("readxl")

library("readxl")

datos <- read_xlsx("estimaciones_pobreza.xlsx")


datos
