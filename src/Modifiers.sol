// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./libraries/LibStorage.sol";

contract Modifiers {
  modifier onlyOwner() {
    LibDiamond.enforceIsContractOwner();
    _;
  }
}
