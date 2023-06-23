/**
* Define un contrato llamado Transferencia que permite enviar ether a otras direcciones usando tres métodos diferentes: send, transfer y call.
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Transferencia {
    constructor() payable {
    }

/**
* El método transferenciaPorSend usa la función send de la dirección de destino, que intenta enviar el monto especificado y devuelve false si falla.
*/
    function transferenciaPorSend(address _destino, uint _monto) public returns(bool) {
        bool salida = payable(_destino).send(_monto);
        return salida;
    }

/**
* El método transferenciaPorTransfer usa la función transfer de la dirección de destino, que envía el monto especificado y revierte la transacción si falla.
*/
    function transferenciaPorTransfer(address _destino, uint _monto) public {
        payable(_destino).transfer(_monto);
    }

/**
* El método transferenciaPorCall usa la función call de bajo nivel de la dirección de destino, que envía el monto especificado y
* devuelve un valor booleano que indica el resultado de la operación. La función call también permite enviar datos arbitrarios como argumento,
* pero en este caso se envía una cadena vacía.
*/
    function transferenciaPorCall(address _destino, uint _monto) public returns (bool) {
        (bool salida, ) = _destino.call{ value:_monto }("");
        return salida;
    }
}