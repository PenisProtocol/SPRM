// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Sha256} from "../src/Sha256.sol";

contract ShaScript is Script {
    Sha256 public hasher;
    bytes32 public hash;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        hasher = new Sha256();
        vm.breakpoint("h");
        hash = hasher.hashPure("");

        vm.stopBroadcast();
    }
}
