// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter1.sol";

error NotOwner();

/**
 * @title FundMe
 * @notice Simple funding contract with USD-based minimum using a price feed.
 */
contract FundMe {
    using PriceConverter for uint256;

    address[] public senders;
    mapping(address => uint256) public addressToAmountFunded;

    uint256 public constant MINIMUM_USD = 5e18;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    /**
     * @notice Fund the contract, enforcing a minimum in USD.
     */
    function fund() external payable {
        require(
            msg.value.getLatestPrice() >= MINIMUM_USD,
            "Didn't send enough ETH"
        );

        senders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    /**
     * @notice Withdraw all funds to the owner.
     */
    function withdraw() external onlyOwner {
        // reset funded amounts
        for (uint256 i = 0; i < senders.length; i++) {
            address sender = senders[i];
            addressToAmountFunded[sender] = 0;
        }
        delete senders;

        // use call to send ETH
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    // modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
}
