const Blockchain = artifacts.require("Blockchain");

module.exports = function(deployer) {
  deployer.deploy(Blockchain, orderId, orderName, billType, value);
};
