//
//  LFWaterFlowLayout1.swift
//  LFWaterFlowView
//
//  Created by ios开发 on 2018/3/6.
//  Copyright © 2018年 ios开发. All rights reserved.
//

import UIKit

class LFWaterFlowLayout1: UICollectionViewFlowLayout {

    override func prepare() {
        //设置方向
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        //设置内边距
        let insert = ((self.collectionView?.frame.width)! - (self.itemSize.width)) / 2
        self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert)
    }
    
    /**
     *  这个方法的返回值是一个数组(数组里存放在rect范围内所有元素的布局属性)
     *  这个方法的返回值  决定了rect范围内所有元素的排布（frame）
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //获得super已经计算好的布局属性 只有线性布局才能使用
        var atts = super.layoutAttributesForElements(in: rect)
        for att in atts! {
            let centetX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.frame.size.width)! / 2
            //cell的中心点x 和CollectionView最中心点的x值
            let delta = abs(att.center.x - centetX)
            let scale = 1 - delta / (self.collectionView?.frame.size.width)!;
            att.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return atts
    }
    
    /*!
     *  多次调用 只要滑出范围就会 调用
     *  当CollectionView的显示范围发生改变的时候，是否重新发生布局
     *  一旦重新刷新 布局，就会重新调用
     *  1.layoutAttributesForElementsInRect：方法
     *  2.preparelayout方法
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    //UIScrollView的方法 只要一松手 就会调用
    /*
     *这个方法的返回值 就决定了CollectionView停止滚动时的偏移量
     *proposedContentOffset  这个是最终的 偏移量的值 但是实际的情况还是要根据返回值来定
     *velocity  是滚动速率  有个x和y 如果x有值 说明x上有速度
     *如果y有值 说明y上又速度 还可以通过x或者y的正负来判断是左还是右（上还是下滑动）  有时候会有用
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //计算出 最终显示的矩形框
        var rect = CGRect()
        rect.origin.x = proposedContentOffset.x
        rect.origin.y = 0
        rect.size = (self.collectionView?.frame.size)!
        
        let array = super.layoutAttributesForElements(in: rect)
        //TODO:  这里的计算和上面的计算不一样的
        // 计算CollectionView最中心点的x值 这里要求 最终的 要考虑惯性
        let centerX = (self.collectionView?.frame.size.width)! / 2 + proposedContentOffset.x
        var minDelta:CGFloat = 1000000000.0
        for att in array! {
            if (abs(minDelta) > abs(att.center.x-centerX)) {
                minDelta = att.center.x-centerX;
            }
        }
        //修改原来的偏移量
        let offset =  CGPoint.init(x: proposedContentOffset.x + minDelta, y: proposedContentOffset.y)       
        return offset
    }
    
}
