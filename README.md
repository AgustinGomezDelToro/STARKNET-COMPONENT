# ERC20-STARKNET

### Transform token name to hash on python 3
```
def str_to_felt(text):
    return hex(int.from_bytes(text.encode(), 'big'))

print(str_to_felt("token_name"))  # Result: 0x4e6577656c6c73204f6c6420426f7973
print(str_to_felt("TKN"))              # Result: 0x4e4f42

```

### Deploy contract ERC20 on starknet
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

## Link to the contract ERC20 and transaction

#### Transaction :
https://sepolia.voyager.online/tx/0x1b2e0a4cf795d3e03cd3a9a4ae49796c9c65e3265953057a0d13f57c2b70594

#### Token:
https://sepolia.starkscan.co/token/0x01bfa2cd2dcf19681aca942f4951277db9dd43c49974af4fb5a631d176f36964



## Link to the Component switchable

#### Transaction :
https://sepolia.voyager.online/tx/0x492fb82d832ccd121973d74113129bac6f455d692482b5801a6df9187eb3645

#### Token:
https://sepolia.voyager.online/token/0x06f6647067da2f878ba129dce9ba3d91154c851f47d9cb02fba54ebebf5a1cb4


## Link to the Component contract

#### Transaction :
https://sepolia.voyager.online/tx/0x04e07509a690855367d0ea85ad9eed11cd6b6ea2fcd1602821f78013291d506b

#### Contract address
0x058a13eb8a026e07f7968806bf949dcb1a5b752350905ecfad03587e1621eeae