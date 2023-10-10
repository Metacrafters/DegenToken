// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DegenToken{
    address public  owner;
    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint amount);

    struct Item {
        uint itemId;
        string itemName;
        uint itemPrice;
    }
    
    mapping(uint => Item) public items;
    uint public itemCount;

    constructor() {
        owner = msg.sender;
        totalSupply = 0;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the Owner so you cant't Mint the Tokens");
        _;
    }

    string public constant name = "Degen Token";
    string public constant symbol = "DGN";

    function transfer(address _address, uint _value) external returns (bool) {
        require(balanceOf[msg.sender] >= _value, "You don't have enough Tokens to Transfer");

        balanceOf[msg.sender] -= _value;
        balanceOf[_address] += _value;

        emit Transfer(msg.sender, _address, _value);
        return true;
    }

    function mint(address _address,uint _value) external onlyOwner {
        balanceOf[_address] += _value;
        totalSupply += _value;
        emit Transfer(address(0), _address, _value);
    }

    function burn(uint _value) external {
        require(_value > 0, "You have Zero Tokens on the platform");
        require(balanceOf[msg.sender] >= _value, "You have less number of token then what you want to burn");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Transfer(msg.sender, address(0), _value);
    }
    
    function addItem(string memory _itemName, uint256 _itemPrice) external onlyOwner {
        itemCount++;
        Item memory newItem = Item(itemCount, _itemName, _itemPrice);
        items[itemCount] = newItem;
    }

    function getItems() external view returns (Item[] memory) {
        Item[] memory allItems = new Item[](itemCount);
        
        for (uint i = 1; i <= itemCount; i++) {
            allItems[i - 1] = items[i];
        }
        
        return allItems;
    }
    
    function redeem(uint _itemId) external {
        require(_itemId > 0 && _itemId <= itemCount, "Enterd Wrong number of Item!!");
        Item memory redeemedItem = items[_itemId];
        
        require(balanceOf[msg.sender] >= redeemedItem.itemPrice, "You can't Redeem this Item as you have less no of Tokens then the Required!!");
        
        balanceOf[msg.sender] -= redeemedItem.itemPrice;
        balanceOf[owner] += redeemedItem.itemPrice;
        emit Transfer(msg.sender, address(0), redeemedItem.itemPrice);
        
    }
}
