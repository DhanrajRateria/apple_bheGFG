// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Blockchain {
    struct Block {
        uint256 index;
        bytes32 orderId;
        bytes32 orderName;
        bytes32 billType;
        uint256 value;
        bytes32 previousHash;
        bytes32 hash;
        uint256 timestamp;
    }

    Block[] public blocks;

    function addBlock(
        bytes32 orderId,
        bytes32 orderName,
        bytes32 billType,
        uint256 value
    ) public {
        bytes32 previousHash = blocks[blocks.length - 1].hash;
        bytes32 hash = keccak256(
            abi.encodePacked(
                blocks.length,
                orderId,
                orderName,
                billType,
                value,
                previousHash,
                block.timestamp
            )
        );
        Block memory block = Block(
            blocks.length,
            orderId,
            orderName,
            billType,
            value,
            previousHash,
            hash,
            block.timestamp
        );
        blocks.push(block);
    }
}
