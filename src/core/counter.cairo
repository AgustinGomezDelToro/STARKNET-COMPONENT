#[starknet::contract]
mod Counter {
    use starknet::{ContractAddress, ClassHash, get_caller_address};
    use starknet::storage::{Map};

    #[storage]
    struct Storage {
        counter: u256,
        mapping: Map<ContractAddress, u256>,
        whitelist: Map<ContractAddress, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        AddToCounter: AddToCounter,
    }

    #[derive(Drop, starknet::Event)]
    struct AddToCounter {
        #[key]
        value: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u256) {
        self.counter.write(initial_value);
    }

    #[abi(embed_v0)]
    impl CounterImpl of cours0::interfaces::counter::ICounter<ContractState> {
        fn add_to_counter(ref self: ContractState) {
            assert!(self.whitelist.read(get_caller_address()), "Caller is not whitelisted");
            self.counter.write(self.counter.read() + 1);
            let caller = get_caller_address();
            self.mapping.write(caller, self.counter.read());

            self.emit(AddToCounter { value: self.counter.read() });
        }

        fn get_counter(self: @ContractState) -> u256 {
            self.counter.read()
        }

        fn get_counter_from_mapping(self: @ContractState, address: ContractAddress) -> u256 {
            self.mapping.read(address)
        }

        fn add_to_whitelist(ref self: ContractState, address: ContractAddress) {
            self.whitelist.write(address, true);
        }
    }

    #[generate_trait]
    impl CounterHelper of CounterHelperTrait {
        fn get_counter_internal(self: @ContractState) -> u256 {
            self.counter.read()
        }
    }
}
