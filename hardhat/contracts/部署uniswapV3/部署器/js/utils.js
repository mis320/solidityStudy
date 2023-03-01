
function getWbe3Methods(web30, abi, address) {
    if (abi == undefined) {
        return new web30.eth.Contract(abi.abi, abi.address).methods;
    } else {
        try {
            return new web30.eth.Contract(abi, address).methods;
        } catch (error) {
            console.log(String(error));
        }
    }
}
const fromWei = (etherInput, uint) => {
    return ethUnit.fromWei(etherInput, uint)
}
const toWei = (etherInput, unit) => {
    return ethUnit.toWei(etherInput, unit)
}

const BN = (etherInput, unit) => {
    return new ethUnit.BN(etherInput, unit || 10)
}

function $set(p1, p2) {
    let t = document.getElementById(p1);

    if (
        t.nodeName.toUpperCase() == 'SPAN' ||
        t.nodeName.toUpperCase() == 'P' ||
        t.nodeName.toUpperCase() == 'DIV'
    ) {
        t.innerHTML = p2
    } else if (t.nodeName.toUpperCase() == 'IMG') {
        t.src = p2
    } else {
        t.value = p2
    }
}

function $get(p1) {
    let t = document.getElementById(p1);
    if (t.nodeName.toUpperCase() != 'SPAN') {
        return t.value
    } else {
        return t.innerHTML
    }

}

//../contracts/Lock.sol/Lock.json
async function getJson(URL) {
    const res = await fetch(URL, {
        "headers": {
            "sec-ch-ua": "\"Chromium\";v=\"110\", \"Not A(Brand\";v=\"24\", \"Google Chrome\";v=\"110\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Windows\""
        },
        "referrer": "http://127.0.0.1:5501/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": null,
        "method": "GET",
        "mode": "cors",
        "credentials": "omit"
    }).then(res => res.text()).then(
        data => {
            return data
        }
    );
    return res
}
