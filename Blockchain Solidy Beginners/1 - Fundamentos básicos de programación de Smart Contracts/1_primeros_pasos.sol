// SPDX-License-Identifier: MIT

//Version
pragma solidity ^0.8.31;

// Importar Smart Contract OpenZeppelin
// ERC721 es el estándar para NFTs (Non-Fungible Tokens)
import "@openzeppelin/contracts@5.5.0/token/ERC721/ERC721.sol";

/**
 * @title Primer Contrato NFT
 * @dev Este contrato hereda de ERC721 de OpenZeppelin para crear una colección básica de NFTs.
 *      Sirve como introducción a la herencia y constructores en Solidity.
 */
contract FirstContract is ERC721 {

    // Dirección de la persona que despliega el contrato
    // 'public' genera automáticamente una función 'getter' para consultar este valor
    address public owner;

    /**
     * @notice Constructor del contrato. Se ejecuta una única vez al desplegarse.
     * @dev Inicializa el contrato ERC721 padre con un nombre y un símbolo.
     *      También guarda la dirección del desplegador (msg.sender) en la variable 'owner'.
     * @param _name El nombre de la colección de NFTs (ej. "Mi Coleccion").
     * @param _symbol El símbolo de la colección (ej. "MCN").
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        owner = msg.sender;
    }
}