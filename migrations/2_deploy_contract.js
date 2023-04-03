const Blockchain = artifacts.require("Blockchain");

module.exports = function(deployer) {
  const orderId = web3.utils.asciiToHex("ORDER123");
  const orderName = web3.utils.asciiToHex("Example Order");
  const billType = web3.utils.asciiToHex("Electricity Bill");
  const value = 1000;

  deployer.deploy(Blockchain, orderId, orderName, billType, value);
};
