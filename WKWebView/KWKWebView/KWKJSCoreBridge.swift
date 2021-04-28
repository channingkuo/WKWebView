//
//  KWKJSCoreBridge.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/23.
//

import UIKit
import WebKit
import SwiftyJSON
import CoreLocation

/// JSBridge method
/// - parameters fixed:
/// - _ params: values come from js
/// - webview : web container WKWebView
class KWKJSCoreBridge: NSObject {
    
    static let sharedInstance: KWKJSCoreBridge = {
        let instance = KWKJSCoreBridge()
        return instance
    }()
    
    fileprivate var webView: KWKWebView?
    fileprivate var callbackId: String?
    
    @objc func test(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        debugPrint(params)
        
        let callbackId = params["callbackId"] as! String
        self.callbackId = callbackId
        
        if #available(iOS 14, *) {
            webView.replyHandler!(arc4random() % 100, nil)
        } else {
            webView.excuteJavaScript(javaScript: "KWKJSBridge.callback('\(callbackId)', '\(arc4random() % 100)');")
        }
    }
    
    @objc func openSettings(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        let jsonParams = JSON(params["params"] as! Dictionary<String, Any>)
        let mode = jsonParams["mode"].int ??  0
        
        let settingsStoryboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let settingsViewCtrl = settingsStoryboard.instantiateViewController(identifier: "Settings") as SettingsViewController
        
        let rootViewController: UIViewController?
        if #available(iOS 13.0, *) {
            rootViewController = UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController
        } else {
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
        }

        /// 默认打开方式为模态窗形式 => 0:modal、1:NavigationController push
        if mode == 0 {
            rootViewController!.present(settingsViewCtrl, animated: true, completion: nil)
        } else {
            settingsViewCtrl.type = 1
            rootViewController!.navigationController?.pushViewController(settingsViewCtrl, animated: true)
        }
    }
    
    @objc func reload(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        webView.reload()
    }
    
    @objc func goBack(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        webView.goBack()
    }
    
    @objc func goForward(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        webView.goForward()
    }
    
    @objc func location(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        self.webView = webView
        
        let jsonParams = JSON(params["params"] as! Dictionary<String, Any>)
        
        let distance = jsonParams["precision"].double ?? 100
        let callbackId = params["callbackId"] as! String
        self.callbackId = callbackId
        
        let rootViewController: UIViewController?
        if #available(iOS 13.0, *) {
            rootViewController = UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController
        } else {
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        let locationManager = KLocationManager(rootViewController!, delegate: self)
        locationManager.delegate = self
        locationManager.startUpdatingLocation(distanceFilter: distance)
    }
    
    @objc func choosePhoto(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        KWKJSCoreBridge.sharedInstance.webView = webView
        
        let jsonParams = JSON(params["params"] as! Dictionary<String, Any>)
        
        let type = jsonParams["type"].int ?? 0
        let allowsEditing = jsonParams["allowsEditing"].bool ?? false
        let callbackId = params["callbackId"] as! String
        KWKJSCoreBridge.sharedInstance.callbackId = callbackId
        
        let rootViewController: UIViewController?
        if #available(iOS 13.0, *) {
            rootViewController = UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController
        } else {
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if type == 0 {
            presentImagePickerController(rootViewController!, sourceType: .camera, allowsEditing: allowsEditing)
        } else if type == 1 {
            presentImagePickerController(rootViewController!, sourceType: .photoLibrary, allowsEditing: allowsEditing)
        } else if type == 2 {
            let actionSheetCtrl = UIAlertController()
            let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler: { _ in })
            let cameraButton = UIAlertAction(title: "拍照", style: .destructive, handler: {
                _ in
                self.presentImagePickerController(rootViewController!, sourceType: .camera, allowsEditing: allowsEditing)
            })
            let photoButton = UIAlertAction(title: "相册", style: .default, handler: {
                _ in
                self.presentImagePickerController(rootViewController!, sourceType: .photoLibrary, allowsEditing: allowsEditing)
            })
            actionSheetCtrl.addAction(cancelButton)
            actionSheetCtrl.addAction(cameraButton)
            actionSheetCtrl.addAction(photoButton)

            rootViewController!.present(actionSheetCtrl, animated: true, completion: nil)
        } else {
            presentImagePickerController(rootViewController!, sourceType: .camera, allowsEditing: allowsEditing)
        }
    }
    
    @objc func previewImage(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        let jsonParams = JSON(params["params"] as! Dictionary<String, Any>)
        
        let data = jsonParams["data"].string
        
        if nil != data && !data!.isEmpty {
            let previewStoryboard = UIStoryboard.init(name: "Preview", bundle: nil)
            let previewCtrl = previewStoryboard.instantiateViewController(identifier: "Preview") as PreviewController
            previewCtrl.imageData = data
            previewCtrl.modalTransitionStyle = .crossDissolve
            previewCtrl.modalPresentationStyle = .overFullScreen
            
            let rootViewController: UIViewController?
            if #available(iOS 13.0, *) {
                rootViewController = UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController
            } else {
                rootViewController = UIApplication.shared.keyWindow?.rootViewController
            }
            
            rootViewController!.present(previewCtrl, animated: true, completion: nil)
        }
    }
    
    @objc func call(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        let jsonParams = JSON(params["params"] as! Dictionary<String, Any>)
        
        let phoneNumber = jsonParams["phoneNumber"].string
        
        if nil != phoneNumber && !phoneNumber!.isEmpty {
            let callWebView = WKWebView()
            callWebView.load(URLRequest(url: URL(string: "tel:\(phoneNumber!)")!))
            
            if #available(iOS 13.0, *) {
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.addSubview(callWebView)
            } else {
                UIApplication.shared.keyWindow?.addSubview(callWebView)
            }
        }
    }
}

// MARK: - LocationDelegate
extension KWKJSCoreBridge: LocationDelegate {

    func coordinateUpdated(latitude: Double, longitude: Double, pois: [Poi]) {
        let locationBridge = LocationBridge(latitude: latitude, longitude: longitude, pois: pois)

        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(locationBridge)
        let json = String(data: jsonData!, encoding: .utf8)
        
        if #available(iOS 14, *) {
            if self.webView!.replyHandler != nil {
                self.webView!.replyHandler!(json, nil)
            }
        } else {
            if callbackId != nil && !callbackId!.isEmpty {
                self.webView!.excuteJavaScript(javaScript: "KWKJSBridge.callback('\(callbackId ?? "")', '\(json ?? "")');")
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension KWKJSCoreBridge: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)

        let image: UIImage
        let url = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        #if DEBUG
        print(url)
        #endif
        if picker.allowsEditing {
            image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        } else {
            image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        }
        
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(["url": url.absoluteString, "base64": ImageUtils.imageToBase64String(image: image)])
        let json = String(data: jsonData!, encoding: .utf8)

        if #available(iOS 14, *) {
            // 直接返回Promise
            if KWKJSCoreBridge.sharedInstance.webView!.replyHandler != nil {
                KWKJSCoreBridge.sharedInstance.webView!.replyHandler!(json, nil)
            }
        } else {
            if callbackId != nil && !callbackId!.isEmpty {
                KWKJSCoreBridge.sharedInstance.webView!.excuteJavaScript(javaScript: "KWKJSBridge.callback('\(KWKJSCoreBridge.sharedInstance.callbackId ?? "")', '\(json ?? "")');")
            }
        }
    }

    func presentImagePickerController(_ viewCtrl: UIViewController, sourceType: UIImagePickerController.SourceType, allowsEditing: Bool) {
        let imagePickerCtrl = UIImagePickerController()
        imagePickerCtrl.allowsEditing = allowsEditing
        imagePickerCtrl.sourceType = sourceType
        imagePickerCtrl.delegate = KWKJSCoreBridge.sharedInstance

        viewCtrl.present(imagePickerCtrl, animated: true, completion: nil)
    }
}
