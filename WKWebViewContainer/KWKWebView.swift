//
//  KWKWebView.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2020/10/16.
//

import UIKit
import WebKit

@IBDesignable
class KWKWebView: UIView {
    
    /// 穿透事件主体——事件由谁发起
    fileprivate var target: AnyObject?
    
    /// WKWebView 加载HTML
    fileprivate var webView = WKWebView()
    
    /// 进度条
    fileprivate var progressView = UIProgressView()
    
    /// WKWebView配置项
    fileprivate let configuretion = WKWebViewConfiguration()
    
    /// 执行JS 需要实现代理方法
    fileprivate var excuteJavaScript = String()
    
    /// 是否是第一次加载
    fileprivate var firstLoad: Bool?
    
    /// WebView配置项
    var webConfig : KWKWebViewConfig?
    
    /// TODO 设计一个Class保存请求的所有记录
    fileprivate var snapShotsArray: Array<Any>?
    
    /// 设置代理
    weak var delegate: WKWebViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    fileprivate func buildInterface(webConfig: KWKWebViewConfig) {
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = webConfig.minFontSize
        configuretion.preferences.javaScriptEnabled = webConfig.isjavaScriptEnabled
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = webConfig.isAutomaticallyJavaScript
        configuretion.userContentController = WKUserContentController()
        
        _ = webConfig.scriptMessageHandlerArray.map{configuretion.userContentController.add(self, name: $0)}
        
        webView = WKWebView(frame: frame, configuration: configuretion)
        
        // 开启手势交互
        webView.allowsBackForwardNavigationGestures = webConfig.isAllowsBackForwardGestures
        
        // 滚动条
        webView.scrollView.showsVerticalScrollIndicator = webConfig.isShowScrollIndicator
        webView.scrollView.showsHorizontalScrollIndicator = webConfig.isShowScrollIndicator
        
        // 监听支持KVO的属性
        //webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView.sizeToFit()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.addSubview(webView)
    }
    
    func load(_ target: AnyObject, _ kWKWebLoadType: KWKWebLoadType) {
        self.target = target
        
        buildInterface(webConfig: webConfig ?? KWKWebViewConfig())
        
        switch kWKWebLoadType {
        case .HTML(let name):
            loadLocalHTML(fileName: name)
        case .URL(let urlString):
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            webView.load(request)
        case .POST(let url, parameters: let jsonString): break
            print(url)
            print(jsonString)
        }
    }
    
    fileprivate func loadLocalHTML(fileName: String) {
        let wwwBundleURL = Bundle.main.url(forResource: "www", withExtension: "bundle")!
        let htmlURL = wwwBundleURL.appendingPathComponent("www", isDirectory: true)
        let htmlFileURL = URL(fileURLWithPath: htmlURL.path + "/index.html")

        do {
            let html = try String(contentsOfFile: htmlFileURL.path, encoding: String.Encoding.utf8)

//            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            webView.loadFileURL(htmlFileURL, allowingReadAccessTo: htmlURL)
        } catch { }
        
//        let path = Bundle.main.path(forResource: fileName, ofType: "html")
//        // 获得html内容
//        do {
//            let html = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
//            // 加载js
//            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
//        } catch { }
    }
}

// MARK: - WKScriptMessageHandler
extension KWKWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let scriptMessage = webConfig?.scriptMessageHandlerArray {
            self.delegate?.webViewUserContentController(scriptMessage, didReceive: message)
        }
    }
}

// MARK: - WKNavigationDelegate
extension KWKWebView: WKNavigationDelegate {
    
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
    }
}

// MARK: - WKUIDelegate 不实现该代理方法 网页内调用弹窗时会抛出异常,导致程序崩溃
extension KWKWebView: WKUIDelegate {
    
    // 获取js 里面的提示
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler()
        }))
        target?.present(alert, animated: true, completion: nil)
    }
    
    // js 信息的交流
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        target?.present(alert, animated: true, completion: nil)
    }
    
    // 交互 可输入的文本。
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(alert.textFields![0].text!)
        }))
        target?.present(alert, animated: true, completion: nil)
    }
}
