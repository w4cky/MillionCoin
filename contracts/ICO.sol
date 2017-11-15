pragma solidity ^0.4.15;

import './OpenZeppelinToken.sol';
import './MON.sol';
import './Stage.sol';


contract ICO {
 
 
 MON public coin;
 
 uint256 public _currentStageIndex;
	uint256 public constant DECIMALS = 8;
 
 bool public isICOOver ;
 
 Stage[5] public currenStage ;
 
 function  ICO(address _coin,address _stage1, address _stage2, address _stage3, address _stage4,address _stage5) public{
       isICOOver = false;
       coin = MON(_coin);
       currenStage[0] = Stage(_stage1);
       currenStage[1] = Stage(_stage2);
       currenStage[2] = Stage(_stage3);
       currenStage[3] = Stage(_stage4);
       currenStage[4] = Stage(_stage5);
       currenStage[0].setCoin(_coin);
       currenStage[1].setCoin(_coin);
       currenStage[2].setCoin(_coin);
       currenStage[3].setCoin(_coin);
       currenStage[4].setCoin(_coin);
       currenStage[0].setNext(currenStage[1]);
       currenStage[0].setValidCaller(address(this));
       currenStage[1].setNext(currenStage[2]);
       currenStage[1].setValidCaller(address(this));
       currenStage[2].setNext(currenStage[3]);
       currenStage[2].setValidCaller(address(this));
       currenStage[3].setNext(currenStage[4]);
       currenStage[3].setValidCaller(address(this));
       currenStage[4].setNext(address(0));
       currenStage[4].setValidCaller(address(this));
       coin.setLegalAddress(address(_stage1)); //only addresses than can mint
       coin.setLegalAddress(address(_stage2));
       coin.setLegalAddress(address(_stage3));
       coin.setLegalAddress(address(_stage4));
       coin.setLegalAddress(address(_stage5));
       coin.closeLegalAddressList();
       _currentStageIndex = 0;
       
 }
 
 function getEthLeft() public returns(uint256,uint256){
   return currenStage[_currentStageIndex].getEthLeft();
 }
 
 function getCurrentStageIndex() public returns(uint256){
   return _currentStageIndex;
 }

  uint256 public constant maxTokenSupply = (10**DECIMALS)*(10**3)*150250 ;  
  function () public payable  {
   if(_currentStageIndex<5){
     if(currenStage[_currentStageIndex].isFinished() && currenStage[_currentStageIndex].isFailed()){
       currenStage[_currentStageIndex].refund(msg.sender);
     }
     else{
       if( currenStage[_currentStageIndex].isFailed()){
        revert();
       }
       else{
        currenStage[_currentStageIndex].buy.value(msg.value)(msg.sender);
        if(currenStage[_currentStageIndex].isFinished()){
          _currentStageIndex = _currentStageIndex+1;
          if(_currentStageIndex==5){
           isICOOver = true;
           
          }
        }
       }
     }
   }
   else{
    
    revert();
   }
  }
  
}
