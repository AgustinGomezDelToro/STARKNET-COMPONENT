// erc20_component.cairo
use starknet::ContractAddress;
use starknet::storage::Map;
use starknet::get_caller_address;

#[starknet::component]
pub mod erc20_component {

    // Definición del almacenamiento para el componente.
    #[storage]
    pub struct Storage {
        name: felt252,
        symbol: felt252,
        total_supply: u256,
        balances: Map<ContractAddress, u256>,
        allowances: Map<(ContractAddress, ContractAddress), u256>,
        owner: ContractAddress,
    }

    // Eventos
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256,
    }

    // Implementación de la interfaz ERC20 en el componente.
    #[embeddable_as(IERC20)]
    impl ERC20ComponentImpl<
        TContractState, +HasComponent<TContractState>
    > of IERC20<ComponentState<TContractState>> {

        fn name(self: @ComponentState<TContractState>) -> felt252 {
            self.name.read()
        }

        fn symbol(self: @ComponentState<TContractState>) -> felt252 {
            self.symbol.read()
        }

        fn total_supply(self: @ComponentState<TContractState>) -> u256 {
            self.total_supply.read()
        }

        fn balance_of(self: @ComponentState<TContractState>, account: ContractAddress) -> u256 {
            self.balances.read(account)
        }

        fn allowance(
            self: @ComponentState<TContractState>, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            self.allowances.read((owner, spender))
        }

        fn transfer(ref self: ComponentState<TContractState>, recipient: ContractAddress, amount: u256) -> bool {
            let sender = get_caller_address();
            let sender_balance = self.balances.read(sender);
            // Verificamos saldo suficiente
            assert(sender_balance >= amount, 'Insufficient balance');

            self.balances.write(sender, sender_balance - amount);
            self.balances.write(recipient, self.balances.read(recipient) + amount);

            self.emit(Event::Transfer(Transfer { from: sender, to: recipient, value: amount }));
            true
        }

        fn approve(ref self: ComponentState<TContractState>, spender: ContractAddress, amount: u256) -> bool {
            let owner = get_caller_address();
            self.allowances.write((owner, spender), amount);

            self.emit(Event::Approval(Approval { owner, spender, value: amount }));
            true
        }

        fn transfer_from(
            ref self: ComponentState<TContractState>,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let spender = get_caller_address();
            let sender_balance = self.balances.read(sender);
            let current_allowance = self.allowances.read((sender, spender));

            assert(sender_balance >= amount, 'Insufficient balance');
            assert(current_allowance >= amount, 'Insufficient allowance');

            self.balances.write(sender, sender_balance - amount);
            self.balances.write(recipient, self.balances.read(recipient) + amount);
            self.allowances.write((sender, spender), current_allowance - amount);

            self.emit(Event::Transfer(Transfer { from: sender, to: recipient, value: amount }));
            true
        }
    }
}
