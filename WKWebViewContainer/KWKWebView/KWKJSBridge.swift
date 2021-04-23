//
//  KWKJSBridge.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/22.
//

import UIKit
import WebKit
import SwiftyJSON

class KWKJSBridge: NSObject {
    
    var webView: KWKWebView
    
    init(webView: KWKWebView) {
        self.webView = webView
    }
    
    func wkUserScript() -> String {
        let path = Bundle.main.path(forResource: "KWKJSBridge", ofType: "js")
        var kWKJSBridge = try? String(contentsOfFile: path!, encoding: .utf8)

        #if DEBUG
        return kWKJSBridge!
        #else
        kWKJSBridge = kWKJSBridge!.replacingOccurrences(of: "\n", with: "")
        kWKJSBridge = kWKJSBridge!.replacingOccurrences(of: " ", with: "")
        return kWKJSBridge!
        #endif
    }
    
    fileprivate func reflectPlugin(_ plugin: String, funcName: String, params: Dictionary<String, Any>) {
        let projectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let pluginClass = NSClassFromString("\(projectName).\(plugin)") as? NSObject.Type
        let selector = Selector("\(funcName):webView:")
        
        if pluginClass?.responds(to: selector) != nil {
            let performClass = pluginClass?.init()
            performClass?.perform(selector, with: params, with: self.webView)
        }
        
        // TODO 记录历史操作
    }
}

// MARK: - WKScriptMessageHandler
extension KWKJSBridge: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if GlobalSetting.scriptMessageHandlerArray.contains(message.name) {
            let body = JSON(message.body)["body"]
            
            let plugin = body["plugin"].stringValue
            let funcName = body["funcName"].stringValue
            
            let dictionary: [String: Any] = [
                "params": body["params"].dictionaryValue,
                "callbackId": body["callbackId"].stringValue
            ]
            
            reflectPlugin(plugin, funcName: funcName, params: dictionary)
        }
    }
}

// MARK: - WKScriptMessageHandlerWithReply
/// available(iOS 14, *)
extension KWKJSBridge: WKScriptMessageHandlerWithReply {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
        if GlobalSetting.scriptMessageHandlerArray.contains(message.name) {
            let body = JSON(message.body)["body"]
            
            let plugin = body["plugin"].stringValue
            let funcName = body["func"].stringValue
            
            let dictionary: [String: Any] = [
                "params": body["params"].dictionaryValue,
                "callbackId": body["callbackId"].stringValue
            ]
            
            reflectPlugin(plugin, funcName: funcName, params: dictionary)
        }
    }
}

enum ViewActionMode: String {
    
    /// js 打开原生页面
    case OpenSettings = "openSettings"
    
    /// 重新加载WKWebView
    case Reload = "reload"
    
    /// WKWebView返回
    case Back = "goBack"
    
    /// WKWebView前进
    case Forward = "goForward"
    
    /// 获取定位经纬度
    case Location = "location"
    
    /// 打开箱机拍照或选取相册照片
    case Image = "image"
    
    /// 预览图片
    case Preview = "preview"
    
    /// 呼叫电话
    case Call = "call"
}
