var target = document.getElementsByClassName('product-list')[0];
var shouIt = false;

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
            var coponI = document.createElement('i');
            coponI.innerHTML = '券减' + jo.off;
            var rateSpan = document.createElement('span');
            rateSpan.className = 'money02'
            rateSpan.innerHTML = '佣金' + (showIt?jo. rate:'?') + '%';
            var img = document.createElement('img');
            img.src = jo.image;
            img.alt = jo.title;
            var title = document.createElement('h4');
            title.innerHTML = jo.title;
            var priceDiv = document.createElement('div');
            priceDiv.className = 'clearfix price';
            var price = document.createElement('strong');
            price.innerHTML = '￥' + jo.price;
            var small = document.createElement('small');
            small.innerHTML = '售出';
            var sold = document.createElement('em');
            small.appendChild(sold);
            sold.innerHTML = jo.sell + '件';
            priceDiv.appendChild(price);
            priceDiv.appendChild(small);
            
            outA.appendChild(coponI);
            outA.appendChild(rateSpan);
            outA.appendChild(img);
            outA.appendChild(title);
            outA.appendChild(priceDiv);
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
