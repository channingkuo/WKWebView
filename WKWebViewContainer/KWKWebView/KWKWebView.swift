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
    
    /// WKWebView配置项
    fileprivate let configuretion = WKWebViewConfiguration()
    
    /// 是否是第一次加载
    fileprivate var firstLoad: Bool = true
    
    /// local web server
    fileprivate var webServer = GCDWebServer()
    
    fileprivate var kWKJSBridge: KWKJSBridge!
    
    /// WebView配置项
    var webConfig: KWKWebViewConfig?
    
    /// 设置代理
    var delegate: KWKNavigationDelegate
    
    /// WKWebView 加载进度代理
    weak var progressDelegate: ProgressDelegate?
    
    override public init(frame: CGRect) {
        delegate = KWKNavigationDelegate()
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        delegate = KWKNavigationDelegate()
        
        super.init(coder: coder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    fileprivate func buildInterface(webConfig: KWKWebViewConfig) {
        configuretion.processPool = WKProcessPool()
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = CGFloat(webConfig.minFontSize)
        configuretion.preferences.javaScriptEnabled = webConfig.isjavaScriptEnabled
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = webConfig.isAutomaticallyJavaScript
        
        kWKJSBridge = KWKJSBridge(webView: self)
        
        let userContentController = WKUserContentController()
        let wkUserScript = WKUserScript(source: kWKJSBridge.wkUserScript(), injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(wkUserScript)
        if #available(iOS 14, *) {
            _ = webConfig.scriptMessageHandlerArray.map{userContentController.addScriptMessageHandler(kWKJSBridge, contentWorld: .page, name: $0)}
        } else {
            _ = webConfig.scriptMessageHandlerArray.map{userContentController.add(kWKJSBridge, name: $0)}
        }
        configuretion.userContentController = userContentController
        
        
        webView = WKWebView(frame: frame, configuration: configuretion)
        // 禁止WKWebView下拉回弹
        webView.scrollView.bounces = false
        
        // 开启手势交互
        webView.allowsBackForwardNavigationGestures = webConfig.isAllowsBackForwardGestures
        
        // 滚动条
        webView.scrollView.showsVerticalScrollIndicator = webConfig.isShowHorizontalScrollIndicator
        webView.scrollView.showsHorizontalScrollIndicator = webConfig.isShowVerticalScrollIndicator
        
        // 监听支持KVO的属性——监听加载进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView.sizeToFit()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.addSubview(webView)
    }
    
    func load(_ target: AnyObject, _ kWKWebLoadType: KWKWebLoadType) {
        self.target = target
        
        webConfig = webConfig ?? KWKWebViewConfig()
        buildInterface(webConfig: webConfig!)
        
        switch kWKWebLoadType {
        case .HTML(let fileName):
            if !webConfig!.enableWebServer {
                loadLocalWebServerHTML(fileName: fileName)
            } else {
                loadLocalHTML(fileName: fileName)
            }
            break
        case .URL(let urlString):
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            webView.load(request)
            break
        case .POST(let url, parameters: let jsonString):
            print(url)
            print(jsonString)
            break
        }
    }
    
    func excuteJavaScript(javaScript script: String?) {
        if let script = script {
            webView.evaluateJavaScript(script) { result, error in
                print(error ?? "")
                self.delegate.webViewEvaluateJavaScript(result, error: error)
            }
        }
    }
    
    @available(iOS 14.0, *)
    func callAsyncJavaScript(javaScript script: String, arguments: [String : Any] = [:], completionHandler: ((Result<Any, Error>) -> Void)? = nil) {
        webView.callAsyncJavaScript(script, arguments: arguments, in: nil, in: .defaultClient, completionHandler: {
            result in
            if completionHandler != nil {
                completionHandler!(result)
            }
        })
    }
    
    func reload() {
        if webConfig!.enableWebServer {
            let url = webServer.serverURL!.appendingPathComponent("index.html")
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            webView.reload()
        }
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    fileprivate func loadLocalHTML(fileName: String?) {
        let wwwBundleURL = Bundle.main.url(forResource: "www", withExtension: "bundle")!
        let htmlURL = wwwBundleURL.appendingPathComponent("www", isDirectory: true)
        
//        let htmlFileURL = URL(fileURLWithPath: htmlURL.path + "/\(fileName ?? "index").html")
//        webView.loadFileURL(htmlFileURL, allowingReadAccessTo: htmlURL)
        
        let htmlFileURL = URL(fileURLWithPath: wwwBundleURL.path + "/test.html")
        webView.loadFileURL(htmlFileURL, allowingReadAccessTo: wwwBundleURL)
    }
    
    fileprivate func loadLocalWebServerHTML(fileName: String?) {
        let wwwBundleURL = Bundle.main.url(forResource: "www", withExtension: "bundle")!
        let htmlURL = wwwBundleURL.appendingPathComponent("www", isDirectory: true)
        
        webServer.addGETHandler(forBasePath: "/", directoryPath: htmlURL.path, indexFilename: "/\(fileName ?? "index")", cacheAge: 3600, allowRangeRequests: true)
        webServer.addHandler(forMethod: "GET", path: "/", request: GCDWebServerRequest.self) {
            request -> GCDWebServerResponse in
            let url = URL(string: "\(fileName ?? "index").html", relativeTo: request.url)
            return GCDWebServerResponse(redirect: url!, permanent: false)
        }
        webServer.start(withPort: 8080, bonjourName: nil)
        
        let url = webServer.serverURL!.appendingPathComponent("\(fileName ?? "index").html")
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            self.progressDelegate?.estimatedProgress(webView, estimatedProgress: webView.estimatedProgress)
        }
    }
}

// MARK: - WKNavigationDelegate
extension KWKWebView: WKNavigationDelegate {

    /// 服务器开始请求的时候调用
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.delegate.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.delegate.webView(webView, didStartProvisionalNavigation: navigation)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if firstLoad {
            firstLoad = false
        }
        self.delegate.webView(webView, didFinish: navigation)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.delegate.webView(webView, didFail: navigation, withError: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.delegate.webView(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
}

// MARK: - WKUIDelegate 不实现该代理方法 网页内调用弹窗时会抛出异常,导致程序崩溃
extension KWKWebView: WKUIDelegate {
    
    // alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        target?.present(alert, animated: true, completion: nil)
    }
    
    // confirm
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
    
    // input
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
