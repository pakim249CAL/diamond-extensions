// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./LibStorage.sol";

library LibERC20 {
  bytes32 private constant _PERMIT_TYPEHASH =
    keccak256(
      "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );

  function s() private pure returns (LibStorage.ERC20Storage storage ds) {
    return LibStorage.erc20Storage();
  }

  /// EVENTS

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

  /// LOGIC

  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    uint256 senderBalance = s().balances[sender];
    require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
    unchecked {
      s().balances[sender] = senderBalance - amount;
    }
    s().balances[recipient] += amount;

    emit Transfer(sender, recipient, amount);
  }

  function _transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) internal returns (bool) {
    _transfer(sender, recipient, amount);

    uint256 currentAllowance = s().allowances[sender][msg.sender];
    require(
      currentAllowance >= amount,
      "ERC20: transfer amount exceeds allowance"
    );
    unchecked {
      _approve(sender, msg.sender, currentAllowance - amount);
    }

    return true;
  }

  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "ERC20: mint to the zero address");

    s().totalSupply += amount;
    s().balances[account] += amount;
    emit Transfer(address(0), account, amount);
  }

  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "ERC20: burn from the zero address");

    uint256 accountBalance = s().balances[account];
    require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
      s().balances[account] = accountBalance - amount;
    }
    s().totalSupply -= amount;

    emit Transfer(account, address(0), amount);
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    s().allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _decreaseAllowance(address spender, uint256 subtractedValue)
    internal
    returns (bool)
  {
    uint256 currentAllowance = s().allowances[msg.sender][spender];
    require(
      currentAllowance >= subtractedValue,
      "ERC20: decreased allowance below zero"
    );
    unchecked {
      _approve(msg.sender, spender, currentAllowance - subtractedValue);
    }

    return true;
  }
}
