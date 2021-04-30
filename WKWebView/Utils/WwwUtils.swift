//
//  WwwUtils.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2021/4/21.
//

import Alamofire
import SwiftyJSON

class WwwUtils {
    
    /// check html version
    class func checkHtmlVersion() {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request("http://192.168.10.68:9000/test", method: .post, headers: headers).responseJSON { response in
            if response.error == nil {
                let json = JSON(response.data as Any)
                
                #if DEBUG
                debugPrint(json)
                #endif
                
                let version = json["version"].stringValue
                let url = json["downloadUrl"].stringValue
                
                if version > GlobalSetting.htmlVersion {
                    GlobalSetting.htmlVersion = version
                    
                    downloadFile(url)
                }
            } else {
                #if DEBUG
                print("check HTML version error.")
                #endif
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "htmlVersionUpdateFailed"), object: nil)
            }
        }
    }
    
    /// download html www.zip
    class func downloadFile(_ url: String) {
        let destination: DownloadRequest.Destination = { _, _ in
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let fileURL = cachesURL.appendingPathComponent("www.zip")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, to: destination)
            .downloadProgress { progress in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "htmlVersionUpdateProgress"), object: progress.fractionCompleted)
            }.responseURL { response in
            if response.error == nil, let fileURL = response.fileURL {
                #if DEBUG
                print(fileURL.path)
                #endif
                FileUtils.unZipWWW()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "htmlVersionUpdated"), object: nil)
            } else {
                #if DEBUG
                print("get HTML from server error，use the local version.")
                #endif
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "htmlVersionUpdateFailed"), object: nil)
            }
        }
    }
}
