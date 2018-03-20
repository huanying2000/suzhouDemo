//
//  ViewController.swift
//  LFWaterFlowView
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建布局格式
        let layout = LFWaterFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.yellow
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.red
        let tag = 100
        var label = cell.viewWithTag(tag) as? UILabel
        if label == nil {
            label = UILabel()
            label?.tag = tag
            cell.addSubview(label!)
        }
        label?.text = "\(indexPath.item)"
        label?.sizeToFit()

        return cell
    }
    
}

