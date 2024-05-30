// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Assessment {

  // Address of the contract owner (who can deposit and withdraw funds)
  address payable public owner;

  // Current balance of the contract
  uint256 public balance;

  // Event emitted when a deposit occurs
  event Deposit(uint256 fund);

  // Event emitted when a withdrawal occurs
  event Withdraw(uint256 fund);

  // Constructor function - Sets the initial owner and balance upon deployment
  constructor(uint initBalance) payable {
    owner = payable(msg.sender);
    balance = initBalance;
  }

  // Function to retrieve the current contract balance (view function - doesn't modify state)
  function getBalance() public view returns (uint256) {
    return balance;
  }

  // Function to deposit funds into the contract
  function deposit(uint fund) public payable {
    // Ensure the message sender is the owner
    require(msg.sender == owner, "Not owner");

    // Update balance with the amount sent in the transaction (using msg.value)
    balance += fund;

    // Emit a Deposit event with the deposited fund
    emit Deposit(msg.value);
  }

  // Function to withdraw funds from the contract
  function withdraw(uint256 _withdrawFund) public {
    // Ensure the message sender is the owner
    require(msg.sender == owner, "Not owner");

    // Check if there are enough funds to withdraw the requested amount
    require(_withdrawFund <= balance, "Insufficient funds");

    // Update balance by subtracting the withdrawal amount
    balance -= _withdrawFund;

    // Emit a Withdraw event with the withdrawn amount
    emit Withdraw(_withdrawFund);
  }
}
