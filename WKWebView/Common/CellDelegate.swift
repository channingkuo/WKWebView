//
//  CellDelegate.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/8.
//

import Foundation

protocol CellDelegate: AnyObject {
    
    /// value值监听代理
    func cellValue(_ target: Any, value: Any)
}
