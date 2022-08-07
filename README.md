<img align="right" width="150" height="150" top="100" src="./assets/blueprint.png">

# Huff - EIP-1167 Minimal Proxy Contract

[EIP-1167: Minimal Proxy Contract](https://eips.ethereum.org/EIPS/eip-1167) implementation with [Huff](https://huff.sh/).
This repo supports dynamic address embedding and gas-efficient bytecode generation for a vanity address (like `0x00000...`).

## Source

```js
├── src
│   ├── MinimalProxy.huff           // using PUSH1 without the jump label
│   ├── MinimalProxyUsingLabel.huff // using the jump label and PUSH2.
│   └── SimpleStore.huff
└── test
    ├── MinimalProxy.t.sol
    └── SimpleStore.t.sol
```

## Dynamic Address Embedding
Embed the address of the delegate destination as follows:

MinimalProxy.huff
```js
#define constant ADDRESS = 0x0102030405060708091011121314151617181920 // dummy address
#define constant JUMPI_DST = 0x2b
```

MinimalProxyUsingLabel.huff:
```js
#define constant ADDRESS = 0x0102030405060708091011121314151617181920 // dummy address
```

MinimalProxy.t.sol:
```js
SimpleStore public simpleStore;
SimpleStore public minimalProxy;
SimpleStore public minimalProxyUsingLabel;
SimpleStore public minimalProxyWithVanityAddress;
uint256 public defaultJumpiDst = 0x2b;
address public vanityAddress = 0x0000000000060708091011121314151617181920;

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

    // 40 bytes
    vm.etch(vanityAddress, address(simpleStore).code);
    string memory vanityAddressString = Strings.toHexString(uint160(vanityAddress));
    uint256 numberOfLeadingZeroBytes = ((2 + 20 * 2) - bytes(vanityAddressString).length) / 2;
    string memory jumpiDst = Strings.toHexString(defaultJumpiDst - numberOfLeadingZeroBytes, 1);
    minimalProxyWithVanityAddress = SimpleStore(
        new HuffConfig().with_constant("ADDRESS", vanityAddressString).with_constant("JUMPI_DST", jumpiDst).deploy("MinimalProxy")
    );
}
```

## Test
```
forge test -vvvvv
```
