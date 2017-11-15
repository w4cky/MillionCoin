var SafeMath = artifacts.require("./Common/SafeMath.sol");
var MON = artifacts.require("./MON.sol");
var Stage = artifacts.require("./Stage.sol");
var ICO = artifacts.require("./ICO.sol");

var startTime = 1241674;
var week = 604800;
var multiplayer = 1000;
var stage1Amount = 6*multiplayer;
var stage2Amount = 10*multiplayer;
var stage3Amount = 12*multiplayer;
var stage4Amount = 15*multiplayer;
var stage5Amount = 17*multiplayer;

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, MON);
  deployer.link(SafeMath, Stage);
  deployer.link(SafeMath, ICO);
  var mon = null;
  var s1 = null;
  var s2 = null;
  var s3 = null;
  var s4 = null;
  var s5 = null;
  var ico = null;
  deployer.deploy([MON,Stage]).then(function(){
      mon = MON.new();
      return mon;
  }).then(function(mon_instence){
    mon = mon_instence;
    s1 = Stage.new(6000,3600,startTime+2*week);
    return s1;
  }).then(function(stage){
    s1 = stage;
    s2 = Stage.new(10000 ,2600 ,startTime+6*week);
    return s2;
  }).then(function(stage){
    s2 = stage;
    s3 = Stage.new(12000 ,2100 ,startTime+10*week);
    return s3;
  }).then(function(stage){
    s3 = stage;
    s4 =  Stage.new(15000 ,1800 ,startTime+16*week);
    return s4;
  }).then(function(stage){
    s4 = stage;
    s5 =  Stage.new(17000 ,1200 ,startTime+24*week);
    return s5;
  }).then(function(stage){
    s5 = stage;
     console.log(mon.address);
     console.log(s1.address);
     console.log(s2.address);
     console.log(s3.address);
     console.log(s4.address);
     console.log(s5.address);
     ico = ICO.new(mon.address,s1.address,s2.address,s3.address,s4.address,s5.address);
      return ico;
    }).then(function(){
        //run All Tests
      });
};
