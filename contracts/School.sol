// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./access/Ownable.sol";

contract School is Ownable {
    mapping(address => mapping(bytes4 => bytes32)) public executableRole;

    modifier onlyRole(bytes32 role) {
        // TODO - friendly error message
        require(hasRole(msg.sender, role), "");
        _;
    }

    constructor(address _owner) Ownable(_owner) {
        Role.configureRole("Operator", bytes32(1));
        Role.configureRole("Admin", bytes32(type(uint256).max >> 1));
    }

    function addOperator(address operator) external {
        Role.grantRole(operator, "Operator");
    }

    function addTarget(address target, bytes4 selector, bytes32 role) external onlyRole("Admin") {
    }

    // TODO - figure out how to enable execute for non registered user, if target is registered as ANY
    // allow this to be called with any role since canExecute will guard thigs/
    function execute(address target, bytes4 selector, bytes calldata data) external {
        require(canExecute(msg.sender, target, selector), "user cannot execute this function");
        bytes memory packedData = abi.encodePacked(selector, data);
        (bool succes, bytes memory ret) = target.call(packedData);
        // TODO - better error message check out 1inch sample
        require(success, "error while executing");
    }

    // check if caller can call certain contract with given selector
    function canExecute(address caller, address target, bytes4 selector) public view returns(bool) {
        return hasRole(caller, executableRole[target][selector]);
    }
}
