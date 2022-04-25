// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./TestSetup.t.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract ERC20Test is Test, TestSetup {
  function testMint(uint256 amount) public {
    vm.assume(amount < 1e50);
    ERC20Facet(address(diamond)).mint(address(diamond), amount);
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(diamond)),
      amount
    );
    console2.log(0);
  }

  function testBurn(uint256 amount) public {
    vm.assume(amount < 1e50);
    ERC20Facet(address(diamond)).mint(address(diamond), amount);
    ERC20Facet(address(diamond)).burn(address(diamond), amount);
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(diamond)),
      0
    );
  }

  function testTransfer(uint256 amount) public {
    vm.assume(amount < 1e50);
    ERC20Facet(address(diamond)).mint(address(this), amount);
    ERC20Facet(address(diamond)).transfer(address(user1), amount);
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(user1)),
      amount
    );
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(diamond)),
      0
    );
  }

  function testTransferFrom(uint256 amount) public {
    vm.assume(amount < 1e50);
    ERC20Facet(address(diamond)).mint(address(user1), amount);
    user1.approve(address(diamond), address(this), amount);
    ERC20Facet(address(diamond)).transferFrom(
      address(user1),
      address(user2),
      amount
    );
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(user2)),
      amount
    );
    assertEq(
      ERC20Facet(address(diamond)).balanceOf(address(user1)),
      0
    );
  }

  function testName() public {
    string memory name = ERC20Facet(address(diamond)).name();
    assertEq(name, "Hello");
  }

  function testSymbol() public {
    string memory symbol = ERC20Facet(address(diamond)).symbol();
    assertEq(symbol, "WORLD");
  }
}
