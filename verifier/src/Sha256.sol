// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
    function hash(bytes calldata _input) public pure returns (bytes32) {}

    /**
     * @dev
     * Return a i-th block slice
     * @param _input The entire message
     * @param _i the index of block
     * @return firstPart The first part of the block
     * @return lastPart The last part of the block
     */
    function getBlock(
        bytes calldata _input,
        uint256 _i
    ) public pure returns (uint256 firstPart, uint256 lastPart) {
        // Copilot, please write a padding function
        // Sure, here is a padding function

        uint256 sizeInBytes = _input.length;
        uint256 blockCount;
        if ((sizeInBytes + 9) % 64 == 0) {
            blockCount = (sizeInBytes + 9) / 64;
        } else {
            blockCount = (sizeInBytes + 9) / 64 + 1;
        }
        // is the last?
        if (_i == blockCount - 1) {
            // yes it is
            uint256 start = _i * 64;
            uint256 end = sizeInBytes + 1;
            if (end < start) {
                // overflows
                firstPart = 0;
                lastPart = uint256(_input.length);
            }
        } else {
            // no it is not
            uint256 start = _i * 64;
            uint256 end = start + 64;

            if (end > sizeInBytes) {
                // underflowing
                end = sizeInBytes;
                bytes memory slice = _input[start:end];
                // parse bytes to uint256
                assembly {
                    firstPart := mload(add(slice, 0x20))
                    lastPart := mload(add(slice, 0x40))
                }
            }

            bytes memory slice = _input[start:end];
            // parse bytes to uint256
            assembly {
                firstPart := mload(add(slice, 0x20))
                lastPart := mload(add(slice, 0x40))
            }
        }

        return (0, 0);
    }
}
