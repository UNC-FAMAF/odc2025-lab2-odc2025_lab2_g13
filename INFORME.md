Nombre y apellido 
Integrante 1: Luisina Lavayen Golletti, DNI: 46228295
Integrante 2: Lucas Brian Heredia, DNI: 46768715
Integrante 3: Maria Catalina Gavilan Uran, DNI: 46592113
Integrante 4: Bautista Gonzalez, DNI: 46769677 


Descripción ejercicio 1: 
Stan y Wendy de la serie South Park se encuentran de dia al lado de un cartel en la calle, con un ambiente nevado y montañas nevadas de fondo, se encuentran nubes en el mismo con copos de nieve en el cielo. 

Descripción ejercicio 2:
Stan y Wendy ahora se encuentran en el mismo fondo del ejercicio 1, pero ahora las nubes son grises y se mueven de izquierda a derecha y viceversa, notar que la nube de mas arriba sobrepasa la punta de la montaña mas grande al moverse. 

Justificación instrucciones ARMv8:

INSTRUCCIONES QUE NO SE ENCUENTRAN EN LA GREENCARD DE LEGv8 pero si en ARMv8: 
(Usaremos los registros x1 y x2 como ejemplo)   

neg: Niega el registro x2 y guarda el mismo en el registro x1, al igual que CMP, NEG es otra pseudoinstruccion, la cual es mov, hacer por ejemplo NEG x1, x13 es el equivalente a hacer NEG x1, -x13. 
En el programa fue utilizado para realizar desplazamientos desde el centro de una figura, por ejemplo, en la funcion circulo.

sp (Stack Pointer): Como su nombre lo dice, es el puntero a una pila, mas especificamente apunta al tope de la misma, es muy util para guardar y recuperar datos temporales cuando se llaman otras funciones. Es fundamental para la llamada funciones como dibujar_stan, dibujar_wendy y nube, pues preserva el contenido de x30. Esto ayuda mucho a que al volver de una funcion el programa siga funcionando correctamente.

stp: Guarda 2 registros en la pila en donde apunta sp, y luego hace que sp reserve un espacio para poder ser actualizado. Junto a ldp es usado para guardar y restaurar registros como x29, x30, etc. 

ldp: Carga los valores de 2 registros desde la direccion apuntada por sp en la pila y luego la actualiza hacia arriba. Normalmente es usado al salir de una funcion para restaurar el estado de los valores. Junto a stp tambien se usan para guardar y restaurar registros como x29, x30, etc. 

ACA UN EJEMPLO DE STP Y LDP TRABAJADOS EN CONJUNTO:
stp x1, x2, [sp, #-16]!   // Guarda los registros temporales que estan por usarse  

(Codigo) 
   
ldp x1, x2, [sp], #16     // Restaura los registros para que continuar con los valores que se usaban en el 
                          // programa 
