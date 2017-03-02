function callBack(html, url){
	var obj = eval('('+html+')');
    var ja = obj.data;
    document.getElementById("date").innerHTML=ja.expire_year+'年-'+ja.expire_month+'月-'+ja.expire_day+'日';
    document.getElementById("code").innerHTML=ja.code;
}
function updateDisplay(userId, password){
	LanJsBridge.getDataFromUrl("https://user.hanjianqiao.cn:10000/query?id="+userId+"&pwd="+password, "callBack")
}