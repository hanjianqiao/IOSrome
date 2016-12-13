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
    document.getElementById("lanSec").innerHTML=text;
}

function isDetailPage(url){
    return url.indexOf("h5.m.taobao.com/awp/core/detail.htm") > 0 || url.indexOf("detail.m.tmall.com/item.htm") > 0;
}

function prepareLanJPanel(url){
    var initialHtml = "<br><p id=\"langenrat\"></p><p id=\"lan30dsel\"></p><p id=\"lanquerat\"></p><br><br>";
    initialHtml += "<table id=\"langenbro\" width=\"100%\" border=\"1\"></table><br><br>";
    initialHtml += "<table id=\"lanquebro\" width=\"100%\" border=\"1\"></table><br><br>";
    initialHtml += "<table id=\"lantaotic\" width=\"100%\" border=\"1\"></table><br><br>";
    initialHtml += "<table id=\"lanTKZtic\" width=\"100%\" border=\"1\"></table><br><br>";
    setLanJPanel(initialHtml);
}

function emptyLanSec(){
    setLanJPanel("")
}

function inforLanSec(){
    setLanJPanel("请在商品页面点击会淘一下")
}

function updateGlobalInfo(){
    //document.getElementById("langenrat").innerHTML="General Taobrokerage";
    //document.getElementById("lan30dsel").innerHTML="Sells in 30 days";
}

// general brokerage
var spTkRates;
var tkRate;

function updateGeneralBrokerageItemCallBack(htmlText, url){
    if(htmlText.startsWith("<!")){
        var item = document.createElement("tr");
        item.innerHTML = "请登陆";
        document.getElementById("langenbro").appendChild(item);
    }
    else{
        var obj = eval('('+htmlText+')');
        var ja = obj.data.campaignList;
        for(var i = 0; i < ja.length; i++){
            var innerText = "";
            var jo = ja[i];
            innerText += "<td>" + jo.campaignName + "</td><td>" + (jo.properties == "3" ? "是" : "否");
            innerText += "</td><td>" + (jo.campaignId == "0" ? tkRate : spTkRates[jo.campaignId]) + "%</td><td>";
            innerText += "<a style=\"color:#fe2641\" href=http://pub.alimama.com/myunion.htm?#!/promo/self/campaign?campaignId=";
            innerText += jo.campaignId + "&shopkeeperId=" + jo.shopKeeperId + ">";
            innerText += "申请计划" + "</a></td>";
            var item = document.createElement("tr");
            item.innerHTML = innerText;
            document.getElementById("langenbro").appendChild(item);
        }
    }
}

function updateGeneralBrokerageItem(memberId){
    LanJsBridge.getDataFromUrl("http://pub.alimama.com/shopdetail/campaigns.json?oriMemberId="+memberId, "updateGeneralBrokerageItemCallBack");
}

function updateGeneralBrokerageCallBack(htmlText, url){
    var obj = eval('('+htmlText+')');
    if(obj.data.head.status == "NORESULT"){
        document.getElementById("langenrat").innerHTML="&nbsp&nbsp<span>没有通用佣金</span>";
        document.getElementById("lan30dsel").innerHTML="&nbsp&nbsp<span>没有推广</span>";
        document.getElementById("langenbro").innerHTML="<caption>没有计划</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>人工审核</th><th>佣金比例</th><th>申请计划</th></tr>";
    }else{
        var dataList = obj.data.pageList[0];
        document.getElementById("langenrat").innerHTML="&nbsp&nbsp<span>通用佣金比例：</span>&nbsp&nbsp<span>"+dataList.tkRate+"%</span>&nbsp&nbsp<a style=\"color:#fe2641\" href=http://pub.alimama.com/promo/search/index.htm?q=https%3A%2F%2Fitem.taobao.com%2Fitem.htm%3Fid%3D"+ goodid + ">生成推广链接</a>";
        document.getElementById("lan30dsel").innerHTML="&nbsp&nbsp<span>30天推广：<span>"+dataList.totalNum+"</span>件</span>&nbsp&nbsp<span >支出佣金：<span id=\"Lan30DayOut\">"+dataList.totalFee+"</span>元</span>";
        var processedText = "<caption>计划详情</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>人工审核</th><th>佣金比例</th><th>申请计划</th></tr>";
        userid = dataList.sellerId;
        spTkRates = dataList.tkSpecialCampaignIdRateMap;
        tkRate = dataList.tkRate;
        document.getElementById("langenbro").innerHTML=processedText;
        updateGeneralBrokerageItem(dataList.sellerId);
    }
}

function updateGeneralBrokerage(){
    LanJsBridge.getDataFromUrlSynch("http://pub.alimama.com/items/search.json?q=https://item.taobao.com/item.htm?id="+goodid+"&perPageSize=50", "updateGeneralBrokerageCallBack");
}

// queqiao brokerage

function updateQueqiaoBrokerageItemCallBack(htmlText, url){
    if(htmlText.startsWith("{\"status\":404")){
        var item = document.createElement("tr");
        item.innerHTML = "没有鹊桥活动";
        document.getElementById("lanquebro").appendChild(item);
        return;
    }
    var jObject = eval('('+htmlText+')');
    var ja = jObject.data;
    for(var i = 0; i < ja.length; i++) {
        var innerText = "";
        var jo = ja[i];
        innerText += "<td>" + jo.event_id + "</td><td>";
        innerText += jo.end_time + "</td><td>";
        innerText += jo.final_rate + "%</td><td>";
        innerText += "<a href=https://temai.taobao.com/preview.htm?id=" + jo.event_id + ">" + "查看计划" + "</a></td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("lanquebro").appendChild(item);
    }
}

function updateQueqiaoBrokerageItem(goodId){
    LanJsBridge.getDataFromUrl("http://zhushou.taokezhushou.com/api/v1/queqiaos/"+goodId, "updateQueqiaoBrokerageItemCallBack");
}

function updateQueqiaoBrokerageCallBack(htmlText, url){
    var obj = eval('('+htmlText+')');
    if(obj.data.head.status == "NORESULT"){
        document.getElementById("lanquebro").innerHTML="<caption>没有鹊桥佣金</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>剩余天数</th><th>实得佣金比例</th><th>操作</th></tr>";
        return;
    }
    var jo = obj.data.pageList[0];
    document.getElementById("lanquerat").innerHTML="&nbsp&nbsp<span>鹊桥佣金比例：</span>&nbsp&nbsp<span>"+jo.eventRate+"%</span>";
    document.getElementById("lanquebro").innerHTML="<caption>高佣金推广活动（新鹊桥）</caption><tr style=\"background: #fe2641; color:#fff; \"><th>鹊桥ID</th><th>结束日期</th><th>实得佣金比例</th><th>操作</th></tr>";
    try {
        updateQueqiaoBrokerageItem(goodid);
    }catch (err){
        alert(err.message);
        document.getElementById("lanquebro").innerHTML="<caption>没有鹊桥佣金</caption><tr style=\"background: #fe2641; color:#fff; \"><th>计划名称</th><th>剩余天数</th><th>实得佣金比例</th><th>操作</th></tr>";
    }
}

function updateQueqiaoBrokerage(){
    LanJsBridge.getDataFromUrl("http://pub.alimama.com/items/search.json?q=https://item.taobao.com/item.htm?id="+goodid+"&perPageSize=50", "updateQueqiaoBrokerageCallBack")
}

// Taobao Coupon

function setClipboard(string){
    //alert("set clipboard")
    LanJsBridge.setClipBoard(string);
}

function updateTaobaoCouponItemCallBack(htmlText, url){
    if(htmlText.indexOf("立刻领用") > 0){
        var innerText = "";
        innerText += "<td>";
        htmlText = htmlText.substring(htmlText.indexOf("coupon-info"), htmlText.indexOf("立刻领用"));
        innerText += htmlText.substring(htmlText.indexOf("满"), htmlText.indexOf("可用")) + "减";
        innerText += htmlText.substring(htmlText.indexOf("<dt>")+4, htmlText.indexOf("优惠券"));
        innerText += "</td><td>";
        innerText += htmlText.substring(htmlText.indexOf("有效期:")+4, htmlText.indexOf("</dl>")-5);
        innerText += "</td><td>";
        innerText += "<button onclick=setClipboard(\"http://shop.m.taobao.com/shop/coupon.htm?seller_id=" + userid +"&activity_id=" + url.substring(url.indexOf("activity_id=")+12, url.length) + "\")>点击复制</button>";
        innerText += "</td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("lantaotic").appendChild(item);
    }
}

function updateTaobaoCouponItem(sellerId, activityId){
    LanJsBridge.getDataFromUrl("http://shop.m.taobao.com/shop/coupon.htm?seller_id="+sellerId+"&activity_id="+activityId, "updateTaobaoCouponItemCallBack");
}

function updateTaobaoCouponCallBack(htmlText, url){
    //alert(htmlText[0]);
    //alert(htmlText[1]);
    //alert(htmlText[2]);
    //alert(htmlText[3]);
    //alert(url);
    if(htmlText[2] == "{"){
        var obj = eval('('+htmlText+')');
        var ja = obj.priceVolumes;
        if(Object.keys(ja).length == 0){
            document.getElementById("lantaotic").innerHTML="<caption>没有优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
            return;
        }
        document.getElementById("lantaotic").innerHTML="<caption>店铺优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
        for(var i = 0; i < ja.length; i++){
            var activityId = ja[i].id;
            updateTaobaoCouponItem(userid, activityId);
        }
    }
    else{
        document.getElementById("lantaotic").innerHTML="<caption>登陆查看优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
        var item = document.createElement("tr");
        item.innerHTML = "请登陆";
        document.getElementById("lantaotic").appendChild(item);
    }
}

function updateTaobaoCoupon(){
    LanJsBridge.getDataFromUrl("https://cart.taobao.com/json/GetPriceVolume.do?sellerId="+userid, "updateTaobaoCouponCallBack");
}

// Taokezhushou Coupon

function updateTKZSCouponItemCallBack(htmlText, url){
    if(htmlText.indexOf("立刻领用") > 0){
        var innerText = "";
        innerText += "<td>";
        htmlText = htmlText.substring(htmlText.indexOf("coupon-info"), htmlText.indexOf("立刻领用"));
        innerText += htmlText.substring(htmlText.indexOf("满"), htmlText.indexOf("可用")) + "减";
        innerText += htmlText.substring(htmlText.indexOf("<dt>")+4, htmlText.indexOf("优惠券"));
        innerText += "</td><td>";
        innerText += htmlText.substring(htmlText.indexOf("有效期:")+4, htmlText.indexOf("</dl>")-5);
        innerText += "</td><td>";
        innerText += "<button onclick=setClipboard(\"http://shop.m.taobao.com/shop/coupon.htm?seller_id=" + userid +"&activity_id=" + url.substring(url.indexOf("activity_id=")+12, url.length) + "\")>点击复制</button>";
        innerText += "</td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("lanTKZtic").appendChild(item);
    }
}

function updateTKZSCouponItem(sellerId, activityId){
    LanJsBridge.getDataFromUrl("http://shop.m.taobao.com/shop/coupon.htm?seller_id="+sellerId+"&activity_id="+activityId, "updateTKZSCouponItemCallBack");
}

function updateTKZSCouponCallBack(htmlText, url){
    var obj = eval('('+htmlText+')');
    var ja = obj.data;
    if(Object.keys(ja).length == 0){
        document.getElementById("lanTKZtic").innerHTML="<caption>没有优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
        return;
    }
    document.getElementById("lanTKZtic").innerHTML="<caption>店铺优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
    for(var i = 0; i < ja.length; i++){
        var activityId = ja[i].activity_id;
        updateTKZSCouponItem(userid, activityId);
    }
}

function updateTKZSCoupon(){
    LanJsBridge.getDataFromUrl("http://zhushou3.taokezhushou.com/api/v1/getdata?itemid="+goodid+"&version=3.5.2", "callBackNull");
    LanJsBridge.getDataFromUrl("http://zhushou3.taokezhushou.com/api/v1/coupons_base/"+userid+"?item_id="+goodid, "updateTKZSCouponCallBack");
}


function imgAutoFit(a, b){
    WebViewJavaScriptBridge1.test0();
    WebViewJavaScriptBridge1.test1('a');
    WebViewJavaScriptBridge1.have('a','b');
    return b;
}

function callBackNull(htmlString, url){
}

function callBackShowAlert(htmlString, url){
    alert(htmlString);
    return ''
}

function doWork(srcUrl){
    if(!isDetailPage(srcUrl)){
        inforLanSec()
        return 'Invaliad';
    }
    if(!LanJsBridge.isVIP()){
        setLanJPanel("购买VIP可启用功能")
        return 'notVIP'
    }
    prepareLanJPanel(srcUrl);
    goodid = getGoodID(srcUrl);
    
    updateGlobalInfo();
    updateGeneralBrokerage();
    updateQueqiaoBrokerage();
    updateTaobaoCoupon();
    updateTKZSCoupon();
    return 'success'
}

function fitSalePosition(x){
    document.getElementById("dialog-singleton").style.left = "" + x + "px";
}


