document.getElementById("sec").innerHTML = new Date();

localStorage["userInfo"] = JSON.stringify({ token: 'qwertyuioplkjhgfdsazxcvbnm' });

function jSBridgeTest() {
    var params = {
        'name': 'hello world jack!!!'
    };

    KWKJSBridge.command("test", params, res => {
        document.getElementById('callback').innerHTML = res;
        
    });
}

/**type="text/javascript"
 1.KWKWebView服务器传值固定写法，当然valueName是自己随意定制的
 2.body就是值的内容，也可以传一个空的字符串，具体什么格式自己和后台同事商量测试
 3.支付宝H5支付是需要后台进行配置的和APP无关系，除非是H5转Native支付
 4.微信H5支付小公司很难申请下来，我们可以采取此方法，当用户点击微信支付按钮时将参数通过JS的方式
   我们直接进行截取再调用本地微信客户端进行支付
 */
function test () {
  window.webkit.messageHandlers.kWKWebView.postMessage({ body: 'I come Here' });
}
function openSettings () {
  /**
   action: openSettings  /reload         /goBack      /forward      /location  /image
   ------- 打开原生页面/重新加载WKWebView/WKWebView返回/WKWebView前进/获取定位信息 /打开相机拍照或选取相册照片
   action: preview   /call
   ------- 原生预览图片/打电话
   
   type: action为openSettings时,控制打开的方式，0: Modal打开、1: NavigationController push;默认为0
   type: action为image时，控制打开相机还是相册，0: 打开相机、1: 打开相册、2: 弹出sheet可选择;默认为0
   distance: action为location时，定位进度，默认为100
   allowsEditing: action为image时，控制是否允许进行编辑照片，true/false
   data: action为preview时，图片资源：本地路径、base64、http/https网络地址
   phoneNumber: action为call时，电话号码
   */
  window.webkit.messageHandlers.kWKWebView.postMessage({
    body: {
      action: 'openSettings',
      type: 0
    }
  });
}
function getLocation () {
  window.webkit.messageHandlers.kWKWebView.postMessage({
    body: {
      action: 'location',
      distance: 10
    }
  }).then((replay, err) => {
    document.getElementById("callback").innerHTML = new Date().getTime() + "<br />" + replay;
  });
}
function chooseImage (type) {
  window.webkit.messageHandlers.kWKWebView.postMessage({
    body: {
      action: 'image',
      type: type,
      allowsEditing: true
    }
  }).then((replay, err) => {
    let resp = JSON.parse(replay)
    document.getElementById("chooseImage").src = resp.url;
    document.getElementById("callback").innerHTML = resp.url;
  });
}
function previewImage (data) {
  window.webkit.messageHandlers.kWKWebView.postMessage({
    body: {
      action: 'preview',
      data: data
    }
  });
}
function previewImageTest () {
  window.webkit.messageHandlers.kWKWebView.postMessage({
    body: {
      action: 'preview',
      data: document.getElementById("chooseImage").src
    }
  });
}
function call () {
  window.webkit.messageHandlers.kWKWebView.postMessage({
    body: {
      action: 'call',
      data: "10000"
    }
  });
}
