var SafeMath = artifacts.require("./Common/SafeMath.sol");
var MON = artifacts.require("./MON.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, MON);
  deployer.deploy(MON);
};
