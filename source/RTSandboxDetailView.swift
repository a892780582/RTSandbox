//
//  RTSandboxDetailView.swift
//  RTSandbox
//
//  Created by sjh on 2024/8/28.
//

import UIKit

class RTSandboxDetailView: UIView {
    
    var sandboxModel: RTSandboxFileModel?
    
    var startY: CGFloat = 0.0

    var rate: CGFloat = 0.4

    init(frame:CGRect,sandboxModel: RTSandboxFileModel? = nil) {
        self.sandboxModel = sandboxModel
        super.init(frame: frame)
        self.startY = self.bounds.height * (1 - rate);
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        self.layer.addSublayer(backgroundLayer)
        
        self.addGestureRecognizer(tapGes)
        
        
//        if {
//          
//        }
        
        let acountView = assembleView(desc: "所有者：", text: sandboxModel?.ownerAccountName ?? "")
        
        let format = "YY/MM/dd HH:mm:ss"
        let createString = sandboxModel?.createTime?.toString(format) ?? ""
        let createView = assembleView(desc: "创建日期：", text: createString)
        
        let modifiString = sandboxModel?.modificationDate?.toString(format) ?? ""
        
        let modifiView = assembleView(desc: "修改日期：", text: modifiString)
        
        let sysSizeView = assembleView(desc: "磁盘空间：", text: sandboxModel?.systemSize.description ?? "")
        
        let countView = assembleView(desc: "子文件数:", text: sandboxModel?.childList?.count.description ?? "0")
        
        self.addSubview(createView)
        self.addSubview(modifiView)
        self.addSubview(sysSizeView)
        self.addSubview(countView)
        
        let height = 45.0
        let space = 5.0
        
        addConstraintsClouse(view: createView) { make in
            let top = NSLayoutConstraint(item: make, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: startY + 15)
            let height = NSLayoutConstraint(item: make, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
            
            return [top,height,left,right]
        }
        
        addConstraintsClouse(view: modifiView) { make in
            let top = NSLayoutConstraint(item: make, attribute: .top, relatedBy: .equal, toItem: createView, attribute: .bottom, multiplier: 1, constant: space)
            let height = NSLayoutConstraint(item: make, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
            
            return [top,height,left,right]
        }
        
        addConstraintsClouse(view: sysSizeView) { make in
            let top = NSLayoutConstraint(item: make, attribute: .top, relatedBy: .equal, toItem: modifiView, attribute: .bottom, multiplier: 1, constant: space)
            let height = NSLayoutConstraint(item: make, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
            
            return [top,height,left,right]
        }
        addConstraintsClouse(view: countView) { make in
            let top = NSLayoutConstraint(item: make, attribute: .top, relatedBy: .equal, toItem: sysSizeView, attribute: .bottom, multiplier: 1, constant: space)
            let height = NSLayoutConstraint(item: make, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
            
            return [top,height,left,right]
        }
        
      
    }
    
    fileprivate lazy var tapGes: UITapGestureRecognizer = {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap: )))
        
        return tap
    }()
    
    @objc private func tapClick(tap: UITapGestureRecognizer){
        
        let point = tap.location(in: self)
        if point.y < startY{
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let beOat = UIBezierPath.init(roundedRect: CGRect(x: 0, y: startY, width: self.bounds.width, height: self.bounds.height - startY), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 15, height: 15))
        layer.path = beOat.cgPath
        layer.fillColor = UIColor.white.cgColor
        layer.fillMode = .both
        return layer
    }()
    
    
    
    func assembleView(desc: String, text: String) -> UIView{
        
        let view = UIView(frame: CGRect.zero)
        
        let lbl_desc = UILabel.init()
        lbl_desc.text = desc
        view.addSubview(lbl_desc)
        
        let lbl_text = UILabel.init()
        lbl_text.text = text
        view.addSubview(lbl_text)
        
        addConstraintsClouse(view: lbl_desc) { make in
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 12)
            let width = NSLayoutConstraint(item: make, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 100)
            let centerY = NSLayoutConstraint(item: make, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            return [left,width,centerY]
        }
        addConstraintsClouse(view: lbl_text) { make in
            let left = NSLayoutConstraint(item: make, attribute: .left, relatedBy: .equal, toItem: lbl_desc, attribute: .right, multiplier: 1, constant: 12)
            let right = NSLayoutConstraint(item: make, attribute: .right, relatedBy: .lessThanOrEqual, toItem: view, attribute: .right, multiplier: 1, constant: -12)
            let centerY = NSLayoutConstraint(item: make, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            return [left,right,centerY]
        }
        return view
    }
    
    func addConstraintsClouse(view: UIView, contraintsClosure:(UIView)->([NSLayoutConstraint])) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let contraints = contraintsClosure(view)
        view.superview!.addConstraints(contraints)
    }
    

}
