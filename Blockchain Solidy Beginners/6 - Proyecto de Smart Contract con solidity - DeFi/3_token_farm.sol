// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Es crucial importar los contratos exactos que vamos a utilizar.
// El Token Farm necesita conocer la "forma" de JamToken y StellarToken para interactuar con ellos.
import "./1_jam_token.sol";
import "./2_stellar_token.sol";

/**
 * @title TokenFarm (DeFi Project)
 * @dev Este contrato de "Yield Farming" (Cosecha de Rendimientos) actúa como un banco cripto.
 * Los usuarios depositan (hacen stake de) su JAM Token y, como recompensa, el
 * contrato les "paga" intereses usando Stellar Token (STE).
 */
contract TokenFarm {
    // --- Declaraciones iniciales ---
    string public name = "Stellar Token Farm";
    address public owner;

    // INTERACCIÓN ENTRE CONTRATOS:
    // Creamos variables de tipo "JamToken" y "StellarToken".
    // Esto conectará nuestro TokenFarm con las redes de los otros dos tokens.
    JamToken public jamToken;
    StellarToken public stellarToken;

    // --- Estructuras de datos (Registro Contable) ---

    // Lista histórica de todas las direcciones que han depositado fondos alguna vez.
    address[] public stakers;

    // ¿Cuánto JAM tiene depositado exactamente cada usuario en este instante?
    mapping(address => uint256) public stakingBalance;

    // ¿El usuario ha depositado fondos alguna vez en la historia? (Útil para evitar usuarios duplicados en el array 'stakers')
    mapping(address => bool) public hasStaked;

    // ¿El usuario tiene fondos bloqueados en este mismo momento?
    mapping(address => bool) public isStaking;

    /**
     * @dev Constructor de TokenFarm.
     * Al desplegar este contrato, DEBEMOS pasarle las direcciones de los contratos
     * JamToken y StellarToken previamente desplegados en la red.
     */
    constructor(StellarToken _stellarToken, JamToken _jamToken) {
        stellarToken = _stellarToken;
        jamToken = _jamToken;
        owner = msg.sender;
    }

    // --- Lógica Core DeFi ---

    /**
     * @notice DEPOSITAR FONDOS (Stake).
     * @dev Paso PREVIO obligatorio en el frontend: El usuario debe llamar a la función `approve`
     * en el contrato JamToken, autorizando a este TokenFarm a mover '_amount' cantidad de JAM.
     */
    function stakeTokens(uint256 _amount) public {
        require(_amount > 0, "No puedes hacer stake de 0 tokens");

        // 1. Cobrar: El Farm "jala" los JAM tokens del usuario hacia sí mismo.
        jamToken.transferFrom(msg.sender, address(this), _amount);

        // 2. Registrar: Anotamos contablemente que el usuario nos depositó esta cantidad.
        stakingBalance[msg.sender] += _amount;

        // 3. Primer depósito histórico: Agregamos al usuario a nuestra base de datos iterable.
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // 4. Actualizar Estado
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    /**
     * @notice RETIRAR FONDOS (Unstake).
     * @dev Permite al usuario retirar su capital inicial (JAM) cuando lo desee.
     */
    function unstakeTokens() public {
        uint256 balance = stakingBalance[msg.sender];
        require(balance > 0, "No tienes tokens en staking");

        // 1. Devolver fondos: El contrato TokenFarm transfiere el JAM resguardado de regreso al usuario.
        jamToken.transfer(msg.sender, balance);

        // 2. Borrar registro contable: Su balance de bloqueo vuelve a 0.
        stakingBalance[msg.sender] = 0;

        // 3. Actualizar estado
        isStaking[msg.sender] = false;
    }

    /**
     * @notice PAGAR RECOMPENSAS DIARIAS (Yield).
     * @dev El administrador ejecuta esta función para repartir Stellar Tokens (STE).
     * ¡Magia DeFi! Ganas 1 token Stellar por cada token Jam que tengas bloqueado.
     * EJ: Si tienes 100 JAM en Staking, recibirás 100 STE como premio.
     */
    function issueTokens() public {
        require(msg.sender == owner, "No eres el owner de la granja");

        // Iteramos sobre TODOS los inversores históricos.
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];

            // Verificamos cuánto capital (JAM) tiene depositado cada uno.
            uint256 balance = stakingBalance[recipient];

            if (balance > 0) {
                // Pagamos el interés o rendimiento enviándoles Stellar Token (STE).
                // IMPORTANTE: Previamente, el contrato TokenFarm debió haber recibido todo el supply
                // inicial de StellarToken para poder tener fondos que regalar.
                stellarToken.transfer(recipient, balance);
            }
        }
    }
}
