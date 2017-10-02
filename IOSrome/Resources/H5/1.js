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
var str = '<a href="ios:showDetail:'
var end = '"><div <div class="fl"><p>'
var end1 = '</p><span>'
var end2 = '</span></div><span style="float:right;color:#00c30e">立即查看</span></a>';

function callBack(html, url){
	var obj = eval('('+html+')');
	var message = obj.message;
    if(message.length > 0){
        for(var i = message.length-1; i >= 0; i--){
            var item = document.createElement('li');
            item.className = 'bill01';
            
            var outA = document.createElement('a');
            outA.href = 'ios:showDetail:' + message[i].id;
            
            var divImg = document.createElement('div');
            divImg.className = 'fl mr20';
            var img = document.createElement('img');
            img.src = 'icon03.png';
            img.alt = 'alert';
            divImg.appendChild(img);
            
            var divTitle = document.createElement('div');
            divTitle.className = 'fl';
            var title = document.createElement('p');
            title.innerHTML = message[i].title;
            var date = document.createElement('span');
            date.innerHTML = message[i].date;
            divTitle.appendChild(title);
            divTitle.appendChild(date);
            
            var check = document.createElement('span');
            check.style = 'float:right;color:#00c30e';
            check.innerHTML = '立即查看';
            
            
            outA.appendChild(divImg);
            outA.appendChild(divTitle);
            outA.appendChild(check);
            
            item.appendChild(outA);
            
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
