# Proyecto de Smart Contract DeFi (Jam Token)

Este módulo marca el inicio de la construcción de un proyecto basado en Finanzas Descentralizadas (DeFi). El primer gran paso es entender cómo se construye un activo programable (Token) desde cero, sin depender de plantillas prefabricadas.

## Contenido del Módulo

### 1. Token ERC-20 Custom (Desde Cero)
**Archivo:** `1_jam_token.sol`

Implementación manual y detallada del estándar ERC-20. Programar las entrañas de un token nos brinda una comprensión fundamental de cómo opera la Ethereum Virtual Machine (EVM).
- **Mapeo de Balances (`balanceOf`):** Cómo el dinero en blockchain no viaja realmente a tu cartera, sino que es un número asociado a tu dirección dentro de un "libro mayor" interno del contrato.
- **Autorizaciones (`allowance`):** La compleja estructura de datos `mapping(address => mapping(address => uint))` que hace posible el modelo DeFi, permitiendo a contratos de terceros (como exchanges) mover tus fondos bajo tu estricto consentimiento.
- **Eventos:** La importancia crítica de emitir eventos `Transfer` y `Approval` para que los exchanges, indexadores y el ecosistema en general puedan "escuchar" lo que sucede dentro del contrato.

## Conceptos Clave
- **Los Cimientos de DeFi:** Antes de crear plataformas de préstamos (lending) o exchanges descentralizados (DEXs), necesitamos un activo económico subyacente. El `JamToken` (`JAM`) servirá como nuestro vehículo de valor para el ecosistema DeFi de nuestro proyecto final.
- **Estándares y Componibilidad:** Entenderemos por qué construir siguiendo estrictamente las reglas de interfaz (ej: usar exactamente `transferFrom`) garantiza que nuestro nuevo token sea compatible inmediatamente con herramientas globales como MetaMask o Uniswap.

### 2. Ecosistema Multi-Token (Pares Liquidez)
**Archivo:** `2_stellar_token.sol`

Implementación de `StellarToken` (STE), el segundo pilar de nuestro incipiente ecosistema DeFi. Estructuralmente es idéntico al Jam Token, pero conceptualmente es la pieza que desbloquea las verdaderas finanzas descentralizadas.
- **Pares de Criptoactivos:** En el mercado financiero real, las transacciones siempre involucran dos activos (Ej: Dólares por Oro). En DeFi, las plataformas de intercambio (DEX) requieren la suma de dos tokens para operar, formando un "Par de Liquidez" (Token A / Token B).
- **El Par JAM/STE:** Al crear Stellar, formamos nuestro primer par comercial de prueba. Sobre esta base construiremos, en capítulos más avanzados, piscinas de liquidez (Liquidity Pools) y Automated Market Makers (AMM).
### 3. Yield Farming y Staking
**Archivo:** `3_token_farm.sol`

El núcleo de nuestro ecosistema DeFi. El contrato `TokenFarm` actúa como un banco descentralizado que vincula a `JamToken` y a `StellarToken` mediante mecanismos de incentivos financieros.
- **Interacción entre Contratos:** Cómo un Smart Contract principal (`TokenFarm`) puede guardar la dirección e interactuar directamente con funciones de contratos subyacentes (`jamToken.transferFrom(...)`).
- **Staking (Bloqueo de Valor):** Mecánica en la cual los usuarios confinan (bloquean) sus tokens JAM dentro del contrato a cambio de la promesa de un rendimiento. Todo manejado de forma `trustless` por el código.
- **Yield Farming (Cosecha de Rendimientos):** Lógica matemática programada donde el administrador (owner) reparte tokens nativos recién acuñados (Stellar - STE) proporcionales a la cantidad de liquidez (JAM) que los usuarios depositaron en la granja.
- **El flujo transaccional DeFi:** 
  1. El usuario invoca `approve` en JamToken.
  2. El usuario invoca `stakeTokens` en TokenFarm.
  3. El owner invoca `issueTokens` y paga las recompensas en StellarToken.
  4. El usuario invoca `unstakeTokens` para recuperar indemne sus JAM iniciales.
