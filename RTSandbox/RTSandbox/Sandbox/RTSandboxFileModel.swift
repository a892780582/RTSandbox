//
//  RTSandBoxFileModel.swift
//  RTAppSandBox
//
//  Created by RT on 2024/8/14.
//

import UIKit

enum RTSandboxFileType: String {
    case unkonwn
    case audio
    case video
    case css
    case folder
    case html
    case js
    case image
    case json
    case pdf
    case ppt
    case ss
    case txt
    case xsl
    case zip
    case plist
    case doc
    
}

class RTSandboxFileModel: NSObject {
    
    var realPath: String?
    
    var createTime: Date?
    
    var modificationDate: Date?
    
    var fileName: String?{
        willSet{
            guard let value = newValue as? NSString else {
                return
            }
            self.fileType = analyseFileType(value.pathExtension.lowercased())
        }
    }
    
    var isDirectory: Bool = false{
        willSet{
            if newValue == true {
                self.fileType = .folder
            }
          
        }
    }
    
    var size: Int64 = 0
    
    var systemSize: Int64 = 0
    
    var childList: [RTSandboxFileModel]?
    
    var owner: String?
    
    var fileType = RTSandBoxFileType.unkonwn
    
    
    func analyseFileType(_ pathExtension: String) -> RTSandBoxFileType{
        
        switch pathExtension.lowercased() {
        case "jpeg": fallthrough
        case "jpg": fallthrough
        case "bmp": fallthrough
        case "png": fallthrough
        case "tif": fallthrough
        case "gif": fallthrough
        case "pcx": fallthrough
        case "heic": fallthrough
        case "svg": fallthrough
        case "raw": fallthrough
        case "dxf": fallthrough
        case "ufo": fallthrough
        case "eps":fallthrough
        case "ai":
            return .image
        case "mp4": fallthrough
        case "mov": fallthrough
        case "avi": fallthrough
        case "rmvb": fallthrough
        case "wmv": fallthrough
        case "mkv": fallthrough
        case "flv": fallthrough
        case "bd":
            return .video
            
        case "mp3": fallthrough
        case "wav": fallthrough
        case "wma": fallthrough
        case "ape": fallthrough
        case "flac": fallthrough
        case "midi": fallthrough
        case "aac": fallthrough
        case "m4v": fallthrough
        case "cda":
            return .audio
        case "doc": fallthrough
        case "docx": fallthrough
        case "pages":
            return .doc
        case "pdf":
            return .pdf
        case "ppt":
            return .ppt
        case "txt":
            return .txt
            
        case "plist":
            return .plist
            
        case "html":
            return .html
        case "js":
            return .js
        case "css":
            return .css
        case "xls": fallthrough
        case "xlsx": fallthrough
        case "number":
            return .xsl
        case "json":
            return .json
        case "zip": fallthrough
        case "rar":
            return .zip
        default:
            break
        }
        
        return RTSandboxFileType.unkonwn
    }

}
