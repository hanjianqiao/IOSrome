function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.message;
    document.getElementById("title").innerHTML=ja.title;
    document.getElementById("value").innerHTML=ja.value;
    document.getElementById("level").innerHTML=ja.level;
    document.getElementById("start").innerHTML=ja.start;
    document.getElementById("end").innerHTML=ja.end;
    document.getElementById("no").innerHTML=ja.no;
}
function updateDisplay(userId, password, messageId){
	LanJsBridge.getDataFromUrl("https://user.hanjianqiao.cn:40000/detail?id="+messageId+"&userid="+userId+"&password="+password, "callBack")
}