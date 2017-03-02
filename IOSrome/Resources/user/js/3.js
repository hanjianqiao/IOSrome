function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.data;
    document.getElementById("inv").innerHTML=ja.invitation_remain;
    document.getElementById("ext").innerHTML=ja.extend_remain;
    document.getElementById("tot").innerHTML=ja.invitee_total;
    document.getElementById("vip").innerHTML=ja.invitee_vip;
    document.getElementById("age").innerHTML=ja.invitee_agent;
    document.getElementById("tea").innerHTML=ja.team_total;
}
function updateDisplay(userId, password){
	LanJsBridge.getDataFromUrl("https://user.hanjianqiao.cn:10000/query?id="+userId+"&pwd="+password, "callBack")
}