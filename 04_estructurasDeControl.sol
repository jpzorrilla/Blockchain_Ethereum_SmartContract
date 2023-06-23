/**
* Contrato que permite consultar el valor de las variables numeros y resultado desde cualquier cuenta externa
*/

// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

contract EstructuraDeControl {
    uint[] public numeros;
    string public resultado;

/**
* El constructor del contrato recibe un parámetro booleano llamado 'condicion' y
* asigna un valor a la variable 'resultado' según si el parámetro es verdadero o falso.
* Luego, el constructor ejecuta un bucle for que agrega los números del 0 al 9 al array 'numeros'
*/
    constructor(bool condicion) {
        if (condicion) {
            resultado = "Condicion True";
        }

        else {
            resultado = "Condicion False";
        }

        for (uint iterador = 0; iterador < 10; iterador++) {
            numeros.push(iterador);
        }
    }
}