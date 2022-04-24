// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./TestSetup.t.sol";
import "forge-std/Test.sol";

contract ERC20Test is Test, TestSetup {
  function testMint(uint256 amount) public {
    vm.assume(amount < 1 ether);
    ERC20Facet(address(diamond)).mint(address(diamond), amount);
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(diamond)),
      amount
    );
  }
}
