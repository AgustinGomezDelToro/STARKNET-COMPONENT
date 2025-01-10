#[starknet::contract]
pub mod SwitchContract {
    use super::switchable_component;

    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchableEvent: switchable_component::Event,
    }

    // Use the internal implementation
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Set the switch off initially
        self.switch._off();
    }
}
