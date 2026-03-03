// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Custom ERC20 Token
 * @dev En este ejemplo, importamos una implementación local del estándar ERC20.
 * A diferencia del ejemplo anterior que usaba OpenZeppelin, aquí se asume que
 * el archivo 3_interfaz_ERC20.sol está en la misma carpeta.
 */
import "./3_interfaz_ERC20.sol";

/**
 * @notice Contrato que hereda de la implementación local de ERC20.
 */
contract customERC20 is ERC20 {
    /**
     * @dev Constructor del Smart Contract.
     * Llama al constructor del contrato padre (ERC20) para establecer:
     * - Nombre: "Sergio"
     * - Símbolo: "SA"
     */
    constructor() ERC20("Sergio", "SA") {}

    /**
     * @notice Función para que cualquier usuario pueda generar (mintear) nuevos tokens.
     * @dev Llama a la función interna _mint definida en el contrato base.
     * En esta implementación específica, la cantidad está fijada en 1000 unidades.
     */
    function createTokens() public {
        // msg.sender es la dirección de la persona que ejecuta la transacción.
        _mint(msg.sender, 1000);
    }
}
