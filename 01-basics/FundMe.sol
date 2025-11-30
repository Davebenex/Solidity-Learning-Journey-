// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter1.sol";

error Notowner();

contract FundMe {

    // Use the PriceConverter library for uint256
    using PriceConverter for uint256;

    address[] public Senders;

    // Tracks how much each address has funded
    mapping(address => uint256) public addressToAmount;

    // Minimum amount required to fund, denominated in USD (with 18 decimals)
    uint256 public constant MINIMUM_uSD = 5e18;

    // Immutable owner address set at deployment
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    // Allows users to fund the contract if the minimum USD value is met
    function fund() public payable {
        require(
            msg.value.getLatestPrice() >= MINIMUM_uSD,
            "Didn't send enough ETH"
        );
        Senders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }

    // Withdraws all funds; can only be called by the owner
    function withdraw() public OnlyOwner {
        require(msg.sender == i_owner, "Aint yours");

        // Reset each sender's funded balance
        for (uint256 sendersIndex = 0; sendersIndex < Senders.length; sendersIndex++) {
            address withdrawFrom = Senders[sendersIndex];
            addressToAmount[withdrawFrom] = 0;
        }

        // Reset the senders array
        Senders = new address[] (0);

        // Three ways to send ETH: transfer, send, call

        // transfer: reverts on failure, forwards 2300 gas
        payable(msg.sender).transfer(address(this).balance);

        // send: returns a boolean instead of reverting, forwards 2300 gas
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        // call: low-level function, forwards all available gas by default
        // returns a boolean and optional returned data
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // Modifier that restricts function access to the owner
    // Modifiers allow reusable logic to be applied to functions
    modifier OnlyOwner() {
        if (msg.sender != i_owner) {
            revert Notowner();
        }
        _; // Execution continues after the modifier check
    }

    // Called when ETH is sent with no data
    receive() external payable {
        fund();
    }

    // Called when calldata does not match any function
    // or when receive() is not defined
    fallback() external payable {
        fund();
    }

    // Note: Modifiers do not have visibility keywords like functions
}
