// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts@4.5.0/security/ReentrancyGuard.sol";

/**
 * @title Marketplace Descentralizado (DEX para NFTs)
 * @dev Este contrato actúa como un "Escrow" (fideicomiso).
 * Retiene temporalmente los NFTs de los vendedores hasta que un comprador paga el precio,
 * asegurando un intercambio sin necesidad de confiar en la contraparte (Trustless).
 *
 * SEGURIDAD: Hereda 'ReentrancyGuard', un modificador vital que previene ataques de
 * reentrada (donde un atacante podría retirar fondos múltiples veces de forma recursiva antes de
 * que el contrato actualice sus balances).
 */
contract Marketplace is ReentrancyGuard {
    // --- Variables de Estado y Configuración de Negocio ---

    // Cuenta que recibirá las comisiones por cada venta (El dueño de la plataforma).
    // 'immutable' significa que se asigna una sola vez en el constructor y no puede cambiar, ahorrando gas.
    address payable public immutable feeAccount;

    // Porcentaje de comisión que cobra la plataforma (Ej: 1 significa 1%).
    uint public immutable feePercent;

    // Contador global para asignar IDs a los objetos puestos a la venta.
    uint public itemCount;

    // --- Estructuras Estructura de Datos (El Catálogo) ---

    struct Item {
        uint itemId; // ID interno de la venta en nuestro marketplace.
        IERC721 nft; // Dirección del contrato inteligente de la colección del NFT.
        uint tokenId; // ID del Token específico dentro de su colección original.
        uint price; // Precio base de venta que pide el vendedor (Ethers/Wei).
        address payable seller; // Dirección de la cartera a la que hay que pagar.
        bool sold; // Estado para saber si esta oferta ya se consumió.
    }

    // Base de datos de todos los items listados (ID de Venta => Detalles del Item)
    mapping(uint => Item) public items;

    // --- Eventos (Notificaciones para Frontend) ---

    // Se dispara cuando alguien pone su NFT a la venta.
    event Offered(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller
    );

    // Se dispara cuando alguien finaliza una compra exitosa.
    event Bought(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller,
        address indexed buyer
    );

    /**
     * @dev Constructor
     * @param _feePercent Determina el porcentaje de comisión que retendrá la tienda en cada venta.
     */
    constructor(uint _feePercent) {
        feeAccount = payable(msg.sender);
        feePercent = _feePercent;
    }

    // --- Lógica Principal del Marketplace ---

    /**
     * @notice LISTAR UN NFT PARA VENTA
     * @dev El usuario debe primero aprobar (Approve) que este contrato maneje su NFT en el contrato original.
     * @param _nft Dirección del Smart Contract del NFT.
     * @param _tokenId ID de la obra dentro de '_nft'.
     * @param _price Precio deseado en Weis.
     */
    function makeItem(
        IERC721 _nft,
        uint _tokenId,
        uint _price
    ) external nonReentrant {
        require(_price > 0, "El precio debe ser mayor a 0");

        // 1. Asignar nuevo ID de listado.
        itemCount++;

        // 2. ESCROW: El contrato Mercado actúa como custodio.
        // Extrae el NFT de la billetera del vendedor y lo guarda en su propia bóveda (address(this)).
        _nft.transferFrom(msg.sender, address(this), _tokenId);

        // 3. Crear el registro en la base de datos (Catálogo).
        items[itemCount] = Item(
            itemCount,
            _nft,
            _tokenId,
            _price,
            payable(msg.sender),
            false // Aún no está vendido
        );

        // 4. Notificar a las aplicaciones conectadas.
        emit Offered(itemCount, address(_nft), _tokenId, _price, msg.sender);
    }

    /**
     * @notice COMPRAR UN NFT
     * @dev Función 'payable' para recibir Ethers. Usa transferencias de bajo nivel ('call').
     * @param _itemId El ID interno de la lista del Marketplace correspondiente a lo que quiero comprar.
     */
    function purchaseItem(uint _itemId) external payable nonReentrant {
        // 1. Calcular el total a pagar (Costo del Vendedor + Comisión Marketplace).
        uint _totalPrice = getTotalPrice(_itemId);

        // Creamos una variable de tipo "storage" para poder modificar el estado global.
        Item storage item = items[_itemId];

        // 2. Controles de Seguridad (Validaciones)
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID");
        require(msg.value >= _totalPrice, "No enviaste suficientes Ethers");
        require(!item.sold, "El item ya fue vendido");

        // 3. PAGOS (Usando .call que es el método más seguro contra errores de Gas)
        // Pago al vendedor:
        (bool success, ) = item.seller.call{value: item.price}("");
        require(success, "Error al enviar Ethers al vendedor");

        // Pago de comisiones (al dueño del marketplace):
        (bool feeSuccess, ) = feeAccount.call{value: _totalPrice - item.price}(
            ""
        );
        require(feeSuccess, "Error al enviar la comision");

        // 4. Actualizar el estado de la oferta a 'vendido'
        // IMPORTANTE: Hacerlo ANTES de entregar el NFT previene reentradas (Checks-Effects-Interactions Pattern).
        item.sold = true;

        // 5. ESCROW: El Mercado le manda el NFT de su bóveda a la billetera del comprador.
        item.nft.transferFrom(address(this), msg.sender, item.tokenId);

        // 6. Notificar Venta!
        emit Bought(
            _itemId,
            address(item.nft),
            item.tokenId,
            item.price,
            item.seller,
            msg.sender
        );
    }

    /**
     * @notice Calcula el precio total de un artículo para presentarlo al comprador.
     * @return Coste del vendedor sumado al porcentaje de comisión.
     */
    function getTotalPrice(uint _itemId) public view returns (uint) {
        // Ejemplo matemático: 100 * (100 + 1) / 100 = 101 Weis Totales.
        return ((items[_itemId].price * (100 + feePercent)) / 100);
    }
}
