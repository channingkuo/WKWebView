//
//  FileUtils.swift
//  KWKWebView
//
//  Created by Channing Kuo on 2020/10/16.
//

import Foundation
import Zip

class FileUtils {
    
    /** 沙箱目录Home ./ */
    class func homeFolder() -> String {
        return NSHomeDirectory()
    }
    
    /** Documents目录 ./Documents */
    class func documentFolder() -> String {
        return self.homeFolder() + "/Documents"
    }
    
    /** Library目录 ./Documents/Library */
    class func libraryFolder() -> String{
        return self.homeFolder() + "/Library"
    }
    
    /** Preferences目录 ./Documents/Library/Preferences */
    class func preferencesFolder() -> String{
        return self.homeFolder() + "/Library/Preferences"
    }
    
    /** Caches目录 ./Documents/Library/Caches */
    class func cachesFolder() -> String{
        return self.homeFolder() + "/Library/Caches"
    }
    
    /** tmp目录 ./tmp */
    class func tmpFolder() -> String{
        return self.homeFolder() + "/tmp"
    }
    
    // 根据文件Id从缓存文件中获取文件的Base64内容
    class func getBase64StringFromCache(id: String) -> String?{
        if id.isEmpty {
            return ""
        }
        let key = id.replacingOccurrences(of: "/", with: "")
        let path = self.cachesFolder() + "/\(key)"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            return ""
        }
        let base64Str = fileManager.contents(atPath: path)
        return String(bytes: base64Str!, encoding: String.Encoding.utf8)
    }
    
    // 将Base64格式的内容存放到缓存中
    class func saveBase64StringToCache(id: String, content: String){
        if id.isEmpty || content.isEmpty {
            return
        }
        let key = id.replacingOccurrences(of: "/", with: "")
        let path = self.cachesFolder() + "/\(key)"
        try! content.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
    }
    
    // 删除指定路径文件夹里的所有文件
    class func deleteFile(path: String, completeHandler: (() -> Void)?){
        if path.isEmpty {
            return
        }
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path){
            return
        }
        let fileArray = fileManager.subpaths(atPath: path)
        for file in fileArray! {
            try? fileManager.removeItem(atPath: path + "/\(file)")
        }
        if completeHandler != nil {
            completeHandler!()
        }
    }
    
    // 获取指定路径文件夹大小
    class func getFolderSize(path: String) -> Float{
        let fileManager = FileManager.default
        if path.isEmpty {
            return 0
        }
        if !fileManager.fileExists(atPath: path){
            return 0
        }
        var length: Float = 0
        let fileArray = fileManager.subpaths(atPath: path)
        for file in fileArray! {
            let attributes = try? fileManager.attributesOfItem(atPath: path + "/\(file)")
            length += attributes![FileAttributeKey.size] as! Float
        }
        return length
    }
    
    class func setupHtml() {
        let manager = FileManager.default
        let wwwPath = cachesFolder() + "/www"
        let wwwPathContent = try? manager.contentsOfDirectory(atPath: wwwPath)
        if wwwPathContent == nil {
            do {
                debugPrint("try to create dir \(wwwPath)")
                try manager.createDirectory(atPath: wwwPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                debugPrint("create dir \(wwwPath) error \(error.localizedDescription)")
            }
        }
        
        let fileArray = manager.subpaths(atPath: wwwPath)
        // 如果www目录为空则解压缩一份bundle里面的www.zip，不为空则使用缓存
        if fileArray == nil || fileArray!.count <= 0 {
            unZipWWW()
        }
    }
    
    class func unZipWWW() {
        let wwwBundleURL = Bundle.main.url(forResource: "www", withExtension: "bundle")!
        
        // Caches目录 ./Documents/Library/Caches下没有www.zip，则拷贝一份bundle里面的www.zip到Caches
        let manager = FileManager.default
        let zipPath = cachesFolder() + "/www.zip"
        if !manager.fileExists(atPath: zipPath) {
            try? manager.copyItem(atPath: wwwBundleURL.appendingPathComponent("www.zip").path, toPath: zipPath)
        }
        
        let wwwPath = cachesFolder() + "/www"
        deleteFile(path: wwwPath) {
            do {
                debugPrint("unzip the www.zip: \(cachesFolder() + "/www.zip")")
                
                let zipFileURL = URL(string: cachesFolder() + "/www.zip")
                let wwwURL = URL(string: cachesFolder())
                
                try Zip.unzipFile(zipFileURL!, destination: wwwURL!, overwrite: true, password: nil)
            } catch let error as NSError {
                debugPrint("unzip the www.zip error: \(error.localizedDescription)")
            }
        }
    }
}
