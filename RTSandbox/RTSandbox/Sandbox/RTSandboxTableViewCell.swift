//
//  RTSandboxTableViewCell.swift
//  RTAppSandBox
//
//  Created by RT on 2024/8/14.
//

import UIKit

class RTSandboxTableViewCell: UITableViewCell {
    
    
    var detailBtnClick:((_ model: RTSandboxFileModel?)->())?
    
    
    var model: RTSandboxFileModel? {
        willSet{
         
            guard let val = newValue else { return  }
            
            if val.childList?.count ?? 0 == 0 {
                
                contentView.backgroundColor = .white
            }else{
                contentView.backgroundColor = .white
            }
            
            let name = val.fileName as? NSString
            nameLbl.text = name?.deletingPathExtension
            
            setFileTypeIcon(val)
            
            let formater = ByteCountFormatter()
//            formater.includesUnit = true
            formater.countStyle = .decimal // 1024
            if val.size > 1 * 1000 * 1000 * 1000{
                formater.allowedUnits = .useGB
            }
            else if val.size > 1 * 1000 * 1000{
                formater.allowedUnits = .useMB
            }
            else if val.size > 1 * 1000 {
                formater.allowedUnits = .useKB
            }
            else{
                formater.allowedUnits = .useBytes
            }
                
            sizeLbl.text = formater.string(fromByteCount: val.size)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addUIControls()
    }
    
    private func addUIControls(){
        
        addConstraintsClouse(view: iconView) { make in
            let centerY = NSLayoutConstraint(item: make, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
            let width = NSLayoutConstraint(item: make, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 45)
            let height = NSLayoutConstraint(item: make, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 45)
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 12)
            return [width,height,centerY,left]
        }
        
        addConstraintsClouse(view: nameLbl) { make in
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: iconView, attribute: .right, multiplier: 1, constant: 5)
            let top = NSLayoutConstraint(item: make, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .top, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1, constant: -90)

            return [left,top,right]
        }
        
        addConstraintsClouse(view: sizeLbl) { make in
            let bottom = NSLayoutConstraint(item: make, attribute: .bottom, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1, constant: 0)
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: nameLbl, attribute: .left, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .right, multiplier: 1, constant: -90)
            return [bottom, left,right]
        }
        
        addConstraintsClouse(view: detailBtn) { make in
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -12)
            let centerY = NSLayoutConstraint(item: make, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
            
            return [right, centerY]
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addConstraintsClouse(view: UIView, contraintsClosure:(UIView)->([NSLayoutConstraint])) {
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let contraints = contraintsClosure(view)
        self.addConstraints(contraints)
    }
    
    
 
    private lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 3
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    private lazy var nameLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "这是测试数据1"
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.backgroundColor = UIColor.white
        lbl.lineBreakMode = .byTruncatingMiddle
       return lbl
    }()
    
    private lazy var sizeLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "这是测试数据2"
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .darkGray
        lbl.backgroundColor = UIColor.white
       return lbl
    }()
    
    
    private lazy var modifiDateLbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    
    private lazy var detailBtn: UIButton = {
        
//        let action = UIAction { act in
//            
//            print("点击了详情按钮")
//        }
//        if #available(iOS 14.0, *) {
//            let btn = UIButton(type:.infoDark, primaryAction: action)
//        } else {
//            // Fallback on earlier versions
//        }
        
        let btn = UIButton(type: .infoDark)
        
        btn.addTarget(self, action: #selector(clickDetail(btn:)), for: .touchUpInside)
    
        return btn
    }()
    
    
    @objc private func clickDetail(btn: UIButton){
    
        if self.detailBtnClick != nil{
            self.detailBtnClick!(self.model)
        }
    }
    
    
    fileprivate func setFileTypeIcon(_ val: RTSandboxFileModel) {
        var imageName = "unknown"
        switch val.fileType {
        case .pdf:
            imageName = "pdf"
        case .audio:
            imageName = "audio"
        case .folder:
            imageName = "folder"
        case .js:
            imageName = "js"
        case .video:
            imageName = "video"
        case .html:
            imageName = "html"
        case .css:
            imageName = "css"
        case .json:
            imageName = "json"
        case .txt:
            imageName = "txt"
        case .zip:
            imageName = "zip"
        case .xsl:
            imageName = "xsl"
        case .plist:
            imageName = "plist"
        case .image:
            imageName = "image"
        case .doc:
            imageName = "doc"
        case .ss:
            imageName = "ss"
        case .ppt:
            imageName = "ppt"
        default: break
            
        }
        iconView.image = Bundle.rt_image(imgName: imageName)
    }
    
}

extension Bundle{
    
    
    static func rt_image(imgName: String) -> UIImage?{
        guard let path = Bundle.main.path(forResource: "RTSanboxBundle.bundle", ofType: nil) else {
            return nil
        }
        let bundle = Bundle(path: path)
        guard let filePath = bundle?.path(forResource: imgName, ofType: "png") else {
            return nil
        }
        return UIImage(contentsOfFile: filePath)
    }
    
    
}
