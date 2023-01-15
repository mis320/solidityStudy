// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.12;
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
 
    function deploy(bytes memory bytecode,uint salt) external returns (address contractAddress){
        assembly {
            contractAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(contractAddress!=address(0),"a0");
    }
    
    function deployChi(bytes memory bytecode,uint salt) external discountCHI returns (address contractAddress) {
        assembly {
            contractAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(contractAddress!=address(0),"a0");
    }
   
    function initCodeHash(bytes memory bytecode) public pure returns (bytes32 contractAddress){
        contractAddress  =keccak256(abi.encodePacked(bytecode));
    }
    function getAddress(bytes memory bytecode,uint salt) external view returns (address contractAddress){
        contractAddress = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                address(this),
                keccak256(abi.encodePacked(salt)),
                initCodeHash(bytecode)
            ))));
    }
}



git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy https://127.0.0.1:7890