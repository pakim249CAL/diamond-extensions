// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "../libraries/LibERC20.sol";

contract ERC20Facet {
  /// PRIVATE STORAGE GETTER

  function s() private pure returns (LibERC20.ERC20Storage storage ds) {
    return LibERC20.erc20Storage();
  }

  /// LOGIC

  function mint(address account, uint256 amount) external {
    LibERC20._mint(account, amount);
  }

  function burn(address account, uint256 amount) external {
    LibERC20._burn(account, amount);
  }

  function name() external view returns (string memory) {
    return s().name;
  }

  function symbol() external view returns (string memory) {
    return s().symbol;
  }

  function decimals() external pure returns (uint8) {
    return 18;
  }

  function totalSupply() external view returns (uint256) {
    return s().totalSupply;
  }

  function balanceOf(address account) external view returns (uint256) {
    return s().balances[account];
  }

  function transfer(address recipient, uint256 amount) external returns (bool) {
    LibERC20._transfer(msg.sender, recipient, amount);
    return true;
  }

  function allowance(address owner, address spender)
    external
    view
    returns (uint256)
  {
    return s().allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) external returns (bool) {
    LibERC20._approve(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool) {
    return LibERC20._transferFrom(sender, recipient, amount);
  }

  function increaseAllowance(address spender, uint256 addedValue)
    external
    returns (bool)
  {
    LibERC20._approve(
      msg.sender,
      spender,
      s().allowances[msg.sender][spender] + addedValue
    );
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue)
    external
    returns (bool)
  {
    return LibERC20._decreaseAllowance(spender, subtractedValue);
  }
}
