var target = document.getElementsByClassName('product-list')[0];

var str0 = '<a href="ios:showDetail:'
var str1 = '"><i>领券<br>减'
var str2 = '</i><span class="money02">佣金'
var str3 = '%</span><img src="'
var str4 = '" alt=""><h4>'
var str5 = '</h4></a><div class="clearfix price"><strong>￥'
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

function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.message;
	if(ja.length > 0){
		for(var i = 0; i < ja.length; i++){
			var jo = ja[i];
		    var item = document.createElement('div');
		    var att = document.createAttribute('class');
		    att.value = 'product-item';
		    item.setAttributeNode(att);
		    item.innerHTML = str0 + jo.good_id + str1 + jo.off + str2 + jo. rate + str3 + jo.image + str4 + jo.title + str5 + jo.price + str6 + jo.sell + str7;
		    target.appendChild(item);
		}
        document.getElementById('pull2up').innerHTML = '点击加载更多'
    }else{
        document.getElementById('pull2up').innerHTML = '没有更多的商品<br>都不满意？请关注微信公众号“小牛快淘”，并回复您的商品需求，3小时内极速上架！'
        document.getElementById('pull2up').onclick = ''
        var item = document.createElement('p');
        item.innerHTML = '';
        target.appendChild(item);
	}
}

function doWork(){
	//LanJsBridge.getDataFromUrl("https://shop.hanjianqiao.cn:30002/search?key="+get('catalog'), "callBack")
    var catalog = get('catalog');
    if(catalog == null) catalog = '0';
    var activity = get('activity');
    if(activity == null) activity = '0';
	LanJsBridge.getDataFromUrl("http://user.hanjianqiao.cn:7010/search?catalog="+catalog+"&activity="+activity, "callBack")
}
