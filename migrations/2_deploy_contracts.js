const Transaction = artifacts.require("Transaction");

module.exports = function(deployer) {
  deployer.deploy(Transaction, "<sender_address>", "<receiver_address>", 100, "bill_type");
};
