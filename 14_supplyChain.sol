// Este código de Solidity define un contrato llamado SupplyChain que representa una cadena de suministro.

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
* El contrato tiene una estructura llamada Step que almacena información sobre cada paso del proceso de envío de un producto,
* como el estado, los metadatos, el precio y el autor.
*/
contract SupplyChain {
    struct Step {
        Status status;
        string metadata;
        uint256 price;
        address author;
    }

/**
* El contrato también tiene un enumerado llamado Status que define los posibles estados de un producto,
* desde que se crea hasta que se entrega.
*/
    enum Status {
        CREATED,
        READY_FOR_PICK_UP,
        PICKED_UP,
        READY_FOR_DELIVERY,
        DELIVERED
    }

// El contrato emite un evento llamado RegisteredStep cada vez que se registra un nuevo paso para un producto.
    event RegisteredStep(
        uint256 productId,
        Status status,
        string metadata,
        address author,
        uint256 price
    );

// El contrato tiene un mapeo llamado products que asocia cada identificador de producto con un array de pasos.
    mapping(uint256 => Step[]) public products;

/**
* El contrato tiene una función llamada registerProduct que permite crear un nuevo producto con el estado CREATED y
* el autor como el remitente de la transacción.
* La función requiere que el producto no exista previamente en el mapeo products.
*/
    function registerProduct(uint256 productId) public returns (bool success) {
        require(products[productId].length == 0, "This product already exists");
        products[productId].push(Step(Status.CREATED, "", 0, msg.sender));
        return success;
    }

/**
* La función toma tres parámetros: el identificador del producto, los metadatos del paso y el precio del servicio.
* La función también requiere que se envíe una cantidad de ether junto con la llamada (calldata).
* La función primero verifica que el producto exista en el mapa de productos,
* que almacena un array de pasos para cada producto. Luego obtiene el estado actual del producto,
* que es el estado del último paso del array.
* Si el estado actual es mayor que DELIVERED, significa que el producto ya ha completado todos los pasos y
* no se puede registrar uno nuevo.
* Si el estado actual es PICKED_UP o DELIVERED, significa que el paso requiere un pago por el servicio.
* La función entonces compara la cantidad de ether enviada con el precio del paso anterior,
* que es el que debe pagar el usuario.
* Si la cantidad enviada es menor que el precio, la función revierte la transacción y
* devuelve el error "You need to pay the service".
* Si la cantidad enviada es suficiente, la función transfiere el ether al autor del paso anterior,
* que es el que ofrece el servicio.
* Finalmente, la función crea un nuevo paso con el estado actual incrementado en uno,
* los metadatos, el precio y el autor dados como parámetros.
* La función añade este paso al array de pasos del producto y emite un evento llamado RegisteredStep con los datos del paso.
* La función devuelve true para indicar que el registro fue exitoso.
*/
    function registerStep(
        uint256 productId,
        string calldata metadata,
        uint256 price
    ) public payable returns (bool success) {
        require(products[productId].length > 0, "This product doesn't exist");
        Step[] memory stepsArray = products[productId];
        uint256 currentStatus = uint256(
            stepsArray[stepsArray.length - 1].status
        ) + 1;
        if (currentStatus > uint256(Status.DELIVERED)) {
            revert("The product has no more steps");
        }

        if (
            currentStatus == uint256(Status.PICKED_UP) ||
            currentStatus == uint256(Status.DELIVERED)
        ) {
            uint256 _price = stepsArray[currentStatus - 1].price;
            if (msg.value < _price) {
                revert("You need to pay the service");
            }
            address payable _to = payable(stepsArray[currentStatus - 1].author);
            _to.transfer(_price);
        }
        Step memory step = Step(
            Status(currentStatus),
            metadata,
            price,
            msg.sender
        );
        products[productId].push(step);
        emit RegisteredStep(
            productId,
            Status(currentStatus),
            metadata,
            msg.sender,
            price
        );
        success = true;
    }
}