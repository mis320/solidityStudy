require("@nomicfoundation/hardhat-toolbox");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.17",
    version: "0.8.9",
    version: "0.6.12",
    viaIR:true,
    settings: {
      optimizer: {
        enabled: true,
        runs: 10000000
      },outputSelection:{
        "*":{
          "*":["evm.assembly","irOptimized"],
        }
      }
    }
  }
};