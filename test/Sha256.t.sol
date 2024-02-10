// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {tp_sha256, hex_digest} from "../src/Sha256.sol";

contract Sha256Test is Test {

    function test_empty() public {
        bytes32 mine = tp_sha256("");
        bytes32 language = sha256("");
        assertEq(mine, language);
    }

}
