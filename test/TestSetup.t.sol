// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";

import "../src/diamond/Diamond.sol";

import "../src/diamond/facets/DiamondCutFacet.sol";
import "../src/diamond/facets/DiamondLoupeFacet.sol";
import "../src/diamond/facets/OwnershipFacet.sol";

import "../src/diamond/interfaces/IDiamondCut.sol";
import "../src/diamond/interfaces/IDiamondLoupe.sol";

import "../src/facets/ERC20Facet.sol";
import "../src/facets/ERC20PermitFacet.sol";
import "../src/facets/ERC721Facet.sol";

import "../src/init/EIP712Init.sol";
import "../src/init/ERC20Init.sol";

import "./helpers/User.sol";

contract TestSetup is DSTest {
  Diamond diamond;
  DiamondCutFacet diamondCutFacet;
  DiamondLoupeFacet diamondLoupeFacet;
  OwnershipFacet ownershipFacet;

  ERC20Facet erc20Facet;
  ERC20PermitFacet erc20PermitFacet;

  IDiamondCut.FacetCut[] diamondCuts;
  IDiamondCut.FacetCut[] erc20Cuts;
  IDiamondCut.FacetCut[] erc20PermitCuts;

  ERC20Init erc20Init;
  EIP712Init eip712Init;

  User user1;

  function setUp() public {
    deployAll();
    populateAndCut();
  }

  function deployAll() internal {
    deployDiamond();
    deployERC20();
    deployERC20Permit();
  }

  function populateAndCut() internal {
    populateDiamondCuts();
    populateERC20Cuts();
    populateERC20PermitCuts();
    IDiamondCut(address(diamond)).diamondCut(
      diamondCuts,
      address(0),
      ""
    );
    IDiamondCut(address(diamond)).diamondCut(
      erc20Cuts,
      address(erc20Init),
      abi.encodeWithSelector(
        erc20Init.init.selector,
        "Hello",
        "WORLD"
      )
    );
    IDiamondCut(address(diamond)).diamondCut(
      erc20PermitCuts,
      address(eip712Init),
      abi.encodeWithSelector(eip712Init.init.selector, "Hello", "1")
    );
  }

  function deployDiamond() internal {
    diamondCutFacet = new DiamondCutFacet();
    diamondLoupeFacet = new DiamondLoupeFacet();
    ownershipFacet = new OwnershipFacet();
    diamond = new Diamond(address(this), address(diamondCutFacet));
  }

  function deployERC20() internal {
    erc20Init = new ERC20Init();
    erc20Facet = new ERC20Facet();
  }

  function deployERC20Permit() internal {
    eip712Init = new EIP712Init();
    erc20PermitFacet = new ERC20PermitFacet();
  }

  function populateDiamondCuts() internal {
    bytes4[] memory loupeFunctionSelectors = new bytes4[](4);
    {
      uint256 index;
      loupeFunctionSelectors[index++] = diamondLoupeFacet
        .facets
        .selector;
      loupeFunctionSelectors[index++] = diamondLoupeFacet
        .facetFunctionSelectors
        .selector;
      loupeFunctionSelectors[index++] = diamondLoupeFacet
        .facetAddresses
        .selector;
      loupeFunctionSelectors[index++] = diamondLoupeFacet
        .facetAddress
        .selector;
    }
    diamondCuts.push(
      IDiamondCut.FacetCut(
        address(diamondLoupeFacet),
        IDiamondCut.FacetCutAction.Add,
        loupeFunctionSelectors
      )
    );
    bytes4[] memory ownershipFunctionSelectors = new bytes4[](2);
    {
      uint256 index;
      ownershipFunctionSelectors[index++] = ownershipFacet
        .owner
        .selector;
      ownershipFunctionSelectors[index++] = ownershipFacet
        .transferOwnership
        .selector;
    }
    diamondCuts.push(
      IDiamondCut.FacetCut(
        address(ownershipFacet),
        IDiamondCut.FacetCutAction.Add,
        ownershipFunctionSelectors
      )
    );
  }

  function populateERC20Cuts() internal {
    bytes4[] memory erc20FunctionSelectors = new bytes4[](13);
    {
      uint256 index;
      erc20FunctionSelectors[index++] = erc20Facet.name.selector;
      erc20FunctionSelectors[index++] = erc20Facet.symbol.selector;
      erc20FunctionSelectors[index++] = erc20Facet.decimals.selector;
      erc20FunctionSelectors[index++] = erc20Facet
        .totalSupply
        .selector;
      erc20FunctionSelectors[index++] = erc20Facet.balanceOf.selector;
      erc20FunctionSelectors[index++] = erc20Facet.transfer.selector;
      erc20FunctionSelectors[index++] = erc20Facet.allowance.selector;
      erc20FunctionSelectors[index++] = erc20Facet.approve.selector;
      erc20FunctionSelectors[index++] = erc20Facet
        .transferFrom
        .selector;
      erc20FunctionSelectors[index++] = erc20Facet
        .increaseAllowance
        .selector;
      erc20FunctionSelectors[index++] = erc20Facet
        .decreaseAllowance
        .selector;
      erc20FunctionSelectors[index++] = erc20Facet.mint.selector;
      erc20FunctionSelectors[index++] = erc20Facet.burn.selector;
    }
    erc20Cuts.push(
      IDiamondCut.FacetCut(
        address(erc20Facet),
        IDiamondCut.FacetCutAction.Add,
        erc20FunctionSelectors
      )
    );
  }

  function populateERC20PermitCuts() internal {
    bytes4[] memory erc20PermitFunctionSelectors = new bytes4[](2);
    {
      uint256 index;
      erc20PermitFunctionSelectors[index++] = erc20PermitFacet
        .nonces
        .selector;
      erc20PermitFunctionSelectors[index++] = erc20PermitFacet
        .permit
        .selector;
    }
    erc20PermitCuts.push(
      IDiamondCut.FacetCut(
        address(erc20PermitFacet),
        IDiamondCut.FacetCutAction.Add,
        erc20PermitFunctionSelectors
      )
    );
  }

  function populateUsers() internal {
    user1 = new User();
  }
}
