// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importación del estándar ERC-20 de la librería de OpenZeppelin.
// OpenZeppelin es el estándar de la industria para implementaciones seguras de Smart Contracts.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Gold Token
 * @dev Implementación básica de un token ERC-20 utilizando OpenZeppelin.
 * El contrato hereda de ERC20, lo que significa que obtiene automáticamente
 * todas las funcionalidades estándar (transferencias, balances, aprobaciones, etc.).
 */
contract GLDToken is ERC20 {
    /**
     * @dev El constructor se ejecuta una sola vez al desplegar el contrato.
     * @param initialSupply Cantidad inicial de tokens a crear.
     *
     * Heredamos del constructor de ERC20 y le pasamos:
     * - Name: "Gold"
     * - Symbol: "GLD"
     */
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        /**
         * _mint es una función interna de OpenZeppelin que:
         * 1. Aumenta el totalSupply (suministro total) del token.
         * 2. Asigna los tokens creados a una dirección específica.
         * En este caso, se le asignan todos los tokens al creador del contrato (msg.sender).
         */
        _mint(msg.sender, initialSupply);
    }
}
