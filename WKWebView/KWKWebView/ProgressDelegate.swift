//
//  ProgressDelegate.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/19.
//

import Foundation
import WebKit

protocol ProgressDelegate: AnyObject {
    
    /// WKWebview 加载进度
    func estimatedProgress(_ webView: WKWebView, estimatedProgress progress: Double)
}
