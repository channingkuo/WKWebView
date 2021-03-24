//
//  SettingsViewController.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/18.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var type: Int = 0

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var actionBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        actionBarView.layer.cornerRadius = 2.5
        actionBarView.isHidden = type != 0
        
        cancelButton.addTarget(self, action: #selector(onCancelButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func onCancelButtonClicked(_ sender: UIButton) {
        dismissBack()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO 保存刷新新的配置
    }
    
    fileprivate func dismissBack() {
        if type == 0 {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
