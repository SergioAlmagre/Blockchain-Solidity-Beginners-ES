# 🧠 Blockchain & Smart Contracts (Solidity) — Repo de aprendizaje público

¡Bienvenido/a! 👋  
Este repositorio es mi **diario de progreso en código** mientras aprendo **blockchain y smart contracts con Solidity**, principalmente usando **Remix**. La idea es compartir implementaciones reales (sin humo), apuntes prácticos y proyectos pequeños/medianos que cualquiera pueda **clonar, leer, ejecutar y entender**.

Además, este repo también funciona como:
- ✅ **Punto de referencia** para mí (volver a ejemplos y patrones)
- ✅ **Material de estudio** para otros
- ✅ **Base pública** para, a futuro, crear contenido más estructurado (posts, hilos, vídeos…) y quién sabe si un **curso propio**

> Si estás aprendiendo Solidity, o quieres ver ejemplos claros y progresivos, estás en el sitio correcto.

---

## 🎯 Objetivo del repositorio

- Aprender haciendo: **contratos, tests, despliegues, dApps y tooling**
- Documentar el “cómo” y el “por qué” (no solo pegar código)
- Mantener ejemplos **pequeños, aislados y reutilizables**
- Construir proyectos completos que conecten piezas: **tokens, NFTs, oráculos, front-end, almacenamiento descentralizado, despliegue**

---

## 🧩 Contenido que encontrarás aquí

Este repo irá creciendo con implementaciones y proyectos alrededor de:

### Solidity y Smart Contracts
- Fundamentos de smart contracts (variables, funciones, eventos, errores, modifiers, estructuras, etc.)
- Solidity avanzado (patrones, seguridad básica, optimización, buenas prácticas)

### Tokens
- **ERC-20** (creación, mint/burn, allowances, casos típicos)
- **ERC-721 (NFTs)** (mint, metadata, ownership, colecciones)
- **ERC-1155** (multi-token, batch operations, casos de uso)

### Proyectos con Smart Contracts
- Proyecto tipo **DeFi**
- Proyecto tipo **lotería** con tokens (p.ej. ERC-20 / NFTs)
- Proyecto tipo **marketplace de NFTs**

### Entorno de desarrollo y herramientas
- **Remix** (despliegue rápido y directo)
- **Ganache** (blockchain local para pruebas)
- **Truffle** (flujo de desarrollo y despliegue)
- **Truffle PRO** (mejoras/flujo más profesional)
- **Hardhat** (scripts, despliegue, testing, debugging)
- **Foundry** (scripts, despliegue, testing, debugging)

### Ecosistema y redes
- **Oráculos** (fundamentos teóricos)
- Redes/EVM: **Polygon (MATIC)**, **BSC**, **Avalanche**

### Librerías para interacción con contratos
- **Web3.js**
- **Ethers.js**

### dApps (Front-end)
- dApp con **React** orientada a **DeFi**
- dApp con **React** para **lotería** con tokens y NFTs
- dApp con **React** para **marketplace de NFTs**

### Almacenamiento y despliegue
- **IPFS**
- Despliegue de dApps con **Docker**

### Extra (para reforzar fundamentos)
- Creación de una **blockchain con Python**
- Creación de una **criptomoneda con Python**
- Proyecto “real”: **emisión y validación de certificados** con blockchain

---

## 🗂️ Estructura (orientativa)

La estructura puede evolucionar, pero la idea es mantenerlo ordenado por temática:

- `contracts/` → contratos Solidity (por concepto o estándar)
- `tokens/` → ERC-20 / ERC-721 / ERC-1155
- `projects/` → proyectos completos on-chain
- `dapps/` → front-end (React) + integración
- `tooling/` → Hardhat / Truffle / scripts de despliegue
- `notes/` → apuntes, checklist, recursos y lecciones aprendidas
- `python/` → ejercicios de fundamentos con Python
- `docker/` → contenedores y despliegues

---

## 🧪 Cómo usar este repo

### Opción A — Remix (rápido y directo)
1. Abre Remix: `https://remix.ethereum.org`
2. Copia el contrato desde este repo (o impórtalo)
3. Compila en la pestaña **Solidity Compiler**
4. Despliega en **Remix VM** o conecta MetaMask para una red real

### Opción B — Local (cuando toque Hardhat/Truffle/Foundry)
Cuando haya proyectos con tooling, normalmente incluirán su propio `README` con:
- instalación de dependencias
- scripts de test
- despliegue local (Ganache/Hardhat)
- despliegue a testnet

---

## ⚠️ Aviso importante (léelo)
Este código es **educativo**.  
No está auditado y **no debe usarse en producción** tal cual. Si decides reutilizar ideas, haz tu propia revisión de seguridad, tests, y auditoría.

Nada de lo publicado aquí es consejo financiero.

---

## 🤝 Contribuciones y feedback
Si ves un bug, una mala práctica, o tienes una mejora:
- abre un **Issue**
- o propone un **Pull Request**

Si algo no se entiende, dímelo: la idea es que el repo sea útil también para otras personas.

---

## 📌 Seguimiento
Iré compartiendo avances en redes con ejemplos y mini-explicaciones.  
Si te interesa, puedes dejar una ⭐ al repo para no perderlo de vista.

Gracias por pasarte 🚀
