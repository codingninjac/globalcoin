/// @title GlobalCoin Contract
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

contract GlobalCoin {

    using SafeMath for uint256;
    string public name = "GlobalCoin";                  // token name
    string public symbol = "GBC";                    // token symbol
    uint8 public decimals = 18;                      // token digit
    address public owner;

    mapping (address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply = 1000000 * (uint256(10) ** decimals);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        // Initially assign all tokens to the contract's creator.
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function mint(address _recipient, uint256 _amount) public onlyOwner {
        require(totalSupply + _amount >= totalSupply);
        totalSupply = totalSupply.add(_amount);
        balanceOf[_recipient] = balanceOf[_recipient].add(_amount);
        emit Transfer(address(0), _recipient, _amount);
    }

    function burn(uint256 _amount) public {
        require(_amount <= balanceOf[msg.sender]);
        totalSupply = totalSupply.sub(_amount);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
        emit Transfer(msg.sender, address(0), _amount);
    }

    function burnFrom(address _from, uint256 _amount) public {
        require(_amount <= balanceOf[_from]);
        require(_amount <= allowance[_from][msg.sender]);
        totalSupply = totalSupply.sub(_amount);
        balanceOf[_from] = balanceOf[_from].sub(_amount);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_amount);
        emit Transfer(_from, address(0), _amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        require(_to != 0x0);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != 0x0);
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
   }

   event Transfer(address indexed from, address indexed to, uint256 value);
   event Approval(address indexed owner, address indexed spender, uint256 value);
}
