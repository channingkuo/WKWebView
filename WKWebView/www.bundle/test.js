/**type="text/javascript"
 1.KWKWebView服务器传值固定写法，当然valueName是自己随意定制的
 2.body就是值的内容，也可以传一个空的字符串，具体什么格式自己和后台同事商量测试
 3.支付宝H5支付是需要后台进行配置的和APP无关系，除非是H5转Native支付
 4.微信H5支付小公司很难申请下来，我们可以采取此方法，当用户点击微信支付按钮时将参数通过JS的方式
   我们直接进行截取再调用本地微信客户端进行支付
 */

document.getElementById("sec").innerHTML = new Date();

localStorage["userInfo"] = JSON.stringify({ token: 'qwertyuioplkjhgfdsazxcvbnm' });

function jSBridgeTest() {
    KWKJSB.test(res => {
        document.getElementById('callback').innerHTML = res;
    })
}

function openSettings () {
    KWKJSB.openSettings(0);
}
function getLocation () {
    KWKJSB.location(100, resp => {
        console.log(resp);
        document.getElementById('callback').innerHTML = resp;
    });
}
function chooseImage (type) {
    KWKJSB.choosePhoto(type, false, resp => {
        var resp = JSON.parse(resp)
        console.log(resp);
        document.getElementById("chooseImage").src = resp.url;
        document.getElementById('callback').innerHTML = resp.url;
    });
}
function previewImage (data) {
    KWKJSB.previewImage(data);
}
function previewImageTest () {
    KWKJSB.previewImage(document.getElementById("chooseImage").src);
}
function call () {
    KWKJSB.call("10000");
}
