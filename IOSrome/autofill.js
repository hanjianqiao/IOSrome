function autofill(username, password){
    LanJsBridge.showAlert(username, password);
    LanJsBridge.lanPrint(document.getElementsByTagName('iframe')[0].src);
}
