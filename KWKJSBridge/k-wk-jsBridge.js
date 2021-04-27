'use strict';

Object.defineProperty(exports, '__esModule', { value: true });
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

        KWKJSBridge.command('goForward', params, callback);
    };

    return KWKJSB;
}());

exports.KWKJSB = KWKJSB;
