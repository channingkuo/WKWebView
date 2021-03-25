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

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableViewCell(style: .default, section: indexPath.section, row: indexPath.row)
        cell.setup(indexPath)
        return cell
    }
}
