// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "../libraries/LibEIP712.sol";

contract ERC20Init {
  /**
   * @dev Initializes the domain separator and parameter caches.
   *
   * The meaning of `name` and `version` is specified in
   * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
   *
   * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
   * - `version`: the current major version of the signing domain.
   *
   * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
   * contract upgrade].
   */
  function init(string memory name, string memory version) external {
    LibEIP712.EIP712Storage storage s = LibEIP712.eip712Storage();
    bytes32 hashedName = keccak256(bytes(name));
    bytes32 hashedVersion = keccak256(bytes(version));
    bytes32 typeHash = keccak256(
      "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );
    s.HASHED_NAME = hashedName;
    s.HASHED_VERSION = hashedVersion;
    s.CACHED_CHAIN_ID = block.chainid;
    s.CACHED_DOMAIN_SEPARATOR = LibEIP712._buildDomainSeparator(
      typeHash,
      hashedName,
      hashedVersion
    );
    s.TYPE_HASH = typeHash;
  }
}
