//
//  ViewController.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2020/10/15.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    fileprivate var kWKWebView: KWKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        kWKWebView = KWKWebView(frame: self.view.frame)
        self.view.addSubview(kWKWebView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

