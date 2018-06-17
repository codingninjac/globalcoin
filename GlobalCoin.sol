/// @title GlobalCoin Contract
/// @author tokendev@pm.me
/// @dev This is not ERC20 Compatible. Only supports CAD token at the moment. 
/// (to do) Implement USD, RMB tokens; Supports upgrading using proxy pattern
/// (to do) Add deposit function for CADSeedBalance
pragma solidity ^0.4.24;


/**
 * Math operations with safety checks
 */
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract GlobalCoinCAD {

    using SafeMath for uint256;
    string public name = "GlobalCoinCAD";           // token name
    string public symbol = "GBCAD";                 // token symbol
    address public owner;
    uint256 public totalSupply;
    
    struct Member {
        bool isMember;
        uint64 lockTime;            //responsible for fund unlocking
        uint64 refreshTime;         //responsible for claiming interests
        uint256 CADSeedBalance;     //Equivalent to "Saving account"
        uint256 CADPointsBalance;   //Equivalent to "Chequeing account"
    }
    
    // mapping to Member struct
    mapping (address => Member) public MemberMapping;
   

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }
    
    /*
    In the future there might be just one function
    for interests management as well as unlocking funds
    Current interest rate is at 2% every 98 days
    Intests will go directly to CADPointsBalance
    However, only CADSeedBalance is eligible for interests
    */
    function claimInterests(address _memberAddr) public returns (bool success) {
       Member storage _member = MemberMapping[_memberAddr];
       require(now > _member.refreshTime + 98 days);
       require(_member.isMember == true);
       _member.refreshTime = uint64(now);
       uint256 newInterests = _member.CADSeedBalance.div(100).mul(2);
       _member.CADPointsBalance = _member.CADPointsBalance.add(newInterests);
       return true;
    }
    
    function unlockFund(address _memberAddr) public returns (bool success) {
        Member storage _member = MemberMapping[_memberAddr];
        require(now > _member.lockTime + 365 days);
        require(_member.isMember == true);
        _member.lockTime  = uint64(now);
        _member.CADSeedBalance = _member.CADSeedBalance.sub(280);
        _member.CADPointsBalance = _member.CADPointsBalance.add(280);
        return true;
    }
    
    /*
    Membership fee is 2800 CAD
    Each member will get 2800 CAD tokens upon registeration 
    Only contract owner can add new members
    */
    function approveMembership(address _newMember) public onlyOwner {
        totalSupply = totalSupply.add(2800);
        Member storage _member = MemberMapping[_newMember];
        _member.isMember = true;
        _member.refreshTime = uint64(now);
        _member.CADSeedBalance = 2520;
        _member.CADPointsBalance = 280;  // 10% of fund will be spendable immediatly
        emit MemberJoined(_newMember, now);
    }   
  

    /*
    Members can spend CADPointsBalance
    OR transfer CADPoints to each other
    */
    function transferPoints(address _to, uint256 _value) public returns (bool success) {
        // Only members can transfer points
        require(MemberMapping[msg.sender].isMember == true);
        require(MemberMapping[_to].isMember == true);
        MemberMapping[msg.sender].CADPointsBalance = MemberMapping[msg.sender].CADPointsBalance.sub(_value);
        MemberMapping[_to].CADPointsBalance = MemberMapping[_to].CADPointsBalance.add(_value);
        emit TransferPoints(msg.sender, _to, _value);
        return true;
    }

   event TransferPoints(address indexed _from, address indexed _to, uint256 _value);
   event MemberJoined(address indexed _newMember, uint256 _joinTime);
}
