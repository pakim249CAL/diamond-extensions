// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../libraries/LibERC20Permit.sol";

contract ERC20PermitFacet {
  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external {
    LibERC20Permit.permit(owner, spender, value, deadline, v, r, s);
  }

  function nonces(address owner) external view returns (uint256) {
    return LibERC20Permit.nonces(owner);
  }

  function DOMAIN_SEPARATOR() external view returns (bytes32) {
    return LibERC20Permit.DOMAIN_SEPARATOR();
  }
}
