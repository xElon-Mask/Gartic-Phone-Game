// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GarticPhone is Ownable {

    // variables: array of words, players and winner if any
    string[] private words;
    mapping (address => bool) played;
    address winner;

    // state of the game
    enum State {proposition, devine, fin}
    State state = State.proposition;

    // events
    event newWord(address player, string word);
    event stateChanged(State enCours);

    // Add new word to the list
    function StoreWord(string memory _newWord) public {
        require(state == State.proposition, "You can't play to the game");
        require(keccak256(abi.encodePacked((_newWord))) != keccak256(abi.encodePacked(GetLastWord())), "Can't write same word ! ");
        require(!played[msg.sender], "You have already played !");
        words.push(_newWord);
        emit newWord(msg.sender, _newWord);
        if (words.length == 20) {
            state = State.devine;
            emit stateChanged(state);
        }
    }

    // Get only the last word : GetLastWord()
    function GetLastWord() public view returns (string memory) {
        if (words.length != 0) {
            return words[words.length - 1];
        } else {
            return " ";
        }
    }

    // Get the words list
    function GetWords() public view onlyOwner returns (string[] memory) {
        return words;
    }
}
