// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract SimpleStoreTest is Test {
    SimpleStore public simpleStore;
    SimpleStore public minimalProxy;
    SimpleStore public minimalProxyUsingLabel;
    SimpleStore public minimalProxyWithVanityAddress;
    address public vanityAddress = 0x0000000000060708091011121314151617181920;
    string public vanityAddressString = "0x060708091011121314151617181920";

    function setUp() public {
        simpleStore = SimpleStore(HuffDeployer.deploy("SimpleStore"));

        // 45 bytes
        minimalProxy = SimpleStore(
            new HuffConfig().with_addr_constant("ADDRESS", address(simpleStore)).deploy("MinimalProxy")
        );

        // 46 bytes
        minimalProxyUsingLabel = SimpleStore(
            new HuffConfig().with_addr_constant("ADDRESS", address(simpleStore)).deploy("MinimalProxyUsingLabel")
        );

        // 40 bytes (vanity address: 0x060708091011121314151617181920)
        vm.etch(vanityAddress, address(simpleStore).code);
        minimalProxyWithVanityAddress = SimpleStore(
            new HuffConfig().with_constant("ADDRESS", vanityAddressString).with_constant("JUMPI_DST", "0x26").deploy("MinimalProxy")
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

    function testMinimalProxyWithVanityAddress(uint256 value) public {
        minimalProxyWithVanityAddress.setValue(value);
        console.log(value);
        console.log(minimalProxyWithVanityAddress.getValue());
        assertEq(value, minimalProxyWithVanityAddress.getValue());
    }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
}
