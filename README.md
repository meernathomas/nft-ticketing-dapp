# NFT Event Ticketing dApp

This project is a decentralized application (dApp) for creating and managing event tickets as NFTs (Non-Fungible Tokens) on the Ethereum Blockchain.

It consists of two main parts:
1.  **A Smart Contract (`EventTicket.sol`):** The backend logic that handles minting, ownership, and resale of the NFT tickets.
2.  **A dApp Frontend (`index.html`):** A minimal, single-page website that allows users to connect their wallets and interact with the smart contract.

**Contract deployed on Sepolia:** `0x3406768f09891d72Ceaec3954f59D1CefD79650E`
The live contract on Etherscan can be viewed through this link:
[https://sepolia.etherscan.io/address/0x3406768f09891d72Ceaec3954f59D1CefD79650E](https://sepolia.etherscan.io/address/0x3406768f09891d72Ceaec3954f59D1CefD79650E)

## How It Works

The dApp is powered by the `EventTicket.sol` smart contract, which has several key features:

1.  **NFT-Based:** Each ticket is a unique ERC-721 token, giving the holder true ownership.
2.  **Initial Sale:** Users can mint a new ticket (`mintTicket()`) by paying the exact `ticketPrice` set by the event organizer.
3.  **Resale Market:** A ticket holder can list their NFT for sale on a built-in secondary market (`listTicketForSale()`).
4.  **Anti-Scalping:** The contract enforces a `maxResalePrice` (set to 1.5x the original price), preventing scalpers from listing tickets at very high prices.
5.  **Secure & Modern:** The contract uses OpenZeppelin's battle-tested ERC-721 and Ownable contracts (v5) for maximum security and is written for Solidity 0.8+, which includes built-in overflow protection.

## The Smart Contract: `EventTicket.sol`

This is basically the "brain" of the dApp. The full code is available in `contracts/EventTicket.sol`.

### Key Functions

* `constructor(string memory _name, ...)`: Deploys the contract, setting the event name, ticket price, and max ticket supply.
* `mintTicket() public payable`: Allows a user to buy a new ticket from the initial sale.
    * **Requires:** `msg.value == ticketPrice`
    * **Requires:** `currentSupply < maxTickets`
* `listTicketForSale(uint256 _tokenId, uint256 _price) public`: Allows the owner of a ticket to list it for resale.
    * **Requires:** `msg.sender == ownerOf(_tokenId)`
    * **Requires:** `_price <= maxResalePrice` (The anti-scalping check)
* `buyResaleTicket(uint256 _tokenId) public payable`: Allows a new user to buy a ticket from the resale market.
    * **Requires:** `listing.isForSale == true`
    * **Requires:** `msg.value == listing.price`
    * **Action:** Automatically transfers the ETH to the seller and the NFT to the buyer.
* `withdraw() public onlyOwner`: A function for the event organizer (contract owner) to withdraw all ETH from the initial sales.

## How to Run This Project Locally

It can be deployed and tested this way.

### Prerequisites

* [Node.js](https://nodejs.org/) (LTS version, e.g., v20 or v22)
* [MetaMask](https://metamask.io/) wallet
* [Sepolia Testnet ETH](https://sepolia-faucet.com/)
* An [Alchemy](https://www.alchemy.com/) RPC URL
* [VS Code](https://code.visualstudio.com/) with the **Live Server** extension.

### 1. Clone & Install Dependencies

```bash
git clone [https://github.com/meernathomas/nft-ticketing-dapp.git](https://github.com/meernathomas/nft-ticketing-dapp.git)

cd nft-ticketing-dapp
npm install
````

Create a `.env` file in the root directory and add keys:

```
SEPOLIA_RPC_URL="ALCHEMY_OR_INFURA_SEPOLIA_URL"
SEPOLIA_PRIVATE_KEY="METAMASK_PRIVATE_KEY"
```

### 3\. Compile the Contract

```bash
npx hardhat compile
```

### 4\. Deploy to Sepolia

Edit the details (price, name, etc.) in `scripts/deploy-event.js` to one's liking, then run:

```bash
npx hardhat run scripts/deploy-event.js --network sepolia
```

**Success\!** The terminal will output the new contract address.

-----

## How to Interact with the dApp

There are two ways to interact with the deployed contract:

### Method 1: Using the dApp Frontend (which I used here)

This is the best way to test the full application.

1.  Open the `nft-ticketing` folder in VS Code.
2.  Make sure the **Live Server** extension is installed.
3.  Right-click on the `index.html` file.
4.  Select **"Open with Live Server"**.
5.  The browser will open to `http://127.0.0.1:5500/index.html`.
6.  Click **"Connect Wallet"** and approve the connection in MetaMask.
7.  The dApp will load the contract info (price, tickets sold, etc.).
8.  Click **"Mint Ticket"** and approve the transaction in MetaMask to buy NFT.

### Method 2: Using Etherscan (Directly)

 can also call the functions directly on the blockchain.

1.  **Go to the Contract on Etherscan:**
[https://sepolia.etherscan.io/address/0x3406768f09891d72Ceaec3954f59D1CefD79650E](https://sepolia.etherscan.io/address/0x3406768f09891d72Ceaec3954f59D1CefD79650E)

2.  **Click the "Contract" Tab:**
    Just below the main overview, find and click the **Contract** tab.

3.  **Click "Write Contract":**

      * Click the **"Write Contract"** button.
      * Click the **"Connect to Web3"** button and connect the MetaMask wallet (on the Sepolia network).
      * Find the **`mintTicket`** function.
      * In the **`payableAmount (ether)`** box, type **`0.01`**.
      * Click the **"Write"** button and approve the transaction.
