<img align="right" width="150" height="150" top="100" src="./assets/blueprint.png">

# Huff - EIP-1167 Minimal Proxy Contract

[EIP-1167: Minimal Proxy Contract](https://eips.ethereum.org/EIPS/eip-1167) implementation with [Huff](https://huff.sh/).

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

MinimalProxy.huff / MinimalProxyUsingLabel.huff:
```js
#define constant ADDRESS = 0x0102030405060708091011121314151617181920 // dummy address
```

MinimalProxy.t.sol:
```js
simpleStore = SimpleStore(HuffDeployer.deploy("SimpleStore"));
string memory simpleStoreAddress = Strings.toHexString(address(simpleStore));

// 45 bytes
minimalProxy = SimpleStore(
    new HuffConfig().with_constant("ADDRESS", simpleStoreAddress).deploy("MinimalProxy")
);

// 46 bytes
minimalProxyUsingLabel = SimpleStore(
    new HuffConfig().with_constant("ADDRESS", simpleStoreAddress).deploy("MinimalProxyUsingLabel")
);
```

## Test
```
forge test -vvvvv
```
