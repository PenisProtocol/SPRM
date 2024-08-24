// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Sprm} from "../src/Sprm.sol";

/**
 * @title SprmUsage
 *
 * This contract describes how to use Sprm contract.
 */
contract SprmUsage is Script {
    Sprm public hasher;
    bytes32 public hash;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Okay, let's learn how to use Sprm contract.

        // First, we need to create a new instance of Sprm contract.
        hasher = new Sprm();

        // Now, we can call the pad function.
        bytes memory input = new bytes(1000);
        bytes memory padded = hasher.pad(input);

        // Next, we can call the rollup function.
        // For now, we assume the first three blocks contains the private data.abi
        bytes32 sprm = hasher.rollup(padded, 3);
        console.logBytes32(sprm);

        // Please send the remaining padded input and the sprm to the recipient.

        // Finally, we can call the getFullHash function at the recipient.
        bytes memory rem = new bytes(padded.length - 192);
        for (uint256 i = 0; i < padded.length - 192; i++) {
            rem[i] = padded[i + 192]; // make a clone of dynamic array
        }

        bytes32 fullHash = hasher.getFullHash(sprm, rem);
        console.logBytes32(fullHash);

        // For confirmation, let's compare the fullHash with the expected value.
        bool result = fullHash == sha256(abi.encodePacked(input));
        console.log(
            "The comparison result is(1 means success, 0 means not equal): %d",
            result
        );

        vm.stopBroadcast();
    }
}
