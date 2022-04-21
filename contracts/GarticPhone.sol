// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GarticPhone is Ownable {

    // variables: array of words, players and winner if any
    string[] private words;
    mapping (address => bool) played;
    address[] players;
    address winner;

    // state of the game
    enum State {proposition, devine, fin}
    State state = State.proposition;

    // events
    event newWord(address player, string word);
    event stateChanged(State enCours);
    event finalResults(string firstWord, string lastWord, address winnerAddress);

    // Add new word to the list
    function StoreWord(string memory _newWord) public {
        require(state == State.proposition, "You can't play to the game");
        require(keccak256(abi.encodePacked((_newWord))) != keccak256(abi.encodePacked(GetLastWord())), "Can't write same word ! ");
        require(!played[msg.sender], "You have already played !");
        words.push(_newWord);
        newPlayer(msg.sender);
        emit newWord(msg.sender, _newWord);
        if (words.length == 20) {
            state = State.devine;
            emit stateChanged(state);
        }
    }

    // Keep all the adresses of the players (20)
    function newPlayer(address _newPlayer) private {
        players.push(_newPlayer);
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

    // Get the first word and the last word at the end of the game
    function getFirstLast() public view onlyOwner returns (string memory first, string memory last) {
        require(state == State.devine, "The Game is not finished");
        state == State.fin;
        emit stateChanged(state);
        return (words[0], words[19]);
    }

    // Guessing
    function guessIt(string memory _word) public returns (address) {
        require(state == State.devine, "You can't guess the word yet");
        if (keccak256(abi.encodePacked(_word)) != keccak256(abi.encodePacked(words[0]))) {
            return (address(0));
        } else {
            winner = msg.sender;
            state = State.fin;
            emit stateChanged(state);
            return winner;
        }
    }

    // Getter of the end of the game
    function getResults() public view {
        require(state == State.fin, "Game not already finished");
        emit finalResults(words[0], words[19], winner);
    }

}
