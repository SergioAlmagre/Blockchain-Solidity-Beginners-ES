// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract variables_modifiers {
    //Valores enteros
    uint256 a;
    uint8 public b = 3;

    //Valores entereros con signo
    int256 c;
    int8 public d = -32;
    int e = 65;

    //Valores string
    string str;
    string public str2 = "Hola mundo";
    string private str3 = "esto es privado";

    //Variablel booleana
    bool private bool1 = false;
    bool public bool2 = true;

    //Variables tipo bytes
    bytes32 first_bytes;
    bytes4 second_bytes;
    bytes1 byte_1;

    //Algoritmo de hash
    bytes32 public hashin_keccak256 = keccak256(abi.encodePacked("Hola", "como estas", uint(10)));
    bytes32 public hashign_sha256 = sha256(abi.encodePacked("Hola", "como estas", 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
    bytes20 public hashign_ripemd160 = ripemd160(abi.encodePacked("Hola","como estas"));

    //Variables address
    address  my_address;
    address public address1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public address2 = msg.sender;

    //Variables de enumeración
    enum options {ON, OFF}
    options state;
    options constant defaultChoice = options.OFF;

    function turnOn() public {
        state = options.ON;
    }

    function turnOff() public {
        state = options.OFF;
    }

    function displayState() public view returns  (options) {
        return state;
    }

}