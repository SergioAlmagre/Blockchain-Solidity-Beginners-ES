# Marketplace de NFTs

Este módulo aborda la base para crear plataformas donde los usuarios pueden acuñar, listar y comercializar libremente sus propios "Non-Fungible Tokens".

## Contenido del Módulo

### 1. Extensión ERC721URIStorage
**Archivo:** `NFT.sol`

Implementación fundamental para un Marketplace de NFT realistas:
- **`ERC721URIStorage`**: En un Marketplace, no sirve un ERC-721 "ciego" que solo guarda un balance. Se necesita una forma de ligar de forma nativa cada número de Token con un archivo de metadatos (para mostrar la gráfica representativa en el Frontend). Para eso sirve esta extensión base de OpenZeppelin.
- **Flujo de Acuñación (Minting):** Explicación del contador interno (`tokenCount`) donde cada unidad creada empareja indisolublemente al creador (`msg.sender`) de un billete con la URL (URI) que transporta el peso gráfico de la imagen, todo usando la directriz `_setTokenURI`.
