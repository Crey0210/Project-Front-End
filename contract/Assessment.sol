// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Wallet {
    address payable public owner;
    uint256 public balance;
    bool internal locked;

    event FundsDeposited(uint256 amount);
    event FundsWithdrawn(uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Access denied: Only the owner can perform this action");
        _;
    }

    // Modifier to prevent reentrancy attacks
    modifier noReentrancy() {
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function depositFunds(uint256 _amount) public payable onlyOwner {
        uint _previousBalance = balance;

        // Update the balance
        balance += _amount;

        // Emit the deposit event
        emit FundsDeposited(_amount);

        // Confirm that the transaction was successful
        assert(balance == _previousBalance + _amount);
    }

    // Function to withdraw funds from the contract
    function withdraw(uint256 _withdrawFund) public onlyOwner noReentrancy {
        // Check if there are enough funds to withdraw the requested amount
        require(_withdrawFund <= balance, "Insufficient funds");

        // Update balance by subtracting the withdrawal amount
        balance -= _withdrawFund;

        // Emit a Withdraw event with the withdrawn amount
        emit FundsWithdrawn(_withdrawFund);
    }

    function transferOwnership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Fallback function to allow the contract to receive Ether directly
    receive() external payable {
        balance += msg.value;
        emit FundsDeposited(msg.value);
    }
}
