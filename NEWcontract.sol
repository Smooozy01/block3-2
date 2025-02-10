// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AITUSE2327MOD is ERC20 {
    address public owner;

    event TransactionDetails(
        address indexed sender,
        address indexed receiver,
        uint256 amount,
        uint256 blockTimestamp
    );

    struct TransactionInfo {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    TransactionInfo[] private transactionHistory;

    constructor(address initialOwner, uint256 initialSupply) ERC20("AITUSE2327", "AITUSE") {
        require(initialOwner != address(0), "Owner cannot be zero address");
        require(initialSupply > 0, "Initial supply must be greater than zero");

        owner = initialOwner;
        _mint(initialOwner, initialSupply * 10 ** decimals());
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        logTransactionDetails(msg.sender, recipient, amount);
        return super.transfer(recipient, amount);
    }

    function logTransactionDetails(address sender, address receiver, uint256 amount) public {
        emit TransactionDetails(sender, receiver, amount, block.timestamp);
        transactionHistory.push(TransactionInfo(sender, receiver, amount, block.timestamp));
    }

    function retrieveTransactionInformation() public view returns (TransactionInfo[] memory) {
        return transactionHistory;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply();
    }
}
