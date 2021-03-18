//
//  KWKWebViewConfig.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2021/3/18.
//

import UIKit

struct KWKWebViewConfig {
    
    /// 默认最小字体字体
    public var minFontSize: CGFloat = 0
    
    /// 显示滚动条
    public var isShowScrollIndicator: Bool = false
    
    /// 开启手势交互
    public var isAllowsBackForwardGestures: Bool = true
    
    /// 是否允许加载javaScript
    public var isjavaScriptEnabled: Bool = true
    
    /// 是否允许JS自动打开窗口的，必须通过用户交互才能打开
    public var isAutomaticallyJavaScript: Bool = true
    
    /// 是否影藏进度条
    public var isProgressHidden: Bool = false
    
    /// 进度条高度
    public var progressHeight: CGFloat = 3
    
    /// 默认颜色
    public var progressTrackTintColor: UIColor = UIColor.clear
    
    /// 加载颜色
    public var progressTintColor: UIColor = UIColor.green
    
    /// WKScriptMessageHandler
    /// 添加一个名称，就可以在JS通过这个名称发送消息：kWKWebView自定义名字
    /// window.webkit.messageHandlers.kWKWebView.postMessage({body: 'xxx'})
    public var scriptMessageHandlerArray: [String] = [String]()
}

enum KWKWebLoadType{
    
    /// 加载普通URL
    case URL(url: String)
    
    /// 加载本地HTML(传名字就可以了)
    case HTML(name: String)
    
    /// 加载POST请求(url:请求URL，parameters：请求参数)
    case POST(url: String, parameters: [String:Any])
}
