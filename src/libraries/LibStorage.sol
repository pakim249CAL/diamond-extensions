pragma solidity 0.8.13;

import "../diamond/libraries/LibDiamond.sol";
import "./dep/Counters.sol";

library LibStorage {
  struct ERC20Storage {
    string name;
    string symbol;
    uint256 totalSupply;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;
  }

  struct EIP712Storage {
    bytes32 CACHED_DOMAIN_SEPARATOR;
    uint256 CACHED_CHAIN_ID;
    bytes32 HASHED_NAME;
    bytes32 HASHED_VERSION;
    bytes32 TYPE_HASH;
  }

  struct ERC20PermitStorage {
    mapping(address => Counters.Counter) nonces;
  }

  function eip712Storage() internal pure returns (EIP712Storage storage ds) {
    bytes32 position = keccak256("diamond.eip712.storage");
    assembly {
      ds.slot := position
    }
  }

  function erc20Storage() internal pure returns (ERC20Storage storage ds) {
    bytes32 position = keccak256("diamond.erc20.storage");
    assembly {
      ds.slot := position
    }
  }

  function erc20PermitStorage()
    internal
    pure
    returns (ERC20PermitStorage storage ds)
  {
    bytes32 position = keccak256("diamond.erc20.permit.storage");
    assembly {
      ds.slot := position
    }
  }
}
