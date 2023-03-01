//SPDX-License-Identifier: UNLICENSED
pragma solidity  = 0.6.12;
interface IERC20 {
   function symbol() external view returns (string memory);
   function name() external view returns (string memory);
    function decimals() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint value) external returns (bool);
     function transferFrom(address from, address to, uint value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}
interface IPancakePair{
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    
     function token0() external view returns (address);
    function token1() external view returns (address);
}

interface router{
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts); 
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}

contract FlashLoan {
    address public uniPair = 0x196f695188A36826bdbB2906C7dB6b85E3A32aA9;
    address public jkToken = 0xb528F0A7b81C738bae3e81d19F44a990f11Fd51d;
    
    address owner;
    
    
    bytes _calldata = bytes("FlashLoan");
    event Balance(address asset, uint256 amount);
    uint256 loanAmount;
    uint256 amountIn;
    
    
    
    
    uint256 private k =2001;
    uint256 private m = 1000000;
    constructor() public{
       owner = msg.sender;
    }
    
    modifier onlyOwner  () {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    function swap(uint256 _loanAmount) public{
        loanAmount = _loanAmount;
        IPancakePair PancakePair  = IPancakePair(uniPair);
       (uint amount0Out, uint amount1Out) = jkToken != PancakePair.token0() ? (uint(0), _loanAmount) : (_loanAmount, uint(0));
        PancakePair.swap(amount0Out,amount1Out,address(this),_calldata);
    }
 
    function deposit()public payable{
     
     
     
    }
    
    
    function withdraw(IERC20 token)public onlyOwner{
       token.transfer(msg.sender,token.balanceOf(address(this)));
       
       payable(address(msg.sender)).transfer(address(this).balance);
    }
    function MCall(address _token,uint256 v,bytes memory data1) public payable onlyOwner{
        (bool success,) = _token.call{value : v}(data1);
         require(success, 'c_FAILED');
    }
    
    function set(uint256 k_)public onlyOwner{
        k = k_;
    }
    
    function pancakeCall(address sender, uint amount0, uint amount1, bytes memory data) public {
        
        sender;
        amount0;
        amount1;
        data;
        require(msg.sender == uniPair,'pancakeCall');


        {
            //实现自己的想法。。。。
            
        }
        
        
        
        
        
        
        uint256 t=  loanAmount  * (m + k) / m ;
        IERC20(jkToken).transfer(uniPair,t);
    }
    
    
   
}