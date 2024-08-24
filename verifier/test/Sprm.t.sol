// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Sprm} from "../src/Sprm.sol";

contract HashTest is Test {
    Sprm public hasher;

    function setUp() public {
        hasher = new Sprm();
    }

    function test_hash() public view {
        bytes memory input = new bytes(1000);
        bytes memory padded = hasher.pad(input);

        bytes32 sprm = hasher.rollup(padded, 1);

        bytes memory rem = new bytes(padded.length - 64);
        for (uint256 i = 0; i < padded.length - 64; i++) {
            rem[i] = padded[i + 64];
        }

        bytes32 fullHash = hasher.getFullHash(sprm, rem);
        console.logBytes32(fullHash);

        assertEq(
            fullHash,
            hex"541b3e9daa09b20bf85fa273e5cbd3e80185aa4ec298e765db87742b70138a53"
        );
    }
}
