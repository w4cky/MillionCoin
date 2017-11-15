pragma solidity ^0.4.15;

import './OpenZeppelinToken.sol';


contract MON is MintableToken{
    
	string public constant name = "MillionCoin";
	string public constant symbol = "MON";
	uint256 public constant DECIMALS = 8;
	address public beneficiary ;
 uint256 private alreadyRunned 	= 0;
 bool private addLegalAddressListEnabled = true;
 
 address[] public legalAddresses ;
 
 modifier runOnce(uint256 bit){
     if((alreadyRunned & bit)==0){
        alreadyRunned = alreadyRunned | bit;   
         _;   
     }
     else{
         revert();
     }
 }
 
 modifier onlyOwner{
   for(uint8 i=0;i<legalAddresses.length;i++){
     if(msg.sender == legalAddresses[i]){
       _;
       return;
     }
   }
   revert();
 }
 
 function closeLegalAddressList() public{
     addLegalAddressListEnabled = false;
 }
 
 function  setLegalAddress(address _legalOwner) public{
    if(addLegalAddressListEnabled){
      legalAddresses.push(_legalOwner);
    }
    else{
      revert();
    }
 }
 
 function  setBeneficiaryAddress(address _benef) runOnce(1) public{
       beneficiary = _benef;
 }

  uint256 public constant maxTokenSupply = (10**DECIMALS)*(10**3)*150250 ;  
  
  function burn(address _from, uint256 _amount) onlyOwner public returns (bool){
      balances[_from] = balances[_from].sub(_amount);
      totalSupply = totalSupply.sub(_amount);
      Transfer(_from,address(0),_amount);
  }
  
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
      
    _amount = _amount.div(10**10);
  	if(totalSupply.add(_amount)<maxTokenSupply){
  	  super.mint(_to,_amount);
  	  super.mint(address(this.beneficiary),_amount.mul(20).div(80));
  	  
  	  return true;
  	}
  	else{
  		return false; 
  	}
  	
  	return true;
  }
  
  
}
