// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

/**
 * @title Proyecto Final Completo: Lotería con ERC-20 y ERC-721
 * @dev Este archivo agrupa magistralmente los estándares fungibles y no fungibles en una dApp real.
 *
 * ARQUITECTURA (3 Contratos):
 * 1. 'loteria' (Este contrato principal): Emite la "Moneda" (ERC-20, 'LOT') para jugar a la lotería.
 * 2. 'mainERC721': Emite los "Billetes de Lotería" (ERC-721, NFTs), que actúan como comprobantes de participación.
 * 3. 'boletosNFT': Contratos Proxy personales de cada usuario. Para darles autonomía y seguridad.
 */
contract loteria is ERC20, Ownable {
    // --- Gestión de los tokens ---

    // Dirección del contrato NFT del proyecto (Donde se forjan los billetes únicos)
    address public nftContractAddress;

    /**
     * @dev Constructor de la Lotería.
     * Al desplegar la Lotería, suceden dos cosas de forma atómica:
     * 1. Se emiten 1000 tokens ERC-20 ("LOT") iniciales al propio contrato.
     * 2. DESPLIEGUE DESDE OTRO CONTRATO: La lotería despliega automáticamente el
     * contrato 'mainERC721' (los billetes NFT) y guarda su dirección de memoria.
     */
    constructor() ERC20("Loteria", "LOT") {
        _mint(address(this), 1000); // El contrato se da fondos iniciales a sí mismo.
        nftContractAddress = address(new mainERC721()); // Pattern de Factoría: Un contrato creando a otro contrato.
    }

    // Ganador del premio de la loteria
    address public ganador;

    // Registro del usuario: Qué persona humana es dueña de qué contrato Proxy (address usuario => address proxyBoletos)
    mapping(address => address) public usuario_contract;

    /**
     * @notice Convierte la cantidad de tokens deseados en su precio en Ethers.
     * @dev Función pura (pure) no lee ni modifica el estado, es solo una calculadora.
     * 1 Token LOT = 0.05 Ethers (Aprox. 100-150 dólares USD según mercado).
     */
    function precioTokens(uint256 _numTokens) internal pure returns (uint256) {
        return _numTokens * (0.05 ether);
    }

    // Visualización del balance de tokens ERC-20 (LOT) de un usuario.
    function balanceTokens(address _account) public view returns (uint256) {
        return balanceOf(_account); // Llamada heredada de OpenZeppelin
    }

    // Visualización del balance de tokens ERC-20 disponibles en las arcas del Smart Contract.
    function balanceTokensSC() public view returns (uint256) {
        return balanceOf(address(this));
    }

    /**
     * @notice Cuánto dinero real (Ethers) ha recaudado el contrato de la Lotería.
     * @dev 1 ether = 10**18 wei. Aquí dividimos para devolver valores legibles por humanos (en formato ETH).
     */
    function balanceEhersSC() public view returns (uint256) {
        return address(this).balance / 10 ** 18;
    }

    // Generación de nuevos tokens ERC-20 (LOT) si se nos agotan en la Lotería. Solo para el Dueño.
    function mint(uint _cantidad) public onlyOwner {
        _mint(address(this), _cantidad);
    }

    /**
     * @notice Registra a un nuevo jugador.
     * @dev Crea un contrato Proxy ('boletosNFT') exclusivo para el msg.sender.
     * Esto separa la lógica de almacenamiento de Billetes para que escale mejor.
     */
    function registrar() internal {
        address addr_personal_contract = address(
            new boletosNFT(msg.sender, address(this), nftContractAddress)
        );
        usuario_contract[msg.sender] = addr_personal_contract;
    }

    // Información del contrato proxy de un usuario.
    function usersInfo(address _account) public view returns (address) {
        return usuario_contract[_account];
    }

    // --- Economía: Venta de la Criptomoneda (LOT) ---

    /**
     * @notice Comprar la moneda de la Lotería usando Ethers. Función 'payable'.
     */
    function compraTokens(uint256 _numTokens) public payable {
        // 1. Registro Automático del jugador si es su primera vez.
        if (usuario_contract[msg.sender] == address(0)) {
            registrar();
        }

        // 2. Establecer el coste
        uint256 coste = precioTokens(_numTokens);

        // 3. Evaluar el pago
        require(
            msg.value >= coste,
            "Compra menos tokens o paga con mas ethers"
        );

        // 4. Verificación de stock de moneda LOT
        uint256 balance = balanceTokensSC();
        require(
            _numTokens <= balance,
            "La loteria no tiene suficientes tokens LOT, compra un numero menor"
        );

        // 5. Devolución del cambio (dinero sobrante si el usuario envió Ether de más)
        uint256 returnValue = msg.value - coste;
        payable(msg.sender).transfer(returnValue);

        // 6. Entrega del producto: Envío de la moneda LOT comprada.
        _transfer(address(this), msg.sender, _numTokens);
    }

    // Devolución de tokens: Permite a un jugador "Vender" su moneda LOT obtenida y recuperar sus Ethers.
    function devolverTokens(uint256 _numTokens) public payable {
        require(
            _numTokens > 0,
            "Necesitas devolver un numero de tokens mayor a 0"
        );
        require(
            _numTokens <= balanceTokens(msg.sender),
            "No tienes los tokens que deseas devolver"
        );

        // 1. El usuario devuelve los tokens LOT al Smart Contract de la Lotería
        _transfer(msg.sender, address(this), _numTokens);

        // 2. El contrato transfiere los Ethers correspondientes al usuario.
        payable(msg.sender).transfer(precioTokens(_numTokens));
    }

    // --- Gestión de la Lotería ---

    // Precio fijo: Participar y comprar un Boleto NFT cuesta 5 tokens LOT.
    uint256 public precioBoleto = 5;

    // Diccionario de Arrays: mapping(direccion de la persona => array[Boleto1, Boleto2, Boleto3...])
    mapping(address => uint[]) idPersona_boletos;

    // Relación Inversa: Si gana el Boleto 1599, ¿de quién es? -> mapping(1599 => direccion del Ganador)
    mapping(uint => address) ADNBoleto;

    // Semilla para asegurar aleatoriedad variable en billeterías que compren en bucle.
    uint randomNonce = 0;

    // Repositorio central de TODOS los boletos que existen jugándose en este sorteo.
    uint[] boletosComprados;

    /**
     * @notice La función estelar. El usuario canjea su moneda LOT por Billetes de Lotería NFT.
     */
    function compraBoleto(uint _numBoletos) public {
        uint precioTotal = _numBoletos * precioBoleto;
        require(
            precioTotal <= balanceTokens(msg.sender),
            "No tienes monedas LOT suficientes"
        );

        // 1. El usuario paga a la lotería (El Smart Contract absorbe los Tokens LOT)
        _transfer(msg.sender, address(this), precioTotal);

        // 2. Proceso de Generación Iterativo (For loop)
        for (uint i = 0; i < _numBoletos; i++) {
            // ALEATORIEDAD ON-CHAIN:
            // En la Blockchain todo es público y determinista, por lo tanto crear un número "al azar"
            // no es posible de manera pura.
            // Aquí usamos un hash "keccak256" de factores impredecibles matemáticamente: (Tiempo actual + Quień pide + Un contador + El bloque entero) y tomamos su residuo (mod 10000).
            uint random = uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randomNonce)
                )
            ) % 10000;
            randomNonce++;

            // Almacenamiento perfiles de usuario.
            idPersona_boletos[msg.sender].push(random);
            boletosComprados.push(random);
            ADNBoleto[random] = msg.sender;

            // INTREGRACIÓN NFTS:
            // Le pedimos al contrato 'boletosNFT' delegado del usuario que acuñe y materialice matemáticamente el billete.
            boletosNFT(usuario_contract[msg.sender]).mintBoleto(
                msg.sender,
                random
            );
        }
    }

    // Visualizar cuántos y cuáles boletos tiene un usuario.
    function tusBoletos(
        address _propietario
    ) public view returns (uint[] memory) {
        return idPersona_boletos[_propietario];
    }

    /**
     * @notice Finaliza el sorteo y reparte la recaudación.
     */
    function generarGanador() public onlyOwner {
        uint longitud = boletosComprados.length;
        require(longitud > 0, "No hay boletos disponibles");

        // Seleccionamos un índice de boleto al azar usando matemáticas Hash y el tiempo del bloque actual de la red.
        uint random = uint(
            uint(keccak256(abi.encodePacked(block.timestamp))) % longitud
        );

        // Elegimos el boleto afortunado usando el índice.
        uint eleccion = boletosComprados[random];

        // Convertimos el boleto (ej: Número 552) a la Adresse de su dueño a través del Diccionario ADNBoleto.
        ganador = ADNBoleto[eleccion];

        // PAGOS (División del Pozo):
        // Envio del 95% del premio amasado en Ethers de la loteria al afortunado ganador.
        payable(ganador).transfer((address(this).balance * 95) / 100);

        // Envio del 5% restante del premio a la direccion del propietario de la Lotería (Para mantenimiento).
        payable(owner()).transfer((address(this).balance * 5) / 100);
    }
}

/**
 * @title Colección de Billetes NFT (ERC-721)
 * @dev Segundo contrato. Es desplegado automáticamente por el constructor del contrato 'loteria'.
 * Representa la colección oficial de NFTs.
 */
contract mainERC721 is ERC721 {
    address public direccionLoteria;

    constructor() ERC721("Loteria", "STE") {
        direccionLoteria = msg.sender;
    }

    // Aquí ocurre la Cuñación. Exclusiva para la arquitectura de la DApp.
    function safeMint(address _propietario, uint256 _boleto) public {
        // PROTECIÓN DE ARQUITECTURA:
        // Solo los contratos 'Proxy' (boletosNFT) de cada usuario, registrados en la Lotería principal, pueden mintear.
        require(
            msg.sender == loteria(direccionLoteria).usersInfo(_propietario),
            "No tienes permisos para ejecutar esta funcion"
        );

        _safeMint(_propietario, _boleto);
    }
}

/**
 * @title Proxy personal de usuario (boletosNFT)
 * @dev Tercer contrato. Se despliega un contrato de estos por cada jugador que use la Lotería.
 * Sirve para encapsular sus transacciones y firmar el minteo de sus NFT con una Adresse diferente al main.
 */
contract boletosNFT {
    // Relación de dependencias. Contempla de dónde venimos y a dónde vamos en la cadena de la Plataforma.
    struct Owner {
        address direccionPropietario; // Yo (el cliente humano)
        address contratoPadre; // Quien me invocó (El SC 'loteria')
        address contratoNFT; // El repositorio finalizado ('mainERC721')
        address contratoUsuario; // Yo (esta instancia Smart Contract en particular)
    }
    Owner public propietario;

    constructor(
        address _owner,
        address _mainContract,
        address _nftContractAddress
    ) {
        propietario = Owner(
            _owner,
            _mainContract,
            _nftContractAddress,
            address(this)
        );
    }

    // Un pasaje autorizado (Gateway) que retransmite la orden de mintear al 'mainERC721'.
    function mintBoleto(address _propietario, uint _boleto) public {
        require(
            msg.sender == propietario.contratoPadre,
            "No tienes permisos para ejecutar esta funcion"
        );
        mainERC721(propietario.contratoNFT).safeMint(_propietario, _boleto);
    }
}
