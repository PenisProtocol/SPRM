// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Sha256} from "../src/Sha256.sol";

contract HashTest is Test {
    Sha256 public hasher;

    function setUp() public {
        hasher = new Sha256();
    }

    function test_pad() public view {
        console.logBytes(hasher.pad(""));
        assertEq(hasher.pad("").length, 64);
    }

    function test_hash() public view {
        assertEq(
            hasher.hashPure(""),
            hex"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        );
        assertEq(
            hasher.hashPure(hex"bd"),
            hex"68325720aabd7c82f30f554b313d0570c95accbb7dc4b5aae11204c08ffe732b"
        );
        assertEq(
            hasher.hashPure("\xc9\x8c\x8e\x55"),
            hex"7abc22c0ae5af26ce93dbb94433a0e0b2e119d014f8e7f65bd56c61ccccd9504"
        );
        // make zero * 55 array
        assertEq(
            hasher.hashPure(new bytes(55)),
            hex"02779466cdec163811d078815c633f21901413081449002f24aa3e80f0b88ef7"
        );
        // make zero * 56 array
        assertEq(
            hasher.hashPure(new bytes(56)),
            hex"d4817aa5497628e7c77e6b606107042bbba3130888c5f47a375e6179be789fbb"
        );
        // make zero * 57 array
        assertEq(
            hasher.hashPure(new bytes(57)),
            hex"65a16cb7861335d5ace3c60718b5052e44660726da4cd13bb745381b235a1785"
        );
        // make zero * 64 array
        assertEq(
            hasher.hashPure(new bytes(64)),
            hex"f5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b"
        );
        // make zero * 1000 array
        assertEq(
            hasher.hashPure(new bytes(1000)),
            hex"541b3e9daa09b20bf85fa273e5cbd3e80185aa4ec298e765db87742b70138a53"
        );
        // make 0x41 * 1000 array
        bytes memory thousand41 = new bytes(1000);
        for (uint256 i = 0; i < 1000; i++) {
            thousand41[i] = 0x41;
        }
        assertEq(
            hasher.hashPure(thousand41),
            hex"c2e686823489ced2017f6059b8b239318b6364f6dcd835d0a519105a1eadd6e4"
        );
        // make 0x55 * 1005 array
        bytes memory thousand55 = new bytes(1005);
        for (uint256 i = 0; i < 1005; i++) {
            thousand55[i] = 0x55;
        }
        assertEq(
            hasher.hashPure(thousand55),
            hex"f4d62ddec0f3dd90ea1380fa16a5ff8dc4c54b21740650f24afc4120903552b0"
        );
    }

    // function testFuzz_hash(uint256 x) public view {
    //     bytes memory data = abi.encodePacked(x);
    //     assertEq(hasher.hashPure(data), hasher.hashPure(data));
    // }
}
