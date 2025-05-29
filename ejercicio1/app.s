.equ SCREEN_WIDTH,      640
.equ SCREEN_HEIGH,      480
.equ BITS_PER_PIXEL,    32
.equ GPIO_BASE,        0x3f200000
.equ GPIO_GPFSEL0,     0x00
.equ GPIO_GPLEV0,      0x34

.globl main
.global cuadrado 

main:
    // x0 contiene la dirección base del framebuffer
    mov x20, x0  // Guarda la dirección base en x20 (preservado)

    // --------------------------
    // Pintar fondo de celeste
    // --------------------------
    mov x10, 0xd6e7      // Color celeste (0x0093d6e7)
    movk x10, 0x0093, lsl 16

    mov x2, SCREEN_HEIGH         // Y Size

loop1:
    mov x1, SCREEN_WIDTH         // X Size

loop0:
    stur w10,[x0]                // Pinta pixel celeste
    add x0, x0, 4                // Siguiente pixel
    sub x1, x1, 1                // Decrementar contador X
    cbnz x1, loop0               // Si no terminó la fila, salto
    sub x2, x2, 1                // Decrementar contador Y
    cbnz x2, loop1               // Si no es la última fila, salto

    // --------------------------
    // Pintar triangulos
    // --------------------------
    // OBSERVEMOS que La funcion triangulo utiliza:
    // x10 = Guarda el color del rectangulo.
    // x11, x12 = Coordenadas del inicio.
    // x13 = Altura
    // Antes de llamar a la funcion debemos determinar estos valores.

    //Montaña 1
    mov x0, x20
    mov x10, 0x6346
    movk x10, 0x32, lsl 16
    mov x11, 400
    mov x12, 220
    mov x13, 260
    bl triangulo

    //Montaña 2
    mov x0, x20
    mov x10, 0x815c
    movk x10, 0x4b, lsl 16
    mov x11, 100
    mov x12, 100
    mov x13, 380
    bl triangulo

    // --------------------------
    // Pintar rectangulos
    // --------------------------
    // OBSERVEMOS que La funcion rectangulo utiliza:
    // x10 = Guarda el color del rectangulo.
    // x11, x12 = Coordenadas del inicio.
    // x13, x14 = Ancho y alto.
    // Antes de llamar a la funcion debemos determinar estos valores.

    //Piso
    mov x0, x20                  
    mov x10, 0x424d
    movk x10, 0x4c, lsl 16
    mov x11, 0
    mov x12, 390
    mov x13, SCREEN_WIDTH
    mov x14, 90
    bl rectangulo                  

    //Nieve sobre el piso
    mov x0, x20                 
    mov x10, 0xf8f8
    movk x10, 0xf8, lsl 16
    mov x11, 0
    mov x12, 350
    mov x13, SCREEN_WIDTH
    mov x14, 40
    bl rectangulo

    //Nieve en la montaña 1
    mov x0, x20
    mov x10, 0xf8f8
    movk x10, 0xf8, lsl 16
    mov x11, 400
    mov x12, 220
    mov x13, 50
    bl triangulo

    //Nieve en la montaña 2
    mov x0, x20
    mov x10, 0xf8f8
    movk x10, 0xf8, lsl 16
    mov x11, 100
    mov x12, 100
    mov x13, 100
    bl triangulo

    //linea
    mov x0, x20                  
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    mov x11, 545
    mov x12, 320
    mov x13, 10
    mov x14, 120
    bl rectangulo                  

    // --------------------------
    // Pintar rmbos
    // --------------------------
    // OBSERVEMOS que La funcion rombo utiliza:
    // x10 = Guarda el color del rectangulo.
    // x11, x12 = Coordenadas del inicio.
    // x13, x14 = Distancia del centro al vertice..
    // Antes de llamar a la funcion debemos determinar estos valores.

    //Cartel
    mov x0, x20
    mov x10, 0xdb22
    movk x10, 0xf5, lsl 16
    mov x11, 549
    mov x12, 280
    mov x13, 55
    bl rombo

   
    // --------------------------
    // Pintar rmbos
    // --------------------------
    // (Este es el código existente para el cartel)
    mov x0, x20
    mov x10, 0xdb22
    movk x10, 0xf5, lsl 16
    mov x11, 549
    mov x12, 280
    mov x13, 55
    bl rombo

   // DIBUJAR LAS LETRAS OdC2025 (no terminé de comentar todo)

    // Este bloque pinta las letras OdC2025 con el color del asfalto
    mov x10, 0x424d
    movk x10, 0x4c, lsl 16

    // Posición base de las letras 
    // En x16 las coords de la base vertical
    movz x16, 278

   //Las dibujo utilizando rectángulos que como dice mas arriba:

    // OBSERVEMOS que La funcion rectangulo utiliza:

    // x10 = Guarda el color del rectangulo. 
    //Este se guardó al principo asi que no lo vovemos a guardar

    // x11, x12 = Coordenadas del inicio.
    // x13, x14 = Ancho y alto.
    // Antes de llamar a la funcion debemos determinar estos valores.

    // Dibujo la letra O:
    // Comienzo con las líneas horizontales superior e inferior

    // LETRA O
    movz x13, 10 // determino que el ancho es 5*2, es decir 5 bloques de 2px => 10
    movz x14, 2 // el ancho es 1*2, es decir un bloque de 2px => 2
    
    // ahora guardo las coords de la base en los parametros de inicio
    mov x11, #510 //esta es la base horizontal
    mov x12, x16
    bl rectangulo
    add x12, x16, #8
    bl rectangulo //Una vez obtenidos todos los parámetros dibuja la línea de arriba

    movz x13, 2
    movz x14, 8
    mov x11, #510
    mov x12, #280
    bl rectangulo
    mov x11, #518
    bl rectangulo

   // LETRA d

    movz x13, 6   // ancho panza
    movz x14, 6   // alto panza
    mov x11, #524
    mov x12, #280
    bl rectangulo

    movz x13, 2   // palo derecho pero finito
    movz x14, 10  // más alto que la panza
    mov x11, #530
    mov x12, #276
    bl rectangulo


    // LETRA C

    movz x13, 10  // horizontal arriba
    movz x14, 2
    mov x11, #536
    mov x12, #276
    bl rectangulo

    add x12, x12, #8 // bajo para la línea de abajo
    bl rectangulo

    movz x13, 2   // lateral izq
    movz x14, 8
    mov x11, #536
    mov x12, #278
    bl rectangulo

    // NUMERO 2

    movz x13, 10
    movz x14, 2
    mov x11, #548
    mov x12, #276
    bl rectangulo // parte de arriba

    add x12, x12, #4
    bl rectangulo // parte del medio

    add x12, x12, #4
    bl rectangulo // parte de abajo

    movz x13, 2
    movz x14, 4
    mov x11, #556
    mov x12, #278
    bl rectangulo // vertical de la derecha

    mov x11, #548
    mov x12, #282
    bl rectangulo // diagonal izquierda

    // NUMERO 0

    movz x13, 10
    movz x14, 2
    mov x11, #560
    mov x12, #276
    bl rectangulo // línea de arriba

    add x12, x16, #8
    bl rectangulo // línea de abajo

    movz x13, 2
    movz x14, 8
    mov x11, #560
    mov x12, #278
    bl rectangulo // lateral izq

    mov x11, #568
    bl rectangulo // lateral der

    // SEGUNDO 2 (igual al anterior con coords distintas)

    movz x13, 10
    movz x14, 2
    mov x11, #572
    mov x12, #276
    bl rectangulo
    add x12, x12, #4
    bl rectangulo
    add x12, x12, #4
    bl rectangulo

    movz x13, 2
    movz x14, 4
    mov x11, #580
    mov x12, #278
    bl rectangulo

    mov x11, #572
    mov x12, #282
    bl rectangulo

    // NUMERO 5

    movz x13, 10
    movz x14, 2
    mov x11, #584
    mov x12, #276
    bl rectangulo // horizontal de arriba
    mov x12, #280
    bl rectangulo // horizontal medio
    mov x12, #284
    bl rectangulo // parte de abajo abajo

    movz x13, 2
    movz x14, 4
    mov x11, #584
    mov x12, #278
    bl rectangulo // verticar lado izq

    mov x11, #592
    mov x12, #282
    bl rectangulo // vertical lado de la dercha

    // -------------------------------------------------
    // Dibujar a Cartman (un cachito mejorado)
    // -------------------------------------------------
    
    // Cabeza (círculo piel)
    mov x0, x20
    mov x10, 0xC69C              // Color piel
    movk x10, 0xFF, lsl 16
    mov x11, 340                 // X center 
    mov x12, 320                 // Y center 
    mov x13, 30                  // Radio
    bl circulo

    // Gorro (triángulo rojo) 
    mov x0, x20
    mov x10, 0x0000              // Color rojo
    movk x10, 0xCC, lsl 16
    mov x11, 340                 // X position 
    mov x12, 250                // Y position 
    mov x13, 40                  // Altura 
    bl triangulo

    // Pompón (círculo blanco) 
    mov x0, x20
    mov x10, 0xFFFF              // Color blanco
    movk x10, 0xFFFF, lsl 16
    mov x11, 340                 // X centro 
    mov x12, 240                // Y posicion más alta 
    mov x13, 10                  // Radio un poco mayor 
    bl circulo

    // Cuerpo (chaqueta roja)
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0xCC, lsl 16
    mov x11, 300
    mov x12, 350
    mov x13, 80
    mov x14, 100
    bl rectangulo

    // Ojos y boca
    mov x0, x20
    mov x10, 0x0000
    mov x11, 330
    mov x12, 315
    mov x13, 4
    bl circulo
    
    mov x11, 350
    bl circulo

    // Boca (línea negra)
    mov x0, x20
    mov x10, 0x0000
    mov x11, 335
    mov x12, 330
    mov x13, 20
    mov x14, 2
    bl rectangulo

    // Brazos
    mov x0, x20
    mov x10, 0x4226
    movk x10, 0x8B, lsl 16
    mov x11, 270
    mov x12, 370
    mov x13, 30
    mov x14, 15
    bl rectangulo
    
    mov x0, x20
    mov x11, 380
    bl rectangulo

    // Piernas
    mov x0, x20
    mov x10, 0x33000000
    mov x11, 310
    mov x12, 450
    mov x13, 20
    mov x14, 30
    bl rectangulo
    
    mov x0, x20
    mov x11, 350
    bl rectangulo

   
    // --------------------------
    // Loop infinito
    // --------------------------
InfLoop:
    b InfLoop

rectangulo:

    // Precalcula el stride (ancho de pantalla en bytes)
    mov x15, SCREEN_WIDTH         
    lsl x15, x15, 2              // x15 = SCREEN_WIDTH * 4 (bytes por fila)

    mov x2, x14                  // Contador de altura (y)

y_loop_rec:
    // Calcular offset de fila: (y_start + delta_y) * stride
    sub x3, x14, x2              // delta_y
    add x4, x12, x3              // y_actual = y_start + delta_y
    mul x4, x4, x15              // offset_y = y_actual * stride

    // Loop interno para las columnas (x)
    mov x1, x13                  // Contador de ancho (x)
x_loop_rec:
    // Calcular offset de columna: (x_start + delta_x) * 4
    sub x6, x13, x1              // delta_x
    add x7, x11, x6              // x_actual = x_start + delta_x
    lsl x7, x7, 2                // offset_x = x_actual * 4

    // Dirección final del píxel: framebuffer + offset_y + offset_x
    add x8, x0, x4
    add x8, x8, x7

    // Pintar píxel
    stur w10, [x8]

    // Siguiente columna
    sub x1, x1, 1
    cbnz x1, x_loop_rec

    // Siguiente fila
    sub x2, x2, 1
    cbnz x2, y_loop_rec

    ret

triangulo:

    // Calcular stride (bytes por fila)
    mov x15, SCREEN_WIDTH
    lsl x15, x15, 2              // stride = SCREEN_WIDTH * 4

    mov x2, #0                   // fila actual (i = 0)

y_loop_tr:
    // y_actual = y_start + i
    add x4, x12, x2
    mul x4, x4, x15              // offset_y = y_actual * stride

    // cantidad de píxeles a pintar en esta fila = 2*i + 1
    lsl x5, x2, 1                // x5 = 2*i
    add x5, x5, #1               // x5 = 2*i + 1 (cantidad de columnas)

    // x_inicio = x_start - i
    sub x6, x11, x2              // columna inicial

    // loop interno por columnas
x_loop_tr:
    // x_actual = x_inicio
    add x7, x6, #0
    lsl x7, x7, 2                // offset_x = x_actual * 4

    // Dirección: framebuffer + offset_y + offset_x
    add x8, x20, x4
    add x8, x8, x7

    // Pintar píxel
    stur w10, [x8]

    // Siguiente columna
    add x6, x6, #1
    sub x5, x5, #1
    cbnz x5, x_loop_tr

    // Siguiente fila
    add x2, x2, #1
    cmp x2, x13
    blt y_loop_tr

    ret


rombo:

    // Calcular stride
    mov x15, SCREEN_WIDTH
    lsl x15, x15, 2             // stride = SCREEN_WIDTH * 4

    // Parte superior y centro del rombo
    mov x2, #0                  // fila actual (de 0 a r-1)

y_loop_up:
    // y_actual = y_center - r + i
    sub x3, x13, x2             // tmp = r - i
    sub x4, x12, x3             // y_actual = y_center - (r - i)
    mul x5, x4, x15             // offset_y = y_actual * stride

    // ancho = 2*i + 1
    lsl x6, x2, 1
    add x6, x6, #1              // x6 = ancho

    // x_inicio = x_center - i
    sub x7, x11, x2             // x_inicio

    // Loop interno columnas
x_loop_rombo_up:
    add x8, x7, #0
    lsl x8, x8, 2               // offset_x

    add x9, x20, x5
    add x9, x9, x8              // dirección del píxel

    stur w10, [x9]              // pintar píxel

    add x7, x7, #1              // siguiente columna
    sub x6, x6, #1
    cbnz x6, x_loop_rombo_up

    add x2, x2, #1
    cmp x2, x13
    cmp x2, x13
    ble y_loop_up   // "branch if less or equal"


    // Parte inferior (inversa de la superior)
    sub x2, x13, #2             // empezamos desde r-2

y_loop_down:
    // y_actual = y_center + (r - 1 - i)
    sub x3, x13, #1
    sub x3, x3, x2
    add x4, x12, x3             // y_actual
    mul x5, x4, x15             // offset_y

    // ancho = 2*i + 1
    lsl x6, x2, 1
    add x6, x6, #1

    // x_inicio = x_center - i
    sub x7, x11, x2

x_loop_rombo_down:
    add x8, x7, #0
    lsl x8, x8, 2               // offset_x

    add x9, x20, x5
    add x9, x9, x8              // dirección del píxel

    stur w10, [x9]

    add x7, x7, #1
    sub x6, x6, #1
    cbnz x6, x_loop_rombo_down

    sub x2, x2, #1
    cmp x2, #-1
    bgt y_loop_down

    ret

circulo:
    // Calculamos radio² para comparaciones
    mul x17, x13, x13  // radio^2

    // Calculamos el stride (bytes por fila)
    mov x15, SCREEN_WIDTH
    lsl x15, x15, 2  // stride = SCREEN_WIDTH * 4 (bytes por fila)

    // Definimos límites para iteración
    sub x1, x12, x13  // y_start = yc - r
    add x18, x12, x13 // y_end = yc + r

loop_y:
    sub x2, x11, x13  // x_start = xc - r
    add x19, x11, x13 // x_end = xc + r

loop_x:
    // Calculamos dx² y dy²
    sub x3, x2, x11
    sub x4, x1, x12
    mul x5, x3, x3
    mul x6, x4, x4
    add x7, x5, x6  // dist² = dx² + dy²

    // Si dist² ≤ radio², pintamos el píxel
    cmp x7, x17
    bgt skip_pixel

    // Calculamos dirección en framebuffer
    mul x9, x1, x15  // offset_y = y * stride
    lsl x16, x2, 2   // offset_x = x * 4
    add x9, x9, x16
    add x9, x9, x20

    // Pintamos el píxel
    stur w10, [x9]

skip_pixel:
    add x2, x2, 1
    cmp x2, x19
    ble loop_x

    add x1, x1, 1
    cmp x1, x18
    ble loop_y

    ret

elipse:
    // x11 = x_center, x12 = y_center
    // x13 = a (radio horizontal), x14 = b (radio vertical)
    // Guardar parámetros
    mov x19, x11  // Centro X
    mov x20, x12  // Centro Y
    mov x21, x13  // a
    mov x22, x14  // b
    
    // Precalcular a² y b²
    mul x23, x21, x21  // a²
    mul x24, x22, x22  // b²
    
    // Calcular stride
    mov x15, SCREEN_WIDTH
    lsl x15, x15, 2  // stride = SCREEN_WIDTH * 4
    
    // Iterar sobre el cuadrante positivo (luego reflejamos)
    mov x1, #0       // x
    mov x2, x22      // y = b
    
elipse_loop:
    // Calcular condición: b²x² + a²y² <= a²b²
    mul x3, x1, x1   // x²
    mul x3, x3, x24  // b²x²
    
    mul x4, x2, x2   // y²
    mul x4, x4, x23  // a²y²
    
    add x5, x3, x4   // b²x² + a²y²
    
    mul x6, x23, x24 // a²b²
    
    cmp x5, x6
    b.gt elipse_next
    
    // Dibujar los 4 puntos simétricos
    // Punto (x,y)
    add x7, x19, x1
    add x8, x20, x2
    bl draw_pixel
    
    // Punto (-x,y)
    sub x7, x19, x1
    add x8, x20, x2
    bl draw_pixel
    
    // Punto (x,-y)
    add x7, x19, x1
    sub x8, x20, x2
    bl draw_pixel
    
    // Punto (-x,-y)
    sub x7, x19, x1
    sub x8, x20, x2
    bl draw_pixel
    
elipse_next:
    // Algoritmo del punto medio para elipses
    // (Implementación simplificada)
    add x1, x1, #1
    cmp x1, x21
    b.gt elipse_done
    
    // Calcular siguiente y
    mul x3, x1, x1
    mul x3, x3, x24
    mul x4, x2, x2
    mul x4, x4, x23
    add x5, x3, x4
    mul x6, x23, x24
    
    sub x5, x5, x6
    cmp x5, #0
    b.gt elipse_decrease_y
    
    b elipse_loop
    
elipse_decrease_y:
    sub x2, x2, #1
    b elipse_loop
    
elipse_done:
    ret

draw_pixel:
    // x7 = x, x8 = y, x10 = color
    // Verificar límites de pantalla
    cmp x7, #0
    b.lt pixel_done
    cmp x7, SCREEN_WIDTH
    b.ge pixel_done
    cmp x8, #0
    b.lt pixel_done
    cmp x8, SCREEN_HEIGH
    b.ge pixel_done
    
    // Calcular dirección del píxel
    mul x9, x8, x15  // y * stride
    lsl x16, x7, 2   // x * 4
    add x9, x9, x16
    add x9, x9, x20  // framebuffer base
    
    // Pintar píxel
    stur w10, [x9]
    
pixel_done:
    ret
