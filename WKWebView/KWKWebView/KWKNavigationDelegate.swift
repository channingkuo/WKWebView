//
//  KWKNavigationDelegate.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/23.
//

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

    /// JS执行回调方法
    func webViewEvaluateJavaScript(_ result: Any?, error: Error?)
}

class KWKNavigationDelegate: NSObject {
    
    // TODO 设计一个Class保存请求的所有记录
    fileprivate var snapShotsArray: Array<Any>?
}

// MARK: - WKWebViewDelegate
extension KWKNavigationDelegate: WKWebViewDelegate {
    
    /// 服务器开始请求的时候调用——桥接html请求变化链接
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
        #if DEBUG
        print("开始加载")
        #endif
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        #if DEBUG
        print("加载完成!")
        #endif
        
        // TODO 获取web localStorage中token信息
        // TODO 可以做一些应用的调试信息的log收集
        let js = """
            return localStorage['userInfo'];
        """
        if #available(iOS 14.0, *) {
            webView.callAsyncJavaScript(js, arguments: [:], in: nil, in: .defaultClient) { result in
                // TODO 执行完swift发起的脚本后处理逻辑
                switch result {
                case .success(let resp):
                    debugPrint(resp)
                    break
                case .failure(let err):
                    debugPrint(err)
                    break
                }
            }
        } else {
            webView.evaluateJavaScript(js) { result, error in
                // TODO 执行完swift发起的脚本后处理逻辑
                // 可以通过从swift执行JSBridge，从而获取web返回的值
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        #if DEBUG
        print("加载失败!")
        #endif
        
        // TODO 收集log，记录加载失败现场
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        #if DEBUG
        print(error)
        #endif
    }
    
    func webViewEvaluateJavaScript(_ result: Any?, error: Error?) {
        #if DEBUG
        print("Swift 执行 JS 到 WKWebview")
        print(result as Any)
        #endif
        // TODO 可以记录历史操作
    }
}
