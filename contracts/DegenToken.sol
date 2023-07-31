// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    constructor() ERC20("Degen", "DGN") {}

        function mint(address to, uint256 amount) public onlyOwner {
            _mint(to, amount); }

        function transferTokens(address _reciever, uint256 value) external{
            require(balanceOf(msg.sender) >= value, "dont hve enough token ");
            approve(msg.sender, value);
            _transfer(msg.sender, _reciever, value);
        }
        function checkBalance() external view returns(uint){
           return balanceOf(msg.sender);
        }
        function burnTokens(uint256 value) external{
            require(balanceOf(msg.sender)>= value, " do not have enough Tokens");
            _burn(msg.sender, value);
        }
        function GameStore() public pure returns (string memory) {
        return
            "1. Kungfuu = 100 \n 2.Ninja Game = 80 \n 3.Itachi Game = 30 ;
    }
        function reedemTokens(uint choice) external payable{
            require(choice<=3,"Invalid selection");
            if(choice ==1){
                require(balanceOf(msg.sender)>=100, "Insufficient Balance");
                approve(msg.sender, 100);
                _transfer(msg.sender, owner(), 100);
            }
            else if(choice ==2){
                require(balanceOf(msg.sender)>=80, "Insufficient Balance");
                approve(msg.sender, 80);
                _transfer(msg.sender, owner(), 80);
            }
            else{
                require(balanceOf(msg.sender)>=30, "Insufficient Balance");
                approve(msg.sender, 30);
                _transfer(msg.sender, owner(), 30);
            }


        }
}
