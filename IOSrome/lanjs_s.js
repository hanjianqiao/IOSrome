var goodid, userid, shopid, tbtoken;
var showIt;

function decodeHtml(html) {
    var txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
}

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
    return url.indexOf("h5.m.taobao.com/awp/core/detail.htm") > 0 || url.indexOf("detail.m.tmall.com/item.htm") > 0
    || url.indexOf("detail.m.liangxinyao.com/item.htm") > 0 || url.indexOf("?id=") > 0;
}

// general brokerage
var spTkRates;
var tkRate;

function updateGeneralBrokerageItemCallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        try{
            var ja = obj.data.campaignList;
            for(var i = 0; i < ja.length; i++){
                var innerText = "";
                var jo = ja[i];
                innerText += "<td>" + jo.campaignName + "</td><td>" + (jo.properties == "3" ? "是" : "否");
                if(jo.campaignId == '0'){
                    innerText += "</td><td style=\"color:#fe2641\">" + tkRate + "%</td><td>";
                }else{
                    innerText += "</td><td id=\"camp_"+jo.campaignId+"\" style=\"color:#fe2641\">" + jo.avgCommissionToString + "</td><td>";
                }
                //innerText += "<a href=\"https://pub.alimama.com/promo/search/index.htm?q=https%3A%2F%2Fitem.taobao.com%2Fitem.htm%3Fid%3D"+ goodid+"&yxjh=-1\"";
                innerText += "<a href=\"https://pub.alimama.com/myunion.htm?#!/promo/self/campaign?campaignId="+jo.campaignId+"&shopkeeperId="+jo.shopKeeperId+"&userNumberId="+userid+"\"";
                innerText += "<button class=\"btn_02\">申请计划</button></a></td>";
                var item = document.createElement("tr");
                item.innerHTML = innerText;
                document.getElementById("plantable").appendChild(item);
            }
        }catch(err){}
    }catch(err){
        document.getElementById("plantitle").innerHTML = "请<a href=loginalimama:show style=\"color:red\"><b>登陆</b></a>后查看详情<br>若您已登陆，则访问受限，请稍后再试。";
    }
}

function updateGeneralBrokerageItem(memberId){
    LanJsBridge.getDataFromUrlUpdateInMain("https://pub.alimama.com/shopdetail/campaigns.json?oriMemberId="+memberId, "updateGeneralBrokerageItemCallBack");
}


function updateGeneralBrokerageItem2CallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        try{
            var ja = obj.data;
            for(var i = 0; i < ja.length; i++){
                var innerText = "";
                var jo = ja[i];
                innerText += "<td>" + jo.CampaignName+ "</td><td>" + jo.Properties;
                    innerText += "</td><td id=\"camp_"+jo.CampaignID+"\" style=\"color:#fe2641\">" + jo.commissionRate + "%</td><td>";
                //innerText += "<a href=\"https://pub.alimama.com/promo/search/index.htm?q=https%3A%2F%2Fitem.taobao.com%2Fitem.htm%3Fid%3D"+ goodid+"&yxjh=-1\"";
                innerText += "<a href=\"https://pub.alimama.com/myunion.htm?#!/promo/self/campaign?campaignId="+jo.CampaignID+"&shopkeeperId="+jo.ShopKeeperID+"&userNumberId="+userid+"\"";
                innerText += "<button class=\"btn_02\">申请计划</button></a></td>";
                var item = document.createElement("tr");
                item.innerHTML = innerText;
                document.getElementById("plantable").appendChild(item);
            }
        }catch(err){}
    }catch(err){
        document.getElementById("plantitle").innerHTML = "请<a href=loginalimama:show style=\"color:red\"><b>登陆</b></a>后查看详情<br>若您已登陆，则访问受限，请稍后再试。";
    }
}

function updateGeneralBrokerageItem2(goodId){
    LanJsBridge.getDataFromUrlUpdateInMain("https://pub.alimama.com/pubauc/getCommonCampaignByItemId.json?itemId="+goodId, "updateGeneralBrokerageItem2CallBack");
}

function alimamaCheckCallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        if(obj.url){
            document.getElementById("alimamacheck").href = obj.url;
        }
    }catch(e){
        document.getElementById("alimamacheck").href = url;
    }
}

function updateGeneralBrokerageCallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        if(obj.url){
            document.getElementById("alimamacheck").style.display = "block";
            LanJsBridge.getDataFromUrlUpdateInMain(obj.url, "alimamaCheckCallBack");
        }else if(obj.data.head.status == "NORESULT"){
            document.getElementById("genbrorate").innerHTML="0%";
            document.getElementById("days30sell").innerHTML="0";
            document.getElementById("givebro").innerHTML = "0";
            document.getElementById("plantitle").innerHTML="没有计划";
        }else{
            var dataList = obj.data.pageList[0];
            document.getElementById("genbrorate").innerHTML = (showIt ? dataList.tkRate : "??")+"%";
            document.getElementById("days30sell").innerHTML = (showIt ? dataList.totalNum : "??");
            document.getElementById("givebro").innerHTML = (showIt ? dataList.totalFee : "??");
            userid = dataList.sellerId;
            spTkRates = dataList.tkSpecialCampaignIdRateMap;
            tkRate = dataList.tkRate;
            if(showIt){
                try{
                    var innerText = "";
                    innerText += "<td>";
                    innerText += dataList.couponInfo;
                    innerText += "</td><td>";
                    innerText += dataList.couponEffectiveEndTime;
                    innerText += "</td><td>";
                    innerText += "后台推广可见";
                    innerText += "</td>";
                    var item = document.createElement("tr");
                    item.innerHTML = innerText;
                    document.getElementById("coupontable").appendChild(item);
                }catch(err){
                }
                updateGeneralBrokerageItem(dataList.sellerId);
                //updateGeneralBrokerageItem2(goodid);
            }
        }
    }catch(err){
        document.getElementById("genbrorate").innerHTML="0%";
        document.getElementById("days30sell").innerHTML="0";
        document.getElementById("givebro").innerHTML = "0";
        document.getElementById("plantitle").innerHTML="没有计划";
    }
}

function updateGeneralBrokerage(){
    LanJsBridge.getDataFromUrlSynch("https://pub.alimama.com/items/search.json?q=https://item.taobao.com/item.htm?id="+goodid+"&perPageSize=50", "updateGeneralBrokerageCallBack");
}

// queqiao brokerage

function updateQueqiaoBrokerageItemCallBack(htmlText, url){
    if(htmlText.startsWith("{\"status\":404")){
        document.getElementById("queqiaotitle").innerHTML = "没有鹊桥活动";
        return;
    }
    var jObject = eval('('+htmlText+')');
    var ja = jObject.data;
    for(var i = 0; i < ja.length; i++) {
        var innerText = "";
        var jo = ja[i];
        innerText += "<td>" + jo.event_id + "</td><td>";
        innerText += jo.end_time + "</td><td style=\"color:#fe2641\">";
        innerText += jo.final_rate + "%</td><td>";
        innerText += "<a href=https://temai.taobao.com/preview.htm?id=" + jo.event_id + ">" + "<button class=\"btn_02\" >查看计划</button>" + "</a></td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("queqiaotable").appendChild(item);
    }
}

function updateQueqiaoBrokerageItem(goodId){
    //LanJsBridge.getDataFromUrl("http://zhushou.taokezhushou.com/api/v1/queqiaos/"+goodId, "updateQueqiaoBrokerageItemCallBack");
}

function updateQueqiaoBrokerageCallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        if(obj.data.head.status == "NORESULT"){
            //document.getElementById("queqiaotitle").innerHTML="没有鹊桥佣金";
            document.getElementById("queqiaorate").innerHTML = "0%";
            return;
        }
        var jo = obj.data.pageList[0];
        try{
            document.getElementById("queqiaorate").innerHTML = (showIt ? (jo.eventRate ? jo.eventRate : "0") : "??")+"%";
        }catch (err){
            document.getElementById("queqiaorate").innerHTML = (showIt?"0%":"??%");
        }
        document.getElementById("genlick").href = (showIt ? ((jo.eventRate || jo.eventRate == '0') ? ("https://pub.alimama.com/promo/item/channel/index.htm?q=https%3A%2F%2Fitem.taobao.com%2Fitem.htm%3Fid%3D"+ goodid+"&channel=qqhd&yxjh=-1") : ("https://pub.alimama.com/promo/search/index.htm?q=https%3A%2F%2Fitem.taobao.com%2Fitem.htm%3Fid%3D"+ goodid+"&yxjh=-1")) : "");
        try {
            if(showIt){
                updateQueqiaoBrokerageItem(goodid);
            }
        }catch (err){
            //alert(err.message);
            document.getElementById("queqiaotitle").innerHTML="没有鹊桥佣金";
        }
    }catch(e){}
}

function updateQueqiaoBrokerage(){
    LanJsBridge.getDataFromUrlUpdateInMain("https://pub.alimama.com/items/search.json?q=https://item.taobao.com/item.htm?id="+goodid+"&perPageSize=50", "updateQueqiaoBrokerageCallBack")
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
        if(showIt){
            innerText += "<button class=\"btn_02\" onclick=setClipboard(\"http://shop.m.taobao.com/shop/coupon.htm?seller_id=" + userid +"&activity_id=" + url.substring(url.indexOf("activity_id=")+12, url.length) + "\")>点击复制</button>";
        }else{
            innerText += "<button class=\"btn_02\">VIP可复制</button>";
        }
        innerText += "</td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("coupontable").appendChild(item);
    }
}

function updateTaobaoCouponItem(sellerId, activityId){
    LanJsBridge.getDataFromUrlUpdateInMain("http://shop.m.taobao.com/shop/coupon.htm?seller_id="+sellerId+"&activity_id="+activityId, "updateTaobaoCouponItemCallBack");
}

function updateTaobaoCouponCallBack(htmlText, url){
    try{
        if(htmlText[2] == "{"){
            var obj = eval('('+htmlText+')');
            var ja = obj.priceVolumes;
            if(Object.keys(ja).length == 0){
                //document.getElementById("lantaotic").innerHTML="<caption>没有优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
                return;
            }
            for(var i = 0; i < ja.length; i++){
                var activityId = ja[i].id;
                var innerText = "";
                innerText += "<td>"+ja[i].condition+"</td><td>";
                innerText += ja[i].timeRange;
                innerText += "</td><td>";
                if(showIt){
                    innerText += "<button class=\"btn_02\" onclick=setClipboard(\"http://shop.m.taobao.com/shop/coupon.htm?seller_id=" + userid +"&activity_id=" + activityId + "\")>点击复制</button>";
                }else{
                    innerText += "<button class=\"btn_02\">VIP可复制</button>";
                }
                innerText += "</td>";
                var item = document.createElement("tr");
                item.innerHTML = innerText;
                document.getElementById("coupontable").appendChild(item);
                //updateTaobaoCouponItem(userid, activityId);
            }
        }
        else{
            document.getElementById("coupontitle").innerHTML="<a href=logintaobao:show style=\"color:red\"><b>登陆淘宝</b></a>获取更多优惠信息";
        }
        
    }catch(e){
        document.getElementById("coupontitle").innerHTML="<a href=logintaobao:show style=\"color:red\"><b>登陆淘宝</b></a>获取更多优惠信息";
    }
}

function updateTaobaoCoupon(){
    LanJsBridge.getDataFromUrlUpdateInMain("https://cart.taobao.com/json/GetPriceVolume.do?sellerId="+userid, "updateTaobaoCouponCallBack");
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
        if(showIt){
            innerText += "<button class=\"btn_02\" onclick=setClipboard(\"http://shop.m.taobao.com/shop/coupon.htm?seller_id=" + userid +"&activity_id=" + url.substring(url.indexOf("activity_id=")+12, url.length) + "\")>点击复制</button>";
        }else{
            innerText += "<button class=\"btn_02\">VIP可复制</button>";
        }
        innerText += "</td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("coupontable").appendChild(item);
    }
}

function updateTKZSCouponItem(sellerId, activityId){
    LanJsBridge.getDataFromUrlUpdateInMain("http://shop.m.taobao.com/shop/coupon.htm?seller_id="+sellerId+"&activity_id="+activityId, "updateTKZSCouponItemCallBack");
}


function updateTKZSCoupon2ItemCallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        var ja = obj.result;
        var start = ja.startFee;
        var amount = ja.amount;
        var status = ja.retStatus;
        if(status != 0){
            return;
        }
        var innerText = "";
        innerText += "<td>";
        htmlText = htmlText.substring(htmlText.indexOf("coupon-info"), htmlText.indexOf("立刻领用"));
        innerText += "满"+start+"减"+amount;
        innerText += "</td><td>";
        innerText += ja.effectiveEndTime;
        innerText += "</td><td>";
        if(showIt){
            innerText += "<button class=\"btn_02\" onclick=setClipboard(\"http://shop.m.taobao.com/shop/coupon.htm?seller_id=" + userid +"&activity_id=" + url.substring(url.indexOf("activityId=")+11, url.length) + "\")>点击复制</button>";
        }else{
            innerText += "<button class=\"btn_02\">VIP可复制</button>";
        }
        innerText += "</td>";
        var item = document.createElement("tr");
        item.innerHTML = innerText;
        document.getElementById("coupontable").appendChild(item);
    }catch(e){}
}

function updateTKZSCoupon2Item(sellerId, activityId){
    LanJsBridge.getDataFromUrlUpdateInMain("https://uland.taobao.com/cp/coupon?"+"itemId="+goodid+"&activityId="+activityId, "updateTKZSCoupon2ItemCallBack");
}


function updateTKZSCouponCallBack(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        var ja = obj.dataList;
        if(Object.keys(ja).length == 0){
            //document.getElementById("lanTKZtic").innerHTML="<caption>没有优惠券</caption><tr style=\"background: #fe2641; color:#fff;\"><th>优惠券</th><th>使用时间</th><th>手机券</th></tr>";
            return;
        }
        for(var i = 0; i < ja.length; i++){
            var activityId = ja[i].activityId;
            updateTKZSCoupon2Item(userid, activityId);
        }
    }catch(e){}
}

function updateTKZSCoupon(){
    LanJsBridge.getDataFromUrl("http://zhushou4.taokezhushou.com/api/v1/tip?version=6.0.0.0", "callBackNull");
}

// Dataoke coupon
function callBackgetDataokeInfo(htmlText, url){
    str0 = htmlText.substring(htmlText.indexOf('activity_id=')+12, htmlText.length);
    str0 = str0.substring(0, str0.indexOf('"'));
    LanJsBridge.getDataFromUrlUpdateInMain("https://uland.taobao.com/cp/coupon?"+"itemId="+goodid+"&activityId="+str0, "updateTKZSCoupon2ItemCallBack");
}

function getDataokeInfo(dtkid){
    LanJsBridge.getDataFromUrl("http://www.dataoke.com/gettpl?gid="+dtkid, "callBackgetDataokeInfo");
}

function callBackDataoke(htmlText, url){
    if(htmlText.indexOf('goods-items_') > 0 && htmlText.indexOf('data_goodsid') > 0){
        dataokeid = htmlText.substring(htmlText.indexOf('goods-items_')+12, htmlText.indexOf('data_goodsid')-2);
        getDataokeInfo(dataokeid);
    }
}

function updateDataokeCouponTwice(){
    LanJsBridge.getDataFromUrlWithRefer("http://www.dataoke.com/search/?keywords="+goodid+"&xuan=spid", "http://www.dataoke.com/search/?keywords="+goodid+"&xuan=spid", "callBackDataoke");
}

function updateDataokeCoupon(){
    LanJsBridge.getDataFromUrlWithRefer("http://www.dataoke.com/search/?keywords="+goodid+"&xuan=spid", "http://www.dataoke.com/search/?keywords="+goodid+"&xuan=spid", "updateDataokeCouponTwice");
}

// Qingtaoke coupon
function updateQingtaokeCouponCallback(htmlText, url){
    try{
        var obj = eval('('+htmlText+')');
        var ja = obj.data;
        for(var i = 0; i < ja.length; i++){
            var jo = ja[i];
            var innerText = "";
            innerText += "<td>";
            if(jo.applyAmount == '0' && jo.amount == '0'){
                innerText += "优惠券";
            }else{
                innerText += "满"+jo.applyAmount+"可减"+jo.amount;
            }
            innerText += "</td><td>";
            if(showIt){
                innerText += "<a href=webpage:"+"https://market.m.taobao.com/apps/aliyx/coupon/detail.html?wh_weex=true&activityId=" + jo.activityId +"&sellerId=" + jo.sellerId+" style=\"color:red\"><b>请点击查看优惠券详情</b></a>";
            }else{
                innerText += "<button class=\"btn_02\">VIP可复制</button>";
            }
            innerText += "</td><td>";
            if(showIt){
                innerText += "<button class=\"btn_02\" onclick=setClipboard(\"https://market.m.taobao.com/apps/aliyx/coupon/detail.html?wh_weex=true&activityId=" + jo.activityId +"&sellerId=" + jo.sellerId + "\")>点击复制</button>";
            }else{
                innerText += "<button class=\"btn_02\">VIP可复制</button>";
            }
            innerText += "</td>";
            var item = document.createElement("tr");
            item.innerHTML = innerText;
            document.getElementById("coupontable").appendChild(item);
        }
    }catch(e){
    }
    
}

function updateQingtaokeCoupon(){
    LanJsBridge.getDataFromUrl("http://www.qingtaoke.com/api/UserPlan/UserCouponList?sid="+userid+"&gid="+goodid, "updateQingtaokeCouponCallback")
}

function imgAutoFit(a, b){
    WebViewJavaScriptBridge1.test0();
    WebViewJavaScriptBridge1.test1('a');
    WebViewJavaScriptBridge1.have('a','b');
    return b;
}

function callBackNothing(htmlString, url){
}
function callBackNull(htmlString, url){
    LanJsBridge.getDataFromUrl("http://zhushou4.taokezhushou.com/api/v1/coupon?sellerId="+userid+"&itemId="+goodid, "updateTKZSCouponCallBack");
}

function callBackShowAlert(htmlString, url){
    alert(htmlString);
    return ''
}

function doWork(srcUrl, showit){
    showIt = showit;
    if(!isDetailPage(srcUrl)){
        LanJsBridge.notValidUrl();
        return 'Invaliad';
    }
    goodid = getGoodID(srcUrl);
    
    tbtoken = LanJsBridge.getCookie("_tb_token_", "https://pub.alimama.com/")

    updateGeneralBrokerage();
    updateQueqiaoBrokerage();
    updateTaobaoCoupon();
    updateTKZSCoupon();
    updateDataokeCoupon();
    updateQingtaokeCoupon();
    return 'success'
}

function copyToken(any){
    var ret = "";
    if(location.href.startsWith('https://pub.alimama.com/myunion.htm')){
        var holder = document.getElementsByClassName('tab-content')[0].children;
        for(var i = 0; i < holder.length; i++){
            var item = holder[i];
            if(item.style.display === 'block'){
                ret += item.getElementsByClassName('getcode-box')[0].getElementsByClassName('textarea')[0].innerHTML;
                break;
            }
        }
    }else if(location.href.startsWith('https://pub.alimama.com/promo')){
        var tokens = document.getElementsByClassName("code-wrap-s");
        var tokenl = document.getElementsByClassName("code-wrap-l");
        for(var i = 0; i < tokens.length; i++){
            var htmlText = tokens[i].innerHTML;
            var startIndex = htmlText.indexOf("class=\"label\"");
            while(htmlText[startIndex] != ">"){startIndex++;}
            startIndex++;
            var endIndex = startIndex;
            while(htmlText[endIndex] != "<"){endIndex++;}
            ret += htmlText.substring(startIndex, endIndex);
            
            startIndex = htmlText.indexOf("value=");
            while(htmlText[startIndex] != "\""){startIndex++;}
            startIndex++;
            endIndex = startIndex;
            while(htmlText[endIndex] != "\""){endIndex++;}
            
            ret += htmlText.substring(startIndex, endIndex);
            ret += "\n"
        }
        for(var i = 0; i < tokenl.length; i++){
            var htmlText = tokenl[i].innerHTML;
            var startIndex = htmlText.indexOf("\"clipboard-target\"");
            while(htmlText[startIndex] != ">"){startIndex++;}
            startIndex++;
            var endIndex = startIndex;
            while(htmlText[endIndex] != "<"){endIndex++;}
            ret += htmlText.substring(startIndex, endIndex);
            ret += "\n"
        }
    }
    return ret;
}


