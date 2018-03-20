//
//  ViewController.swift
//  LFFlowView
//
//  Created by ios开发 on 2017/8/21.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowView = LFFlowView.init(frame:CGRect(x: 0, y: 100, width: self.view.frame.width, height: 100) , titleArr: ["收藏商品  >","支付定金  >","支付尾款  >","商家发货  >"], radius: 12, roundIndex: 4, lineIndex: 4)
        
        //全部完成
//        flowView.setCurrentRoundIndex(index: 5, lineIndex: 5)
        self.view.addSubview(flowView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

