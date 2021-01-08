// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Role {
    mapping(address => bytes32) private roleOf;
    mapping(bytes32 => bytes32) private flag;

    modifier onlyRole(bytes32 role) {
        // TODO : fix this to library that will not pack the empty bytes
        string memory message = string(abi.encodePacked("only user with role ", role, " can call this function"));
        require(hasRole(msg.sender, role), message);
        _;
    }

    function hasRole(address user, bytes32 role) internal returns(bool) {
        require(flag[role] != bytes32(0), "role is not registered");
        return roleOf[user] & flag[role] == flag[role];
    }

    ///@dev sets role based on existing roles
    ///@param role name of role that will be registered
    ///@param roles target roles that `role` will inherit
    function setRole(bytes32 role, bytes32[] memory roles) internal {
        require(flag[role] == bytes32(0), "role is already registered");
        require(roles.length != 0, "should have at least 1 roles");
        bytes32 roleFlag;
        for(uint256 i = 0; i < roles.length; i++){
            roleFlag = roleFlag | flag[roles[i]];
        }
        require(roleFlag != bytes32(0), "target role has to be registered");
        flag[role] = roleFlag;
    }

    ///@dev sets role based on flag
    ///@param role name of role that will be registered
    ///@param _flag flag that `role` will get
    function setRole(bytes32 role, bytes32 _flag) internal {
        require(flag[role] == bytes32(0), "role is already registered");
        require(_flag != bytes32(0), "flag cannot be zero");
        flag[role] = _flag;
    }
}
