/**
* Este contrato permite consultar el valor de "numeros" y "resultado" mediante funciones públicas generadas automáticamente
* Los eventos son un tipo de dato que sirve para emitir avisos de que ocurrió alguna acción en particular.
* Puede ser utilizado por clientes para escuchar cambios importantes, y también pueden utilizarse para indexar información.
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Eventos {
    uint[] public numeros;
    string public resultado;
    event notificacionDeCondicion(bool condicion);

/**
* El constructor del contrato recibe un parámetro booleano llamado 'condicion' y
* asigna un valor a 'resultado' dependiendo de si condicion es verdadera o falsa.
* Además, emite un evento llamado 'notificacionDeCondicion' con el valor de 'condicion' como argumento.
* El constructor también llena el array 'numeros' con los números del 0 al 9 usando un ciclo for.
*/
    constructor(bool condicion) {
        if (condicion) {
            resultado = "Condicion True";
        }

        else {
            resultado = "Candicion False";
        }

        emit notificacionDeCondicion(condicion);
        for (uint iterador = 0; iterador < 10; iterador++) {
            numeros.push(iterador);
        }
    }
}