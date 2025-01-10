# ERC20-STARKNET
### transform token name to hash on python 3
```
def str_to_felt(text):
    return hex(int.from_bytes(text.encode(), 'big'))

print(str_to_felt("token_name"))  # Result: 0x4e6577656c6c73204f6c6420426f7973
print(str_to_felt("TKN"))              # Result: 0x4e4f42

```

### deploy contract on starknet
```
starkli deploy \
    --rpc https://starknet-sepolia.infura.io/v3/<YOUR_INFURA_RPC_TOKEN> \
    --account account.json \
    --keystore keystore.json \
    <CLASS_HASH> \  
    <TOKEN_NAME_FELT252> \  # Token name converted to felt252 (e.g., "MyToken")
    <TOKEN_SYMBOL_FELT252> \  # Token symbol converted to felt252 (e.g., "MTK")
    <TOTAL_SUPPLY_LOW> <TOTAL_SUPPLY_HIGH>  # u256 representation (e.g., low = 1000000, high = 0)
```

