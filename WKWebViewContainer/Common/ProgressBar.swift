//
//  ProgressBar.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/22.
//

import UIKit
import SnapKit

let STATIC_VIEW_TAG = -1
let PROGRESS_BAR_TAG = 0

class ProgressBar {
    
    fileprivate var alert: UIAlertController
    fileprivate var progressBar: UIProgressView
    fileprivate var percent: UILabel
    
    init(progress: Float?) {
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        progressBar = UIProgressView(progressViewStyle: .bar)
        percent = UILabel()
                
        alert.view.clipsToBounds = false
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.tag = STATIC_VIEW_TAG
        
        alert.view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        progressBar.tag = PROGRESS_BAR_TAG
        progressBar.progressTintColor = UIColor(red: 236 / 255, green: 128 / 255, blue: 13 / 255, alpha: 1)
        progressBar.trackTintColor = UIColor.lightGray
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        progressBar.setProgress(progress ?? 0, animated: true)
        
        contentView.addSubview(progressBar)
        
        progressBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-20)
            make.width.lessThanOrEqualTo(150)
        }
        
        percent.text = "\(String(round((progress ?? 0) * 100)))%"
        percent.sizeToFit()
        percent.font = UIFont.systemFont(ofSize: 10)
        
        contentView.addSubview(percent)
        
        percent.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(progressBar.snp.right).inset(-10)
        }
        
        let staticLabel = UILabel()
        staticLabel.text = "版本更新"
        staticLabel.font = UIFont.systemFont(ofSize: 8)
        staticLabel.sizeToFit()
        
        contentView.addSubview(staticLabel)
        
        staticLabel.snp.makeConstraints { make in
            make.right.lessThanOrEqualTo(-8)
            make.bottom.lessThanOrEqualTo(-4)
        }
        
        let action = UIAlertAction(title: "", style: .default, handler: nil)
        alert.addAction(action)

        _ = alert.view.subviews.compactMap { view -> Void in
            if view.tag != STATIC_VIEW_TAG {
                view.isHidden = true
            } else {
                view.isHidden = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bar: UIAlertController {
        get {
            return alert
        }
    }
    
    func setProgress(_ progress: Float, animation: Bool) {
        progressBar.setProgress(progress, animated: animation)
        percent.text = "\(String(round(progress * 100)))%"
        debugPrint("----------")
        debugPrint(progress)
        debugPrint("\(String(round(progress * 100)))%")
        debugPrint("----------")
    }
}
