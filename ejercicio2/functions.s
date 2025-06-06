.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGH, 480
.equ BITS_PER_PIXEL, 32

.global nube
.global nube_borra
.global triangulo
.global rectangulo
.global rombo
.global drew_stan
.global drew_wendy
.global generar_copos
.global circulo
.global elipse
.global cuarto_elipse

//---------------------
//Funciones auxiliares
//---------------------

nube:
    str x30, [sp, #-16]!        // solo el link register es suficiente
    // Pintar rectángulo base
    mov x0, x20
    mov x10, 0xFFFF
    movk x10, 0xFF, lsl 16
    mov x13, 60
    mov x14, 45
    bl rectangulo

    // Cuarto de elipse izquierda
    mov x0, x20
    add x12, x12, 45
    mov x13, 30
    mov x15, 0
    bl cuarto_elipse

    // Cuarto de elipse derecha
    mov x0, x20
    add x11, x11, 60
    mov x15, 1
    bl cuarto_elipse

    // Elipse central
    mov x0, x20
    sub x11, x11, 30
    sub x12, x12, 45
    bl elipse

    ldr x30, [sp], #16
    ret
    
nube_borra:
    str x30, [sp, #-16]!
    // Rectángulo base en color celeste
    mov x0, x20
    mov x10, 0xd6e7
    movk x10, 0x93, lsl 16
    mov x13, 60
    mov x14, 45
    bl rectangulo

    // Cuarto de elipse izquierda
    mov x0, x20
    add x12, x12, 45
    mov x13, 30
    mov x15, 0
    bl cuarto_elipse

    // Cuarto de elipse derecha
    mov x0, x20
    add x11, x11, 60
    mov x15, 1
    bl cuarto_elipse

    // Elipse central
    mov x0, x20
    sub x11, x11, 30
    sub x12, x12, 45
    bl elipse

    ldr x30, [sp], #16
    ret

drew_stan:
    str x30, [sp, #-16]!    // guarda el link register en stack

//ABRIGO (chaqueta roja)
    mov x0, x20
    mov x10, 0x4226
    movk x10, 0x8B, lsl 16
    mov x13, 80 //a
    mov x14, 80 //b
    bl rectangulo

// CIERRE Y BROCHES DEL ABRIGO 
    mov x0, x20              // Empezamos con el cierre del abrigo
    mov x10, 0x000000        // Negro
    add x11, x11, 40           // Coordenada X centrada en el abrigo
    mov x13, 2               // Ancho muy fino
    mov x14, 80              // Alto igual al del abrigo
    bl rectangulo

    mov x0, x20              // Empezamos con los broches
    mov x10, 0x000000        // Color negro
    mov x13, 3               // Radio pequeño

    //Broche mas alto
    sub x11, x11, 4             // X a la izquierda del cierre
    add x12, x12, 25             // Y bajado para evitar la bufanda
    mov x14, 0               
    bl circulo

   //Broche del medio
    add x12, x12, 25
    bl circulo

   //Broche mas bajo 
    add x12, x12, 25 
    bl circulo

//BUFANDA
    mov x0, x20
    mov x10, 0xCC0000
    add x11, x11, 1                 // X  
    sub x12, x12, 100               // Y  
    mov x13, 40                // Radio
    mov x14, 2
    bl circulo

// Cabeza (círculo piel)
    mov x0, x20
    mov x10, 0xC69C              // Color piel
    movk x10, 0xFF, lsl 16               
    sub x12, x12, 15                 
    mov x13, 45
    mov x14, 0
    bl circulo

//GORRO 
    mov x0, x20 
    mov x10, 0x0000CC
    sub x12, x12, 10
    mov x13, 45
    mov x14, 1
    bl circulo

    mov x0, x20
    mov x10, 0xC69C              // Color piel
    movk x10, 0xFF, lsl 16
    sub x11, x11, 44
    sub x12, x12, 5
    mov x13, 89
    mov x14, 25
    bl rectangulo

    mov x0, x20
    mov x10, 0xCC0000
    sub x11, x11, 1
    sub x12, x12, 10
    mov x13, 90
    mov x14, 10
    bl rectangulo

// Pompón (círculo blanco) 
    mov x0, x20
    mov x10, 0xCC0000
    add x11, x11, 45                // X  
    sub x12, x12, 30              // Y pos más alta 
    mov x13, 10               // Radio un poco mayor 
    mov x14,0
    bl circulo

 // Piernas
    mov x0, x20
    mov x10, 0x0000CC
    sub x11, x11, 40
    add x12, x12, 175
    mov x13, 40
    mov x14, 20
    bl rectangulo
    
    mov x0, x20
    add x11, x11, 45
    bl rectangulo

//Zapatos
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    sub x11, x11, 25
    add x12, x12, 20
    mov x13, 25//a
    mov x14, 6 //b
    bl elipse

    mov x0, x20
    add x11, x11, 45
    bl elipse

// Boca (línea negra)
    mov x0, x20
    mov x10, 0x0000
    sub x11, x11, 35
    sub x12, x12, 115
    mov x13, 20
    mov x14, 2
    bl rectangulo

//Brazos
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    sub x11, x11, 30
    add x12, x12, 53
    mov x13, 14
    mov x14, 41
    bl elipse
    
    mov x0, x20
    add x11, x11, 80
    bl elipse

// Brazos
    mov x0, x20
    mov x10, 0x4226
    movk x10, 0x8B, lsl 16
    sub x11, x11, 80
    mov x13, 13
    mov x14, 40
    bl elipse
    
    mov x0, x20
    add x11, x11, 80
    bl elipse

//borrar borde dentro del cuerpo 
    mov x0, x20
    mov x13, 16
    mov x14, 40
    mov x15, 0
    bl cuarto_elipse

    mov x0, x20
    sub x11, x11, 80
    mov x13, 16
    mov x14, 40
    mov x15, 1
    bl cuarto_elipse

//MANOS 
    mov x0, x20 
    mov x10, 0x0000
    movk x10, 0xCC, lsl 16 
    add x12, x12, 32
    mov x13, 10
    mov x14, 0
    bl circulo

    mov x0, x20 
    add x11, x11, 80
    mov x14, 0
    bl circulo

//CONTORNO DEDO
    mov x0, x20 
    mov x10, 0x0000
    movk x10, 0x00, lsl 16 
    sub x11, x11, 75
    mov x13, 6
    mov x14, 0
    bl circulo

    mov x0, x20 
    add x11, x11, 70
    mov x14, 0
    bl circulo


//DEDO
    mov x0, x20 
    mov x10, 0x0000
    movk x10, 0xCC, lsl 16 
    sub x11, x11, 70
    mov x13, 5
    mov x14,0
    bl circulo

    mov x0, x20 
    add x11, x11, 70
    mov x14, 0
    bl circulo

//CONTORNO OJOS 
    mov x0, x20
    mov x10, 0x000000
    sub x11, x11, 45
    sub x12, x12, 110
    mov x13, 15
    mov x14,0
    bl circulo
    
    add x11, x11, 20
    mov x14,0
    bl circulo

//FONDO OJOS
    mov x0, x20
    mov x10, 0xFFFFFF
    sub x11, x11, 20
    mov x13, 14
    mov x14,0
    bl circulo
    
    add x11, x11, 20
    mov x14,0
    bl circulo

//COLOR OJO
    mov x0, x20
    mov x10, 0x000000
    sub x11, x11, 20
    mov x13, 4
    mov x14,0
    bl circulo

    mov x0, x20
    add x11, x11, 20
    mov x14, 0
    bl circulo

    ldr x30, [sp], #16      // restaura Link register
    ret

drew_wendy:
    str x30, [sp, #-16]!    // guarda el link register en stack

// Pelo 
    mov x0, x20
    mov x10, 0x2e36
    movk x10, 0x38, lsl 16
    mov x13, 92
    mov x14, 60
    bl rectangulo

// ABRIGO (campera violeta)
    mov x0, x20
    mov x10, 0x63b4
    movk x10, 0xa2, lsl 16
    add x11, x11, 9
    add x12, x12, 57
    mov x13, 80 //a
    mov x14, 80 //b
    bl rectangulo 

// CIERRE Y BROCHES DEL ABRIGO 
    mov x0, x20              // Empezamos con el cierre del abrigo
    mov x10, 0x000000        // Negro
    add x11, x11, 40         // Coordenada X centrada en el abrigo
    mov x13, 2               // Ancho muy fino
    mov x14, 80              // Alto igual al del abrigo
    bl rectangulo

    mov x0, x20              // Empezamos con los broches
    mov x10, 0x000000        // Color negro
    mov x13, 3               // Radio pequeño

// Broche mas alto
    sub x11, x11, 4             // X a la izquierda del cierre
    add x12, x12, 25            // Y bajado para evitar la bufanda
    mov x14, 0               
    bl circulo

// Broche del medio
    add x12, x12, 25
    bl circulo

// Broche mas bajo 
    add x12, x12, 25
    bl circulo


//BUFANDA
    mov x0, x20
    mov x10, 0x3957
    movk x10, 0x38, lsl 16
    add x11, x11, 1 
    sub x12, x12, 100               // Y  
    mov x13, 40                // Radio
    mov x14,2
    bl circulo


// Cabeza (círculo piel)
    mov x0, x20
    mov x10, 0xd9b3            // Color piel
    movk x10, 0xfb, lsl 16
    sub x12, x12, 15 
    mov x13, 45                 // Radio
    mov x14,0
    bl circulo


//Pelo sobre la cara    
    //flequillo
    mov x0, x20 
    mov x10, 0x2e36
    movk x10, 0x38, lsl 16
    sub x12, x12, 10
    mov x13, 47
    mov x14, 1
    bl circulo

    mov x0, x20
    mov x10, 0xd9b3            // Color piel
    movk x10, 0xfb, lsl 16
    sub x11, x11, 44
    sub x12, x12, 8
    mov x13, 89
    mov x14, 25
    bl rectangulo

    //mechon izquierdo 1
    mov x0, x20
    mov x10, 0x2e36
    movk x10, 0x38, lsl 16
    sub x12, x12, 2
    mov x13, 10
    mov x14, 30
    mov x15, 3
    bl cuarto_elipse

    //mechon izquierdo 2
    mov x0, x20
    mov x10, 0x2e36
    movk x10, 0x38, lsl 16
    add x11, x11, 10
    mov x13, 10
    mov x14, 10
    mov x15, 3
    bl cuarto_elipse

    //mechon derecho 1
    mov x0, x20
    mov x10, 0x2e36
    movk x10, 0x38, lsl 16
    add x11, x11, 79
    mov x13, 10
    mov x14, 30
    mov x15, 2
    bl cuarto_elipse

    //mechon derecho 2
    mov x0, x20
    mov x10, 0x2e36
    movk x10, 0x38, lsl 16
    sub x11, x11, 9
    mov x13, 10
    mov x14, 10
    mov x15, 2
    bl cuarto_elipse

//Gorro 
    mov x0, x20
    mov x10, 0x87e9
    movk x10, 0xfa, lsl 16
    sub x11, x11, 36
    sub x12, x12, 10
    mov x13, 45
    mov x14, 28
    mov x15, 0
    bl cuarto_elipse

    mov x0, x20
    mov x10, 0x87e9
    movk x10, 0xfa, lsl 16
    mov x13, 45
    mov x14, 28
    mov x15, 1
    bl cuarto_elipse

    mov x0, x20
    mov x10, 0x2931
    movk x10, 0x2c, lsl 16
    sub x12, x12, 20
    mov x13, 10
    mov x14, 5
    bl elipse

//CONTORNO Brazos
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    sub x11, x11, 40
    add x12, x12, 128
    mov x13, 14
    mov x14, 41
    bl elipse
    
    mov x0, x20
    add x11, x11, 80
    bl elipse


// Brazos
    mov x0, x20
    mov x10, 0x63b4
    movk x10, 0xa2, lsl 16
    sub x11, x11, 80
    mov x13, 13
    mov x14, 40
    bl elipse

    mov x0, x20
    add x11, x11, 80
    bl elipse

//borrar borde dentro del cuerpo 
    mov x0, x20
    mov x13, 16
    mov x14, 40
    mov x15, 0
    bl cuarto_elipse

    mov x0, x20
    sub x11, x11, 80
    mov x13, 16
    mov x14, 40
    mov x15, 1
    bl cuarto_elipse

//CONTORNO OJOS 

    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    add x11, x11, 30
    sub x12, x12, 78
    mov x13, 15
    mov x14, 0
    bl circulo
    
    add x11, x11, 20
    mov x14, 0
    bl circulo

//FONDO OJOS

    mov x0, x20
    mov x10, 0xffff
    movk x10, 0xff, lsl 16
    sub x11, x11, 20
    mov x13, 14
    mov x14, 0
    bl circulo
    
    add x11, x11, 20
    mov x14, 0
    bl circulo

//COLOR OJO

    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    sub x11, x11, 20
    mov x13, 2
    mov x14, 0
    bl circulo

    mov x0, x20
    add x11, x11, 20
    mov x14,0
    bl circulo

// Sonrisa
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    sub x11, x11, 10
    add x12, x12, 28
    mov x13, 12
    mov x14, 6
    bl elipse

    
    mov x0, x20
    mov x10, 0xd9b3
    movk x10, 0xfb, lsl 16
    mov x13, 10
    mov x14, 4
    bl elipse

    mov x0, x20
    mov x10, 0xd9b3
    movk x10,  0xfb, lsl 16
    sub x11, x11, 12
    sub x12, x12, 6
    mov x13, 25
    mov x14, 8
    bl rectangulo

 // Vestido
    mov x0, x20
    mov x10, 0xdc05
    movk x10, 0xfa, lsl 16
    sub x11, x11, 22
    add x12, x12, 98 
    mov x13, 74
    mov x14, 20
    bl rectangulo
    

//Zapatos
    mov x0, x20
    mov x10, 0x0000
    movk x10, 0x00, lsl 16
    add x11, x11, 14 //x
    add x12, x12, 20 //y
    mov x13, 25//a
    mov x14, 6 //b
    bl elipse

    mov x0, x20
    add x11, x11, 45
    bl elipse

//MANOS 
    mov x0, x20 
    mov x10, 0xd9b3
    movk x10, 0xfb, lsl 16 
    sub x11, x11, 65
    sub x12, x12, 30
    mov x13, 10
    mov x14,0
    bl circulo

    mov x0, x20 
    add x11, x11, 80
    mov x14, 0
    bl circulo

//CONTORNO DEDO

    mov x0, x20 
    mov x10, 0x0000
    movk x10, 0x00, lsl 16 
    sub x11, x11, 75
    mov x13, 6
    mov x14,0
    bl circulo

    mov x0, x20 
    add x11, x11, 70
    mov x14, 0
    bl circulo


// DEDO

    mov x0, x20 
    mov x10, 0xd9b3
    movk x10, 0xfb, lsl 16 
    sub x11, x11, 70
    mov x13, 5
    mov x14,0
    bl circulo

    mov x0, x20 
    add x11, x11, 70
    mov x14, 0
    bl circulo

    ldr x30, [sp], #16      // restaura Link register
    ret

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

    mov x15, SCREEN_WIDTH
    lsl x15, x15, 2          // stride

    mov x2, #0               // fila actual

y_loop_tr:
    add x4, x12, x2          // y_actual
    mul x4, x4, x15          // offset_y

    lsl x5, x2, 1
    add x5, x5, #1           // columnas

    sub x6, x11, x2          // x_inicio

x_loop_tr:
    lsl x7, x6, 2
    add x8, x20, x4
    add x8, x8, x7
    stur w10, [x8]

    add x6, x6, #1
    sub x5, x5, #1
    cbnz x5, x_loop_tr

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

//Registro x14 indica el modo en el que se desea pintar el circulo 

    stp x1, x2, [sp, #-16]!
    stp x3, x4, [sp, #-16]!
    stp x5, x6, [sp, #-16]!
    stp x7, x8, [sp, #-16]!
    stp x9, x10, [sp, #-16]!

    mov x1, -1 * 1000
    neg x1, x13        // dx = -radio

dx_loop:
    cmp x1, x13
    b.gt end_loop

    mov x2, -1 * 1000
    neg x2, x13        // dy = -radio

dy_loop:
    cmp x2, x13
    b.gt inc_dx

    // Ver si está dentro del círculo: dx² + dy² <= r²
    mul x3, x1, x1     // dx²
    mul x4, x2, x2     // dy²
    add x5, x3, x4
    mul x6, x13, x13   // r²
    cmp x5, x6
    b.gt inc_dy        // fuera del círculo

    // Check de orientación (modo)
    // Calculamos coordenadas relativas
    // Si x14 == 1 (arriba) -> dy < 0
    // Si x14 == 2 (abajo) -> dy >= 0
    // Si x14 == 3 (izquierda) -> dx < 0
    // Si x14 == 4 (derecha) -> dx >= 0

    cmp x14, #0
    beq pintar

    cmp x14, #1        // arriba
    beq check_arriba

    cmp x14, #2        // abajo
    beq check_abajo

    cmp x14, #3        // izq
    beq check_izq

    cmp x14, #4        // der
    beq check_der
    
    b inc_dy           // valor inválido

check_arriba:
    cmp x2, #0        // dy < 0
    b.lt pintar
    b inc_dy


check_abajo:
    cmp x2, #0
    b.ge pintar
    b inc_dy

check_izq:
    cmp x1, #0
    b.lt pintar
    b inc_dy

check_der:
    cmp x1, #0
    b.ge pintar
    b inc_dy

pintar:
    add x7, x11, x1     // x = x_center + dx
    add x8, x12, x2     // y = y_center + dy

    // Si el pixel está fuera de la pantalla, no pintar
    cmp x7, #0
    blt inc_dy
    cmp x7, #SCREEN_WIDTH
    b.ge inc_dy
    cmp x8, #0
    blt inc_dy
    cmp x8, #SCREEN_HEIGH
    b.ge inc_dy

    // Calcular offset
    mov x9, SCREEN_WIDTH
    mul x9, x8, x9      // y * SCREEN_WIDTH
    add x9, x9, x7      // + x
    lsl x9, x9, #2      // * 4 bytes por píxel

    add x9, x0, x9
    str w10, [x9]

inc_dy:
    add x2, x2, 1
    b dy_loop

inc_dx:
    add x1, x1, 1
    b dx_loop

end_loop:
    ldp x9, x10, [sp], #16
    ldp x7, x8, [sp], #16
    ldp x5, x6, [sp], #16
    ldp x3, x4, [sp], #16
    ldp x1, x2, [sp], #16
    ret

elipse:
    // x11 = xc (centro x)
    // x12 = yc (centro y)
    // x13 = a (radio horizontal)
    // x14 = b (radio vertical)
    // x20 = framebuffer base
    // w10 = color (32 bits)

    // Calcular stride (bytes por fila)
    mov x15, SCREEN_WIDTH
    lsl x15, x15, 2        // stride = SCREEN_WIDTH * 4 bytes

    // Calcular a² y b² para la ecuación de la elipse
    mul x16, x13, x13      // a²
    mul x17, x14, x14      // b²

    // Inicializar variables para iterar x de -a a a
    neg x1, x13            // x = -a

elipse_x_loop:
    // Precalcular b²*x²
    mul x18, x1, x1        // x²
    mul x18, x18, x17      // b² * x²

    mov x2, x14            // y = -b (inicial)
    neg x2, x2

elipse_y_loop:
    // Precalcular a²*y²
    mul x19, x2, x2        // y²
    mul x19, x19, x16      // a² * y²

    // Sumar b²*x² + a²*y²
    add x26, x18, x19      // usar x26 en lugar de pisar x20

    // Comparar con a²*b²
    mul x21, x16, x17      // a²*b²
    cmp x26, x21
    bgt elipse_y_next      // Si está fuera de la elipse, no pinta

    // Calcular offset para pixel (xc + x, yc + y)
    add x22, x12, x2       // y_actual = yc + y
    mul x23, x22, x15      // offset_y = y_actual * stride

    add x24, x11, x1       // x_actual = xc + x
    lsl x24, x24, 2        // offset_x = x_actual * 4

    add x25, x20, x23      // framebuffer + offset_y
    add x25, x25, x24      // + offset_x

    stur w10, [x25]        // pintar pixel

elipse_y_next:
    add x2, x2, 1
    cmp x2, x14
    ble elipse_y_loop

    add x1, x1, 1
    cmp x1, x13
    ble elipse_x_loop

    ret

cuarto_elipse:
    // x11 = xc (centro x)
    // x12 = yc (centro y)
    // x13 = a (radio horizontal)
    // x14 = b (radio vertical)
    // x15 = cuarto (0 a 3)
    // x20 = framebuffer base
    // w10 = color (32 bits)

    // Calcular stride (bytes por fila)
    mov x16, SCREEN_WIDTH
    lsl x16, x16, 2        // stride = SCREEN_WIDTH * 4 bytes

    // Calcular a² y b² para la ecuación de la elipse
    mul x17, x13, x13      // a²
    mul x18, x14, x14      // b²

    // Inicializar variables para iterar x de -a a a
    neg x1, x13            // x = -a

cuarto_elipse_x_loop:
    // Precalcular b²*x²
    mul x19, x1, x1        // x²
    mul x19, x19, x18      // b² * x²

    mov x2, x14            // y = -b (inicial)
    neg x2, x2

cuarto_elipse_y_loop:
    // Precalcular a²*y²
    mul x21, x2, x2        // y²
    mul x21, x21, x17      // a² * y²

    // Sumar b²*x² + a²*y²
    add x22, x19, x21      // resultado de la ecuación

    // Comparar con a²*b²
    mul x23, x17, x18      // a²*b²
    cmp x22, x23
    bgt cuarto_elipse_y_next // Fuera de la elipse, no pinta

    // Filtrar por cuarto:
    // x < 0 → izquierda
    // x >= 0 → derecha
    // y < 0 → arriba
    // y >= 0 → abajo

    // Comprobar el cuarto
    cmp x15, 0
    beq check_0
    cmp x15, 1
    beq check_1
    cmp x15, 2
    beq check_2
    cmp x15, 3
    beq check_3
    b cuarto_elipse_y_next  // Si x15 no es válido, salta

check_0: // superior izquierda: x < 0 && y < 0
    cmp x1, 0
    bge cuarto_elipse_y_next
    cmp x2, 0
    bge cuarto_elipse_y_next
    b pintar_pixel

check_1: // superior derecha: x >= 0 && y < 0
    cmp x1, 0
    blt cuarto_elipse_y_next
    cmp x2, 0
    bge cuarto_elipse_y_next
    b pintar_pixel

check_2: // inferior izquierda: x < 0 && y >= 0
    cmp x1, 0
    bge cuarto_elipse_y_next
    cmp x2, 0
    blt cuarto_elipse_y_next
    b pintar_pixel

check_3: // inferior derecha: x >= 0 && y >= 0
    cmp x1, 0
    blt cuarto_elipse_y_next
    cmp x2, 0
    blt cuarto_elipse_y_next
    // cae a pintar_pixel

pintar_pixel:
    // Calcular offset para pixel (xc + x, yc + y)
    add x24, x12, x2       // y_actual = yc + y
    mul x25, x24, x16      // offset_y = y_actual * stride

    add x26, x11, x1       // x_actual = xc + x
    lsl x26, x26, 2        // offset_x = x_actual * 4

    add x9, x20, x25       // framebuffer + offset_y
    add x9, x9, x26        // + offset_x

    stur w10, [x9]         // pintar pixel

cuarto_elipse_y_next:
    add x2, x2, 1
    cmp x2, x14
    ble cuarto_elipse_y_loop

    add x1, x1, 1
    cmp x1, x13
    ble cuarto_elipse_x_loop

    ret 
    