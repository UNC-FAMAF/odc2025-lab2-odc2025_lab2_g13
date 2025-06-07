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
    
    mov x0, x20              // Restaurar framebuffer base después del fondo

/* ¿Qué parámetros utiliza cada función geométrica?

    Funciones básicas (figuras geométricas):
    - triangulo:
        Pinta un triángulo isósceles con base horizontal y vértice superior, centrado horizontalmente.
        x10 = Color
        x11 = Coordenada x del vértice superior
        x12 = Coordenada y del vértice superior 
        x13 = Altura

    - rectangulo:
        Dibuja un rectángulo relleno, con base y altura variables.
        x10 = Color
        x11 = Coordenada x del vértice superior
        x12 = Coordenada y del vértice superior
        x13 = Ancho
        x14 = Alto

    - rombo:
        Dibuja un rombo relleno dada la distancia vertical desde el centro hasta un vértice.
        x10 = Color
        x11 = Coordenada X del centro del rombo.
        x12 = Coordenada Y del centro del rombo.
        x13 = Radio (altura hasta el vértice)

    - circulo:
        Dibuja un círculo relleno o porciones del mismo.
        x10 = Color
        x11 = Coordenada X del centro.
        x12 = Coordenada Y del centro.
        x13 = Radio.
        x14 = Sección a pintar:
            0: Completo
            1: Mitad superior
            2: Mitad inferior
            3: Mitad izquierda
            4: Mitad derecha

    - elipse:
        Dibuja una elipse rellena.
        x10 = Color
        x11 = Coordenada X del centro.
        x12 = Coordenada Y del centro.
        x13 = Radio horizontal
        x14 = Radio vertical

    - cuarto_elipse:
        Dibuja un cuarto específico de una elipse.
        x10 = Color
        x11 = Coordenada X del centro.
        x12 = Coordenada Y del centro.
        x13 = Radio horizontal
        x14 = Radio vertical
        x15 = Cuarto a pintar:
            0: Arriba-Izquierda
            1: Arriba-Derecha
            2: Abajo-Izquierda
            3: Abajo-Derecha

    Funciones de animacion:
    -loop_animar:
        Sirve como bucle de animacion
        x11 = Posiciones X de las nubes
        x12 = altura 
        x16 = Control de delay y movimiento
    
    -delay_loop:
        Es un retraso que ayuda a realentizar la animacion
        x11 = Posiciones X de las nubes
        x12 = Altura
        x16 = Contador
        x27 = Dirección de movimiento de nubes
    
    -controlar_derecha:
        Controla el rebote horizontal de la segunda nube  
        x27 = Dirección de movimiento
        x28 = Posición actual de la nube 


    Las demás funciones (dibujar_stan, nube, nube_borra, etc.) son combinaciones de las anteriores.
*/


    // --------------------------
    // Pintar triangulos
    // --------------------------

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

// DIBUJAR LAS LETRAS OdC2025 
    
    // Este bloque pinta las letras OdC2025 con el color del asfalto
    mov x10, 0x424d
    movk x10, 0x4c, lsl 16

    // Posición base de las letras 
    // En x16 las coords de la base vertical
    movz x16, 278

   //Las dibujo utilizando rectángulos que como dice mas arriba:

    // OBSERVEMOS que ocurre algo en particular en uno de los parametros de la funcion rectangulo:
    // x10 = Guarda el color del rectangulo. 
    //Este se guardó al principo asi que no lo vovemos a guardar

    // Dibujo la letra O:
    // Comienzo con las líneas horizontales superior e inferior

// LETRA O
    movz x13, 10 // determino que el ancho es 5*2, es decir 5 bloques de 2px => 10
    movz x14, 2 // el ancho es 1*2, es decir un bloque de 2px => 2
    
    // ahora guardo las coords de la base en los parametros de inicio
    mov x11, 510 //esta es la base horizontal
    mov x12, x16
    bl rectangulo
    add x12, x16, 8
    bl rectangulo //Una vez obtenidos todos los parámetros dibuja la línea de arriba

    movz x13, 2
    movz x14, 8
    mov x11, 510
    mov x12, 280
    bl rectangulo
    mov x11, 518
    bl rectangulo

// LETRA d

    movz x13, 6   // ancho panza
    movz x14, 6   // alto panza
    mov x11, 524
    mov x12, 280
    bl rectangulo

    movz x13, 2   // palo derecho pero finito
    movz x14, 10  // más alto que la panza
    mov x11, 530
    mov x12, 276
    bl rectangulo


// LETRA C

    movz x13, 10  // horizontal arriba
    movz x14, 2
    mov x11, 536
    mov x12, 276
    bl rectangulo

    add x12, x12, 8 // bajo para la línea de abajo
    bl rectangulo

    movz x13, 2   // lateral izq
    movz x14, 8
    mov x11, 536
    mov x12, 278
    bl rectangulo

// NUMERO 2

    movz x13, 10
    movz x14, 2
    mov x11, 548
    mov x12, 276
    bl rectangulo // parte de arriba

    add x12, x12, 4
    bl rectangulo // parte del medio

    add x12, x12, 4
    bl rectangulo // parte de abajo

    movz x13, 2
    movz x14, 4
    mov x11, 556
    mov x12, 278
    bl rectangulo // vertical de la derecha

    mov x11, 548
    mov x12, 282
    bl rectangulo // diagonal izquierda

// NUMERO 0

    movz x13, 10
    movz x14, 2
    mov x11, 560
    mov x12, 276
    bl rectangulo // línea de arriba

    add x12, x16, 8
    bl rectangulo // línea de abajo

    movz x13, 2
    movz x14, 8
    mov x11, 560
    mov x12, 278
    bl rectangulo // lateral izq

    mov x11, 568
    bl rectangulo // lateral der

// SEGUNDO 2 (igual al anterior con coords distintas)

    movz x13, 10
    movz x14, 2
    mov x11, 572
    mov x12, 276
    bl rectangulo
    add x12, x12, 4
    bl rectangulo
    add x12, x12, 4
    bl rectangulo

    movz x13, 2
    movz x14, 4
    mov x11, 580
    mov x12, 278
    bl rectangulo

    mov x11, 572
    mov x12, 282                       
    bl rectangulo

 // NUMERO 5

    movz x13, 10
    movz x14, 2
    mov x11, 584
    mov x12, 276
    bl rectangulo // horizontal de arriba
    mov x12, 280
    bl rectangulo // horizontal medio
    mov x12, 284
    bl rectangulo // parte de abajo abajo

    movz x13, 2
    movz x14, 4
    mov x11, 584
    mov x12, 278
    bl rectangulo // verticar lado izq

    mov x11, 592
    mov x12, 282
    bl rectangulo // vertical lado de la dercha

//---------------------------------------------//
//         STAN SOUTH PARK                    //
//-------------------------------------------//

    mov x0, x20
    mov x11, 308
    mov x12, 340
    bl dibujar_stan

//---------------------------------------------//
//         Wendy                              //
//-------------------------------------------//
    mov x0, x20
    mov x11, 141
    mov x12, 283
    bl dibujar_wendy

    // Restaurar framebuffer
    mov x0, x20

    // Inicializar variables
    mov x29, 0     // X inicia de la nube

    mov x28, 300       // Posición inicial nube 2 (empieza a la derecha)
    mov x27, -1        // Dirección inicial: -1 (va hacia la izquierda)

loop_animar:

    // Dibujar nube
    mov x0, x20
    mov x11, x29
    mov x12, 80
    bl nube

    // Dibujar nube 2
    mov x0, x20
    mov x11, x28
    mov x12, 160         // altura más abajo
    bl nube

    // Delay simple       
    movz x16, 0x02, lsl 16
    movk x16, 0xffFF
    lsl x16, x16, 5

delay_loop:
    subs x16, x16, 1
    b.ne delay_loop

    mov x11, x29
    mov x12, 80
    bl nube_borra

    // Borrar nube 2
    mov x11, x28
    mov x12, 160
    bl nube_borra

    //Nieve en la montaña 2
    mov x0, x20
    mov x10, 0xf8f8
    movk x10, 0xf8, lsl 16
    mov x11, 100
    mov x12, 100
    mov x13, 100
    bl triangulo

    // Calcular nueva posición
    add x29, x29, 1

    // Mover nube 2
    add x28, x28, x27

    // control de rebote
    cmp x28, 250
    b.ge controlar_derecha
    mov x27, 1
    b despues_del_control

    controlar_derecha:
    cmp x28, 525
    b.le despues_del_control
    mov x27, -1

    despues_del_control:

    bl loop_animar

    // --------------------------
    // Loop infinito
    // --------------------------
InfLoop:
    b InfLoop

//---------------------
//Funciones auxiliares
//---------------------

//Se encuentran en functions.s
