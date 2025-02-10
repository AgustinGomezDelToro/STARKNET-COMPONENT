// ERC20ComponentContract.cairo
use starknet::ContractAddress;
use starknet::contract_address_const;
use starknet::get_caller_address;
use erc20_component;  // Composant ERC20

#[starknet::contract]
mod ERC20ComponentContract {
    // Intégration du composant ERC20.
    component!(path: erc20_component, storage: erc20_storage, event: ERC20Event);

    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, symbol: felt252, initial_supply: u256) {
        // Initialisation
        self.erc20_storage.name.write(name);
        self.erc20_storage.symbol.write(symbol);
        self.erc20_storage.total_supply.write(initial_supply);
        let caller = get_caller_address();
        self.erc20_storage.balances.write(caller, initial_supply);
        self.erc20_storage.owner.write(caller);

        // Émission de l'événement de transfert
        self.erc20_storage.emit(
            ERC20Event::Transfer(
                erc20_component::Transfer {
                    from: contract_address_const::<0>(),
                    to: caller,
                    value: initial_supply
                }
            )
        );
    }

    #[external]
    fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
        self.erc20_storage.transfer(recipient, amount)
    }

    #[external]
    fn name(self: ContractState) -> felt252 {
        self.erc20_storage.name()
    }
}
