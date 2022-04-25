// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "../TestSetup.t.sol";
import "../../src/facets/ERC20Facet.sol";
import "../../src/facets/ERC20PermitFacet.sol";
import "../../src/facets/ERC721Facet.sol";

contract User {
  function transfer(
    address diamond,
    address account,
    uint256 amount
  ) external {
    ERC20Facet(diamond).transfer(account, amount);
  }
}
