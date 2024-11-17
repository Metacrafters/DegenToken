// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, ERC20Burnable {
    
    error NotOwner();
    error ItemNotAvailable(uint256 itemId);
    error ItemAlreadyRedeemed(uint256 itemId);
    error InsufficientBalance(address player, uint256 required, uint256 available);
    error ItemDoesNotExist(uint256 itemId);
    error InvalidBurnAmount();
    error InvalidTransferAmount();
    error TransferFailed();

    address public owner;
    uint8 private _decimals = 1;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    struct StoreItem {
        string name;
        uint256 price;
        bool exists;
        bool isRedeemed;
    }

    mapping(uint256 => StoreItem) public storeItems;
    
    uint256 public itemCounter;

    event TokenRedemption(address indexed player, uint256 itemId, string itemName, uint256 tokenAmount);
    event StoreItemAdded(uint256 indexed itemId, string name, uint256 price);
    event ItemRemovedFromStore(uint256 indexed itemId, string name);
    event TokensBurned(address indexed burner, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }


    function burnTokens(uint256 amount) public {
        if (amount == 0) {
            revert InvalidBurnAmount();
        }
        if (amount > balanceOf(msg.sender)) {
            revert InsufficientBalance(msg.sender, amount, balanceOf(msg.sender));
        }
        
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }


    function transferTokens(address recipient, uint256 amount) public returns (bool) {
        if (recipient == address(0)) {
            revert InvalidTransferAmount();
        }
        if (amount == 0) {
            revert InvalidTransferAmount();
        }
        if (amount > balanceOf(msg.sender)) {
            revert InsufficientBalance(msg.sender, amount, balanceOf(msg.sender));
        }

        bool success = transfer(recipient, amount);
        if (!success) {
            revert TransferFailed();
        }

        emit TokensTransferred(msg.sender, recipient, amount);
        return true;
    }


    function addStoreItem(string memory name, uint256 price) public onlyOwner returns (uint256) {
        uint256 newItemId = itemCounter;
        storeItems[newItemId] = StoreItem({
            name: name,
            price: price,
            exists: true,
            isRedeemed: false
        });
        
        itemCounter++;
        
        emit StoreItemAdded(newItemId, name, price);
        return newItemId;
    }


    function redeemTokenForItem(uint256 itemId) public {
        StoreItem storage item = storeItems[itemId];
        
        if (!item.exists) {
            revert ItemNotAvailable(itemId);
        }
        
        if (item.isRedeemed) {
            revert ItemAlreadyRedeemed(itemId);
        }
        
        uint256 itemPrice = item.price;
        uint256 playerBalance = balanceOf(msg.sender);
        
        if (playerBalance < itemPrice) {
            revert InsufficientBalance(msg.sender, itemPrice, playerBalance);
        }
        
        item.isRedeemed = true;
        
        _burn(msg.sender, itemPrice);
        
        removeItemFromStore(itemId);
        
        emit TokenRedemption(msg.sender, itemId, item.name, itemPrice);
    }


    function removeItemFromStore(uint256 itemId) internal {
        if (!storeItems[itemId].exists) {
            revert ItemDoesNotExist(itemId);
        }
        
        string memory itemName = storeItems[itemId].name;
        
        storeItems[itemId].exists = false;
        
        emit ItemRemovedFromStore(itemId, itemName);
    }


    function getStoreItem(uint256 itemId) public view returns (
        string memory name, 
        uint256 price, 
        bool exists,
        bool isRedeemed
    ) {
        StoreItem memory item = storeItems[itemId];
        return (item.name, item.price, item.exists, item.isRedeemed);
    }


    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }


    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}