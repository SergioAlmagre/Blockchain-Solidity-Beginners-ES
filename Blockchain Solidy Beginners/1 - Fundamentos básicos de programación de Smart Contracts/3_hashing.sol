// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Funciones de Hashing
 * @dev Muestra el uso de funciones criptográficas de hash nativas en Solidity.
 *      Los hashes son funciones unidireccionales que transforman datos de entrada en
 *      una cadena de longitud fija. Son fundamentales en criptografía.
 */
contract hashing {

    // ==========================================
    // Algoritmos de Hash
    // ==========================================

    /**
     * @notice keccak256: El estándar en Ethereum (usado para generar direcciones, firmas, etc).
     * @dev Devuelve un hash de 32 bytes. No es exactamente SHA-3 (es una versión anterior).
     */
    bytes32 public hashin_keccak256 = keccak256(abi.encodePacked("Hola", "como estas", uint(10)));

    /**
     * @notice sha256: Algoritmo SHA-256 estándar.
     * @dev Devuelve 32 bytes. A veces usado para interoperabilidad con Bitcoin u otros sistemas.
     */
    bytes32 public hashign_sha256 = sha256(abi.encodePacked("Hola", "como estas", 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));

    /**
     * @notice ripemd160: Algoritmo que genera un hash más corto (20 bytes).
     * @dev Útil cuando el espacio es crítico, pero considerado menos seguro que keccak256 o sha256 hoy en día.
     */
    bytes20 public hashign_ripemd160 = ripemd160(abi.encodePacked("Hola","como estas"));

}