// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// This line is commented out as we're not using console functionalities in this contract
// import "hardhat/console.sol";

contract Assessment {
  // Stores the address of the contract owner (payable for potential future uses)
  address payable public owner;
  // Stores the current balance of the contract
  uint256 public balance;

  // Event emitted when a deposit occurs
  event Deposit(uint256 fund);
  // Event emitted when a withdrawal occurs
  event Withdraw(uint256 fund);

  // Constructor function that initializes the contract with an initial balance
  // and sets the owner as the message sender
  constructor(uint initBalance) payable {
    owner = payable(msg.sender);
    balance = initBalance;
  }

  // Function to retrieve the current balance of the contract (view function - doesn't modify state)
  function getBalance() public view returns (uint256) {
    return balance;
  }

  // Function to deposit funds into the contract
  function deposit(uint256 _fund) public payable {
    // Store the previous balance for checking
    uint _previousBalance = balance;

    // Ensure only the owner can deposit
    require(msg.sender == owner, "You are not the owner of this account");

    // Add the deposited amount to the balance
    balance += _fund;

    // Assert to verify the balance is updated correctly (for debugging purposes)
    assert(balance == _previousBalance + _fund);

    // Emit a Deposit event with the deposited amount
    emit Deposit(_fund);
  }

  // Custom error to handle insufficient balance during withdrawal
  error InsufficientBalance(uint256 balance, uint256 withdrawFund);

  // Function to withdraw funds from the contract
  function withdraw(uint256 _withdrawFund) public {
    // Ensure only the owner can withdraw
    require(msg.sender == owner, "You are not the owner of this account");

    // Store the previous balance for checking
    uint _previousBalance = balance;

    // Check if there's enough balance for withdrawal
    if (balance < _withdrawFund) {
      // Revert the transaction with a custom error message
      revert InsufficientBalance({ balance: balance, withdrawFund: _withdrawFund });
    }

    // Withdraw the requested amount
    balance -= _withdrawFund;

    // Assert to verify the balance is updated correctly (for debugging purposes)
    assert(balance == (_previousBalance - _withdrawFund));

    // Emit a Withdraw event with the withdrawn amount
    emit Withdraw(_withdrawFund);
  }
}
