import React, { useContext, useEffect, useState } from "react";
import { AppContext } from "../App";
import Web3 from "web3";
const ChainPay = require("../artifacts/contracts/ChainPay.sol/ChainPay.json");

function Transaction() {
  // Getting account address from AppContext
  const { loginState } = useContext(AppContext);
  const [account, setAccount] = useState(loginState.account);
  const [balance, setBalance] = useState(loginState.balance);
  const [recipientAddress, setRecipientAddress] = useState("");
  const [amount, setAmount] = useState("");
  const [contract, setContract] = useState(null);

  // Function to create contract instance
  const getContractInstance = async () => {
    try {
      // Connecting to MetaMask
      const web3 = new Web3(window.ethereum);
      await window.ethereum.request({ method: "eth_requestAccounts" });
      const accounts = await web3.eth.getAccounts();
      const signerAccount = accounts[0];
      setAccount(signerAccount);

      const signerBalanceWei = await web3.eth.getBalance(signerAccount);
      const signerBalance = web3.utils.fromWei(signerBalanceWei, "ether");
      console.log(`${signerAccount}  ${signerBalance}`);
      setBalance(signerBalance.toString().slice(0, 6));

      const contractAddress = "0x94Ce64DBB7192558187597f45d7007B7AFA20B7a"; // Use the correct contract address here
      const contract = new web3.eth.Contract(ChainPay.abi, contractAddress);
      setContract(contract);
    } catch (error) {
      console.error("Error getting contract: ", error);
    }
  };

  // Calling function to get contract instance
  useEffect(() => {
    const fetchData = async () => {
      await getContractInstance();
    };
    fetchData();

    window.ethereum.on("accountsChanged", fetchData);
  }, []);

  // Transfer funds
  const transferFunds = async () => {
    if (!contract) {
      console.error("Contract instance is not available.");
      return;
    }
    try {
      if (!Web3.utils.isAddress(recipientAddress)) {
        console.error("Invalid recipient address");
        return;
      }
      console.log("Sending to:", recipientAddress, "Amount:", amount);

      // Call the smart contract method to transfer ETH
      await contract.methods.transferEth(recipientAddress).send({
        from: account,
        value: Web3.utils.toWei(amount, "ether"),
      });
      console.log("Transaction successful");
    } catch (error) {
      console.error("Error in transaction: ", error.message);
    }
  };

  return (
    <div className="transaction">
      <div className="tx-upper">
        <img src="./logo.png" alt="logo" />
        <p id="balance">
          <span>Balance:</span> {balance}
        </p>
      </div>
      <div className="tx-account">
        <p id="account">
          <span>Account:</span> {account}
        </p>
      </div>
      <div className="tx-main">
        <input
          onChange={(e) => setRecipientAddress(e.target.value)}
          id="address"
          type="text"
          placeholder="payment address"
        />
        <input
          onChange={(e) => setAmount(e.target.value)}
          id="amount"
          type="text"
          placeholder="amount"
        />
      </div>
      <button id="pay" onClick={transferFunds}>
        Pay
      </button>
    </div>
  );
}

export default Transaction;
