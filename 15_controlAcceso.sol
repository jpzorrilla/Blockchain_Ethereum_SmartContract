/**
* En este contrato reutilizamos el ejemplo en Remix "1_Storage.sol" para
* añadirle controles de acceso
*/ 

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Este código utiliza la librería AccessControl de OpenZeppelin para gestionar los roles de los usuarios.
import "@openzeppelin/contracts/access/AccessControl.sol";

// El contrato tiene dos roles: rolAdmin y rolWriter, que se definen mediante el hash de sus nombres.
contract ControlAcceso is AccessControl {
    bytes32 rolAdmin = keccak256("ROL_ADMIN");
    bytes32 rolWriter = keccak256("ROL_WRITER");

// El constructor del contrato asigna el rolAdmin al creador del contrato.
    constructor() {
        _grantRole(rolAdmin, msg.sender);
    }

// El contrato tiene una variable llamada number que almacena un valor numérico.
    uint256 number;

    /**
     * El contrato tiene dos funciones públicas: store y retrieve, que permiten modificar y consultar el valor de number respectivamente.
     * La función store solo puede ser ejecutada por los usuarios que tengan el rolWriter,
     * mientras que la función retrieve puede ser ejecutada por cualquier usuario. 
     */
    function store(uint256 num) public onlyWriter {
        number = num;
    }

    /**
     * Estas restricciones se implementan mediante los modificadores onlyWriter y onlyAdmin,
     * que verifican si el emisor del mensaje tiene el rol correspondiente usando la función hasRole de AccessControl.
     */
    function retrieve() public view returns (uint256){
        return number;
    }

    modifier onlyWriter() {
        require(hasRole(rolWriter, msg.sender), "Solo pueden ejecutar la funcion los roles Writer");
        _;
    }

    modifier onlyAdmin() {
        require(hasRole(rolAdmin, msg.sender), "Solo pueden ejecutar la funcion los roles Admin");
        _;
    }

/** 
* El contrato también tiene dos funciones públicas para gestionar los usuarios con el rolWriter:
* agregarWriter y quitarWriter, que otorgan y revocan el rolWriter a una dirección dada respectivamente.
* Estas funciones solo pueden ser ejecutadas por los usuarios con el rolAdmin,
* lo que se verifica mediante el modificador onlyAdmin.
*/
    function agregarWriter(address cuenta) public onlyAdmin {
        _grantRole(rolWriter, cuenta);
    }

    function quitarWriter(address cuenta) public onlyAdmin {
        _revokeRole(rolWriter, cuenta);
    }
}