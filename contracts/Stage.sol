pragma solidity ^0.4.15;

import './OpenZeppelinToken.sol';
import './MON.sol';


contract Stage{
  using SafeMath for uint256;
    
    MON public _coin ;
    address public _owner; 
    address public _nextStage ;
    address public _validCaller ;
    uint256 public _endTime ;
    uint256 public _amountForEthInStage ;
    uint256 public _maxEthToRise ;
    uint256 public _ethActuallyRised ;
    bool public isFailed = false;
    bool public isFinished = false;
    
    mapping(address=>uint256) balance;
    
    modifier onlyOwner() {
        if(msg.sender==_owner || _owner == address(0)){
            _;
        }
        else{
            revert();   
        }
    }
    
    function GetNow() returns(uint256){
        return now;   
    }
    
    function Stage(uint256 price, uint256 ethToRise, uint256 endTime){
        _amountForEthInStage = price;
        _maxEthToRise = ethToRise*18**18;
        _endTime = endTime;
    }
    
    
    function buy(address sndr) public  onlyOwner() payable{
        uint256 valToMint = 0;
        uint256 valueToReturnOrForward = 0;
        if(msg.value+_ethActuallyRised<_maxEthToRise){
            if(_endTime>this.GetNow()){
                isFinished = true;
                isFailed = true;
            }
            valToMint = msg.value.mul(_amountForEthInStage);
            balance[sndr] = balance[sndr].add(valToMint);
            _ethActuallyRised = _ethActuallyRised.add(msg.value);
            _coin.mint(sndr,valToMint);
            
        }
        else{
            
            if(_endTime>this.GetNow()){
                isFinished = true;
                isFailed = true;
            }
            else{
                  isFinished = true;
                  isFailed = false;
                  valToMint = (_maxEthToRise.sub(_ethActuallyRised)).mul(_amountForEthInStage);
                  valueToReturnOrForward = msg.value.sub(_maxEthToRise-_ethActuallyRised);
                  _ethActuallyRised = _maxEthToRise;
                  balance[sndr] = balance[sndr].add(valToMint);
                  _coin.mint(sndr,valToMint);
                  
                  if(_nextStage==address(0)){
                     sndr.transfer(valueToReturnOrForward);
                  }
                  else{
                      Stage(_nextStage).buy.value(valueToReturnOrForward)(sndr);
                  }
            }
          
        }
    }
    
    function refund(address sndr)  onlyOwner() public{
        _coin.burn(sndr,balance[sndr]);
        uint256 valToReturn = balance[sndr].div(_amountForEthInStage);
        balance[sndr] = 0;
        sndr.transfer(valToReturn);
    }
    
    function setCoin(address c) onlyOwner() public{
        _coin = MON(c);   
        _owner = msg.sender;
    }
    function setNext(address c) onlyOwner() public{
        _nextStage = c;   
        _owner = msg.sender;
    }
    function setValidCaller(address _a) onlyOwner() public{
        _validCaller = _a;   
        _owner = msg.sender;
    }
    function getEthLeft() public returns(uint256,uint256){
        return(_ethActuallyRised,_maxEthToRise);   
    }
    
}
