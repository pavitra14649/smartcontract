// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Under14CricketSelection {

    struct Player {
        string name;
        uint8 age;
        bool isSelected;
    }

    address public coach;
    mapping(address => Player) public players;
    uint public selectedPlayerCount;

    event PlayerRegistered(address playerAddress, string name, uint8 age);
    event PlayerSelected(address playerAddress, string name);
    event PlayerRejected(address playerAddress, string name, string reason);

    modifier onlyCoach() {
        require(msg.sender == coach, "Only the coach can perform this action");
        _;
    }

    constructor() {
        coach = msg.sender;
    }

    function registerPlayer(string memory _name, uint8 _age) public {
        require(_age < 14, "Player must be under 14 years of age");
        
        players[msg.sender] = Player(_name, _age, false);

        emit PlayerRegistered(msg.sender, _name, _age);
    }

    function selectPlayer(address _playerAddress) public onlyCoach {
        Player storage player = players[_playerAddress];
        
        require(player.age != 0, "Player not registered");
        require(player.age < 14, "Player must be under 14 years of age");
        require(!player.isSelected, "Player is already selected");

        player.isSelected = true;
        selectedPlayerCount++;

        assert(selectedPlayerCount > 0);

        emit PlayerSelected(_playerAddress, player.name);
    }

    function rejectPlayer(address _playerAddress, string memory reason) public onlyCoach {
        Player storage player = players[_playerAddress];

        require(player.age != 0, "Player not registered");
        
        if (player.age >= 14) {
            revert("Player is not eligible, age is 14 or above");
        }

        emit PlayerRejected(_playerAddress, player.name, reason);
    }

    function getPlayerDetails(address _playerAddress) public view returns (string memory, uint8, bool) {
        Player memory player = players[_playerAddress];
        return (player.name, player.age, player.isSelected);
    }
}


