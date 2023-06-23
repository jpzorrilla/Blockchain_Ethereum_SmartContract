/**
* Un modificador es un tipo especial de función que se usa para modificar el comportamiento de otras funciones.
* Por ejemplo, los desarrolladores pueden usar un modificador para comprobar que se cumple una cierta condición
* antes de permitir que se ejecute la función.
* Los modificadores son similares a las funciones, en el sentido de que pueden tomar argumentos y tener un tipo de retorno.
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
* Este código de Solidity define un contrato llamado 'Modificadores'
* que tiene una variable de estado privada llamada 'owner',
* un constructor que asigna el valor de 'owner' al remitente de la transacción,
* una función llamada 'Suma' que devuelve la suma de dos números enteros sin signo y
* un modificador llamado 'esOwner' que verifica si el remitente de la llamada es el mismo que el propietario del contrato.
*/
contract Modificadores {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

/**
* La función 'Suma' tiene el modificador 'esOwner' adjunto a su declaración,
* lo que significa que solo se puede llamar si el remitente es el propietario del contrato.
* Además, tiene la palabra clave 'view', que indica que no modifica el estado del contrato.
* La función toma dos parámetros de tipo 'uint' (entero sin signo) y devuelve su suma como otro 'uint'.
*/
    function Suma(uint _numero1, uint _numero2) public view esOwner()
    returns (uint) {
        return _numero1 + _numero2;
    }

/**
* El modificador 'esOwner' toma como argumento la dirección del remitente de la llamada y
* compara si es igual a la dirección del propietario del contrato.
* Si no lo es, revierte la transacción usando la función 'revert()'.
* Si lo es, continúa con la ejecución de la función usando el carácter especial '_'.
*/
    modifier esOwner() {
        if (msg.sender != owner) revert();
        _;
    }
}