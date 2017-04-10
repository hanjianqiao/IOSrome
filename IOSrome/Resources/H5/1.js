var str = '<a href="ios:showDetail:'
var end = '"><div class="fl mr20"><img src="icon03.png" alt=""></div><div class="fl"><p>'
var end1 = '</p><span>立即查看</span></div></a>';
var target;
var nowLoad = 0;
var uid;
var passwd;
function lastStage0(para){
    sel = document.getElementById('pull2up');
    sel.innerHTML = '点击加载更多';
}
function lastStage1(para){
    sel = document.getElementById('pull2up');
    sel.innerHTML = '已显示全部消息';
    sel.onclick = '';
}
function callBack(html, url){
	var obj = eval('('+html+')');
	var message = obj.message;
    if(message.length > 0){
        for(var i = message.length-1; i >= 0; i--){
            var item = document.createElement('li');
            var att = document.createAttribute('class');
            att.value = 'bill01';
            item.setAttributeNode(att);
            item.innerHTML = str+message[i].id+end+message[i].title+end1;
            target.appendChild(item);
        }
        LanJsBridge.callInMain("lastStage0", "");
    }else{
        LanJsBridge.callInMain("lastStage1", "");
    }
}

function updateDisplay(userId, password){
    uid = userId;
    passwd = password;
    var limit = 20;
    target = document.getElementById('messagelist');
    LanJsBridge.getDataFromUrl("http://user.vsusvip.com:30000/list?userid="+userId+"&password="+password+"&offset="+nowLoad+"&limit="+limit, "callBack");
}

function loadMore(){
    var limit = 20;
    nowLoad = nowLoad+limit;
    LanJsBridge.getDataFromUrl("http://user.vsusvip.com:30000/list?userid="+uid+"&password="+passwd+"&offset="+nowLoad+"&limit="+limit, "callBack");
}
