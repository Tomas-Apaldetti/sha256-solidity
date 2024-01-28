// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        bytes4 a = bytes4(0xFFFFFFFF);
        bytes32 b;

        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
