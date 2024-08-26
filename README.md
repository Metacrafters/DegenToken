# DegenToken

This program contains a smart contract which creates a token on a local HardHat network, and then used Remix IDE to interact with it.

## Description

This program contains a simple contract named as DegenToken, which contains a mint function to send ethers to the provided address,  burn function to deduct that amount from the wallet and transfer function to send amount to the provided address.


## Getting Started

### Executing program

To run this program, I have used online Remix Solidity IDE. You can visit the Remix website at https://remix.ethereum.org/ .
Extension used for creating a new file is .sol , example: assessment3.sol

**Compiled contract on local HardHat network on VS Code using code:**

```Hardhat

npx hardhat compile

```

 It is used to compile a Solidity smart contract project using the Hardhat framework. 

 ```Hardhat

npx hardhat node

```
```Hardhat

npx hardhat run scripts/deploy.js --network fuji 

```
```Hardhat

remixid 

```

It is used to start a local fuji network using Hardhat. It spins up a local blockchain environment with a set of accounts and a simulated avax network. 

SMART CONTRACT CODE:

```solidity

// SPDX-License-Identifier: MIT

```

This line specifies the Software Package Data Exchange (SPDX) license identifier for the contract.In this case, it is the MIT license.

```solidity
pragma solidity ^0.8.18;
```
This line specifies that the Solidity compiler version should be 0.8.18 or higher.


```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

```

These lines import the ERC20 token standard and Ownable contract from the OpenZeppelin library. ERC20 provides standard functions and features for ERC20 tokens, and Ownable provides access control, allowing only the contract owner to call certain functions.

```solidity

contract DegenToken is ERC20, Ownable {
  
  
```
This line declares the DegenToken contract, inheriting from ERC20 and Ownable.


```solidity

struct Item {
    string name;
    uint256 redeemAmount;
}

  
```

This struct defines an item with a name and the amount of tokens required to redeem it.
```solidity

 mapping(uint256 => Item) public items;
mapping(address => mapping(uint256 => uint256)) public redeemedItems;

```
items maps an item ID (a uint256) to an Item.
redeemedItems tracks the number of each item redeemed by each user. The outer mapping maps user addresses to another mapping, which maps item IDs to the number of items redeemed by that user.

```solidity
constructor() ERC20("Degen", "DGN") {
    items[1] = Item("Sword NFT", 1000);
    items[2] = Item("Costume NFT", 500);
    items[3] = Item("Shoes NFT", 500);
    items[4] = Item("Shield NFT", 500);
}

  
```
he constructor sets the token name to "Degen" and the symbol to "DGN". It also initializes four items with their respective names and redeem amounts.

```solidity

function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```
This function mints new tokens and assigns them to the specified address. Only the contract owner can call this function.
```solidity

function burn(uint256 amount) public {
    require(balanceOf(msg.sender) >= amount, "Insufficient balance");
    _burn(msg.sender, amount);
}

```
This function allows users to burn their tokens, reducing the total supply. It checks if the caller has enough tokens before burning.


```solidity

function TransferToken(address _receiver, uint amount) external {
    require(balanceOf(msg.sender) >= amount, "Sorry, Not enough Degen tokens available");
    approve(msg.sender, amount);
    transferFrom(msg.sender, _receiver, amount);
}

  
```
This function allows users to transfer tokens to another address. It checks if the caller has enough tokens, approves the transfer, and then transfers the tokens from the caller to the receiver.

```solidity

function redeem(uint256 item) external payable {
    Item storage selectedItem = items[item];
    require(bytes(selectedItem.name).length > 0, "Invalid redeem item");
    require(balanceOf(msg.sender) >= selectedItem.redeemAmount, "Insufficient balance to redeem");

    _burn(msg.sender, selectedItem.redeemAmount);
    redeemedItems[msg.sender][item] += 1;
}

```
This function allows users to redeem an item using their tokens. It checks if the item is valid and if the user has enough tokens. If the checks pass, it burns the required amount of tokens from the user's balance and increments the count of redeemed items for that user.

```solidity
function showStore() external pure returns (string memory) {
    return "1. Sword NFT(1000 tokens) 2. Costume NFT(500 tokens) 3. Shoes NFT(500 tokens) 4. Shield NFT(500 tokens)";
}  
```
This function returns a string listing all the items available in the store and their respective token costs.

```solidity

function getRedeemedItems(address user, uint256 item) external view returns (uint256) {
    return redeemedItems[user][item];
}
```
This function returns the number of a specific item that a user has redeemed.

The DegenToken contract is an ERC20 token with additional features that allow the contract owner to mint tokens, users to burn tokens, transfer tokens to others, and redeem tokens for items. The contract tracks redeemed items and provides a function to display the available items and their costs.


## Authors

Yashasvi
[yashasvisharma846@gmail.com]
[22BCS11802@cuchd.in]

## Video 
https://www.loom.com/share/cb345790d1cb4e7aa5f0fa8241ad1413

