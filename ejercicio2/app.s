.equ SCREEN_WIDTH,      640
.equ SCREEN_HEIGH,      480
.equ BITS_PER_PIXEL,    32
.equ GPIO_BASE,        0x3f200000
.equ GPIO_GPFSEL0,     0x00
.equ GPIO_GPLEV0,      0x34

.globl main
.global cuadrado 

/*INSTRUCCIONES QUE NO SE ENCUENTRAN EN LA GREENCARD DE LEGv8:
    (Usaremos los registros x1 y x2 como ejemplo)

    neg: Niega el registro x2 y guarda el mismo en el registro x1, al igual que CMP, NEG es otra pseudoinstruccion, la cual es mov, hacer por ejemplo NEG x1, x13 es el equivalente a hacer NEG x1, -x13. En el programa fue utilizado para realizar desplazamientos desde el centro de una figura, por ejemplo, en la funcion circulo.

    sp (Stack Pointer): Como su nombre lo dice, es el puntero a una pila, mas especificamente apunta al tope de la misma, es muy util para guardar y recuperar datos temporales cuando se llaman otras funciones, como en circulo por ejemplo. Es fundamental tambien para las instrucciones STP y LDP.

    stp: Guarda 2 registros en memoria en donde apunta sp, y luego hace que sp reserve un espacio para poder ser actualizado. Normalmente es usado al entrar a una funcion para guardar los registros y usarlos para una dererminada funcion.

    ldp: Carga los valores de 2 registros desde la direccion apuntada por sp en memoria y luego la actualiza hacia arriba. Normalmente es usado al salir de una funcion para restaurar el estado de los valores.

    ACA UN EJEMPLO DE STP Y LDP TRABAJADOS EN CONJUNTO:
    stp x1, x2, [sp, #-16]!   // Guarda los registros temporales que estan por usarse 
  
    (Codigo) 
   
    ldp x1, x2, [sp], #16     // Restaura los registros para que continuar con los valores que se usaban en el 
                              // programa
*/



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


//Nube 1
    mov x0, x20
    mov x11, 200
    mov x12, 65
    bl nube

//Nube 2
    mov x0, x20
    mov x11, 500
    mov x12, 85
    bl nube

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

//---------------------------------------------//
//         STAN SOUTH PARK                    //
//-------------------------------------------//

    mov x0, x20
    mov x11, 308
    mov x12, 340
    bl drew_stan

//---------------------------------------------//
//         Wendy                              //
//-------------------------------------------//
    mov x0, x20
    mov x11, 141
    mov x12, 283
    bl drew_wendy

//--------------------------------------------
//Generamos los copos de nieve para el fondo
//--------------------------------------------
    bl generar_copos
    mov x0, x20 

// ---------------------------------------------
// Inicializar desplazamiento de nubes
// ---------------------------------------------
    mov x27, #0        // desplazamiento nube 1
    mov x28, #0        // desplazamiento nube 2

// ---------------------------------------------
// Bucle de animación de nubes
// ---------------------------------------------
loop_anim_nubes:

    // Calcular posición actual nube 1
    mov x5, #640         // posición inicial derecha
    sub x5, x5, x27      // x5 = 640 - desplazamiento

    // Calcular posición actual nube 2
    mov x6, #880         // nube 2 empieza más lejos (fuera de pantalla)
    sub x6, x6, x28

    // Borrar nube 1 (área anterior)
    mov x0, x20
    mov x10, 0xd6e7
    movk x10, 0x0093, lsl 16
    mov x11, x5
    mov x12, #40         // Y fija nube 1
    mov x13, #80         // ancho
    mov x14, #60         // alto
    bl rectangulo

    // Borrar nube 2
    mov x0, x20
    mov x11, x6
    mov x12, #60         // Y fija nube 2
    mov x13, #80
    mov x14, #60
    bl rectangulo

    // Dibujar nube 1
    mov x0, x20
    mov x11, x5
    mov x12, #40
    bl nube

    // Dibujar nube 2
    mov x0, x20
    mov x11, x6
    mov x12, #60
    bl nube

    // Aumentar desplazamiento
    add x27, x27, #2
    add x28, x28, #2

    // Reiniciar desplazamiento cuando salen de pantalla
    cmp x27, #720
    b.lt .ok1
    mov x27, #0
.ok1:
    cmp x28, #880
    b.lt .ok2
    mov x28, #0
.ok2:

    // el delay(no funciona muy bien!!)
    movz x0, 0x2, lsl 16
    movk x0, 0xFFFF
.delay_loop:
    subs x0, x0, #1
    b.ne .delay_loop

    // Repetir animación
    b loop_anim_nubes

    // --------------------------
    // Loop infinito
    // --------------------------
InfLoop:
    b InfLoop

//---------------------
//Funciones auxiliares
//---------------------

//Se encuentran en functions.s
