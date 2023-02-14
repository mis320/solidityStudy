/*
 * @Author: mis16 2422914657@qq.com
 * @Date: 2022-10-18 20:11:32
 * @LastEditors: mis16 2422914657@qq.com
 * @LastEditTime: 2023-02-02 22:48:52
 * @FilePath: \testHardhat\hardhat.config.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.17",
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