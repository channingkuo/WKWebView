//
//  NumberCell.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/7.
//

import UIKit

class NumberCell: UIView {
    
    /// value值监听代理
    weak var cellValueDelegate: CellDelegate?
    
    fileprivate var title: UILabel!
    fileprivate var value: UIPickerView!
    fileprivate var unit = UILabel()
    
    fileprivate var text: String?
    fileprivate var number: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    init(frame: CGRect, text: String, number: Int) {
        super.init(frame: frame)
        
        self.text = text
        self.number = number
        
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
        
        value.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.greaterThanOrEqualTo(unit.snp.left)
            make.width.lessThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(50)
        })
        unit.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.greaterThanOrEqualToSuperview().offset(-20)
        })
    }
    
    fileprivate func setupSubViews() {
        title = UILabel()
        title.sizeToFit()
        title.text = text == nil ? "未设置" : text
        self.addSubview(title)
        
        value = UIPickerView()
        value.dataSource = self
        value.delegate = self
        self.addSubview(value)
        
        unit.sizeToFit()
        unit.text = "pt"
        unit.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(unit)
        
        // TODO 添加一层不可见textFieldView，提供键盘输入来设置number值
    }
    
    func setText(text: String) {
        title.text = text
    }
    
    func setNumber(number: Int) {
        self.number = number
        value.selectRow(number, inComponent: 0, animated: true)
        value.reloadAllComponents()
    }
}

// MARK: - UIPickerViewDataSource
extension NumberCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return number <= 100 ? 100 : number
    }
}

// MARK: - UIPickerViewDelegate
extension NumberCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let size = pickerView.rowSize(forComponent: component)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.sizeToFit()
        label.text = "\(row)"
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.number = row
        
        cellValueDelegate?.cellValue(pickerView, value: self.number)
    }
}
