var str0 = '<div class="top"><span class="fl top-left">';
var str1 = '</span><span class="fr green">';
var str2 = '</span></div><div class="btm"><span class="fl mr03">';
var str3 = '</span><span class="fr">成功</span>';
function callBack(html, url){
	var target = document.getElementsByClassName('bill')[0];
	var obj = eval('('+html+')');
	var message = obj.message;
	for(var i = 0; i < message.length; i++){
	    var item = document.createElement('li');
	    var att = document.createAttribute('class');
	    att.value = 'bill01';
	    item.setAttributeNode(att);
	    item.innerHTML = str0+message[i].action+str1+message[i].amount+str2+message[i].date+str3;
	    target.appendChild(item);
	}
}
function updateDisplay(userId, password, messageId){
	LanJsBridge.getDataFromUrl("https://user.hanjianqiao.cn:40000/list?userid="+userId+"&password="+password, "callBack")
}
