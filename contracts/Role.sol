// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Role {
    modifier onlyRole(bytes32 role) {
        // TODO : fix this to library that will not pack the empty bytes
        string memory message = string(abi.encodePacked("only user with role ", role, " can call this function"));
        require(hasRole(msg.sender, role), message);
        _;
    }

    function getFlag(bytes32 _role) private view returns(bytes32 flag) {
        bytes32 slot = keccak256(abi.encodePacked("Minnow.Flag.", _role));
        assembly {
            flag := sload(slot)
        }
    }

    function getRole(address _user) private view returns(bytes32 flag) {
        bytes32 slot = keccak256(abi.encodePacked("Minnow.Role.", _user));
        assembly {
            flag := sload(slot)
        }
    }

    function setFlag(bytes32 _role, bytes32 _flag) private {
        bytes32 slot = keccak256(abi.encodePacked("Minnow.Flag.", _role));
        assembly {
            sstore(slot, _flag)
        }
    }
    
    function setRole(address _user, bytes32 _flag) private {
        bytes32 slot = keccak256(abi.encodePacked("Minnow.Role.", _user));
        assembly {
            sstore(slot, _flag)
        }
    }

    function hasRole(address user, bytes32 role) internal view returns(bool) {
        bytes32 flag = getFlag(role);
        require(flag != bytes32(0), "role is not registered");
        return getRole(user) & flag == flag;
    }

    ///@dev sets role to user
    ///@param role role 
    ///@param user address of user receiving the role
    function grantRole(bytes32 role, address user) internal {
        require(getFlag(role) != bytes32(0), "role is not registered");
        setRole(user, getFlag(role));
    }

    ///@dev revoke role of user
    ///@param user address of user that will be revoked
    function revokeRole(address user) internal {
        setRole(user, bytes32(0));
    }

    ///@dev sets role based on existing roles
    ///@param role name of role that will be registered
    ///@param roles target roles that `role` will inherit
    function configureRole(bytes32 role, bytes32[] memory roles) internal {
        require(getFlag(role) == bytes32(0), "role is already registered");
        require(roles.length != 0, "should have at least 1 roles");
        bytes32 flag;
        for(uint256 i = 0; i < roles.length; i++){
            flag = flag | getFlag(roles[i]);
        }
        require(flag != bytes32(0), "target role has to be registered");
        setFlag(role,flag);
    }

    ///@dev sets role based on flag
    ///@param role name of role that will be registered
    ///@param _flag flag that `role` will get
    function configureRole(bytes32 role, bytes32 _flag) internal {
        require(getFlag(role) == bytes32(0), "role is already registered");
        require(_flag != bytes32(0), "flag cannot be zero");
        setFlag(role, _flag);
    }
}
