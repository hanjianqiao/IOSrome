function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.data;
    document.getElementById("tot").innerHTML=ja.invitee_total;
    document.getElementById("vip").innerHTML=ja.invitee_vip;
    document.getElementById("newvip").innerHTML=ja.newvip;
    document.getElementById("newextend").innerHTML=ja.newextend;
    if(ja.level == "vip"){
        document.getElementById("level").innerHTML = "会员"
    }else if(ja.level == "agent"){
        document.getElementById("level").innerHTML = "代理"
    }else if(ja.level == "golden"){
        document.getElementById("level").innerHTML = "金牌代理"
    }else if(ja.level == "cofound"){
        document.getElementById("level").innerHTML = "联合创始人"
    }else{
        document.getElementById("level").innerHTML = "用户"
    }
}
function updateDisplay(userId, password){
	LanJsBridge.getDataFromUrl("https://user.vsusvip.com:10000/query?id="+userId+"&pwd="+password, "callBack")
}
