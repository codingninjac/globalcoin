pragma solidity ^0.4.24;

import "./Ownable.sol";

contract Proxy is Ownable {
    
  address public _implementation;

  function upgradeTo(address impl) public onlyOwner {
    require(_implementation != impl);
    _implementation = impl;
    emit Upgraded(impl);
  }
 
  function () payable public {
    address _impl = _implementation;
    require(_impl != address(0));
    bytes memory data = msg.data;

    assembly {
      let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
      let size := returndatasize
      let ptr := mload(0x40)
      returndatacopy(ptr, 0, size)
      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
  
  event Upgraded(address indexed implementation);
}
