// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "../libraries/LibERC20.sol";

contract ERC20Init {
  function init(string calldata name, string calldata symbol) external {
    LibStorage.ERC20Storage storage s = LibStorage.erc20Storage();
    s.name = name;
    s.symbol = symbol;
  }
}
