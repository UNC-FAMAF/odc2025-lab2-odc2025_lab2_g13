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
    // 1. Pintar fondo blanco
    // --------------------------
    movz x10, 0xff, lsl 16      // Color blanco (0x00FFFFFF)
    movk x10, 0xffff, lsl 00

    mov x2, SCREEN_HEIGH         // Y Size
loop1:
    mov x1, SCREEN_WIDTH         // X Size
loop0:
    stur w10,[x0]                // Pinta pixel blanco
    add x0, x0, 4                // Siguiente pixel
    sub x1, x1, 1                // Decrementar contador X
    cbnz x1, loop0               // Si no terminó la fila, salto
    sub x2, x2, 1                // Decrementar contador Y
    cbnz x2, loop1               // Si no es la última fila, salto

    // --------------------------
    // 2. Pintar cuadrado rosa
    // --------------------------
    mov x0, x20                  // Restaura dirección del framebuffer
    bl cuadrado                  // Llama a la función

    // --------------------------
    // 3. Loop infinito
    // --------------------------
InfLoop:
    b InfLoop

cuadrado:
    // x0 ya contiene la dirección del framebuffer
    // Configura color rosa (0xC71585)
    movz x10, 0xC7, lsl 16
    movk x10, 0x1585, lsl 00

    // Coordenadas de inicio (x11, x12) = (100, 100)
    mov x11, 100
    mov x12, 100 

    // Tamaño (x13, x14) = (200, 200)
    mov x13, 200
    mov x14, 200

    // Precalcula el stride (ancho de pantalla en bytes)
    mov x15, SCREEN_WIDTH         
    lsl x15, x15, 2              // SCREEN_WIDTH * 4

    mov x2, x14                  // Contador de altura (y)

y_loop:
    // Calcular offset de fila: (y_start + delta_y) * stride
    sub x3, x14, x2              // delta_y
    add x4, x12, x3              // y_actual = y_start + delta_y
    mul x4, x4, x15              // offset_y = y_actual * stride

    // Loop interno para las columnas (x)
    mov x1, x13                  // Contador de ancho (x)
x_loop:
    // Calcular offset de columna: (x_start + delta_x) * 4
    sub x6, x13, x1              // delta_x
    add x7, x11, x6              // x_actual = x_start + delta_x
    lsl x7, x7, 2                // offset_x = x_actual * 4

    // Dirección final del píxel: framebuffer + offset_y + offset_x
    add x8, x0, x4
    add x8, x8, x7

    // Pintar píxel rosa
    stur w10, [x8]

    // Siguiente columna
    sub x1, x1, 1
    cbnz x1, x_loop

    // Siguiente fila
    sub x2, x2, 1
    cbnz x2, y_loop

    ret

	