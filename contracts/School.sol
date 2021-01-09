// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./access/Ownable.sol";

contract School is Ownable {
    modifier onlyRole(bytes32 role) {
        require(hasRole(msg.sender, role), "");
        _;
    }

    constructor(address _owner) Ownable(_owner) {
        Role.configureRole("Operator", bytes32(1));
    }

    function addOperator(address operator) external {
        Role.grantRole(operator, "Operator");
    }

    function addTarget(address target, bytes4 selector, bytes32 role) external {
    }
    function execute(address target, bytes4 selector, bytes calldata data) external {
    }
}
