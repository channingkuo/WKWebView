//
//  SettingsTableViewCell.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/25.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    init(style: UITableViewCell.CellStyle, section: Int, row: Int) {
        let reuseIdentifier = ""
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func setup(_ indexPath: IndexPath) {
        
    }
}
