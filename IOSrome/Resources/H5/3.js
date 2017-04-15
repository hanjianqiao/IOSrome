function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.data;
    document.getElementById("tot").innerHTML=ja.invitee_total;
    document.getElementById("vip").innerHTML=ja.invitee_vip;
    document.getElementById("newvip").innerHTML=ja.newvip;
    document.getElementById("newextend").innerHTML=ja.newextend;
}
function updateDisplay(userId, password){
	LanJsBridge.getDataFromUrl("https://user.vsusvip.com:10000/query?id="+userId+"&pwd="+password, "callBack")
}
