## Try to Hack Vault

Read the smart contract `Vault.sol`, try to steal all eth from the vault.

You can write a hacker contract and add some code to pass the `forge test` .

### Tips

you need understand following knowledge points:

1. reentrance
2. ABI encoding
3. delegatecall

### Anvil

```shell
$ anvil
```

### Deploy

```shell
forge script script/Vault.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

## test

```
forge test -vvv
```

## Logs

```
Ran 1 test for test/Vault.t.sol:VaultExploiter
[PASS] testExploit() (gas: 160149)
Logs:
  vault balance before attack: 110000000000000000
  vault balance after attack: 0

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 374.91µs (147.56µs CPU time)

Ran 1 test suite in 4.22ms (374.91µs CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```
