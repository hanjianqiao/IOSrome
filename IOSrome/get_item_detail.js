

// price and title

function priceAndTitleCallBack(htmlText, url){
    var subStr = htmlText.substring(htmlText.indexOf('s-showcase'), htmlText.indexOf('s-shop'));
    var img = subStr.substring(subStr.indexOf('<img src=')+ 10, subStr.indexOf('alt=')-2);
    var item = document.createElement("tr");
    item.innerHTML = "<img src=\"https:"+img+"\">";
    document.getElementById("lanSec").innerHTML = img;
}

function updatePriceAndTitle(){
    LanJsBridge.getDataFromUrlSynch("https://detail.m.tmall.com/item.htm?id=20004166595", "priceAndTitleCallBack");
}

