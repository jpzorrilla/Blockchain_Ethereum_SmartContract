/**
* Contrato llamado "Funciones" que tiene cuatro funciones: Suma, sumaInterna, obtenerResultado
* Las funciones son piezas de código definidas por un nombre, parámetros y modificadores
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
* Modificadores de acceso: public, private, internal, external.
* Modificadores de mutabilidad: view, pure.
* En el desarrollo Solidity existe una convención no obligatoria y es que
* todos los parámetros de una función empiecen con guión bajo (p. ej. _numero).
*/

/**
* La función 'Suma' toma 2 números enteros sin signo (uint) como parámetros y
* devuelve la suma de ellos usando la función 'sumaInterna'.
*/
contract Funciones {
    function Suma(uint _numero1, uint _numero2) public pure returns (uint) {
        return sumaInterna(_numero1, _numero2);
    }

/**
* La función 'sumaInterna' es privada y pura,
* lo que significa que solo puede ser llamada desde dentro del contrato y
* que no modifica el estado del mismo.
*/
    function sumaInterna(uint _numero1, uint _numero2) private pure returns(uint) {
        return _numero1 + _numero2;
    }

/**
* La función 'obtenerResultado' es pública y de solo lectura (view),
* lo que significa que puede ser llamada desde fuera del contrato y que solo lee el estado del contrato.
* Esta función devuelve el valor de la variable 'resultado', que es privada y se inicializa en cero en el constructor.
*/
    uint private resultado;

    function obtenerResultado() public view returns (uint) {
        return resultado;
    }
}