/**
* este código de Solidity crea un token personalizado que puede ser quemado,
* pausado y reanudado por el propietario del contrato.
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/** 
* Este código de Solidity define un contrato llamado Extensiones que hereda de las interfaces ERC20Burnable, ERC20Pausable y Ownable. Estas interfaces permiten que el token creado por el contrato tenga las siguientes características:
* ERC20Burnable: permite que el propietario del token pueda quemar (destruir) una cantidad de sus tokens.
* ERC20Pausable: permite que el propietario del contrato pueda pausar y reanudar las transferencias de tokens entre las cuentas.
* Ownable: permite que el contrato tenga un propietario que pueda ejecutar funciones especiales.
*/
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
* El constructor del contrato llama al constructor de ERC20 y le pasa el nombre y el símbolo del token.
* También crea 1000 tokens y los asigna a la cuenta que desplegó el contrato (msg.sender).
*/
contract Extensiones is ERC20Burnable, ERC20Pausable, Ownable {
    constructor() ERC20Burnable() ERC20("TestNFT", "TS") {
        _mint(msg.sender, 1000);
    }

/**
* burn: permite que el propietario del token queme una cantidad de sus tokens.
* Esta función sobrescribe la función burn de ERC20Burnable y añade el modificador onlyOwner,
* que restringe su uso solo al propietario del contrato.
*/
    function burn(uint256 amount) onlyOwner() public override {
        super.burn(amount);
    }

/**
* Pausar: permite que el propietario del contrato pause las transferencias de tokens.
* Esta función llama a la función interna _pause de ERC20Pausable, que emite un evento Pause y
* cambia el estado del contrato a pausado.
*/
    function Pausar() public onlyOwner {
    _pause();
}

/**
* DesactivarPausa: permite que el propietario del contrato reanude las transferencias de tokens.
* Esta función llama a la función interna _unpause de ERC20Pausable, que emite un evento Unpause y
* cambia el estado del contrato a no pausado.
*/
    function DesactivarPausa() public onlyOwner {
        _unpause();
    }

/**
* _beforeTokenTransfer: es una función interna que se ejecuta antes de cada transferencia de tokens.
* Esta función sobrescribe la función _beforeTokenTransfer de ERC20 y ERC20Pausable, y
* llama a ambas funciones con los mismos parámetros.
* Esto permite que se apliquen las reglas de ambas interfaces antes de cada transferencia.
*/
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}