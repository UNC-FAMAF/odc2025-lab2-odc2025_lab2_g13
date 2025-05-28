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

    // -------------------------------------------------
    // Dibujar a Cartman (Version trucha por el momento)
    // -------------------------------------------------
    
    // Cuerpo (chaqueta roja)
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0xCC, lsl 16       // Color rojo Cartman
    mov x11, 300                 // X position (ajustado para estar en la calle)
    mov x12, 350                 // Y position (base, ajustado para estar sobre la nieve)
    mov x13, 80                  // Ancho
    mov x14, 100                 // Alto
    bl rectangulo

    // Cabeza (círculo/ovalado)
    mov x0, x20
    mov x10, 0xC69C              // Color piel
    movk x10, 0xFF, lsl 16
    mov x11, 340                 // X center (centrado sobre el cuerpo)
    mov x12, 320                 // Y center (por encima del cuerpo)
    mov x13, 30                  // Radio
    bl circulo

    // Gorro (triángulo amarillo)
    mov x0, x20
    mov x10, 0xE6D8              // Color amarillo
    movk x10, 0xFF, lsl 16
    mov x11, 340                 // X position (centrado sobre la cabeza)
    mov x12, 290                 // Y position
    mov x13, 20                  // Altura
    bl triangulo

    // Pompón del gorro (círculo rojo)
    mov x0, x20
    mov x10, 0x0000              // Color rojo
    movk x10, 0xFF, lsl 16
    mov x11, 340                 // X center
    mov x12, 290                 // Y center
    mov x13, 8                   // Radio pequeño
    bl circulo

    // Ojos (pequeños rectángulos negros)
    mov x0, x20
    mov x10, 0x0000              // Color negro
    mov x11, 330                 // X position ojo izquierdo
    mov x12, 315                 // Y position
    mov x13, 5                   // Ancho
    mov x14, 5                   // Alto
    bl circulo
    
    mov x0, x20
    mov x11, 345                 // X position ojo derecho
    bl rectangulo

    // Boca (rectángulo pequeño)
    mov x0, x20
    mov x10, 0x0000              // Color negro
    mov x11, 335                 // X position
    mov x12, 330                 // Y position
    mov x13, 10                  // Ancho
    mov x14, 3                   // Alto
    bl rectangulo

    // Brazos (rectángulos marrones)
    mov x0, x20
    mov x10, 0x4226              // Color marrón
    movk x10, 0x8B, lsl 16
    mov x11, 270                 // X position brazo izquierdo
    mov x12, 370                 // Y position
    mov x13, 30                  // Ancho
    mov x14, 15                  // Alto
    bl rectangulo
    
    mov x0, x20
    mov x11, 380                 // X position brazo derecho
    bl rectangulo

    // Piernas (rectángulos azules)
     mov x0, x20
    mov x10, 0x33000000       // Color azul Cartman (0x00003300) - versión corregida
    mov x11, 310              // X position pierna izquierda
    mov x12, 450              // Y position (sobre la nieve)
    mov x13, 20               // Ancho
    mov x14, 30               // Alto
    bl rectangulo
    
    mov x0, x20
    mov x11, 350              // X position pierna derecha
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
