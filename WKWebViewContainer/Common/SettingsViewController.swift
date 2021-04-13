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
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        // 保存刷新新的配置
        // 如果设置页面的值有发生改变，则通知重新加载kWKWebView
        if GlobalSetting.settingViewValueChanged {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewDismiss"), object: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 重置设置页面数据的脏检查
        GlobalSetting.settingViewValueChanged = false
    }
    
    fileprivate func dismissBack() {
        if type == 0 {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalViewSettings.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 6 {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "设置"
        }
        return "其他"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SettingsTableViewCell(style: .default, indexPath: indexPath)
    }
}
