//
//  LFWaterFlowLayout.swift
//  LFWaterFlowView
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class LFWaterFlowLayout: UICollectionViewLayout {
    //列数 (可以随意更改)
    let columnCount = 3
    //每列之间的间距
    let columnMargin:CGFloat = 10
    //每行之间的距离
    let rowMargin:CGFloat = 10
    //边缘间距
    let edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    
    //存放所有的cell的布局属性
    var attributes = [UICollectionViewLayoutAttributes]();
    
    //存放所有列的当前高度
    var columHeights = [CGFloat]()
    
    //每次更新layout布局 都会首先调用此方法
    override func prepare() {
        print("---------")
        super.prepare()
        //清除之前的计算
        attributes.removeAll()
        columHeights.removeAll()
        for _ in 0..<columnCount {
            //刚开始每列的高度都是0
            columHeights.append(0)
        }
        //创建每一个cell对应的布局属性
        let count = collectionView?.numberOfItems(inSection: 0) ?? 0
        for i in 0..<count {
            //创建位置
            let indexPath = NSIndexPath(item: i, section: 0)
            //获取indexPath位置cell对应的布局属性
            let attrs = layoutAttributesForItem(at: indexPath as IndexPath)
            attributes.append(attrs!)
        }
    }
    /// UICollectionViewLayout 当继承UICollectionViewLayout时，会不停的调用layoutAttributesForElements方法
    //返回rect中的所有元素的布局属性 返回的是包含UICollectionViewLayoutAttributes的NSarray UICollectionViewLayoutAttributes可以是cell 追加视图或装饰视图的信息 通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes;
    }
    
    //返回对应于indexPath的位置的cell的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let collectionViewW = collectionView!.frame.width
        //设置布局属性的frame
        let w:CGFloat = (collectionViewW - edgeInsets.left - edgeInsets.right - CGFloat(columnCount - 1) * columnMargin) / CGFloat(columnCount)
        let h = CGFloat(50 + arc4random_uniform(100))
        
        //找出最短的那一列
        //最短列数
        var destColumn = 0
        //最短高度
        var minHeight = columHeights[0]
        //遍历数组找出最短高度
        for i in 1..<columnCount {
            let height = columHeights[i]
            if minHeight > height {
                minHeight = height
                destColumn = i
            }
        }
        let x:CGFloat = edgeInsets.left + (CGFloat(destColumn) * (w + columnMargin))
        let y = minHeight + columnMargin
        attrs.frame = CGRect(x: x, y: y, width: w, height: h)
        columHeights[destColumn] = attrs.frame.maxY
        return attrs
    }
    
    override var collectionViewContentSize: CGSize {
        var maxHeight = columHeights[0]
        // 便利数组找出最短的高度
        for i in 1..<columnCount {
            let height = columHeights[i]
            if maxHeight < height {
                maxHeight = height
            }
        }
        return CGSize(width: 0, height: maxHeight + columnMargin)
    }
    
}
