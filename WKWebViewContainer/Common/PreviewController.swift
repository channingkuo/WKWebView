//
//  PreviewController.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/12.
//

import UIKit
import SDWebImage

class PreviewController: UIViewController {
    
    @IBOutlet weak var previewImage: UIImageView!
    
    /// 预览图片的本地路径、base64、http/https网络地址
    var imageData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        previewImage.isUserInteractionEnabled = true
        
        previewImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBack)))
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        panGestureRecognizer.maximumNumberOfTouches = 1
        previewImage.addGestureRecognizer(panGestureRecognizer)
        
        setupImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func setupImage() {
        if imageData!.hasPrefix("http") || imageData!.hasPrefix("https") {
            let url = URL(string: imageData!)
            previewImage.sd_setImage(with: url, completed: nil)
        } else if imageData!.hasPrefix("file") {
            let url = URL(string: imageData!)!
            let data = try? Data(contentsOf: url)
            previewImage.image = UIImage(data: data!)
        } else {
            previewImage.image = ImageUtils.base64StringToUIImage(base64String: imageData!)
        }
    }
    
    @objc func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        let viewHeight = self.view.frame.height
        let translation = sender.translation(in: self.view)
        var currentRate = 1 - translation.y / viewHeight * 2.5
        currentRate = currentRate > 1 ? 1 : currentRate
        currentRate = currentRate < 0 ? 0 : currentRate
        
        if sender.state == .began || sender.state == .changed {
            if translation.y > 0 {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: currentRate)
                
                let imageScaleRate = currentRate < 0.1 ? 0.1 : currentRate
                let transform = CGAffineTransform(a: imageScaleRate, b: 0, c: 0, d: imageScaleRate, tx: translation.x, ty: translation.y)
                previewImage.transform = transform
            }
        }
        if sender.state == .ended {
            // TODO 可以计算拉动的加速度来判断是否要关闭
            if translation.y >= viewHeight / 2.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    self.previewImage.transform = CGAffineTransform(translationX: 0, y: viewHeight)
                }, completion: { _ in
                    self.dismissBack()
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    self.previewImage.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    @objc func dismissBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
