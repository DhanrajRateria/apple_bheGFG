module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
    },
    advanced: {
      websocket: true,
    },
  },
  contract_build_directory: "./contracts/build/contracts/Blockchain.json",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
