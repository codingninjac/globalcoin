pragma solidity ^0.4.24;

import "./token.sol";

contract Memebership {
    using SafeMath for uint256;
    uint256 MinimumWithdrawTime = 90 days;
    mapping(address => mapping(address => uint256)) public Balance;
    mapping(address => mapping(address => uint256)) public DepositTime;
    constructor() public {
    }
    
    modifier passMinimum(GlobalCoin _token) {
        require(now > DepositTime[msg.sender][_token].add(MinimumWithdrawTime));
        _;
    }
    
    // To be implemented;
    function joinMember() public {
        require(msg.value == 5 ether);
    }
    
    function deposit(GlobalCoin _token, uint256 _amount) public {
        require(_token.transferFrom(msg.sender, this, _amount));
        Balance[msg.sender][_token] = Balance[msg.sender][_token].add(_amount);
        DepositTime[msg.sender][_token] = now;
        emit Deposit(msg.sender, _token, now);
    }
    
    function withdraw(GlobalCoin _token, uint256 _amount) passMinimum(_token) public {
        Balance[msg.sender][_token] = Balance[msg.sender][_token].sub(_amount);
        require(_token.transfer(msg.sender, _amount));
        emit Withdraw(msg.sender, _token, now);
    }
    
    event Deposit(address indexed account, address token, uint256 time);
    event Withdraw(address indexed account, address token, uint256 time);
}

