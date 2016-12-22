var tbtoken;

function updateListCallBack(htmlText, url){
    if(htmlText.startsWith("<!")){
        var item = document.createElement("tr");
        item.innerHTML = "请登陆";
        document.getElementById("lanSec").appendChild(item);
        return;
    }
    var obj = eval('('+htmlText+')');
    var list = obj.data.paymentList;
    for(var i = 0; i < list.length; i++){
        var l = list[i];
        var item = document.createElement("tr");
        item.innerHTML = l.auctionTitle;
        document.getElementById("lanSec").appendChild(item);
    }
}

function updateList(){
    LanJsBridge.getDataFromUrl("http://pub.alimama.com/report/getTbkPaymentDetails.json?startTime=2016-12-15&endTime=2016-12-21&payStatus=&queryType=1&toPage=1&perPageSize=20&_tb_token_="+tbtoken+"&_input_charset=utf-8", "updateListCallBack");
}

function doWork(srcUrl, showit){
    tbtoken = LanJsBridge.getCookie("_tb_token_", "http://pub.alimama.com/")
    updateList();
    return 'success'
}

