// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {tp_sha256} from "../src/Sha256.sol";

contract Sha256Test is Test {

    function test_empty() public {
        bytes32 mine = tp_sha256("");
        bytes32 language = sha256("");
        assertEq(mine, language);
    }

    function test_first() public {
        bytes32 mine = tp_sha256("This is a test");
        bytes32 language = sha256("This is a test");
        assertEq(mine, language);
    }

    function test_second() public {
        bytes32 mine = tp_sha256("Lorem ipsum dolor sit amet, consectetur adipiscing elit integer.");
        bytes32 language = sha256("Lorem ipsum dolor sit amet, consectetur adipiscing elit integer.");
        assertEq(mine, language);
    }

    function test_third() public {
        bytes32 mine = tp_sha256("Lorem ipsum dolor sit amet, consectetur adipiscing tellus.");
        bytes32 language = sha256("Lorem ipsum dolor sit amet, consectetur adipiscing tellus.");
        assertEq(mine, language);
    }

    function test_fourth() public {
        bytes memory str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit volutpat.";
        bytes32 mine = tp_sha256(str);
        bytes32 language = sha256(str);
        assertEq(mine, language);
    }

    function test_fifth() public {
        bytes memory str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse blandit dui non augue facilisis rhoncus. Ut egestas.";
        bytes32 mine = tp_sha256(str);
        bytes32 language = sha256(str);
        assertEq(mine, language);
    }

    function test_sixth() public {
        bytes memory str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eleifend ut turpis a fringilla. Mauris mi ligula, volutpat quam.";
        bytes32 mine = tp_sha256(str);
        bytes32 language = sha256(str);
        assertEq(mine, language);
    }
}
