//
//  SettingsTableViewCell.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/3/25.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    let canHighlightRow = [5, 6]
    
    var toggleCell: ToggleCell!
    var numberCell: NumberCell!
    
    fileprivate final let rect = CGRect(x: 0, y: 0, width: GlobalViewSettings.tableViewCellWidth, height: GlobalViewSettings.tableViewCellHeight)
    
    var identifier: String!
    
    init(style: UITableViewCell.CellStyle, indexPath: IndexPath) {
        super.init(style: style, reuseIdentifier: "\(indexPath.section)-\(indexPath.row)")
        
        identifier = "\(indexPath.section)-\(indexPath.row)"
        toggleCell = ToggleCell(frame: rect)
        toggleCell.cellValueDelegate = self
        numberCell = NumberCell(frame: rect)
        numberCell.cellValueDelegate = self
        
        switch identifier {
        case "0-0":
            toggleCell.setText(text: "开启手势交互")
            toggleCell.setOn(isOn: GlobalSetting.isAllowsBackForwardGestures)
            self.contentView.addSubview(toggleCell)
            break
        case "0-1":
            toggleCell.setText(text: "显示水平滚动条")
            toggleCell.setOn(isOn: GlobalSetting.isShowHorizontalScrollIndicator)
            self.contentView.addSubview(toggleCell)
            break
        case "0-2":
            toggleCell.setText(text: "显示垂直滚动条")
            toggleCell.setOn(isOn: GlobalSetting.isShowVerticalScrollIndicator)
            self.contentView.addSubview(toggleCell)
            break
        case "0-3":
            toggleCell.setText(text: "允许javaScript打开窗口")
            toggleCell.setOn(isOn: GlobalSetting.isAutomaticallyJavaScript)
            self.contentView.addSubview(toggleCell)
            break
        case "0-4":
            numberCell.setText(text: "默认最小字体字体")
            numberCell.setNumber(number: GlobalSetting.minFontSize)
            self.contentView.addSubview(numberCell)
            break
        case "0-5":
            toggleCell.setText(text: "允许加载javaScript")
            toggleCell.setOn(isOn: GlobalSetting.isJavaScriptEnabled)
            toggleCell.setEnable(enable: false)
            self.contentView.addSubview(toggleCell)
            break
        case "0-6":
            break
        case "1-0":
            toggleCell.setText(text: "Local Web Server")
            toggleCell.setOn(isOn: GlobalSetting.enableWebServer)
            self.contentView.addSubview(toggleCell)
            break
        case "1-2":
            break
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - CellDelegate
extension SettingsTableViewCell: CellDelegate {
    
    func cellValue(_ target: Any, value: Any) {
        GlobalSetting.settingViewValueChanged = true
        
        switch identifier {
        case "0-0":
            GlobalSetting.isAllowsBackForwardGestures = value as! Bool
            break
        case "0-1":
            GlobalSetting.isShowHorizontalScrollIndicator = value as! Bool
            break
        case "0-2":
            GlobalSetting.isShowVerticalScrollIndicator = value as! Bool
            break
        case "0-3":
            GlobalSetting.isAutomaticallyJavaScript = value as! Bool
            break
        case "0-4":
            GlobalSetting.minFontSize = value as! Int
            break
        case "0-5":
            GlobalSetting.isJavaScriptEnabled = value as! Bool
            break
        case "0-6":
            break
        case "1-0":
            GlobalSetting.enableWebServer = value as! Bool
            break
        case "1-2":
            break
        default:
            break
        }
    }
}
