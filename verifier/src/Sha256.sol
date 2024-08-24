// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Libhash} from "./libhash.sol";

contract Sha256 {
    function hashAccel(bytes calldata _input) public pure returns (bytes32) {
        return sha256(abi.encodePacked(_input));
    }

    /**
     * @dev
     * Hashes a string using the SHA-256 algorithm
     * Computes without SHA-256 precompile
     * @param _input The string to hash
     */
    function hashPure(bytes calldata _input) public pure returns (bytes32) {
        bytes memory padded = Libhash.pad(_input);

        uint256 blockLength = padded.length / 64;

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

        // Process each block
        for (uint256 i = 0; i < blockLength; i++) {
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
}
