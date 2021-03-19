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
        
        for view in self.subviews {
            if view is UIImageView {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = 1
                animation.toValue = 0
                animation.timingFunction = CAMediaTimingFunction(
                    name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut")
                )
                animation.repeatCount = 1
                animation.duration = 0.7
                animation.isRemovedOnCompletion = true
                animation.fillMode = .forwards
                // add animation into layer
                view.layer.add(animation, forKey: nil)
            }
        }
    }
}
