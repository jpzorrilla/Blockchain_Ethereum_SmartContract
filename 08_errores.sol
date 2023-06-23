/**
* Manejo de errores
* assert: Se utiliza para pruebas, compara dos valores
* revert: Es un error que regresa todas las modificaciones de estado realizadas durante la ejecución de la función, recibe por parámetro un mensaje de error
* require: Es una variación del revert que recibe por parámetro una expresión booleana y revierte si esta expresión es falsa.
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Errores {
    address private owner;

/**
* El constructor del contrato asigna el valor de owner al remitente del mensaje que crea el contrato.
*/
    constructor() {
        owner = msg.sender;
    }

/**
* La función Suma recibe dos números enteros sin signo (_numero1 y _numero2) como parámetros y devuelve la suma de ambos.
* La función Suma tiene un modificador esOwner que verifica que el remitente del mensaje
* sea el mismo que el creador del contrato, y si no lo es,
* lanza un error con el mensaje "El usuario no es el creador del contrato".
*/
    function Suma(uint _numero1, uint _numero2) public view esOwner()
    returns (uint) {
        return _numero1 + _numero2;
    }

/**
* El modificador esOwner se define al final del código con la palabra clave modifier y
* usa la función require para hacer la comprobación.
*/
    modifier esOwner() {
        require(msg.sender == owner, "El usuario no es el creador del contrato");
        _;
    }
}