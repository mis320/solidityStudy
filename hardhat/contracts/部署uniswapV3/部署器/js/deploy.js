async function deploy(web3, contractOBJ, args) {
    contractOBJ = JSON.parse(contractOBJ)
    let accounts
    res = {
        "address": '',
        "blockHash": ''
    }
    //let contract = await $.get(contracttemp)
    console.log(contractOBJ);
    let abi = contractOBJ.abi
    let bytecode = contractOBJ.bytecode
    let endcode = ""
    if (args.length > 0) {
        if (abi[0].type === "constructor") {
            endcode = web3.eth.abi.encodeFunctionCall(abi[0], args)
        } else {
            let localArray;
            for (let index = 0; index < abi.length; index++) {
                const element = abi[index];

                if (element.type == "constructor") {
                    localArray = index;
                    break;

                }
            }
            endcode = web3.eth.abi.encodeFunctionCall(abi[localArray], args)
        }
    }

    endcode = endcode.substring(10)
    console.log(endcode);

    // if (privateKey.length > 21) {
    //     web3.eth.accounts.wallet.clear();
    //     web3.eth.accounts.wallet.add({
    //         privateKey: privateKey
    //     });
    //     accounts = web3.eth.accounts.wallet[0].address
    // } else {
    //     accounts = web3.currentProvider.selectedAddress
    // }

    console.log(bytecode + endcode);
    accounts = web3.currentProvider.selectedAddress
    let gas = await web3.eth.estimateGas({
        from: accounts,
        data: bytecode + endcode,
    })

    console.log(gas);
    let r = await web3.eth.sendTransaction({
        from: accounts,
        data: bytecode + endcode,
        gas: String(parseInt(gas * 1.2)),  //Gas sent with each transaction (default: ~6700000)
        gasPrice: toWei("10", "gwei")
    }
    )
    res.address = r.contractAddress
    res.blockHash = r.blockHash
    return res;
}
