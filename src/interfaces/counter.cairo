use starknet::ContractAddress;
use starknet::ClassHash;

#[starknet::interface]
pub trait ICounter<TContractState> {
    fn add_to_counter(ref self: TContractState);
    fn get_counter(self: @TContractState) -> u256;
    fn get_counter_from_mapping(self: @TContractState, address: ContractAddress) -> u256;
    fn add_to_whitelist(ref self: TContractState, address: ContractAddress);
}

