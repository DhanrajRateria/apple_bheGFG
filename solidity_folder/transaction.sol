// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transaction {
    address public sender;
    address public receiver;
    uint256 public value;
    string public billType;

    constructor(address _sender, address _receiver, uint256 _value, string memory _billType) {
        sender = _sender;
        receiver = _receiver;
        value = _value;
        billType = _billType;
    }

    function getTransaction() public view returns(address, address, uint256, string memory) {
        return (sender, receiver, value, billType);
    }
}
