// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";

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
        bytes memory padded = pad(_input);

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

            state = compress(state, oneBlock);
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

    /**
     * @dev
     * Pad the input to the next 64 byte boundary
     * @param _input The input to pad
     * @return The padded input
     */
    function pad(bytes calldata _input) public pure returns (bytes memory) {
        uint256 dataSize = _input.length;
        uint256 blockCount = (dataSize + 9) % 64 == 0
            ? (dataSize + 9) / 64
            : (dataSize + 9) / 64 + 1;
        uint256 paddedSize = blockCount * 64;
        bytes memory padded = new bytes(paddedSize);

        for (uint256 i = 0; i < dataSize; i++) {
            padded[i] = _input[i];
        }

        padded[dataSize] = 0x80;

        uint256 bitSize = dataSize * 8;
        for (uint256 i = 0; i < 8; i++) {
            padded[paddedSize - 1 - i] = bytes1(uint8(bitSize >> (i * 8)));
        }

        return padded;
    }

    /**
     * @dev
     * Perform the SHA-256 compression function
     * @param _state The current state of the hash
     * @param _block The block to compress
     * @return The new state of the hash
     */
    function compress(
        uint32[8] memory _state,
        uint32[16] memory _block
    ) public pure returns (uint32[8] memory) {
        unchecked {
            uint32[64] memory sched; // schedule array W

            // Initialize the first 16 words of the schedule array
            for (uint256 i = 0; i < 16; i++) {
                sched[i] = _block[i];
            }

            // Initialize the rest of the schedule array
            for (uint256 i = 16; i < 64; i++) {
                sched[i] =
                    lsigma1(sched[i - 2]) +
                    sched[i - 7] +
                    lsigma0(sched[i - 15]) +
                    sched[i - 16];
            }

            uint32[64] memory k = [
                0x428a2f98,
                0x71374491,
                0xb5c0fbcf,
                0xe9b5dba5,
                0x3956c25b,
                0x59f111f1,
                0x923f82a4,
                0xab1c5ed5,
                0xd807aa98,
                0x12835b01,
                0x243185be,
                0x550c7dc3,
                0x72be5d74,
                0x80deb1fe,
                0x9bdc06a7,
                0xc19bf174,
                0xe49b69c1,
                0xefbe4786,
                0x0fc19dc6,
                0x240ca1cc,
                0x2de92c6f,
                0x4a7484aa,
                0x5cb0a9dc,
                0x76f988da,
                0x983e5152,
                0xa831c66d,
                0xb00327c8,
                0xbf597fc7,
                0xc6e00bf3,
                0xd5a79147,
                0x06ca6351,
                0x14292967,
                0x27b70a85,
                0x2e1b2138,
                0x4d2c6dfc,
                0x53380d13,
                0x650a7354,
                0x766a0abb,
                0x81c2c92e,
                0x92722c85,
                0xa2bfe8a1,
                0xa81a664b,
                0xc24b8b70,
                0xc76c51a3,
                0xd192e819,
                0xd6990624,
                0xf40e3585,
                0x106aa070,
                0x19a4c116,
                0x1e376c08,
                0x2748774c,
                0x34b0bcb5,
                0x391c0cb3,
                0x4ed8aa4a,
                0x5b9cca4f,
                0x682e6ff3,
                0x748f82ee,
                0x78a5636f,
                0x84c87814,
                0x8cc70208,
                0x90befffa,
                0xa4506ceb,
                0xbef9a3f7,
                0xc67178f2
            ];

            uint32 a = _state[0];
            uint32 b = _state[1];
            uint32 c = _state[2];
            uint32 d = _state[3];
            uint32 e = _state[4];
            uint32 f = _state[5];
            uint32 g = _state[6];
            uint32 h = _state[7];

            for (uint256 i = 0; i < 64; i++) {
                uint32 temp1 = h + sigma1(e) + Ch(e, f, g) + k[i] + sched[i];
                uint32 temp2 = sigma0(a) + Maj(a, b, c);
                h = g;
                g = f;
                f = e;
                e = d + temp1;
                d = c;
                c = b;
                b = a;
                a = temp1 + temp2;
            }

            uint32[8] memory newState;
            newState[0] = _state[0] + a;
            newState[1] = _state[1] + b;
            newState[2] = _state[2] + c;
            newState[3] = _state[3] + d;
            newState[4] = _state[4] + e;
            newState[5] = _state[5] + f;
            newState[6] = _state[6] + g;
            newState[7] = _state[7] + h;

            return newState;
        }
    }

    // sha util
    function Ch(uint32 x, uint32 y, uint32 z) private pure returns (uint32) {
        return (x & y) ^ (~x & z);
    }

    function Maj(uint32 x, uint32 y, uint32 z) private pure returns (uint32) {
        return (x & y) ^ (x & z) ^ (y & z);
    }

    function rotr(uint32 x, uint32 n) private pure returns (uint32) {
        return (x >> n) | (x << (32 - n));
    }

    function sigma0(uint32 x) private pure returns (uint32) {
        return rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22);
    }

    function sigma1(uint32 x) private pure returns (uint32) {
        return rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25);
    }

    function lsigma0(uint32 x) private pure returns (uint32) {
        return rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3);
    }

    function lsigma1(uint32 x) private pure returns (uint32) {
        return rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10);
    }
}
