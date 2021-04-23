var KWKJSBridge = {

  callAPI: (funcName, params, callBack) => {
    var message;
    var plugin = 'KWKJSBridge';
    var callBackId = plugin + '_' + funcName + '_' + 'CallBack';

    if (callBack) {
      if (!JSBridgeEvent._listeners[callBackId]) {
        JSBridgeEvent.addEvent(callBackId, function (data) {
          callBack(data);
        });
      }
    }

    if (callBack) {
      message = { 'plugin': plugin, 'func': funcName, 'params': params, 'callBackID': callBackId };
    } else {
      message = { 'plugin': plugin, 'func': funcName, 'params': params };
    }

    window.webkit.messageHandlers.kWKWebView.postMessage(message);
  },

  callBack: (callBackID, data) => {
    JSBridgeEvent.fireEvent(callBackID, data);
  },

  removeAllCallBacks: () => {
    JSBridgeEvent._listeners = {};
  }
};

var KWKJSBridgeEvent = {

  _listeners: {},

  addEvent: (type, fn) => {
    if (typeof this._listeners[type] === "undefined") {
      this._listeners[type] = [];
    }
    if (typeof fn === "function") {
      this._listeners[type].push(fn);
    }

    return this;
  },

  fireEvent: (type, param) => {
    var arrayEvent = this._listeners[type];
    if (arrayEvent instanceof Array) {
      for (var i = 0, length = arrayEvent.length; i < length; i += 1) {
        if (typeof arrayEvent[i] === "function") {
          arrayEvent[i](param);
        }
      }
    }

    return this;
  },

  removeEvent: (type, fn) => {
    var arrayEvent = this._listeners[type];
    if (typeof type === "string" && arrayEvent instanceof Array) {
      if (typeof fn === "function") {
        for (var i = 0, length = arrayEvent.length; i < length; i += 1) {
          if (arrayEvent[i] === fn) {
            this._listeners[type].splice(i, 1);
            break;
          }
        }
      } else {
        delete this._listeners[type];
      }
    }

    return this;
  }
};
