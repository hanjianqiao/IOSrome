
var target;
var searchKey;

function get(name){
   if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
      return decodeURIComponent(name[1]);
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
	var status = obj.status;
    var ja = obj.message;

    if(ja.length > 0){
		for(var i = 0; i < ja.length; i++){
            var jo = ja[i];
            var item = document.createElement('div');
            item.className = 'product-item';
            var outA = document.createElement('a');
            outA.href = 'ios:showDetail:' + jo.good_id;
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
            
            outA.appendChild(img);
            outA.appendChild(title);
            outA.appendChild(priceDiv);
            item.appendChild(outA);
            target.appendChild(item);
        }
        //LanJsBridge.callInMain("lastStage0", "");
        lastStage0();
    }else{
        if(query_type == '0'){
            nowLoad = -20;
            query_type = '1';
            LanJsBridge.callInMain("loadMore", "");
        }else{
            //LanJsBridge.callInMain("lastStage1", "");
            lastStage1();
        }
    }
}

function doWork(q){
    searchKey = q;
	target = document.getElementsByClassName('product-list')[0];
	LanJsBridge.getDataFromUrlUpdateInMain("http://self.vsusvip.com:7080/search"+q, "callBack")
}
