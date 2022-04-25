// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./dep/ECDSA.sol";
import "./dep/Counters.sol";
import "./LibERC20.sol";
import "./LibEIP712.sol";

library LibERC20Permit {
  using Counters for Counters.Counter;

  // Renamed to avoid shadowing with permit
  function _s()
    private
    pure
    returns (LibStorage.ERC20PermitStorage storage ds)
  {
    return LibStorage.erc20PermitStorage();
  }

  /// PERMIT FUNCTIONALITY
  bytes32 private constant _PERMIT_TYPEHASH =
    keccak256(
      "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );

  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) internal {
    require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

    bytes32 structHash = keccak256(
      abi.encode(
        _PERMIT_TYPEHASH,
        owner,
        spender,
        value,
        _useNonce(owner),
        deadline
      )
    );

    bytes32 hash = LibEIP712._hashTypedDataV4(structHash);

    address signer = ECDSA.recover(hash, v, r, s);
    require(signer == owner, "ERC20Permit: invalid signature");

    LibERC20._approve(owner, spender, value);
  }

  function nonces(address owner) internal view returns (uint256) {
    return _s().nonces[owner].current();
  }

  function DOMAIN_SEPARATOR() internal view returns (bytes32) {
    return LibEIP712._domainSeparatorV4();
  }

  function _useNonce(address owner) internal returns (uint256 current) {
    Counters.Counter storage nonce = _s().nonces[owner];
    current = nonce.current();
    nonce.increment();
  }
}
