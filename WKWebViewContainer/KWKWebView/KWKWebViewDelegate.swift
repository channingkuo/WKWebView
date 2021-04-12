//
//  KWKWebViewDelegate.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2021/3/18.
//

import Foundation
import WebKit

protocol WKWebViewDelegate: class {
    
    /// 服务器开始请求的时候调用
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    
    /// 页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    
    /// 页面加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    
    /// 跳转失败的时候调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    
    /// 内容加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    
    /// 执行JS注入方法
    func webViewUserContentController(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage)
    
    /// JS执行回调方法
    func webViewEvaluateJavaScript(_ result: Any?, error: Error?)
    
    /// JS执行结果直接返回给Web，Promise resolve
    func webView(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage, resolve replyHandler: @escaping (Any?, String?) -> Void)
}
