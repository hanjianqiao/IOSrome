var showIt = false;
function get(name){
   if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
      return decodeURIComponent(name[1]);
}

function callBack(html, url){
	var obj = JSON.parse(html);
	var ja = obj.message;
	var jo = ja[0];
	document.getElementById("intro").innerHTML = jo.title;
	document.getElementById("price").innerHTML = jo.price;
	document.getElementById("introimg").src = jo.image;
    if(showIt){
        document.getElementById("selllink").href = "huitao:http://pub.alimama.com/promo/item/channel/index.htm?q="+encodeURIComponent(jo.url)+"&channel=qqhd";
    }else{
        document.getElementById("selllink").href = "lanalert:您不是VIP不能使用推广功能";
    }
	document.getElementById("taodetail").href = "ios:showTaobaoDetail:"+jo.url;
}
function doWork(q, isVip){
    showIt = isVip;
	//LanJsBridge.getDataFromUrl("https://user.hanjianqiao.cn:30002/query?id="+get('id'), "callBack")
	LanJsBridge.getDataFromUrl("http://user.hanjianqiao.cn:7010/query?id="+q, "callBack")
}
