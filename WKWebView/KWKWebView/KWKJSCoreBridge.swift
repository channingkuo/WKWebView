//
//  KWKJSCoreBridge.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/23.
//

import UIKit
import WebKit
import SwiftyJSON

// TODO 可以设计一个protocol，规定所有方法的定义
class KWKJSCoreBridge: NSObject {
    
    @objc func tests(_ s: String, ssd: KWKWebView) {
        debugPrint(11111111111)
        debugPrint(s)
    }
    
    @objc func test(_ params: Dictionary<String, Any>, webView: KWKWebView) {
        debugPrint(params)
        let callbackId = params["callbackId"] as! String
        webView.excuteJavaScript(javaScript: "KWKJSBridge.callback('\(callbackId)','123445677');")
    }
}

// MARK: - ScriptMessageHandlerArray
//extension ViewController {
//    /// 桥接JS与Swift
//    func scriptMessageHandle(didReceive message: JSON) {
//        let action = ViewActionMode(rawValue: message["action"].stringValue)
//
//        switch action {
//        case .OpenSettings:
//            let settingsStoryboard = UIStoryboard.init(name: "Settings", bundle: nil)
//            let settingsViewCtrl = settingsStoryboard.instantiateViewController(identifier: "Settings") as SettingsViewController
//
//            /// 默认打开方式为模态窗形式 => 0:modal、1:NavigationController push
//            let type = message["type"].intValue
//            if type == 0 {
//                self.present(settingsViewCtrl, animated: true, completion: nil)
//            } else {
//                settingsViewCtrl.type = 1
//                self.navigationController?.pushViewController(settingsViewCtrl, animated: true)
//            }
//            break
//        case .Reload:
//            kWKWebView.reload()
//            break
//        case .Back:
//            kWKWebView.goBack()
//            break
//        case .Forward:
//            kWKWebView.goForward()
//            break
//        case .Location:
//            let distance = message["distance"].doubleValue
//
//            let locationManager = LocationManager.sharedInstance
//            locationManager.delegate = self
//            locationManager.startUpdatingLocation(self, distanceFilter: distance)
//            break
//        case .Image:
//            let type = message["type"].intValue
//            let allowsEditing = message["allowsEditing"].boolValue
//
//            if type == 0 {
//                presentImagePickerController(.camera, allowsEditing: allowsEditing)
//            } else if type == 1 {
//                presentImagePickerController(.photoLibrary, allowsEditing: allowsEditing)
//            } else if type == 2 {
//                let actionSheetCtrl = UIAlertController()
//                let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler: { _ in })
//                let cameraButton = UIAlertAction(title: "拍照", style: .destructive, handler: {
//                    _ in
//                    self.presentImagePickerController(.camera, allowsEditing: allowsEditing)
//                })
//                let photoButton = UIAlertAction(title: "相册", style: .default, handler: {
//                    _ in
//                    self.presentImagePickerController(.photoLibrary, allowsEditing: allowsEditing)
//                })
//                actionSheetCtrl.addAction(cancelButton)
//                actionSheetCtrl.addAction(cameraButton)
//                actionSheetCtrl.addAction(photoButton)
//
//                self.present(actionSheetCtrl, animated: true, completion: nil)
//            } else {
//                presentImagePickerController(.camera, allowsEditing: allowsEditing)
//            }
//            break
//        case .Preview:
//            if !message["data"].stringValue.isEmpty {
//                let previewStoryboard = UIStoryboard.init(name: "Preview", bundle: nil)
//                let previewCtrl = previewStoryboard.instantiateViewController(identifier: "Preview") as PreviewController
//                previewCtrl.imageData = message["data"].stringValue
//                previewCtrl.modalTransitionStyle = .crossDissolve
//                previewCtrl.modalPresentationStyle = .overFullScreen
//                self.present(previewCtrl, animated: true, completion: nil)
//            }
//            break
//        case .Call:
////            let callWebView = WKWebView()
////            callWebView.load(URLRequest(url: URL(string: "tel:\(message["phoneNumber"].stringValue)")!))
////            UIApplication.shared.keyWindow?.addSubview(callWebView)
//            break
//        default: break
//        }
//    }
//}
//
//// MARK: - CLLocationManagerDelegate
//extension ViewController: LocationProtocol {
//
//    func coordinateUpdated(latitude: Double, longitude: Double, placemarks: [CLPlacemark]?) {
//        let json = JSON(["latitude": latitude, "longitude": longitude, "placemarks": placemarks ?? []] as [String : Any])
//
//        if replyHandler != nil {
//            // 直接返回Promise
//            replyHandler!(json.rawString(), nil)
//        } else {
//            // TODO 传递经纬度信息到web
//            kWKWebView.excuteJavaScript(javaScript: "")
//        }
//    }
//}
//
//// MARK: - UIImagePickerControllerDelegate
//extension ViewController: UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        picker.dismiss(animated: true, completion: nil)
//
//        let image: UIImage
//        let url = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
//        #if DEBUG
//        print(url)
//        #endif
//        if picker.allowsEditing {
//            image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
//        } else {
//            image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        }
//
//        let json = JSON(["url": url.absoluteString, "base64": ImageUtils.imageToBase64String(image: image)] as [String : String?])
//
//        if replyHandler != nil {
//            // 直接返回Promise
//            replyHandler!(json.rawString(), nil)
//        } else {
//            kWKWebView.excuteJavaScript(javaScript: "")
//        }
//    }
//
//    fileprivate func presentImagePickerController(_ sourceType: UIImagePickerController.SourceType, allowsEditing: Bool) {
//        let imagePickerCtrl = UIImagePickerController()
//        imagePickerCtrl.allowsEditing = allowsEditing
//        imagePickerCtrl.sourceType = sourceType
//        imagePickerCtrl.delegate = self
//
//        self.present(imagePickerCtrl, animated: true, completion: nil)
//    }
//}
