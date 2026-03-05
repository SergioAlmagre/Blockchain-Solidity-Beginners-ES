// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title NFT Base para Marketplace
 * @dev Este contrato no utiliza el ERC721 estándar, sino la extensión 'ERC721URIStorage'.
 *
 * ¿POR QUÉ ERC721URIStorage?
 * El ERC721 básico solo guarda el ID del token y quién es el dueño. Para un Marketplace de Arte,
 * necesitamos saber QUÉ imagen representa ese token. Esta extensión nos permite anexar una
 * URL única (URI) a cada Token ID (ej. un link a IPFS o a una API) que contiene sus
 * metadatos (nombre, características, imagen).
 */
contract NFT is ERC721URIStorage {
    // Variable de estado que rastrea la cantidad total de NFTs creados.
    // También funciona como el identificador numérico único (ID) para el próximo NFT.
    uint public tokenCount;

    /**
     * @dev Constructor
     * Bautiza a la colección de NFTs que se venderán en el Marketplace.
     */
    constructor() ERC721("DApp NFT", "DAPP") {}

    /**
     * @notice Función pública para forjar un nuevo NFT.
     * @dev Idealmente en un Marketplace, los creadores de arte usarían esta función.
     * @param _tokenURI La dirección web (ej. un CID de IPFS) donde "vive" la imagen de la obra.
     * @return El número de ID del token recién forjado.
     */
    function mint(string memory _tokenURI) external returns (uint) {
        // 1. Incrementamos el contador para obtener un ID virgen (1, luego 2, luego 3...).
        tokenCount++;

        // 2. _safeMint: Acuña el token de forma segura al MSG.SENDER.
        // Asocia en la blockchain que "tokenCount" pertenece a la dirección que llamó a la función.
        _safeMint(msg.sender, tokenCount);

        // 3. _setTokenURI: La Magia de la extensión URIStorage.
        // Vincula el ID del token con el enlace externo (la imagen/metadatos).
        _setTokenURI(tokenCount, _tokenURI);

        // 4. Retornamos el número de serie de la obra a modo de comprobante.
        return tokenCount;
    }
}
