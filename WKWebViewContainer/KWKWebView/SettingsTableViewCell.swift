//
//  SettingsTableViewCell.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/25.
//

import UIKit

@IBDesignable
class SettingsTableViewCell: UITableViewCell {
    
    @IBInspectable var title: UILabel!
    
    init(style: UITableViewCell.CellStyle, section: Int, row: Int) {
        let reuseIdentifier = ""
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2, height: self.frame.height))
    }
    
    public func setup(_ indexPath: IndexPath) {
        
    }
}
