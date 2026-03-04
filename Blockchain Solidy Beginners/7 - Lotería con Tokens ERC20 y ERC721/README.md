# Lotería Integral (ERC-20 y ERC-721 integrados)

Este módulo representa el Proyecto Final que aúna lo aprendido en Creación de Tokens, NFTs y lógica compleja descentralizada, encapsulado en una sola DApp de Lotería.

## Contenido del Módulo

### 1. DApp Lotería (Tokens y NFTs)
**Archivo:** `1_loteria.sol`

Implementación de un sistema robusto, con escalabilidad superior empleando el patrón de "Contratos Múltiples".
- **Comercio de Criptomonedas (ERC-20):** Implementación de una pasarela de pago para convertir Ethers en nuestro token `LOT`, la criptomoneda nativa de nuestro "salón de juegos". Incluye una función para devolver los tokens y reclamar tu dinero inicial restante.
- **Colección de Billetes (ERC-721):** Para asegurar de forma inquebrantable que un usuario compró un billete con un número particular (ej. comprar el 1599), se utiliza la naturaleza inmutable de los NFTs. Esto se procesa delegando autoridad al contrato `mainERC721`.
- **Contratos Proxy Personales (`boletosNFT.sol`):** Diseño de arquitectura modular donde el Smart Contract principal, para alivianar su carga y mejorar la protección en el minteo, despliega pequeños sub-contratos "Proxy" dedicados como embajadores de cada usuario o comprador individual.
- **Problema de la Aleatoriedad:** Exploración y demostración de la generación de números pseudoaleatorios (PRNG) en Solidity a través de la función criptográfica `keccak256` mezclando el Timestamp actual, el contador local y la dirección del usuario. Conoceremos por qué esto no es 100% infranqueable en Mainnet y por qué las Lotearias modernas externalizan la aleatoriedad a Oráculos como Chainlink (VRF).
