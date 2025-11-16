// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MappingPlayground {
    // lets use this struct to organize our data
    struct User {
        address userAddress;
        string username;
    }

    // lets make an array out of our struct 
    User[] public userbase;

    mapping(address => uint256) public addressToIndex;
    mapping (address => bool) public isRegistered;

    // lets collect the user's name
    function collectUsername(string memory _username, address _address) public {
        userbase.push(User(_address, _username));

        addressToIndex[_address] = userbase.length - 1; //asighns numbering based on array lenght after this epoch 
        isRegistered[_address] = true; //marks address as regstered 
    }

    function getUser(address _address) public view returns (string memory, address) {
        require(isRegistered[_address], "user not found"); //if false revert
        // find the index in our array and store in var called index 
        
        uint256 index = addressToIndex[_address];
        // make a pointer for the row within the index so it is easy to type 
        User storage m = userbase[index];

        // on that row return specific columns
        return (m.username, m.userAddress);
    }

        function UpdateUsername(string memory _newusername,address _address) public{
            require(isRegistered[_address], "user not found");//checks if the address can be found 
            //now lets locate it
            uint index = addressToIndex[_address];
            //make a pointer to index location 
            User storage I = userbase[index];
            //update the user name
            I.username = _newusername;



        }



}
