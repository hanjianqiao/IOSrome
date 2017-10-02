var str0 = '<div class="top"><span class="fl top-left">';
var str1 = '</span><span class="fr green">';
var str2 = '</span></div><div class="btm"><span class="fl mr03">';
var str3 = '</span><span class="fr">成功</span>';
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
    sel.innerHTML = '已显示全部账单';
    sel.onclick = '';
}
function callBack(html, url){
    var obj = eval('('+html+')');
    var message = obj.message;
    if(message.length > 0){
        for(var i = message.length-1; i >= 0; i--){
            var item = document.createElement('li');
            item.className = 'bill01';

            var topDiv = document.createElement('div');
            topDiv.className = 'top';
            var spanAction = document.createElement('span');
            spanAction.className = 'fl top-left';
            spanAction.innerHTML = message[i].action;
            var spanAmount = document.createElement('span');
            spanAmount.className = 'fr green';
            spanAmount.innerHTML = message[i].amount;
            topDiv.appendChild(spanAction);
            topDiv.appendChild(spanAmount);
            
            var btmDiv = document.createElement('div');
            btmDiv.className = 'btm';
            var spanDate = document.createElement('span');
            spanDate.className = 'fl mr03';
            spanDate.innerHTML = message[i].date;
            var spanStatus = document.createElement('span');
            spanStatus.className = 'fr';
            spanStatus.innerHTML = '成功';
            btmDiv.appendChild(spanDate);
            btmDiv.appendChild(spanStatus);
            
            item.appendChild(topDiv);
            item.appendChild(btmDiv);
            
            target.appendChild(item)
        }
        LanJsBridge.callInMain("lastStage0", "");
    }else{
        LanJsBridge.callInMain("lastStage1", "");
    }
}
function updateDisplay(userId, password, messageId){
    uid = userId;
    passwd = password;
    var limit = 20;
    target = document.getElementById('billlist');
	LanJsBridge.getDataFromUrl("http://user.vsusvip.com:40000/list?userid="+userId+"&password="+password+"&offset="+nowLoad+"&limit="+limit, "callBack")
}

function loadMore(){
    var limit = 20;
    nowLoad = nowLoad+limit;
    LanJsBridge.getDataFromUrl("http://user.vsusvip.com:40000/list?userid="+uid+"&password="+passwd+"&offset="+nowLoad+"&limit="+limit, "callBack")
}
