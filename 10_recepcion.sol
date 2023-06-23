// SPDX-License-Identifier: GPL-3.0

// ME QUEDE EN EL VIDEO 15

pragma solidity >=0.7.0 <0.9.0;

contract Recepcion {
    mapping(address => uint) balances;
    uint public saldoEnviado;

/**
* La función receive se ejecuta cuando se envía ether al contrato sin datos.
* Esta función actualiza el mapa balances con la dirección del remitente y la cantidad enviada.
*/
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

/**
* La función fallback se ejecuta cuando se envía ether al contrato con datos que no coinciden con ninguna otra función.
* Esta función no hace nada.
*/
    fallback() external payable {
    }

/**
* La función recibirSaldo recibe un parámetro llamado numero y es de tipo payable, lo que significa que puede recibir ether.
* Esta función asigna el valor enviado a la variable saldoEnviado y luego declara una variable local llamada monto,
* que es igual al parámetro numero.
*/
    function recibirSaldo(uint _numero) public payable {
        saldoEnviado = msg.value;
        uint monto = _numero;
    }
}