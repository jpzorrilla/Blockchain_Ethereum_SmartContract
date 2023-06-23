/**
* Este código muestra cómo inicializar variables de estado y
* cómo usar el modificador public para hacerlas accesibles desde fuera del contrato.
*/

// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

/**
* Define un contrato llamado 'saldo' que tiene un mapeo de direcciones a enteros sin signo llamado 'balance' y
* una enumeración de estados llamada 'Estado'.
* El contrato tiene una variable pública de tipo Estado llamada 'estadoDelContrato' que indica el estado actual del contrato.
*/
contract saldo {
    mapping(address => uint) public balance;
    enum Estado { Iniciado, Finalizado}
    Estado public estadoDelContrato;

/**
* El contrato tiene un constructor que se ejecuta 1 sola vez cuando se despliega el contrato en la red.
* El constructor asigna el valor Iniciado a la variable 'estadoDelContrato',
* luego asigna el valor 1000 al balance de la dirección que desplegó el contrato (msg.sender) y
* finalmente asigna el valor Finalizado a la variable 'estadoDelContrato'.
*/
    constructor() {
        estadoDelContrato = Estado.Iniciado;
        balance[msg.sender] = 1000;
        estadoDelContrato = Estado.Finalizado;
    }
}