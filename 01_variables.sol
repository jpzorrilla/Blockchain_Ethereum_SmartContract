/**
* Especifica la versión del compilador de Solidity que se debe usar (>=0.7.0 <0.9.0)
*  y la licencia del código (MIT)
*/

// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

/**
* Este código define un contrato llamado 'Estructura'
* Tiene 4 variables de estado:
* 'cantidad' (almacenan un número entero con signo)
* 'cantidadSinSigno' (un número entero sin signo)
* 'direccion' (una dirección de Ethereum)
* 'firmado' (un valor booleano)
*/
contract Estructura {
    int cantidad;
    uint cantidadSinSigno;
    address direccion;
    bool firmado;

/**
* El contrato tiene un constructor que recibe un parámetro de tipo booleano llamado 'estaFirmado'.
* El constructor asigna el valor del parámetro a la variable 'firmado' y
* también asigna la dirección del creador del contrato a la variable 'direccion'.
* El constructor se ejecuta 1 sola vez cuando se despliega el contrato en la red Ethereum.
*/
    constructor(bool estaFirmado) {
        direccion = msg.sender;
        firmado = estaFirmado;
    }
}