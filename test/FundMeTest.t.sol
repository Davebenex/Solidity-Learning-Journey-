//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from"forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";

contract FundMeTest is Test {
        FundMe FundMeContract;

    function setUp() external {
        FundMeContract = new FundMe();
    }

    function testminimumDollarIsFive() public {
        assertEq(FundMeContract.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public {
        console.log(FundMeContract.i_owner());
        console.log(address(this));
        assertEq(FundMeContract.i_owner(), address(this));
    }
}
