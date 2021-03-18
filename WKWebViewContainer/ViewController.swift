//
//  ViewController.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2020/10/15.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var kWKWebView: KWKWebView!
//    fileprivate var kWKWebView: KWKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var config = KWKWebViewConfig()
        config.isShowScrollIndicator = false
        config.isProgressHidden = false
        
//        kWKWebView.load(self, .URL(url: "https://www.baidu.com"))
        
        config.scriptMessageHandlerArray = ["kWKWebView"]
        kWKWebView.webConfig = config
        
        kWKWebView.load(self, .HTML(name: "test"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

