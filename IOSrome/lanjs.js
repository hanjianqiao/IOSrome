var srcurl = window.location.href;
var goodid, userid, shopid, tbtoken;

function RegexItem(f, c, b) {
    try {
        var a = c.exec(f);
        return a[b]
    } catch (d) {}
    return null
}

function getGoodID(a) {
    var b = /[&|?]id=(\d+)/g;
    return RegexItem(a, b, 1)
}


function setLanJPanel(text){
    document.getElementById("LanJPanel").innerHTML=text;
}

function isDetailPage(url){
    return url.indexOf("h5.m.taobao.com/awp/core/detail.htm") > 0 || url.indexOf("detail.m.tmall.com/item.htm") > 0;
}

function insertAfter(newNode, referenceNode) {
    referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function prepareLanJPanel(url){
    var JP = document.createElement("section");
    var att = document.createAttribute("id");
    att.value = "LanJPanel";
    JP.setAttributeNode(att);
    insertAfter(JP, document.getElementById("s-price"));
    var initialHtml = "<p id=\"langenrat\"></p><p id=\"lan30dsel\"></p><br><br>";
    initialHtml += "<table id=\"langenbro\" width=\"100%\" border=\"1\"></table><br><br>";
    initialHtml += "<table id=\"lanquebro\" width=\"100%\" border=\"1\"></table><br><br>";
    initialHtml += "<table id=\"lantaotic\" width=\"100%\" border=\"1\"></table><br><br>";
    initialHtml += "<table id=\"lanTKZtic\" width=\"100%\" border=\"1\"></table><br><br>";
    setLanJPanel(initialHtml);
}

function updateGlobalInfo(){
    //document.getElementById("langenrat").innerHTML="General Taobrokerage";
    //document.getElementById("lan30dsel").innerHTML="Sells in 30 days";
}
function updateGeneralBrokerageCallBack(htmlText){
    var obj = eval('('+htmlText+')');
    if(obj.data.head.status == "NORESULT"){
        document.getElementById("langenbro").innerHTML="<caption>没有计划</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>人工审核</th><th>佣金比例</th><th>申请计划</th></tr>";
    }else{
        var dataList = obj.data.pageList[0];
        document.getElementById("langenrat").innerHTML="&nbsp&nbsp<span>通用佣金比例：</span>&nbsp&nbsp<span>"+dataList.tkRate+"%</span>&nbsp&nbsp<a style=\"color:#fe2641\" href=http://pub.alimama.com/promo/search/index.htm?q=https%3A%2F%2Fitem.taobao.com%2Fitem.htm%3Fid%3D"+ goodid + ">生成推广链接</a>";
        document.getElementById("lan30dsel").innerHTML="&nbsp&nbsp<span>30天推广：<span>"+dataList.totalNum+"</span>件</span>&nbsp&nbsp<span >支出佣金：<span id=\"Lan30DayOut\">"+dataList.totalFee+"</span>元</span>";
        var processedText = "<caption>计划详情</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>人工审核</th><th>佣金比例</th><th>申请计划</th></tr>";
        document.getElementById("langenbro").innerHTML=processedText;
    }
}
function updateGeneralBrokerage(){
    LanJsBridge.getDataFromUrl("http://pub.alimama.com/items/search.json?q=https://item.taobao.com/item.htm?id="+goodid+"&perPageSize=50", "updateGeneralBrokerageCallBack");
}

function updateQueqiaoBrokerage(){
    document.getElementById("lanquebro").innerHTML="<caption>没有鹊桥佣金</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>剩余天数</th><th>实得佣金比例</th><th>操作</th></tr>";
    //LanJsBridge.getDataFromUrl('http://pub.alimama.com/shopdetail/campaigns.json?oriMemberId=2120743977', 'callBackShowAlert')
}

function updateTaobaoCoupon(){
    document.getElementById("lantaotic").innerHTML="<caption>没有优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
}

function updateTKZSCoupon(){
    document.getElementById("lanTKZtic").innerHTML="<caption>没有优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
    
    //LanJsBridge.getDataFromUrl('http://zhushou3.taokezhushou.com/api/v1/coupons_base/725677994', 'callBackShowAlert')
}


function imgAutoFit(a, b){
    WebViewJavaScriptBridge1.test0();
    WebViewJavaScriptBridge1.test1('a');
    WebViewJavaScriptBridge1.have('a','b');
    return b;
}

function callBackShowAlert(htmlString){
    //alert(htmlString);
    return ''
}

function doWork(){
    if(!isDetailPage(srcurl) || document.getElementById("LanJPanel")){
        return 'Invaliad';
    }
    
    prepareLanJPanel(srcurl);
    goodid = getGoodID(srcurl);
    
    updateGlobalInfo();
    updateGeneralBrokerage();
    updateQueqiaoBrokerage();
    updateTaobaoCoupon();
    updateTKZSCoupon();
    return 'success'
}
