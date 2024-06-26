// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.25;

import {ERC20} from "./ERC20.sol";

contract DepositorCoin is ERC20 {
    struct Deposit {
        uint256 amount;
        uint256 timestamp;
    }

    event DepositMade(address indexed user, uint256 amount, uint256 timestamp);
    mapping(address => Deposit) deposits;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_, decimals_) {
        owner = msg.sender;
    }

    function mintStabilcoin(uint256 _amount) external payable{
        mint(msg.sender, _amount);
    }

    function deposite(uint256 _amount) external payable{
        require(balanceOf(msg.sender) >= _amount);
        deposits[msg.sender] = Deposit({amount: _amount, timestamp: block.timestamp});
        _transfer(msg.sender, owner, _amount);
        emit DepositMade(msg.sender, msg.value, block.timestamp);
    }

  

  function stop(uint256 _amount) external {
        Deposit memory userDeposit = deposits[msg.sender];
        require(userDeposit.amount > 0, "No deposit found");
        require(_amount <= userDeposit.amount, "Not enough balance");

        uint256 p = 10; // Interest rate percentage
        uint256 duration = (block.timestamp - userDeposit.timestamp) / (3600 * 24 * 365); // Duration in years

        uint256 interest = (_amount * p * duration) / 100;
        uint256 totalAmount = _amount + interest;

        require(balanceOf(owner) >= totalAmount, "Owner has insufficient funds");
        
        _transfer(owner, msg.sender, totalAmount);

        // Reset user's deposit
        deposits[msg.sender] = Deposit({amount: 0, timestamp: 0});
}
}