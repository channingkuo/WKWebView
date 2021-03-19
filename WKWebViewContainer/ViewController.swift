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
    
    // TODO 设计一个Class保存请求的所有记录
    fileprivate var snapShotsArray: Array<Any>?
    
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
        
//        let settingsStoryboard = UIStoryboard.init(name: "Settings", bundle: nil)
//        let settingsViewCtrl = settingsStoryboard.instantiateViewController(identifier: "Settings")
//        self.navigationController?.pushViewController(settingsViewCtrl, animated: true)
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
    
    /// 服务器开始请求的时候调用
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
//        let navigationURL = navigationAction.request.url?.absoluteString
//        if let requestURL = navigationURL?.removingPercentEncoding {
//            //拨打电话
//            //兼容安卓的服务器写法:<a class = "mobile" href = "tel://电话号码"></a>
//            //或者:<a class = "mobile" href = "tel:电话号码"></a>
//            if requestURL.hasPrefix("tel://") {
//                //取消WKWebView 打电话请求
//                decisionHandler(.cancel);
//                //用openURL 这个API打电话
//                if let mobileURL:URL = URL(string: requestURL) {
//                    UIApplication.shared.openURL(mobileURL)
//                }
//            }
//            // 支付宝支付
//            if requestURL.hasPrefix("alipay://") {
//
//                var urlString = requestURL.mySubString(from: 23)
//                urlString = urlString.replacingOccurrences(of: "alipays", with: webConfig!.aliPayScheme)
//
//                if let strEncoding = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
//
//                    let payString = "alipay://alipayclient/?\(strEncoding)"
//
//                    if let urlalipayURL:URL = URL(string: payString) {
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(urlalipayURL, options: [:], completionHandler: { result in
//                                self.webView.reload()
//                            })
//                        } else {
//                            UIApplication.shared.openURL(urlalipayURL)
//                        }
//                    }
//                }
//            }
//        }
//        switch navigationAction.navigationType {
//        case WKNavigationType.linkActivated:
//            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
//            break
//        case WKNavigationType.formSubmitted:
//            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
//            break
//        case WKNavigationType.backForward:
//            break
//        case WKNavigationType.reload:
//            break
//        case WKNavigationType.formResubmitted:
//            break
//        case WKNavigationType.other:
//            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
//            break
//        }
//        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成!")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败!")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webViewUserContentController(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage) {
        print(message.body)
        print("JS 执行 Swift 代码")
    }
    
    func webViewEvaluateJavaScript(_ result: Any?, error: Error?) {
        print(result as Any)
        print("Swift 执行 JS 到 WKWebview")
    }
}
