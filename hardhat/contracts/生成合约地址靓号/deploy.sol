// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.12;
//0x8ec195ee65b95741490f9b682667ce503c0ca4d9
//0x652bcabc0aff25eac0c563a4a017f7b518fc67c8359f34a5c25920602e16e07c
interface ChiToken {
    function freeFromUpTo(address from, uint256 value) external;
    function approve(address spender, uint256 amount) external ;
    function mint(uint256 value)external;
    function deploy(bytes memory bytecode,uint salt) external view returns (address contractAddress);
}
contract deployer {
    
    ChiToken constant  chi = ChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    modifier discountCHI {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41947);
    }
 
    function deploy(bytes memory bytecode,bytes32 salt0) external returns (address contractAddress){
        bytes32 salt = keccak256(abi.encodePacked(salt0));
        assembly {
            contractAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(contractAddress!=address(0),"a0");
    }
    
    function deploy2(bytes memory bytecode,bytes32 salt) external discountCHI returns (address contractAddress) {
        assembly {
            contractAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(contractAddress!=address(0),"a0");
    }
   
    function initCodeHash(bytes memory bytecode) external pure returns (bytes32 contractAddress){
        contractAddress  =_initCodeHash(bytecode);
    }
    function toBytes32(uint salt) external pure returns (bytes32 b){
       b =  bytes32(salt);
    }


     function k256(uint salt) external pure returns (bytes32 b){
       b = keccak256(abi.encodePacked(salt));
    }
    function _initCodeHash(bytes memory bytecode) private pure returns (bytes32 contractAddress){
        contractAddress  =keccak256(abi.encodePacked(bytecode));
    }

    function getAddress(bytes memory bytecode,address deployer_,bytes32 salt) external pure returns (address contractAddress){
        contractAddress = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                address(deployer_),
                keccak256(abi.encodePacked(salt)),
                _initCodeHash(bytecode)
            ))));
    }


}