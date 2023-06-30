/**
* Este código de Solidity define un contrato inteligente llamado MyNFT que hereda de la clase ERC721URIStorage,
* el cual implementa la interfaz ERC721 para Tokens No Fungibles (NFT) con almacenamiento de URI.
* Este código permite crear NFT con un precio fijo y un URI asociado, y
* transferir los fondos recaudados al propietario del contrato.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
* Una variable privada _tokenIds que lleva la cuenta de los identificadores de los NFT emitidos por el contrato.
* Una variable owner de tipo address payable que almacena la dirección del propietario del contrato, que es quien lo despliega.
* Una variable price de tipo uint que almacena el precio en wei que se debe pagar para acuñar un NFT con el contrato.
*/
contract MyNFT is ERC721URIStorage {
    uint private  _tokenIds;
    address payable owner;
    uint price;

/**
* Un constructor que recibe el precio como parámetro e inicializa las variables owner y price,
* así como el nombre y el símbolo del token ERC721.
*/
    constructor(uint _price) ERC721("MyNFT", "NFT") {
        owner = payable (msg.sender);
        price = _price;
    }

/**
* Una función mintNFT que recibe una cadena de texto tokenURI como parámetro y
* devuelve un uint256 que es el identificador del NFT acuñado. Esta función hace lo siguiente:
* Verifica que el valor enviado en la transacción sea mayor o igual que el precio establecido, y si no lo es,
* lanza una excepción con el mensaje "No tienes fondos suficientes".
* Transfiere el valor enviado a la dirección del propietario del contrato.
* Incrementa la variable _tokenIds en uno.
* Llama a la función _mint heredada de ERC721 para crear un nuevo NFT con el emisor como propietario y
* el valor de _tokenIds como identificador.
* Llama a la función _setTokenURI heredada de ERC721URIStorage para asociar el tokenURI dado al NFT creado.
* Devuelve el valor de _tokenIds como resultado.
*/
    function mintNFT(string memory tokenURI)
        public
        payable 
        returns (uint256)
    {
        require(msg.value >= price, "No tienes fondos suficientes");
        owner.transfer(msg.value);
        _tokenIds = _tokenIds + 1;
        _mint(msg.sender, _tokenIds);
        _setTokenURI(_tokenIds, tokenURI);

        return _tokenIds;
    }
}