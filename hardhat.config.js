require("@nomiclabs/hardhat-waffle");

const privateKey = "2f16c3c1e6275233a34e5d41ab7442bab10c4e43e07edbac511e89d128be691a"

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
module.exports = {
  networks : {
    hardhat : {
    },
    rinkeby : {
      url : "https://eth-rinkeby.alchemyapi.io/v2/vlVRbbG52utbvCINSumuRWI_-s8O6J8X",
      accounts: [privateKey]
    },
    mainnet: {
      url : "https://polygon-mainnet.infura.io/v3/be88e1ca8daa4255a1491c5eeed5713a",
      accounts: [privateKey]
    }
  },
  solidity: "0.8.4",
};
