function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.data;
    document.getElementById("balance").innerHTML=ja.balance;
}
function updateDisplay(userId, password){
	LanJsBridge.getDataFromUrl("https://user.hanjianqiao.cn:10000/query?id="+userId+"&pwd="+password, "callBack")
}