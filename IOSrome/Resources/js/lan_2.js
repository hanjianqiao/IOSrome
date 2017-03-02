
var target;

var str0 = '<a href="ios:showDetail:'
var str1 = '"><img src="'
var str2 = '" alt="Here is the image"></a><a href="ios:showDetail:'
var str3 = '"><h4>'
var str4 = '</h4></a><div class="clearfix price"><span>￥'
var str5 = '</span><em>月销<i>'
var str6 = '</i>件</em></div>';

function get(name){
   if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
      return decodeURIComponent(name[1]);
}

function callBack(html, url){
	var obj = eval('('+html+')');
	var status = obj.status;
    var ja = obj.message;

    if(ja.length > 0){
		for(var i = 0; i < ja.length; i++){
			var jo = ja[i];
		    var item = document.createElement('div');
		    var att = document.createAttribute('class');
		    att.value = 'product-item';
		    item.setAttributeNode(att);
		    item.innerHTML = str0 + jo.good_id + str1 + jo.image + str2 + jo. good_id + str3 + jo.title + str4 + jo.price + str5 + jo.sell + str6;
		    target.appendChild(item);
		}
	}else{
		var moreStr = '找不到商品，请换一个关键词';
		var item = document.createElement('p');
		var att = document.createAttribute('style');
		att.value = 'font-size:0.3rem; line-height: 0.9rem; color:#666; text-align:center';
		item.setAttributeNode(att);
		item.innerHTML = moreStr;
		target.appendChild(item);
	}
}

function doWork(q){
	target = document.getElementsByClassName('product-list')[0];
	LanJsBridge.getDataFromUrl("http://user.hanjianqiao.cn:7008/search"+q, "callBack")
}
