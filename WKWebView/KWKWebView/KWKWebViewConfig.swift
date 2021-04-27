//
//  KWKWebViewConfig.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/18.
//

import UIKit

struct KWKWebViewConfig {
    
    /// 默认最小字体字体
    public var minFontSize: Int
    
    /// 显示水平滚动条
    public var isShowHorizontalScrollIndicator: Bool
    /// 显示垂直滚动条
    public var isShowVerticalScrollIndicator: Bool
    
    /// 开启手势交互
    public var isAllowsBackForwardGestures: Bool
    
    /// 是否允许加载javaScript
    public var isjavaScriptEnabled: Bool
    
    /// 是否允许JS自动打开窗口的，必须通过用户交互才能打开
    public var isAutomaticallyJavaScript: Bool
    
    /// WKScriptMessageHandler
    /// 添加一个名称，就可以在JS通过这个名称发送消息：kWKWebView自定义名字
    /// window.webkit.messageHandlers.kWKWebView.postMessage({body: 'xxx'})
    public var scriptMessageHandlerArray: [String]
    
    public var enableWebServer: Bool
    
    init() {
        minFontSize = GlobalSetting.minFontSize
        isShowHorizontalScrollIndicator = GlobalSetting.isShowHorizontalScrollIndicator
        isShowVerticalScrollIndicator = GlobalSetting.isShowVerticalScrollIndicator
        isAllowsBackForwardGestures = GlobalSetting.isAllowsBackForwardGestures
        isjavaScriptEnabled = GlobalSetting.isJavaScriptEnabled
        isAutomaticallyJavaScript = GlobalSetting.isAutomaticallyJavaScript
        scriptMessageHandlerArray = GlobalSetting.scriptMessageHandlerArray
        enableWebServer = GlobalSetting.enableWebServer
    }
}

enum KWKWebLoadType{
    
    /// 加载普通URL
    case URL(url: String)
    
    /// 加载本地HTML index.html
    case HTML(fileName: String?)
    
    /// 加载POST请求(url:请求URL，parameters：请求参数)
    case POST(url: String, parameters: [String:Any])
}
