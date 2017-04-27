var showIt = false;
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
    if(jo.tb_token && jo.tb_token != ''){
        document.getElementById("selllink").href = "clipboard:"+jo.tb_token;
    }
    else{
        document.getElementById("selllink").href = "clipboard:"+jo.url;
    }
	document.getElementById("taodetail").href = "ios:showTaobaoDetail:"+jo.url;
}
function doWork(q, isVip){
    showIt = isVip;
	//LanJsBridge.getDataFromUrl("https://user.vsusvip.com:30002/query?id="+get('id'), "callBack")
	LanJsBridge.getDataFromUrl("http://shop.vsusvip.com:7010/query?id="+q, "callBack")
}
