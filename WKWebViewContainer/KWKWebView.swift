//
//  KWKWebView.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2020/10/16.
//

import UIKit
import WebKit

class KWKWebView: WKWebView, WKNavigationDelegate {
    
    init(frame: CGRect) {
        super.init(frame: frame, configuration: WKWebViewConfiguration.init())
        
        self.frame = frame
        self.navigationDelegate = self
                
//        let htmlFilePathURL = Bundle.main
        let wwwBundleURL = Bundle.main.url(forResource: "www", withExtension: "bundle")!
        let htmlURL = wwwBundleURL.appendingPathComponent("www", isDirectory: true)
        let htmlFileURL = URL(fileURLWithPath: htmlURL.path + "/index.html")
        print(htmlURL.path)
        print(htmlFileURL.path)
        self.loadFileURL(htmlFileURL, allowingReadAccessTo: htmlURL)
    }
    
    init(frame: CGRect, url: String) {
        super.init(frame: frame, configuration: WKWebViewConfiguration.init())
        
        self.frame = frame
        
        self.load(URLRequest(url: URL(string: url)!))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载...")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("内容开始返回...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成!")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载失败 error:" + error.localizedDescription)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("进程被终止")
        print(webView.url)
        
    }
}
