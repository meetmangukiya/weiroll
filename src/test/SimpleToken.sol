// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { ERC20 } from "solady/tokens/ERC20.sol";

contract ExecutorToken is ERC20 {
    constructor(uint256 initialSupply) ERC20() {
        _mint(msg.sender, initialSupply);
    }

    function symbol() public pure override returns (string memory) {
        return "EXE";
    }

    function name() public pure override returns (string memory) {
        return "Exec";
    }
}
