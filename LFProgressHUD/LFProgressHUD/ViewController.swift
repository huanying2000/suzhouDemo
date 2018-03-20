//
//  ViewController.swift
//  LFProgressHUD
//
//  Created by ios开发 on 2017/8/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func popToUser(_ sender: Any) {
        
        LFProgressHUD.showMessage("请先登录")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

