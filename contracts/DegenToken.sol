// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DegenToken is ERC20, Ownable {

    struct Item {
        string name;
        uint256 redeemAmount;
    }

    mapping(uint256 => Item) public items;
    mapping(address => mapping(uint256 => uint256)) public redeemedItems; // New mapping to track redeemed items per user

    constructor() ERC20("Degen", "DGN") {
        items[1] = Item("Sword NFT", 1000);
        items[2] = Item("Costume NFT", 500);
        items[3] = Item("Shoes NFT", 500);
        items[4] = Item("Shield NFT", 500);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "There is not sufficient balance");
        _burn(msg.sender, amount);
    }
    
    function TransferToken(address _receiver, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Sorry,There is not enough Degen tokens available");
        approve(msg.sender, amount);
        transferFrom(msg.sender, _receiver, amount);
    }
        
    function redeem(uint256 item) external payable {
        Item storage selectedItem = items[item];
        require(bytes(selectedItem.name).length > 0, "Invalid redeem item");
        require(balanceOf(msg.sender) >= selectedItem.redeemAmount, "Insufficient balance to redeem");

        _burn(msg.sender, selectedItem.redeemAmount);
        redeemedItems[msg.sender][item] += 1; // Track the redeemed item
    }

    function showStore() external pure returns (string memory) {
        return "1. Sword NFT(1000 tokens) 2. Costume NFT(500 tokens) 3. Shoes NFT(500 tokens) 4. Shield NFT(500 tokens)";
    }

    function getRedeemedItems(address user, uint256 item) external view returns (uint256) {
        return redeemedItems[user][item]; // Function to get the count of redeemed items for a user
    }
}
