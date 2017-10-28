pragma solidity ^0.4.15;

import './OpenZeppelinToken.sol';

contract MON is MintableToken{
    
	string public constant name = "MillionCoin";
	string public constant symbol = "MON";
	uint8 public constant decimals = 18;

  uint256 public constant maxTokenSupply = (10**18)*(10**4)*15025 ;  
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
      
  	if(totalSupply.add(_amount)<maxTokenSupply){
  	  super.mint(_to,_amount);
  	  return true;
  	}
  	else{
  		return false; 
  	}
  	
  	return true;
  }
}
