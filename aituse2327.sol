// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin's ERC-20 implementation
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AITUSE2327 is ERC20 {
    // Event to log transaction details
    event TransactionDetails(
        address indexed sender,
        address indexed receiver,
        uint256 amount,
        uint256 blockTimestamp
    );

    // Struct to store transaction information
    struct TransactionInfo {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    // Array to store all transaction information
    TransactionInfo[] private transactionHistory;

    // Constructor to initialize the token with an initial supply
    constructor() ERC20("AITUSE2327", "AITUSE") {
        _mint(msg.sender, 2000 * 10 ** decimals()); // Mint 2000 tokens to the deployer
    }

    // Override the transfer function to log transaction details
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // Log the transaction details (and store in transactionHistory)
        logTransactionDetails(msg.sender, recipient, amount);
        // Note: Multiplying by decimals() here might not be what you intended.
        // Typically, you would use: amount * (10 ** decimals())
        return super.transfer(recipient, amount * decimals());
    }

    // Function to log transaction details and store them on-chain
    function logTransactionDetails(address sender, address receiver, uint256 amount) public {
        // Emit an event for off-chain listening/recording
        emit TransactionDetails(sender, receiver, amount, block.timestamp);
        // Save the transaction details in our array for on-chain retrieval
        transactionHistory.push(TransactionInfo(sender, receiver, amount, block.timestamp));
    }

    // Function to retrieve and display all transaction information
    function retrieveTransactionInformation() public view returns (TransactionInfo[] memory) {
        return transactionHistory;
    }

    // Function to retrieve the block timestamp of the latest transaction in a human-readable format
    function getLatestTransactionTimestamp() public view returns (string memory) {
        return _timestampToString(block.timestamp);
    }

    // Function to retrieve the address of the transaction sender
    function getTransactionSender() public view returns (address) {
        return msg.sender;
    }

    // Function to retrieve the address of the transaction receiver
    function getTransactionReceiver(address recipient) public pure returns (address) {
        return recipient;
    }

    // Helper function to convert timestamp to a human-readable string
    function _timestampToString(uint256 timestamp) private pure returns (string memory) {
        return string(abi.encodePacked(
            "Timestamp: ",
            uint2str(timestamp)
        ));
    }

    // Helper function to convert uint256 to string
    function uint2str(uint256 _i) private pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = uint8(48 + (_i % 10));
            bstr[k] = bytes1(temp);
            _i /= 10;
        }
        return string(bstr);
    }
}
