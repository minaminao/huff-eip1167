// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract SimpleStoreTest is Test {
    SimpleStore public minimalProxy;
    SimpleStore public minimalProxyUsingLabel;
    SimpleStore public simpleStore;

    function setUp() public {
        simpleStore = SimpleStore(HuffDeployer.deploy("SimpleStore"));
        string memory simpleStoreAddress = Strings.toHexString(address(simpleStore));

        // 46 bytes
        minimalProxy = SimpleStore(
            new HuffConfig().with_constant("ADDRESS", simpleStoreAddress).deploy("MinimalProxy")
        );

        // 47 bytes
        minimalProxyUsingLabel = SimpleStore(
            new HuffConfig().with_constant("ADDRESS", simpleStoreAddress).deploy("MinimalProxyUsingLabel")
        );
    }

    function testMinimalProxy(uint256 value) public {
        minimalProxy.setValue(value);
        console.log(value);
        console.log(minimalProxy.getValue());
        assertEq(value, minimalProxy.getValue());
    }

    function testMinimalProxyUsingLabel(uint256 value) public {
        minimalProxyUsingLabel.setValue(value);
        console.log(value);
        console.log(minimalProxyUsingLabel.getValue());
        assertEq(value, minimalProxyUsingLabel.getValue());
    }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
}
