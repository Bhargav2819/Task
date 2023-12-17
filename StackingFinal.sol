// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FixedStaking is ERC20 {
    mapping (address => uint256) public supplied;
    mapping (address => uint256) private suppliedTime;
    mapping (address => uint256) public rewardsEarned; 
    

    constructor() ERC20("Fixed Staking", "Fix"){
        _mint(msg.sender, 1000);
    }

    function supply(uint256 amount) external {
        require(amount > 0, "Amount is <= 0");
        require(balanceOf(msg.sender) >= amount, "Balance is < amount");
        suppliedTime[msg.sender] = block.timestamp;
        supplied[msg.sender] += amount;
        _transfer(msg.sender, address(this), amount);
    }

    function claimAll(uint256 amount) external {
        require(amount > 0, "Amount is <= 0");
        require(supplied[msg.sender] >= amount, "Amount is > stacked");
        supplied[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    function claimReward() public {
        require(supplied[msg.sender] > 0, "Stacked is <= 0");
        uint256 secondsSupplied = block.timestamp - suppliedTime[msg.sender];
        uint256 rewards = (supplied[msg.sender] * secondsSupplied * 1) / 100;

        if (rewards > 0) {
            rewardsEarned[msg.sender] += rewards;
            _mint(msg.sender, rewards);
            suppliedTime[msg.sender] = block.timestamp;
        }
    }
}
