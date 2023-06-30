/**
* Este código define un contrato inteligente que implementa las funciones básicas de un token ERC20.
* Un token ERC20 es un estándar para crear criptomonedas compatibles con la red Ethereum.
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
* - Tiene un nombre público y constante ("WhatEverCoin"), un símbolo público y constante ("WEC") y
* un número de decimales público y constante (18).
* Estos atributos sirven para identificar el token y definir su unidad mínima.
*/
contract tokenBasico {
    string public constant name = "WhatEverCoin";
    string public constant symbol = "WEC";
    uint8 public constant decimals = 18;

/**
* Tiene una variable interna llamada _totalSupply, que almacena la cantidad total de tokens creados.
* Esta variable se inicializa en el constructor del contrato, que recibe como parámetro el total de tokens a emitir.
*/ 
    uint256 _totalSupply;

/**
* Tiene un mapeo llamado balances, que asocia cada dirección con la cantidad de tokens que posee.
* Un mapeo es una estructura de datos que permite guardar pares clave-valor.
* En este caso, la clave es una dirección y el valor es un número entero sin signo de 256 bits (uint256).
* Tiene otro mapeo llamado allowed, que asocia cada dirección con otro mapeo que a su vez
* asocia cada dirección con la cantidad de tokens que puede gastar en su nombre.
* Esto sirve para implementar la funcionalidad de aprobación, que permite a un usuario autorizar a otro a usar sus tokens.
*/
    mapping(address => uint256) balances;
    mapping (address => mapping(address => uint256)) allowed;

/**
- Tiene dos eventos llamados Transfer y Approval,
* que se emiten cuando se realiza una transferencia o una aprobación de tokens, respectivamente.
* Un evento es una forma de registrar información en la cadena de bloques, que puede ser leída por aplicaciones externas.
* Los eventos tienen parámetros indexados, que facilitan la búsqueda y el filtrado de los mismos.
*/
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value 
    );

/**
* El constructor también asigna todos los tokens al creador del contrato, usando la variable global msg.sender,
* que representa la dirección del remitente de la transacción.
*/
    constructor(uint256 total) {
        _totalSupply = total;
        balances[msg.sender] = total;
    }

// totalSupply(): devuelve la cantidad total de tokens que existen en el contrato.
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

// balanceOf(_owner): devuelve el saldo de tokens que tiene una dirección específica.
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

/**
* transfer(_to, _value): permite enviar una cantidad de tokens desde la dirección que llama a la función a otra dirección.
* Requiere que el emisor tenga suficientes tokens y emite un evento Transfer para registrar la operación.
*/
    function transfer(
        address _to,
        uint256 _value)
        public returns (bool success)
    {
        require(
            _value <= balances[msg.sender],
            "No hay fondos suficientes para realizar la transferencia"
        );
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

/**
* approve(_spender, _value): permite autorizar a otra dirección a gastar una cantidad de tokens en nombre del emisor.
* Emite un evento Approval para registrar la autorización.
*/
    function approve(address _spender, uint256 _value)
        public returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
    }

// allowance(_owner, _spender): devuelve la cantidad de tokens que una dirección puede gastar en nombre de otra.
    function allowance(address _owner, address _spender)
        public view returns (uint256 remaining)
    {
        remaining = allowed[_owner][_spender];
    }

/**
* Este código de Solidity define una función llamada transferFrom que permite transferir una cantidad de tokens
* de una dirección a otra, siempre que se cumplan ciertas condiciones.
* La función recibe tres parámetros: _from, _to y _value, que representan la dirección de origen,
* la dirección de destino y la cantidad de tokens a transferir, respectivamente.
* La función devuelve un valor booleano que indica si la transferencia fue exitosa o no.
* La función utiliza la palabra clave require para verificar dos condiciones antes de realizar la transferencia:
* 1) que la dirección de origen tenga suficientes tokens para transferir (_value <= balances[_from]) y
* 2) que el emisor de la transacción esté autorizado para transferir tokens de la dirección de origen (_value <= allowed[_from][msg.sender]).
* Si alguna de estas condiciones no se cumple, la función revertirá la transacción y emitirá un mensaje de error.
* Si ambas condiciones se cumplen, la función actualiza los balances de las direcciones involucradas y
* el límite de tokens permitidos para el emisor, restando la cantidad transferida de la dirección de origen y
* sumándola a la dirección de destino (balances[_from] = balances[_from] - _value; allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value; balances[_to] = balances[_to] + _value;).
* Luego, la función emite un evento Transfer con los datos de la transacción (emit Transfer(_from, _to, _value);) y
* asigna el valor true a la variable success, indicando que la transferencia se realizó correctamente.
*/
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(
            _value <= balances[_from],
            "There are not enough funds to do the transfer"
        );
        require(_value <= allowed[_from][msg.sender], "Sender not allowed");

        balances[_from] = balances[_from] - _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(_from, _to, _value);
        success = true;
    }
}