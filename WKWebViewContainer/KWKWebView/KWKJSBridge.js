const KWKJSBridge = {

	command: function (funcName, params, callback) {
		var message;
		var body;
		var plugin = 'KWKJSCoreBridge';
		var callbackId = plugin + '_' + funcName + '_' + 'callback';

		if (callback) {
			if (!KWKJSBridgeEvent._listeners[callbackId]) {
				KWKJSBridgeEvent.addEvent(callbackId, (data) => {
					callback(data);
				});
			}
		}
		if (callback) {
			body = { 'plugin': plugin, 'func': funcName, 'params': params, 'callbackId': callbackId };
		} else {
			body = { 'plugin': plugin, 'func': funcName, 'params': params };
		}
		message = { body: body };
		window.webkit.messageHandlers.kWKWebView.postMessage(message);
	},

	callback: (callBackID, data) => {
		KWKJSBridgeEvent.fireEvent(callBackID, data);
	},

	removeAllCallBacks: () => {
		KWKJSBridgeEvent._listeners = {};
	}
};

const KWKJSBridgeEvent = {

	_listeners: {},

	addEvent: function (type, fn) {
		if (typeof this._listeners[type] === "undefined") {
			this._listeners[type] = [];
		}
		if (typeof fn === "function") {
			this._listeners[type].push(fn);
		}

		return this;
	},

	fireEvent: function (type, param) {
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

	removeEvent: function (type, fn) {
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
