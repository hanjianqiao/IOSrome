var target = document.getElementsByClassName('product-list')[0];
var shouIt = false;

var str0 = '<a href="ios:showDetail:'
var str1 = '"><i>券减<br>'
var str2 = '</i><span class="money02">佣金'
var str3 = '%</span><img src="'
var str4 = '" alt=""><h4>'
var str5 = '</h4><div class="clearfix price"><strong>￥'
var str6 = '</strong><small>售出<em>'
var str7 = '</em>件</small></div></a>';

function get(name){
    if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search)){
        var ret = decodeURIComponent(name[1]);
        ///alert(ret);
        if(ret == null)
            return '0';
        else
            return ret;
    }
}

function lastStage0(para){
    sel = document.getElementById('pull2up');
    sel.innerHTML = '点击加载更多'
}
function lastStage1(para){
    sel = document.getElementById('pull2up');
    sel.innerHTML = '没有更多的商品<br>都不满意？请关注微信公众号“小牛快淘”，并回复您的商品需求，3小时内极速上架！'
    sel.onclick = ''
}

function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.message;
	if(ja.length > 0){
		for(var i = 0; i < ja.length; i++){
			var jo = ja[i];
		    var item = document.createElement('div');
		    item.className = 'product-item';
            var outA = document.createElement('a');
            outA.href = 'ios:showDetail:' + jo.good_id;
            outA.innerHTML = str0 + jo.good_id + str1 + jo.off + str2 + (showIt?jo. rate:'?') + str3 + jo.image + str4 + jo.title + str5 + jo.price + str6 + jo.sell + str7;
            item.appendChild(outA);
		    target.appendChild(item);
        }
        LanJsBridge.callInMain("lastStage0", "");
    }else{
        LanJsBridge.callInMain("lastStage1", "");

    }
}

function doWork(isVip){
    showIt = isVip;
	//LanJsBridge.getDataFromUrl("https://user.vsusvip.com:30002/search?key="+get('catalog'), "callBack")
    var catalog = get('catalog');
    if(catalog == null) catalog = '0';
    var activity = get('activity');
    if(activity == null) activity = '0';
    if(activity == '0' && catalog == '0') activity = '5';
	LanJsBridge.getDataFromUrl("http://shop.vsusvip.com:7011/search?catalog="+catalog+"&activity="+activity, "callBack")
}
