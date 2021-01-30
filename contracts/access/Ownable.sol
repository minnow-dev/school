// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../library/Role.sol";

contract Ownable {
    modifier onlyOwner() {
        require(Role.hasRole(msg.sender, "Owner"), "only user with role Owner can call this function");
        _;
    }

    constructor(address _owner) {
        // grant all access for Owner
        Role.configureRole("Owner", bytes32(type(uint256).max));
        Role.grantRole(_owner, "Owner");
    }

    function transferOwnership(address _newOwner) public {
        Role.revokeRole(msg.sender);
        Role.grantRole(_newOwner, "Owner");
    }

    function renounceOwnership() external onlyOwner {
        Role.revokeRole(msg.sender);
    }
}
