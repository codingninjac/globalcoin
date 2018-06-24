/// @title GlobalCoin Contract
/// keyValueStorage Module
/// @author tokendev@pm.me
pragma solidity ^0.4.24;

contract keyValueStorage {
    
    mapping (address => mapping(bytes32 => bool)) isMember;
    mapping (address => mapping(bytes32 => uint256)) lockTime;
    mapping (address => mapping(bytes32 => uint256)) refreshTime;
    mapping (address => mapping(bytes32 => uint256)) SeedBalance;
    mapping (address => mapping(bytes32 => uint256)) PointsBalance;
    
    // Get Methods
    function getisMember(bytes32 _key) public view returns (bool) {
        return isMember[msg.sender][_key];
    }
    
    function getlockTime(bytes32 _key) public view returns (uint256) {
        return lockTime[msg.sender][_key];
    }
    
    function getrefreshTime(bytes32 _key) public view returns (uint256) {
        return refreshTime[msg.sender][_key];
    }
    
    function getSeedBalance(bytes32 _key) public view returns (uint256) {
        return SeedBalance[msg.sender][_key];
    }
    
    function getPointsBalance(bytes32 _key) public view returns (uint256) {
        return PointsBalance[msg.sender][_key];
    }
    
    // Set Methods
    function setisMember(bytes32 _key, bool _pass) internal {
        isMember[msg.sender][_key] = _pass;
    }
    
    function setlockTime(bytes32 _key, uint256 _time) internal {
        lockTime[msg.sender][_key] = _time;
    }
    
    function setrefreshTime(bytes32 _key, uint256 _time) internal {
        refreshTime[msg.sender][_key] = _time;
    }
    
    function setSeedBalance(bytes32 _key, uint256 _value) internal {
        SeedBalance[msg.sender][_key] = _value;
    }
    
    function setPointsBalance(bytes32 _key, uint256 _value) internal {
        PointsBalance[msg.sender][_key] = _value;
    }
    
    // Delete Methods
    function deleteMember(bytes32 _key) internal {
        delete isMember[msg.sender][_key];
        delete lockTime[msg.sender][_key];
        delete refreshTime[msg.sender][_key];
        delete SeedBalance[msg.sender][_key];
        delete PointsBalance[msg.sender][_key];
    }
}
