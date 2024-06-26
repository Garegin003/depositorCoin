// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.25;

import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DepositorCoin.sol";

contract StabilCoin is ERC20 {
    DepositorCoin public depositorCoin;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_, 2) {}

    function mint() external payable {
        uint256 price;
        _mint(msg.sender, price);
    }
}
