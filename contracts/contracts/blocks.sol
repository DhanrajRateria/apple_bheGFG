// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Blockchain {
    uint256 public blocksCount;
    struct Blocks {
        uint256 id;
        string orderId;
        string orderName;
        string billType;
        string value;
        uint256 timeStamp;
    }
    mapping(uint256 => Blocks) public blocks;

    constructor() public {
        blocksCount = 0;
    }

    event BlockAdded(uint256 _id);

    function addBlock(
        string memory _orderId,
        string memory _orderName,
        string memory _billType,
        string memory _value,
        uint256 timeStamp
    ) public {
        blocks[blocksCount] = Blocks(
            blocksCount,
            _orderId,
            _orderName,
            _billType,
            _value,
            timeStamp
        );
        emit BlockAdded(blocksCount);
        blocksCount++;
    }
}
