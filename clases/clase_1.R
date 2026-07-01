# Clase 1: Introducción a R
# Introducción al análisis de datos con R para ciencias sociales
# 2026-06-22
# Bastián Olea Herrera - https://bastianolea.rbind.io - bastianolea@gmail.com

# diapositivas: https://bastianolea.github.io/curso_intro_R_3/

# en esta primera clase veremos los elementos más básicos del lenguaje R:
# operaciones, tipos de datos, objetos, vectores, funciones y paquetes,
# para terminar cargando nuestros primeros datos desde un archivo Excel.

# en un script escribimos el código y lo ejecutamos línea por línea:
# ponemos el cursor sobre la línea y presionamos control + enter (o el botón Run)
# el resultado siempre aparece abajo, en la consola

# operaciones matemáticas ----
# R puede funcionar como una calculadora: podemos hacer cualquier operación

2 + 2 # suma
50 * 100 # multiplicación
4556 - 1000 # resta
6565 / 89 # división
10^4 # potencias

# podemos combinar muchos números en una sola línea
687676 + 3435 + 4343 + 3232


# comentarios ----
# todo lo que va después de un # es un comentario: R lo ignora al ejecutar
# sirve para explicar qué hace nuestro código

# esta línea está comentada, así que no se ejecuta
# 34 * 4545

# también podemos comentar al final de una línea de código
2 + 2 # esto es una suma


# trabajar con texto ----
# en R, el texto (o "caracteres") se escribe entre comillas

"ésta es una cadena de texto"
"perro"

# el texto no se puede sumar como si fueran números;
# estas líneas darían error si las ejecutamos, por eso están comentadas:
# "gato" + "perro"
# "2" + "2"

# tipos de datos ----
# lo que podemos hacer con un dato depende de su tipo. Los principales son:
# - numéricos: 1, 2, 3, 5.5 (pueden ser enteros o decimales)
# - caracteres (texto): "hola", "perro"
# - lógicos: TRUE, FALSE (verdadero o falso)

# crear objetos (asignación) ----
# si queremos guardar un dato para volver a usarlo, lo guardamos en un objeto
# usamos el operador de asignación <- (se escribe con alt + - / option + -)

# guardamos un texto en el objeto "animal"
animal <- "gato"

# al ejecutar el nombre del objeto, obtenemos su contenido
animal

# guardamos un número en el objeto "edad"
edad <- 43

# al crear un objeto, éste aparece en el panel de entorno (Environment)

# reasignar y operar con objetos ----
# podemos cambiar el valor de un objeto existente
año <- 2029

# y usar objetos dentro de operaciones (el orden importa en la resta)
año - edad
edad - año

# el resultado de una operación también se puede guardar en un objeto nuevo
resultado_resta <- año - edad
resultado_resta


# vectores ----
# un vector es una secuencia de varios elementos del mismo tipo
# se crea con la función c() (de "combinar")

c(1, 2, 3)

# guardamos un vector de edades en un objeto
edades <- c(
  33,
  44,
  52,
  32,
  58,
  23,
  64,
  38,
  33,
  44,
  52,
  32,
  58,
  23,
  64,
  38,
  43,
  54,
  78
)

edades

# podemos aplicar una operación sobre todos los elementos del vector a la vez
edades - año


# funciones ----
# las funciones son pequeños programas que realizan una operación
# se escriben con el nombre seguido de paréntesis: funcion(argumento)

mean(edades) # promedio
median(edades) # mediana
sum(edades) # suma de todos los elementos
max(edades) # valor máximo
min(edades) # valor mínimo

# guardamos el resultado de una función en un objeto
edad_maxima <- max(edades)
edad_maxima

# paste() nos permite combinar texto y valores en una sola frase
paste("la edad máxima es:", edad_maxima, "años")


# paquetes ----
# los paquetes son extensiones que agregan nuevas funciones a R
# se instalan una sola vez (como bajar una app), con install.packages()

# instalamos el paquete para leer archivos Excel
# install.packages("readxl")

# cada vez que abrimos R debemos cargar el paquete con library() (como abrir la app)
library("readxl")


# cargar datos ----
# usamos una función del paquete readxl para leer un archivo Excel
# como argumento le damos la ruta (nombre) del archivo, entre comillas
# el archivo debe estar dentro de la carpeta del proyecto

datos <- read_xlsx("estimaciones_pobreza.xlsx")

# al ejecutar el objeto, vemos los datos cargados
datos
