//
//  RTSandboxViewController.swift
//  RTAppSandBox
//
//  Created by RT on 2024/8/14.
//

import UIKit
import zlib

open class RTSandboxViewController: UITableViewController {
    
    
    var activePath: String = NSHomeDirectory()
    
    private var firstLoad: Bool = false
    
    
    private var rootFileModel = RTSandboxFileModel()
    
    
    init(_ path: String? = nil){
        super.init(style: .plain)
        if path != nil {
            self.activePath = path!
        }
      
        rootFileModel.realPath = activePath
        self.firstLoad = true
    }
    
    private init(baseModel: RTSandboxFileModel){
        
        super.init(style: .plain)
        rootFileModel = baseModel
      
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView .register(RTSandboxTableViewCell.self, forCellReuseIdentifier: "RTSandBoxTableViewCell")
        self.tableView.estimatedRowHeight = 100
        self.title = rootFileModel.fileName
        if self.firstLoad == true{
            let queue = DispatchQueue.global()
            self.title = "HomeDirectory"
            queue.async {
                self.rootFileModel.size = self.getFileSize(rootModel: self.rootFileModel)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
    private func getFileSize(rootModel: RTSandboxFileModel) -> Int64{
        
        let enumator = FileManager.default.enumerator(atPath: rootModel.realPath!)
        
       
        var longSize: Int64 = 0
        
        var fileName = enumator?.nextObject() as? String
        
        var array = [RTSandboxFileModel]()
        
        while(fileName != nil){
            
            enumator?.skipDescendants()
            
            if fileName?.hasPrefix(".") == true {
                fileName = enumator?.nextObject() as? String
                continue
            }
            
            let newModel = RTSandboxFileModel()
          
            newModel.realPath = rootModel.realPath?.appending("/\(fileName!)")
            newModel.fileName = fileName!
            
            if let att = enumator?.fileAttributes {
                newModel.size = att[FileAttributeKey.size] as? Int64 ?? 0
                newModel.isDirectory = att[FileAttributeKey.type] as? FileAttributeType == FileAttributeType.typeDirectory
                newModel.createTime = att[FileAttributeKey.creationDate] as? Date
                newModel.modificationDate = att[FileAttributeKey.modificationDate] as? Date
                newModel.systemSize = att[FileAttributeKey.systemSize] as? Int64 ?? 0
               
            }
            if newModel.isDirectory == true{
                newModel.size = self.getFileSize(rootModel: newModel)
            }
            longSize = longSize + newModel.size
            array.append(newModel)
            
            fileName = enumator?.nextObject() as? String
        }
        if array.count > 0 {
            rootModel.childList = array
        }

        return longSize
        
    }
    
  

}

extension RTSandboxViewController {
    
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  rootFileModel.childList?.count ?? 0
        
        return count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RTSandBoxTableViewCell") as! RTSandboxTableViewCell
        cell.model = rootFileModel.childList?[indexPath.row]
        return cell
    }
    
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let model = self.rootFileModel.childList?[indexPath.row]
        if model != nil && model?.childList?.count ?? 0 > 0{
            
            let vc = RTSandboxViewController(baseModel: model!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    open override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let model = self.rootFileModel.childList?[indexPath.row] as? RTSandboxFileModel else {
            return nil
        }
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "delete") { action, inp in
            
            self.showAlert("确定要删除该文件吗？") {
                if let realPath = model.realPath {
                    try?FileManager.default .removeItem(atPath: realPath)
                    self.rootFileModel.childList?.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
        
        }
        
        let shareAction = UITableViewRowAction(style: .normal, title: "share") { action, inp in
             
            if let path = self.zipCreate(model: model){
                
                self.shareTo(path: path)
            }
            
        }
        
        if let homePath = model.realPath as NSString?{
            if homePath.deletingLastPathComponent == NSHomeDirectory(){
                return [shareAction]
            }
        }
        let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last
        if model.realPath == library?.appending("/Caches") ||
            model.realPath == library?.appending("/Preferences") ||
            model.realPath == library?.appending("/SplashBoard"){
            return [shareAction]
        }
        return [shareAction,deleteAction]
    }
    
    private func showAlert(_ msg: String, confirmAction:@escaping ()->()){
        
        let alert = UIAlertController(title: "提示🔔", message: msg, preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(.init(title: "取消", style: UIAlertAction.Style.cancel))
        
        alert.addAction(.init(title: "确定", style: UIAlertAction.Style.default, handler: { act in
            confirmAction()
        }));
        
        self .present(alert, animated: true)
    }
    
    private func shareTo(path: String){
        
        guard let item = NSItemProvider.init(contentsOf: URL.init(fileURLWithPath: path)) else {
            return
        }
//        let config = UIActivityItemsConfiguration(itemProviders: [item])
        
        
        let activityViewController = UIActivityViewController.init(activityItems: [item], applicationActivities: nil)
    
        activityViewController.completionWithItemsHandler = { type, suc, items, er in
//            print("分享结束了")
           try?FileManager.default.removeItem(atPath: path);
        }
//        activityViewController.excludedActivityTypes = [.addToReadingList,.copyToPasteboard]
        
        self.present(activityViewController, animated: true)
        
    }

    private func zipCreate(model: RTSandboxFileModel) -> String?{
        
        if model.isDirectory == false{
            return model.realPath
        }
        guard let arPath = model.realPath else {
            return nil
        }
        
        let readHandle = FileHandle(forReadingAtPath: arPath)
        
        let formatter = DateFormatter.init()
//        formatter.locale = Locale.init(identifier: "")
        formatter.calendar = Calendar.init(identifier: Calendar.Identifier.iso8601)
        formatter.dateFormat = "YYYYMMdd-HH:mm:ss.SSS";
        let dateString = formatter .string(from: Date())
        let tempPath = NSTemporaryDirectory().appending("\(model.fileName!)-\(dateString).zip")
    
        FileManager.default.createFile(atPath: tempPath, contents: Data.init())
    
        let writeHandle = FileHandle(forWritingAtPath: tempPath)
        
        let averageSize = 5.0 * 1000 * 1000
        
        let count = ceil(Double(model.size) * 1.0 / averageSize)
        
        for _ in 0..<Int(count) {
            autoreleasepool {
                if let data = readHandle?.readData(ofLength: Int(averageSize)){
                    writeHandle?.write(data)
                }
            }
        }
        
        readHandle?.closeFile()
        writeHandle?.closeFile()
    
        return tempPath
    }
    
    
    
}


extension FileManager{
    
    

    
    
}
