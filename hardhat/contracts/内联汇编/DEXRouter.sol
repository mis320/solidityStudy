// SPDX-License-Identifier: SEE LICENSE IN LICENSE
// 随便写写的没有写约束
pragma solidity ^0.6.12;

interface IPancakePair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint value) external returns (bool);

    function withdraw(uint) external;
}

contract DEXRouterV3 {
    //uint constant ERROR_INSUFFICIENT_OUTPUT_AMOUNT  = 1;
     function dextet() public payable {
        uint256 k = 9980;
        address[] memory pairs = new address[](1);
        pairs[0] = 0xC64c507D4BA4CAb02840CecD5878cB7219e81fe0;
        address[] memory path = new address[](2);
        path[0] = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
        path[1] = 0x8a9424745056Eb399FD19a0EC26A14316684e274;
        DEXEthSwap(pairs,path,address(0),k,0);
    }
    
    function DEXEthSwap(
        address[] memory pairs,
        address[] memory path,
        address to,
        uint k,
        uint amountOutMin
    ) public payable //uint amountIn
    {
        uint[] memory amounts = getAmountsOut(msg.value, k, pairs, path);
        require(
            amounts[amounts.length - 1] >= amountOutMin,
            "ERROR_INSUFFICIENT_OUTPUT_AMOUNT"
        );
        IWETH(path[0]).deposit{value: amounts[0]}();
        assert(IWETH(path[0]).transfer(pairs[0], amounts[0]));
        _swap(amounts, path, pairs, to);
    }

    // function sortTokens(
    //     address tokenA,
    //     address tokenB
    // ) private pure returns (address token0, address token1) {
    //     assembly {
    //         switch lt(tokenA, tokenB)
    //         case true {
    //             token0 := tokenA
    //             token1 := tokenB
    //         }
    //         default {
    //             token0 := tokenB
    //             token1 := tokenA
    //         }
    //     }
    // }

    // function getReserves(
    //     address tokenA,
    //     address tokenB,
    //     address pair
    // ) internal view returns (uint reserveA, uint reserveB) {
    //     (address token0, ) = sortTokens(tokenA, tokenB);

    //     (uint reserve0, uint reserve1, ) = IPancakePair(pair)
    //         .getReserves();
    //     (reserveA, reserveB) = tokenA == token0
    //         ? (reserve0, reserve1)
    //         : (reserve1, reserve0);
    // }

    // function getReserves(
    //     address tokenA,
    //     address tokenB,
    //     address pair
    // ) public view returns (uint reserveA, uint reserveB) {
    //     (address token0, ) = sortTokens(tokenA, tokenB);
    //     assembly {
    //         mstore(
    //             128,
    //             0x0902f1ac00000000000000000000000000000000000000000000000000000000
    //         )
    //         let _4 := staticcall(gas(), pair, 128, 4, 128, 96)
    //         let ok := 0x0
    //         if _4 {
    //             if returndatasize() {
    //                 ok := 0x01
    //             }
    //         }

    //         if ok {
    //             let _reserve0 := mload(128)
    //             let _reserve1 := mload(add(128, 32))
    //             switch eq(tokenA, token0)
    //             case 0x01 {
    //                 reserveA := _reserve0
    //                 reserveB := _reserve1
    //             }
    //             default {
    //                 reserveA := _reserve1
    //                 reserveB := _reserve0
    //             }
    //         }
    //     }
    // }
    
    
    //  function getAmountsOut( 
    //     uint amountIn,
    //     uint k,
    //     address[] memory pairs,
    //     address[] memory path
    //     ) internal view returns (uint[] memory amounts) {
    //     require(path.length >= 2, 'PancakeLibrary: INVALID_PATH');
    //     amounts = new uint[](path.length);
    //     amounts[0] = amountIn;
    //     for (uint i; i < path.length - 1; i++) {
    //         (uint reserveIn, uint reserveOut) = getReserves(path[i], path[i + 1],pairs[i]);
    //         amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut,k);
    //     }
    // }


    function getAmountsOut(
        uint amountIn,
        uint k,
        address[] memory pairs,
        address[] memory path
    ) internal view returns (uint[] memory amounts) {
     assembly {
            function sortTokens(tokenA, tokenB) -> token0, token1 {
                switch lt(tokenA, tokenB)
                case true {
                    token0 := tokenA
                    token1 := tokenB
                }
                default {
                    token0 := tokenB
                    token1 := tokenA
                }
            }

            function getReserves(tokenA, tokenB, pair) -> reserveA, reserveB {
                let token0, _ := sortTokens(tokenA, tokenB)
                 let freeMemoryPointer := mload(0x40)
                mstore(
                    freeMemoryPointer,
                    0x0902f1ac00000000000000000000000000000000000000000000000000000000
                )
                let _4 := staticcall(gas(), pair, freeMemoryPointer, 4, freeMemoryPointer, 96)
                let ok := 0x0
                if _4 {
                    if returndatasize() {
                        ok := 0x01
                    }
                }

                if ok {
                    let _reserve0 := mload(freeMemoryPointer)
                    let _reserve1 := mload(add(freeMemoryPointer, 32))
                    switch eq(tokenA, token0)
                    case 0x01 {
                        reserveA := _reserve0
                        reserveB := _reserve1
                    }
                    default {
                        reserveA := _reserve1
                        reserveB := _reserve0
                    }
                }
            }
            function getAmountOut(gamountIn, reserveIn, reserveOut, gk)
                -> amountOut
            {
                let amountInWithFee := mul(gamountIn,gk)
                let numerator := mul(amountInWithFee,reserveOut)
                let denominator := add(mul(10000,reserveIn),amountInWithFee)
                amountOut :=div(numerator,denominator)
        
            }

            function memory_array_index(baseRef, index) -> addr {
                addr := add(add(baseRef, mul(index, 32)), 32)
            }

            function getAmountsOut(gamountIn, gk, gpairs, gpath) -> gamounts {
                let len := mload(gpath)
                gamounts:=mload(64)
                let newFreePtr := add(gamounts, add(mul(len, 32), 32))
                mstore(64, newFreePtr)
                mstore(gamounts, len)
                mstore(add(gamounts, 32), gamountIn)
                //mstore(add(gamounts, 64), 10000000)
                for {let i := 0} lt(i, sub(len, 1)) {i := add(i, 1)} {
                    let reserveIn, reserveOut := getReserves(
                        mload(memory_array_index(gpath, i)),
                        mload(memory_array_index(gpath, add(i, 1))),
                        mload(memory_array_index(gpairs, i))
                    )
                    let amounts_i_add_1 := getAmountOut(
                        mload(memory_array_index(gamounts, i)),
                        reserveIn,
                        reserveOut,
                        gk
                    )
                  mstore(memory_array_index(gamounts,add(i,1)),amounts_i_add_1)
                }
            }
            
            
            amounts:=getAmountsOut(amountIn,k,pairs,path)
            
        }


    }


    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut,
        uint k
    ) internal pure returns (uint amountOut) {
       
        require(amountIn > 0, "PancakeLibrary: INSUFFICIENT_INPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "PancakeLibrary: INSUFFICIENT_LIQUIDITY"
        );
        uint amountInWithFee = SafeMath.mul(amountIn, k);
        uint numerator = SafeMath.mul(amountInWithFee, reserveOut);
        uint denominator = SafeMath.add(
            SafeMath.mul(reserveIn, 10000),
            amountInWithFee
        );
        amountOut = numerator / denominator;
    }

    // function _swap(
    //     uint[] memory amounts,
    //     address[] memory path,
    //     address[] memory pairs,
    //     address _to
    // ) internal {
    //     for (uint i; i < path.length - 1; i++) {
    //         (address input, address output) = (path[i], path[i + 1]);
    //         (address token0, ) = sortTokens(input, output);
    //         uint amountOut = amounts[i + 1];
    //         (uint amount0Out, uint amount1Out) = input == token0
    //             ? (uint(0), amountOut)
    //             : (amountOut, uint(0));
    //         address to = i < path.length - 2 ? pairs[i + 1] : _to;
    //         IPancakePair(pairs[i]).swap(amount0Out, amount1Out, to, "");
    //     }
    // }
    
    function _swap(
        uint[] memory samounts,
        address[] memory spath,
        address[] memory spairs,
        address s_to
    ) internal  {
      assembly{
          function sortTokens(tokenA, tokenB) -> token0, token1 {
                switch lt(tokenA, tokenB)
                case 0x01 {
                    token0 := tokenA
                    token1 := tokenB
                }
                default {
                    token0 := tokenB
                    token1 := tokenA
                }
            }
            
            function memory_array_index(baseRef, index) -> addr {
                addr := add(add(baseRef, mul(index, 32)), 32)
            }
            
                let len := mload(spath)
                for {let i := 0} lt(i, sub(len, 1)) {i := add(i, 1)} {
                    let input := mload(memory_array_index(spath,i)) 
                    let output := mload(memory_array_index(spath,add(i,1))) 
                    let token0, _ := sortTokens(input, output)
                    let amountOut := mload(memory_array_index(samounts,add(i,1)))
                    let amount0Out, amount1Out
                    switch eq(input, token0)
                    case 0x01 {
                        amount0Out := 0x0
                        amount1Out := amountOut
                    }
                    default {
                        amount0Out := amountOut
                        amount1Out := 0x0
                    }
                    
                    let to 
                    switch lt(i, sub(len,2))
                    case 0x01 {
                        to:=mload(memory_array_index(spairs,add(i,1)))
                    }
                    default {
                      to:=s_to
                    }
                    let ptoken:= mload(memory_array_index(spairs,i))
                    let freeMemoryPointer := mload(0x40)
                    mstore(freeMemoryPointer, 0x022c0d9f00000000000000000000000000000000000000000000000000000000)
                    mstore(add(freeMemoryPointer, 4), amount0Out)
                    mstore(add(freeMemoryPointer, 36), amount1Out) 
                    mstore(add(freeMemoryPointer, 68), to)
                    mstore(add(freeMemoryPointer, 100), 0x80)
                    //164 = 3*32+32*2 +4
                    let isok :=call(gas(), ptoken, 0, freeMemoryPointer, 164, 0, 0)
                    if iszero(isok) {
                        revert(3, 3)
                    }
                }
                
         } 
            
    }
}
