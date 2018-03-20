//
//  ViewController.swift
//  LFStartTateView
//
//  Created by ios开发 on 2017/8/21.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       let starView = LFStarRateView.init(frame: CGRect(x: 20, y: 140, width: 200, height: 30), numOfStars: 5, currentScore: 0, isAnimation: true) { (currentScore) in
            print("用户分数  \(currentScore)")
        }
        self.view.addSubview(starView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

