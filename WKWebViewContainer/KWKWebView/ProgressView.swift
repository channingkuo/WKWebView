//
//  ProgressView.swift
//  WKWebViewContainer
//
//  Created by Channing Kuo on 2021/3/18.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // TODO 设置loading
    }
}
