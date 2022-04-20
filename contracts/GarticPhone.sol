// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GarticPhone is Ownable {

    // variables: array of words, players and winner if any
    string[] private words;
    mapping (address => bool) played;
    address winner;

    
}
