import { useState, useEffect } from "react";
import { ethers } from "ethers";
import atm_abi from "../artifacts/contract/Assessment.sol/Assessment.json";

export default function HomePage() {
  // State variables for wallet, account, contract instance, and balance
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [atm, setATM] = useState(undefined);
  const [balance, setBalance] (useState(undefined));

  // Contract address and ABI for easy reference
  const contractAddress = "0x4e5553450b8dD82E222107108017d043717eeDf2";
  const atmABI = atm_abi.abi;

  // Function to check for and connect to MetaMask wallet
  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
      if (ethWallet) {
        try {
          const accounts = await ethWallet.request({ method: "eth_accounts" });
          handleAccount(accounts);
        } catch (error) {
          console.error("Error fetching accounts:", error);
        }
      }
    } else {
      console.log("Please install MetaMask wallet to use this app.");
    }
  };

  // Function to handle account connection/disconnection
  const handleAccount = (account) => {
    if (account) {
      console.log("Account connected:", account);
      setAccount(account);
      getATMContract(); // Get contract instance if connected
    } else {
      console.log("No account connected or user disconnected.");
      setAccount(undefined);
      setATM(undefined); // Clear contract instance if disconnected
      setBalance(undefined); // Clear balance if disconnected
    }
  };

  // Function to connect to the deployed ATM contract
  const getATMContract = () => {
    if (ethWallet) {
      const provider = new ethers.providers.Web3Provider(ethWallet);
      const signer = provider.getSigner();
      const atmContract = new ethers.Contract(contractAddress, atmABI, signer);
      setATM(atmContract);
    } else {
      console.error("Please connect your MetaMask wallet first.");
    }
  };

  // Function to fetch the user's balance from the ATM contract
  const getBalance = async () => {
    if (atm) {
      try {
        const weiBalance = await atm.getBalance();
        // Convert wei to a more user-friendly format (e.g., Ether)
        const formattedBalance = ethers.utils.formatEther(weiBalance);
        setBalance(formattedBalance);
      } catch (error) {
        console.error("Error fetching balance:", error);
      }
    }
  };

  // Function to deposit 1 ETH to the ATM
  const deposit = async () => {
    if (atm) {
      try {
        const tx = await atm.deposit(ethers.utils.parseEther("1"));
        await tx.wait();
        getBalance(); // Update balance after successful deposit
      } catch (error) {
        console.error("Error depositing:", error);
      }
    }
  };

  // Function to withdraw 1 ETH from the ATM
  const withdraw = async () => {
    if (atm) {
      try {
        const tx = await atm.withdraw(ethers.utils.parseEther("1"));
        await tx.wait();
        getBalance(); // Update balance after successful withdrawal
      } catch (error) {
        console.error("Error withdrawing:", error);
      }
    }
  };

  // Function to conditionally render UI based on connection status and balance
  const initUser = () => {
    if (!ethWallet) {
      return <p>Please install MetaMask to use this ATM.</p>;
    }

    if (!account) {
      return <button onClick={connectAccount}>Connect MetaMask Wallet</button>;
    }

    if (balance === undefined) {
      getBalance(); // Get balance on initial connection or when undefined
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <p>Your Balance: {balance}</p>
        <button onClick={deposit}>Deposit 1 ETH</button>
        <button onClick={withdraw}>Withdraw 1 ETH</button>
      </div>
    )
  }

  useEffect(() => {getWallet();}, []);

  return (
    <main className="container">
      <header><h1>Welcome to the Smart Contract!</h1></header>
      {initUser()}
      <style jsx>{`
        .container {
          text-align: center
        }
      `}
      </style>
    </main>
  )
}
