# Marketplace de NFTs

Este módulo aborda la base para crear plataformas donde los usuarios pueden acuñar, listar y comercializar libremente sus propios "Non-Fungible Tokens".

## Contenido del Módulo

### 1. Extensión ERC721URIStorage
**Archivo:** `NFT.sol`

Implementación fundamental para un Marketplace de NFT realistas:
- **`ERC721URIStorage`**: En un Marketplace, no sirve un ERC-721 "ciego" que solo guarda un balance. Se necesita una forma de ligar de forma nativa cada número de Token con un archivo de metadatos (para mostrar la gráfica representativa en el Frontend). Para eso sirve esta extensión base de OpenZeppelin.
- **Flujo de Acuñación (Minting):** Explicación del contador interno (`tokenCount`) donde cada unidad creada empareja indisolublemente al creador (`msg.sender`) de un billete con la URL (URI) que transporta el peso gráfico de la imagen, todo usando la directriz `_setTokenURI`.

### 2. El Agente de Fideicomiso (Marketplace Escrow)
**Archivo:** `Marketplace.sol`

El núcleo comercial donde ocurre el intercambio descentralizado seguro.
- **Patrón Escrow Trustless:** La función `makeItem` no solo publica una oferta, sino que transfiere el NFT del usuario al custodio (el propio Smart Contract). Para comprar (`purchaseItem`), el comprador paga al contrato, este calcula y retiene su comisión (Fee), paga el remanente al vendedor, y despacha el NFT al comprador, todo atómicamente.
- **Seguridad y Reentradas:** Introducción a `ReentrancyGuard` y al modificador `nonReentrant`. Entendemos la necesidad imperiosa de alterar el estado (como `item.sold = true;`) ANTES de enviar los Ethers o los Tokens para evitar ataques catastróficos.
- **Pagos de Bajo Nivel:** Utilización del método `.call{value}()` sobre métodos heredados como `.transfer()` o `.send()` por ser el estándar más flexible al tratar con gas dinámico con cuentas controladas por código (Smart Contracts).
