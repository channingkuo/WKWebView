//
//  ViewController.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2020/10/15.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var kWKWebView: KWKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
        var config = KWKWebViewConfig()
        config.isShowScrollIndicator = false
        config.isProgressHidden = false
        
        kWKWebView.delegate = self
        kWKWebView.progressDelegate = self
        
//        kWKWebView.load(self, .URL(url: "https://baidu.com"))
        
        config.scriptMessageHandlerArray = ["kWKWebView"]
        kWKWebView.webConfig = config
        
        kWKWebView.load(self, .HTML(fileName: nil))
//        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

// MARK: - ProgressDelegate
extension ViewController: ProgressDelegate {
    
    func estimatedProgress(_ webView: WKWebView, estimatedProgress progress: Double) {
        if progress >= 1.0 {
            progressView.removeFromSuperview()
        }
    }
}

// MARK: - WKWebViewDelegate
extension ViewController: WKWebViewDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webViewUserContentController(_ scriptMessageHandlerArray:[String], didReceive message: WKScriptMessage) {
        print(message.body)
    }
    
    func webViewEvaluateJavaScript(_ result:Any?,error:Error?) {
        print("开始加载")
    }
}
