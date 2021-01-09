// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../library/Role.sol";
import "./Ownable.sol";

contract AccessControl is Ownable {
    modifier onlyRole(bytes32 role) {
        // TODO : fix this to library that will not pack the empty bytes
        string memory message = string(abi.encodePacked("only user with role ", role, " can call this function"));
        require(Role.hasRole(msg.sender, role), message);
        _;
    }

    constructor(address _owner) Ownable(_owner) {
    }
}
