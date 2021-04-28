'use strict';

//Object.defineProperty(exports, '__esModule', { value: true });
var KWKJSB = /** @class */ (function () {
    function KWKJSB () {
        // this._KWKJSBridge = KWKJSBridge;
    }

    /**
      * 测试方法
      * @param {(data) => void} callback 回调方法获取返回值
      */
    KWKJSB.test = function (callback) {
        const params = {
            'name': 'hello world'
        };

        KWKJSBridge.command('test', params, callback);
    };

    /**
      * 打开App的设置页面
      * @param {number} mode 设置页面打开方式，0: modal、1: NavigationController push，默认为0
      */
    KWKJSB.openSettings = function (mode) {
        const params = {
            'mode': mode
        };

        KWKJSBridge.command('openSettings', params);
    };

    /**
     * 模拟浏览器刷新当前页
     */
    KWKJSB.reload = function () {
        KWKJSBridge.command('reload');
    };

    /**
     * 模拟浏览器后退
     */
    KWKJSB.goBack = function () {
        KWKJSBridge.command('goBack');
    };

    /**
     * 模拟浏览器前进
     */
    KWKJSB.goForward = function () {
        KWKJSBridge.command('goForward');
    };

    /**
     * 获取定位信息
     * @param {number} precision 定位精度，默认100m
     * @param {(data) => void} callback 回调方法获取返回值
     */
    KWKJSB.location = function (precision, callback) {
        const params = {
            'precision': precision
        };

        KWKJSBridge.command('location', params, callback);
    };
    
    /**
      * 获取照片
      * @param {number} type type: 0调起相机拍摄照片，type: 1调起相册选择照片
      * @param {boolean} allowsEditing 能否编辑
      * @param {(data) => void} callback 回调方法获取返回值
      */
    KWKJSB.choosePhoto = function (type, allowsEditing, callback) {
        const params = {
            'type': type,
            'allowsEditing': allowsEditing
        };
        
        KWKJSBridge.command('choosePhoto', params, callback);
    };

    /**
     * 预览图片
     * @param {string} imageUrl 图片路径：可以是网络路径、可以是base64、可以是本地路径
     */
    KWKJSB.previewImage = function (imageUrl) {
        const params = {
            'data': imageUrl
        };

        KWKJSBridge.command('previewImage', params);
    };

    /**
     * 调起打电话
     * @param {string} phoneNumber 电话号码：手机、固话
     */
    KWKJSB.call = function (phoneNumber) {
        const params = {
            'phoneNumber': phoneNumber
        };

        KWKJSBridge.command('call', params);
    };

    return KWKJSB;
}());

//exports.KWKJSB = KWKJSB;
