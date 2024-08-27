//
//  ViewController.swift
//  RTSandbox
//
//  Created by RT on 2024/8/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let viewc = UINavigationController(rootViewController: RTSandboxViewController())
        
        self.present(viewc, animated: true)
    }

}

