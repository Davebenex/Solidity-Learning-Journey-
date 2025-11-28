// Get funds from users 
// Withdraw funds 
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter1.sol";
contract FundMe {
using PriceConverter for uint256;

address[] public Senders;
mapping (address Senders  => uint amountFunded) public addressToAmount;

uint256 public minimumUsd = 5e18;

address public owner;
constructor() {
    owner = msg.sender;
}

function fund() public payable {
    require( msg.value.getLatestPrice() >= minimumUsd,
       "Didn't send enough ETH"
    );
    Senders.push(msg.sender);
    addressToAmount[msg.sender] += msg.value;
}

function withdraw() public OnlyOwner{
    require(msg.sender == owner, "Aint yours");

    for (uint256 sendersIndex = 0; sendersIndex < Senders.length; sendersIndex++)
    {
       address withrawFrom = Senders[sendersIndex];

       addressToAmount[withrawFrom] = 0;
    }
    Senders = new address[] (0);

    //transfer //send //call

    //tranfer error reverts tansaction 
    payable(msg.sender).transfer(address(this).balance);//msg.sender = address //payable(msg.sender) = payable type/ 2300 max
    //send; no error returns bool 
   bool sendSuccess = payable(msg.sender).send(address(this).balance); //2300 max gas
   require(sendSuccess, "Send Failed");
   //call, low level, allows us o call any function onchain
   (bool callSuccess, ) =  payable(msg.sender).call{value: address(this).balance}("");//forward all gas or set gas, returns bool
   require (callSuccess, "call failled");

}
// lets create a modifier a modifier lets us add functionlity to pre-existing fundtions from out-side of the funstion
    modifier OnlyOwner() {
    require(msg.sender == owner, "Sender is not owner");
    _; //oreder of this line is very importan to sequence of execution
    }
    //notice we do not set viibility for modifiersunlike functions
}
