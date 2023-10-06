// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    constructor() ERC20("Degen", "DGN") {}

    // Mint new tokens. Only the owner can call this function.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transfer tokens to another address.
    function transferTokens(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    // Redeem tokens for in-game items or rewards.
    function redeemTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        // Add logic here to provide in-game items or rewards.
    }

    // Check the token balance of an address.
    function checkTokenBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Burn tokens owned by the caller.
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }
}
