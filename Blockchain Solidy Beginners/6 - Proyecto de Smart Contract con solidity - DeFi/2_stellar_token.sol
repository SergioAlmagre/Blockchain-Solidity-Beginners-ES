// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title StellarToken (DeFi Project)
 * @dev Implementación manual de un segundo contrato ERC-20.
 *
 * ¿POR QUÉ UN SEGUNDO TOKEN?
 * En ecosistemas DeFi (Finanzas Descentralizadas) reales, casi todas las operaciones
 * de intercambio (Swaps) y de provisión de liquidez operan en "Pares" (Token A / Token B).
 *
 * Por ejemplo:
 * Para crear un mercado descentralizado para el token anterior (JAM), no basta con que el
 * token exista aislado. La gente necesita poder intercambiarlo por otro activo.
 * Aquí creamos 'Stellar' (STE) para formar nuestro primer Par de Liquidez (JAM / STE),
 * simulando un ecosistema de trading real.
 */
contract StellarToken {
    // --- Declaraciones y Metadatos ---
    string public name = "Stellar";
    string public symbol = "STE";

    // Suministro Total: Al igual que JAM, creamos 1 millón de unidades con 18 decimales.
    uint256 public totalSupply = 10 ** 24;
    uint8 public decimals = 18;

    // --- Eventos ---
    // Repaso: Estos eventos son los "megáfonos" de la blockchain. Avisan al mundo exterior
    // que el diccionario de balances (balanceOf) o el diccionario de permisos (allowance) ha cambiado.

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 value
    );

    // --- Estructuras de Datos ---

    // El registro contable principal. Quien tiene qué.
    mapping(address => uint256) public balanceOf;

    // El registro de autorizaciones delegadas para plataformas DeFi.
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * @dev Generación (Minteo) Inicial. Todo el supply pertenece a quien despliega el contrato.
     */
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    // --- Funciones ERC-20 Estándar ---

    /**
     * @notice Enviar tokens desde mi propia wallet a otra persona.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(
            balanceOf[msg.sender] >= _value,
            "StellarToken: Balance insuficiente"
        );
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @notice Dar permiso a un 'Spender' (Ej: Nuestro futuro Exchange Descentralizado).
     * Este es el paso 1 crtico antes de poder hacer un intercambio (Swap) o proveer liquidez en DeFi.
     */
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice El 'Spender' (que recibió permiso anteriormente) ejecuta la transacción cobrándose de la wallet del '_from'.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(
            _value <= balanceOf[_from],
            "StellarToken: Balance insuficiente del emisor"
        );
        require(
            _value <= allowance[_from][msg.sender],
            "StellarToken: Permiso delegado insuficiente"
        );

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
