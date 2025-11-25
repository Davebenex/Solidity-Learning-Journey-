// Get funds from users 
// Withdraw funds 
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
    import{AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
AggregatorV3Interface public pricefeed;
address[] public Senders;
mapping (address Senders  => uint amountFunded) public addressToAmount;
constructor(){
    pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
}

uint256 public minimumUsd = 5e18;

function fund() public payable {
    require(
        getLatestPrice(msg.value) >= minimumUsd,
        "Didn't send enough ETH"
    );
    Senders.push(msg.sender);
    addressToAmount[msg.sender] = addressToAmount[msg.sender] + msg.value;
}


//function to confirm curent prince of token from chainlink
function GetPrice() public view returns(uint256) {
//Address; 0x694AA1769357215DE4FAC081bf1f309aDC325306
//ABI; 
pricefeed.latestRoundData();
//this returns 5 values
//(uint80 roundId,
 //int256 answer,
 //uint256 startedAt,
 //uint256 updatedAt,
 //uint80 answeredInRound)....but we only need the price value stored as var "answer" 
 //lets write in a way that tellssoliit to only provide that one 
(, int256 answer, , , ) = pricefeed.latestRoundData();//take the second value only and lets rename her price
return uint(answer) * 1e10;  //Typecast → Multiply → Return
}

//soldty math
function getLatestPrice(uint256 _ethAmount) public view returns(uint256){
uint256 ethprice = GetPrice();

return (ethprice * _ethAmount)/1e18;//always multiply before you divide in solidity
//TO IMPLIMENT LATER 
}

}
