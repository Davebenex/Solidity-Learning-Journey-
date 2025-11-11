// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TransactionsApproved {
    uint256[] public listOfApprovedTransactions;

    function addTnx(uint256 _tnxNo) public {
        listOfApprovedTransactions.push(_tnxNo);
    }

    function removeLastTnx() public {
        listOfApprovedTransactions.pop();
    }

    function deleteTnx(uint256 _tnxIndex) public {
        delete listOfApprovedTransactions[_tnxIndex];
    }

    function viewList() public view returns (uint256[] memory) {
        return listOfApprovedTransactions;
    }
}
