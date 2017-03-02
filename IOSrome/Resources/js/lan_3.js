function get(name){
   if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
      return decodeURIComponent(name[1]);
}

function callBack(html, url){
	var obj = eval('('+html+')');
	var ja = obj.message;
	var jo = ja[0];
	document.getElementById("intro").innerHTML = jo.title;
	document.getElementById("price").innerHTML = jo.price;
	document.getElementById("introimg").src = jo.image;
	document.getElementById("selllink").href = "huitao:http://pub.alimama.com/promo/search/index.htm?q="+encodeURIComponent(jo.url);
	document.getElementById("taodetail").href = "ios:showTaobaoDetail:"+jo.url;
}
function doWork(q){
	//LanJsBridge.getDataFromUrl("https://shop.hanjianqiao.cn:30002/query?id="+get('id'), "callBack")
	LanJsBridge.getDataFromUrl("http://user.hanjianqiao.cn:7010/query?id="+q, "callBack")
}
