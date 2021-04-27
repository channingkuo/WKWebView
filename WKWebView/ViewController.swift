//
//  ViewController.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2020/10/15.
//

import UIKit
import WebKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var kWKWebView: KWKWebView!
    
    fileprivate var statusView: UIView!
    
    fileprivate var downloadingView: ProgressBar!
    fileprivate var downloadingViewPresented: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        downloadingView = ProgressBar(progress: 0.0)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let statusBarFrame: CGRect?
        if #available(iOS 13, *) {
            statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        statusView = UIView(frame: statusBarFrame!)
        self.view.addSubview(statusView)
        
        kWKWebView.webConfig = KWKWebViewConfig()
        kWKWebView.progressDelegate = self
        kWKWebView.load(self, .HTML(fileName: nil))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDismissNotification), name: NSNotification.Name(rawValue: "viewDismiss"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(htmlVersionUpdateProgress), name: NSNotification.Name(rawValue: "htmlVersionUpdateProgress"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(htmlVersionUpdated), name: NSNotification.Name(rawValue: "htmlVersionUpdated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(htmlVersionUpdateFailed), name: NSNotification.Name(rawValue: "htmlVersionUpdateFailed"), object: nil)
        
        DispatchQueue.global().async() {
            WwwUtils.checkHtmlVersion()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func viewDismissNotification() {
        kWKWebView.reload()
    }
    
    @objc func htmlVersionUpdateProgress(_ notification: NSNotification) {
        let progress = notification.object as! Double
        #if DEBUG
        print("Download Progress: \(progress)")
        #endif
        
        downloadingView.setProgress(Float(progress), animation: true)

        if !downloadingViewPresented {
            self.present(downloadingView.bar, animated: true, completion: nil)

            downloadingViewPresented = true
        }
    }
    
    @objc func htmlVersionUpdated() {
        let alert = UIAlertController(title: "温馨提示", message: "新版本已更新，是否加载", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            self.dismiss(animated: true, completion: nil)
            
            self.kWKWebView.reload()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel) { (_) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        downloadingView.bar.present(alert, animated: true, completion: nil)
    }
    
    @objc func htmlVersionUpdateFailed() {
        let alert = UIAlertController(title: "检查版本更新异常", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - ProgressDelegate
extension ViewController: ProgressDelegate {
    
    func estimatedProgress(_ webView: WKWebView, estimatedProgress progress: Double) {
        if progress >= 1.0 && progressView != nil {
            // TODO 从HTML读取状态栏的颜色
            statusView.backgroundColor = UIColor(red: 236 / 255, green: 128 / 255, blue: 13 / 255, alpha: 1)
            
            // 延迟1秒移除——为了遮挡HTML加载瞬间的"白屏"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.progressView.removeFromSuperview()
            }
        }
    }
}
