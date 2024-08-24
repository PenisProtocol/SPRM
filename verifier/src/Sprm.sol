// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Libhash} from "./libhash.sol";

import {Test, console} from "forge-std/Test.sol";

contract Sprm {
    function pad(bytes calldata _input) public pure returns (bytes memory) {
        return Libhash.pad(_input);
    }

    function rollup(
        bytes calldata padded,
        uint pos
    ) public pure returns (bytes32) {
        uint256 blockLength = padded.length / 64;
        require(pos < blockLength, "Invalid position");

        uint32[8] memory state = [
            0x6a09e667,
            0xbb67ae85,
            0x3c6ef372,
            0xa54ff53a,
            0x510e527f,
            0x9b05688c,
            0x1f83d9ab,
            0x5be0cd19
        ];

        // Process each block up to the position
        for (uint256 i = 0; i < pos; i++) {
            uint32[16] memory oneBlock;
            uint256 offset = i * 64;
            for (uint256 j = 0; j < 16; j++) {
                oneBlock[j] = uint32(
                    (uint32(uint8(padded[offset + j * 4])) << 24) |
                        (uint32(uint8(padded[offset + j * 4 + 1])) << 16) |
                        (uint32(uint8(padded[offset + j * 4 + 2])) << 8) |
                        (uint32(uint8(padded[offset + j * 4 + 3])))
                );
            }

            state = Libhash.compress(state, oneBlock);
        }

        bytes32 hash = bytes32(uint256(state[0]) << 224) |
            bytes32(uint256(state[1]) << 192) |
            bytes32(uint256(state[2]) << 160) |
            bytes32(uint256(state[3]) << 128) |
            bytes32(uint256(state[4]) << 96) |
            bytes32(uint256(state[5]) << 64) |
            bytes32(uint256(state[6]) << 32) |
            bytes32(uint256(state[7]));

        return hash;
    }

    function getFullHash(
        bytes32 sprm,
        bytes calldata _padPub
    ) public pure returns (bytes32) {
        uint remBlockLength = _padPub.length / 64;

        uint32[8] memory state = [
            uint32(uint256(sprm) >> 224),
            uint32(uint256(sprm) >> 192),
            uint32(uint256(sprm) >> 160),
            uint32(uint256(sprm) >> 128),
            uint32(uint256(sprm) >> 96),
            uint32(uint256(sprm) >> 64),
            uint32(uint256(sprm) >> 32),
            uint32(uint256(sprm))
        ];
        // Process each block
        for (uint i = 0; i < remBlockLength; i++) {
            uint32[16] memory oneBlock;
            uint offset = i * 64;
            for (uint j = 0; j < 16; j++) {
                oneBlock[j] = uint32(
                    (uint32(uint8(_padPub[offset + j * 4])) << 24) |
                        (uint32(uint8(_padPub[offset + j * 4 + 1])) << 16) |
                        (uint32(uint8(_padPub[offset + j * 4 + 2])) << 8) |
                        (uint32(uint8(_padPub[offset + j * 4 + 3])))
                );
            }

            state = Libhash.compress(state, oneBlock);
        }

        bytes32 hash = bytes32(uint256(state[0]) << 224) |
            bytes32(uint256(state[1]) << 192) |
            bytes32(uint256(state[2]) << 160) |
            bytes32(uint256(state[3]) << 128) |
            bytes32(uint256(state[4]) << 96) |
            bytes32(uint256(state[5]) << 64) |
            bytes32(uint256(state[6]) << 32) |
            bytes32(uint256(state[7]));

        return hash;
    }
}
