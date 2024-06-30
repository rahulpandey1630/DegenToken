// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenGamingToken is Ownable, ERC20Burnable {
    mapping(uint256 => uint256) public opitionToPrice; // 1: 50 DGTs , 2: 200 DGTs ....
    mapping(address => uint256[]) public addressToRewards; // 0xasdfc : [1,2,2] ...

    constructor() ERC20("DegenGamingToken", "DGT") Ownable(msg.sender) {
        opitionToPrice[1] = 50;
        opitionToPrice[2] = 200;
        opitionToPrice[3] = 5000;
    }

    function showRewards() public pure returns (string memory) {
        string memory rewardList = "1: Basic Power Boost - 50 DGTs \n2: Advance Armor Set - 200 DGTs\n3: Legendary Weapon - 5000 DGTs";
        console.log(rewardList);
        return rewardList;
    }

    function mintToken(address _to, uint256 _value) external onlyOwner {
        _mint(_to, _value);
    }

    function transferToken(address _to, uint256 _value) public {
        require(balanceOf(msg.sender) >= _value, "You don't have enough DGTs");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _to, _value);
    }

    function redeemAwards(uint256 _optionNumber) public {
        require(
            opitionToPrice[_optionNumber] != 0,
            "Please select a valid option"
        );
        require(
            balanceOf(msg.sender) >= opitionToPrice[_optionNumber],
            "You don't have engouh DGTs"
        );
        burn(opitionToPrice[_optionNumber]);
        addressToRewards[msg.sender].push(_optionNumber);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burnToken(uint256 _value) public {
        burn(_value);
    }

    function showRedeemedRewards(address _player) public view returns(uint[] memory){
        return addressToRewards[_player];
    }
}