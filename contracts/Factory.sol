pragma solidity >=0.5.0 <0.7.0;

contract Coin {
  address public minter;
  mapping (address => uint) private balances;

  event Sent(address from, address to, uint amount);

  constructor(uint inital) public {
    minter = msg.sender;
    balances[minter] = inital;
  }

  function mint(address receiver, uint amount) public {
    require(msg.sender == minter);
    require(amount < 1e60);
    balances[receiver] += amount;
  }

  function myBalance() public view returns(uint balance){
    return balances[minter];
  }
}

contract Factory {
  bytes contractBytecode = type(Coin).creationCode;
  address[] public groups;

  function deployer(uint _inital) public {
    bytes memory bytecode = abi.encodePacked(contractBytecode, abi.encode(_inital));
    address addr;

    assembly {
      addr := create2(0, add(bytecode, 0x20), mload(bytecode), 0)
      if iszero(extcodesize(addr)) {
        revert(0, 0)
      }
    }
    
    groups.push(addr);
  }
   
}