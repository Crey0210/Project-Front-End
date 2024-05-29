// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// This line is commented out as we're not using hardhat console in this example
// import "hardhat/console.sol";

contract Assessment {
  // Stores the address of the contract owner (payable for potential future use)
  address payable public owner;
  // Stores the current balance of the contract
  uint256 public balance;

  // Event emitted when a deposit is made
  event Deposit(uint256 amount);
  // Event emitted when a withdrawal is made
  event Withdraw(uint256 amount);

  // Constructor function, called when the contract is deployed
  // Sets the owner and initial balance
  constructor(uint initBalance) payable {
    owner = payable(msg.sender);
    balance = initBalance;
  }

  // Function to retrieve the current balance of the contract (view function - doesn't modify state)
  function getBalance() public view returns(uint256){
    return balance;
  }

  // Function to deposit funds into the contract
  function deposit(uint256 _amount) public payable {
    // Store the balance before the deposit
    uint _previousBalance = balance;

    // Check if the sender is the owner (only the owner can deposit)
    require(msg.sender == owner, "You are not the owner of this account");

    // Add the deposited amount to the balance
    balance += _amount;

    // Assert to verify the balance is updated correctly (for debugging purposes)
    assert(balance == _previousBalance + _amount);

    // Emit a Deposit event with the deposited amount
    emit Deposit(_amount);
  }

  // Custom error to indicate insufficient balance for withdrawal
  error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

  // Function to withdraw funds from the contract
  function withdraw(uint256 _withdrawAmount) public {
    // Check if the sender is the owner (only the owner can withdraw)
    require(msg.sender == owner, "You are not the owner of this account");

    // Store the balance before the withdrawal
    uint _previousBalance = balance;

    // Check if there are enough funds for the withdrawal
    if (balance < _withdrawAmount) {
      // Revert the transaction with a custom error message and details
      revert InsufficientBalance({
        balance: balance,
        withdrawAmount: _withdrawAmount
      });
    }

    // Subtract the withdrawn amount from the balance
    balance -= _withdrawAmount;

    // Assert to verify the balance is updated correctly (for debugging purposes)
    assert(balance == (_previousBalance - _withdrawAmount));

    // Emit a Withdraw event with the withdrawn amount
    emit Withdraw(_withdrawAmount);
  }
}
