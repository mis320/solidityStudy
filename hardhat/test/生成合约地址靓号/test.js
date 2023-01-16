
'use strict';
var bignumber_1 = require("@ethersproject/bignumber");
var bytes_1 = require("@ethersproject/bytes");
var keccak256_1 = require("@ethersproject/keccak256");
var logger_1 = require("@ethersproject/logger");
var logger = new logger_1.Logger('v2');
var solidity = require('@ethersproject/solidity');
var pack = solidity.pack;
var keccak256 = solidity.keccak256;
const fs = require('fs');
function getCreat2Address(factory, initCodeHash, salt) {
  function getChecksumAddress(address) {
    if (!bytes_1.isHexString(address, 20)) {
      logger.throwArgumentError("invalid address", "address", address);
    }
    address = address.toLowerCase();
    var chars = address.substring(2).split("");
    var expanded = new Uint8Array(40);
    for (var i = 0; i < 40; i++) {
      expanded[i] = chars[i].charCodeAt(0);
    }
    var hashed = bytes_1.arrayify(keccak256_1.keccak256(expanded));
    for (var i = 0; i < 40; i += 2) {
      if (hashed[i >> 1] >> 4 >= 8) {
        chars[i] = chars[i].toUpperCase();
      }
      if ((hashed[i >> 1] & 0x0f) >= 8) {
        chars[i + 1] = chars[i + 1].toUpperCase();
      }
    }
    return "0x" + chars.join("");
  }
  function getAddress(address) {
    var result = null;
    if (typeof address !== "string") {
      logger.throwArgumentError("invalid address", "address", address);
    }
    if (address.match(/^(0x)?[0-9a-fA-F]{40}$/)) {
      // Missing the 0x prefix
      if (address.substring(0, 2) !== "0x") {
        address = "0x" + address;
      }
      result = getChecksumAddress(address);
      // It is a checksummed address with a bad checksum
      if (address.match(/([A-F].*[a-f])|([a-f].*[A-F])/) && result !== address) {
        logger.throwArgumentError("bad address checksum", "address", address);
      }
      // Maybe ICAP? (we only support direct mode)
    } else if (address.match(/^XE[0-9]{2}[0-9A-Za-z]{30,31}$/)) {
      // It is an ICAP address with a bad checksum
      if (address.substring(2, 4) !== ibanChecksum(address)) {
        logger.throwArgumentError("bad icap checksum", "address", address);
      }
      result = bignumber_1._base36To16(address.substring(4));
      while (result.length < 40) {
        result = "0" + result;
      }
      result = getChecksumAddress("0x" + result);
    } else {
      logger.throwArgumentError("invalid address", "address", address);
    }
    return result;
  }
  function getCreate2Address(from, salt, initCodeHash) {
    if (bytes_1.hexDataLength(salt) !== 32) {
      logger.throwArgumentError("salt must be 32 bytes", "salt", salt);
    }
    if (bytes_1.hexDataLength(initCodeHash) !== 32) {
      logger.throwArgumentError("initCodeHash must be 32 bytes", "initCodeHash", initCodeHash);
    }
    return getAddress(bytes_1.hexDataSlice(keccak256_1.keccak256(bytes_1.concat(["0xff", getAddress(from), salt, initCodeHash])), 12));
  }

  return getCreate2Address(factory, keccak256(['bytes'], [pack(['uint'], [salt])]), initCodeHash);
}
function randomNumber(conut) {
  let str = ""
  for (let index = 0; index < 64; index++) {
    let random = parseInt(Math.random() * 10) + ""
    str += random
  }
  if (str.slice(0, 1) == "0") {
    str = "1" + str
  }
  return str + conut
}
let conut = 0
while (true) {
  let random = randomNumber(String(conut))
  let addtress = getCreat2Address("0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8", "0x11dafecf3bfeda557cc86931a570a034698ab9a2d1babfc7b7cadc75e0ac3ac1", random)

  if (addtress.slice(2,5) == "000") {
    console.log(addtress);
    fs.appendFileSync(__dirname + "/keys.txt", random + "----" + addtress + "\n")
    break
  }
  conut++
}
