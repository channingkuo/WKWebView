//
//  GlobalSettings.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/24.
//

import UIKit
import Foundation

class GlobalSetting{
    /// 是否第一次打开应用
    static var isFirstOpen: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isFirstOpen")
            return v == nil ? false : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isFirstOpen")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Token
    static var authToken: String {
        get{
            let v = UserDefaults.standard.value(forKey: "authToken")
            return v == nil ? "" : v as! String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "authToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Base URL
    static var xrmWebApiBaseUrl: String {
        get{
            let v = UserDefaults.standard.value(forKey: "baseApiUrl")
            return v == nil ? "" : v as! String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "baseApiUrl")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// HTML5版本号
    static var wwwVersion: String {
        get{
            let v = UserDefaults.standard.value(forKey: "wwwVersion")
            return v == nil ? "1.0.0.0" : v as! String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "wwwVersion")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// 调试模式
    static var isHTMLDebug: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isHTMLDebug")
            return v == nil ? false : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isHTMLDebug")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// WKWebview Config
    static var minFontSize: CGFloat {
        get{
            let v = UserDefaults.standard.value(forKey: "minFontSize")
            return v == nil ? 0 : v as! CGFloat
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "minFontSize")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isShowHorizontalScrollIndicator: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isShowHorizontalScrollIndicator")
            return v == nil ? false : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isShowHorizontalScrollIndicator")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isShowVerticalScrollIndicator: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isShowVerticalScrollIndicator")
            return v == nil ? false : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isShowVerticalScrollIndicator")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isAllowsBackForwardGestures: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isAllowsBackForwardGestures")
            return v == nil ? true : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isAllowsBackForwardGestures")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isjavaScriptEnabled: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isjavaScriptEnabled")
            return v == nil ? true : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isjavaScriptEnabled")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isAutomaticallyJavaScript: Bool {
        get{
            let v = UserDefaults.standard.value(forKey: "isAutomaticallyJavaScript")
            return v == nil ? true : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isAutomaticallyJavaScript")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var scriptMessageHandlerArray: [String] {
        get{
            let v = UserDefaults.standard.value(forKey: "scriptMessageHandlerArray")
            return v == nil ? ["kWKWebView"] : v as! [String]
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "scriptMessageHandlerArray")
            UserDefaults.standard.synchronize()
        }
    }
}
