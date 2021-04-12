//
//  ToggleCell.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/26.
//

import UIKit
import SnapKit

class ToggleCell: UIView {
    
    /// value值监听代理
    weak var cellValueDelegate: CellDelegate?
    
    fileprivate var title: UILabel!
    fileprivate var toggle: UISwitch!
    
    fileprivate var text: String?
    fileprivate var isOn: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    init(frame: CGRect, text: String, isOn: Bool) {
        super.init(frame: frame)
        
        self.text = text
        self.isOn = isOn
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        title.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(20)
        })
        
        toggle.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.greaterThanOrEqualToSuperview().offset(-20)
        })
    }
    
    fileprivate func setupSubViews() {
        title = UILabel()
        title.sizeToFit()
        title.text = text == nil ? "未设置" : text
        self.addSubview(title)
        
        toggle = UISwitch()
        toggle.addTarget(self, action: #selector(onToggleClicked), for: .touchUpInside)
        self.addSubview(toggle)
    }
    
    func setText(text: String) {
        title.text = text
    }
    
    func setOn(isOn: Bool) {
        self.isOn = isOn
        toggle.isOn = isOn
    }
    
    func setEnable(enable: Bool) {
        toggle.isEnabled = enable
    }
    
    @objc func onToggleClicked(_ sender: UISwitch) {
        isOn = sender.isOn
        
        cellValueDelegate?.cellValue(sender, value: isOn ?? false)
    }
}
