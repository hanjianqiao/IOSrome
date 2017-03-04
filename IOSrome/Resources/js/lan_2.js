
var target;
var searchKey;

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
        document.getElementById('pull2up').innerHTML = '点击加载更多'
    }else{
        document.getElementById('pull2up').innerHTML = '没有更多的商品<br>都不满意？请关注微信公众号“小牛快淘”，并回复您的商品需求，3小时内极速上架！'
        document.getElementById('pull2up').onclick = ''
        var item = document.createElement('p');
        item.innerHTML = '';
        target.appendChild(item);
        //$(".btn03").removeClass('disNone');
    }
}

function doWork(q){
    searchKey = q;
	target = document.getElementsByClassName('product-list')[0];
	LanJsBridge.getDataFromUrl("http://user.hanjianqiao.cn:7008/search"+q, "callBack")
}
