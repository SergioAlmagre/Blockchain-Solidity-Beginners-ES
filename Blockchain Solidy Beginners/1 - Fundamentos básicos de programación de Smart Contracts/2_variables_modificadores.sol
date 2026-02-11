// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Variables y Tipos de Datos en Solidity
 * @dev Este contrato demuestra los diferentes tipos de datos primitivos y complejos 
 *      disponibles en Solidity, así como su visibilidad (public, private).
 */
contract variables_modifiers {
    
    // ==========================================
    // Valores Enteros (Unsigned Integers)
    // ==========================================
    // uint256: Entero sin signo de 256 bits (0 a 2^256 - 1)
    // Es el tipo por defecto para números en Solidity si no se especifica el tamaño.
    uint256 a; 
    
    // uint8: Entero sin signo de 8 bits (0 a 255). 
    // Usar tamaños menores (uint8, uint16) solo ahorra gas si se empaquetan variables.
    uint8 public b = 3;

    // ==========================================
    // Valores Enteros con Signo (Signed Integers)
    // ==========================================
    // int256: Entero con signo (permite negativos).
    int256 c;
    
    // int8: Entero con signo de 8 bits (-128 a 127).
    int8 public d = -32;
    
    // int: Alias para int256.
    int e = 65;

    // ==========================================
    // Cadenas de Texto (Strings)
    // ==========================================
    // string: Cadena de caracteres UTF-8. Es costoso en gas.
    string str;
    
    // public: Visible desde fuera del contrato y desde otros contratos.
    string public str2 = "Hola mundo";
    
    // private: Solo visible dentro de este contrato. No impide que se lea desde la blockchain,
    // solo impide que otros contratos lo accedan directamente.
    string private str3 = "esto es privado";

    // ==========================================
    // Booleanos
    // ==========================================
    // bool: true o false.
    bool private bool1 = false;
    bool public bool2 = true;

    // ==========================================
    // Bytes (Datos en crudo)
    // ==========================================
    // bytes32: Tamaño fijo de 32 bytes. Es más eficiente que string.
    bytes32 first_bytes;
    bytes4 second_bytes;
    bytes1 byte_1;

    // ==========================================
    // Algoritmos de Hashing
    // ==========================================
    /** 
     * @notice keccak256 es el algoritmo de hash estándar en Ethereum.
     * @dev abi.encodePacked concatena los argumentos antes de hashear.
     */
    bytes32 public hashin_keccak256 = keccak256(abi.encodePacked("Hola", "como estas", uint(10)));
    
    // sha256: Otro algoritmo de hash disponible.
    bytes32 public hashign_sha256 = sha256(abi.encodePacked("Hola", "como estas", 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
    
    // ripemd160: Devuelve 20 bytes.
    bytes20 public hashign_ripemd160 = ripemd160(abi.encodePacked("Hola","como estas"));

    // ==========================================
    // Direcciones (Addresses)
    // ==========================================
    // address: Almacena una dirección de Ethereum (20 bytes).
    address  my_address;
    address public address1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    
    // msg.sender: Variable global que contiene la dirección de quien llama al contrato.
    address public address2 = msg.sender;

    // ==========================================
    // Enumeraciones (Enums)
    // ==========================================
    // enum: Crea un tipo definido por el usuario con un conjunto de constantes.
    // Útil para máquinas de estados.
    enum options {ON, OFF}
    
    // Variable de estado del tipo 'options'
    options state;
    
    // constant: El valor se fija en tiempo de compilación y no consume almacenamiento (storage).
    options constant defaultChoice = options.OFF;

    /**
     * @notice Cambia el estado a ON.
     */
    function turnOn() public {
        state = options.ON;
    }

    /**
     * @notice Cambia el estado a OFF.
     */
    function turnOff() public {
        state = options.OFF;
    }

    /**
     * @notice Devuelve el estado actual.
     * @return El valor actual de la variable 'state'.
     */
    function displayState() public view returns (options) {
        return state;
    }
}