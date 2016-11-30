var srcurl = window.location.href;
var goodid, userid, shopid, tbtoken;

function imgAutoFit(a, b){
    WebViewJavaScriptBridge1.test0();
    WebViewJavaScriptBridge1.test1('a');
    WebViewJavaScriptBridge1.have('a','b');
    return b;
}

function callBackForUrlGet(htmlString){
    //alert('Hello my name is Lily');
    alert(htmlString);
    return ''
}

function doWork(){
    if(srcurl.indexOf("taobao.com") > 0){
        alert(srcurl)
    }
    LanJsBridge.getDataFromUrl('http://zhushou3.taokezhushou.com/api/v1/coupons_base/725677994', 'callBackForUrlGet')
    LanJsBridge.getDataFromUrl('http://pub.alimama.com/shopdetail/campaigns.json?oriMemberId=2120743977', 'callBackForUrlGet')
    return 'success'
}
