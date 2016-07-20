//
//  LPLayout.swift
//  LPLayoutDemo(swift)
//
//  Created by iOS on 16/7/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

import UIKit
enum LPLayoutPagingStyle: Int {
    case none
    case fast
    case slow
}
class LPLayout: UICollectionViewLayout {

    var roundCenter = CGPoint()
    var roundRadius = CGFloat()
    var itemSize = CGSize()
    var pagingStyle = LPLayoutPagingStyle.none
    
    internal var itemCount: Int = 0
    
    override func prepare() {
        super.prepare()
        itemCount = (collectionView?.numberOfItems(inSection: 0))!
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: (self.collectionView?.frame.width)!, height: (collectionView?.bounds.height)!*10)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrsArr = attrsArrForVisible(rect: rect, offset: (self.collectionView?.contentOffset)!)
        return attrsArr as? [UICollectionViewLayoutAttributes]
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var rect = CGRect.init()
        rect.origin = proposedContentOffset
        rect.size = (collectionView?.bounds.size)!
        
        let attrsArr: [UICollectionViewLayoutAttributes] = attrsArrForVisible(rect: rect, offset: proposedContentOffset) as! [UICollectionViewLayoutAttributes]
        
        let centerY = roundCenter.y + proposedContentOffset.y
        
        var gap = CGFloat(MAXFLOAT)
        
        for attr in attrsArr {
            if (abs(gap) > abs(attr.center.y - centerY)) {
                gap = attr.center.y - centerY
            }
        }
        var Y: CGFloat = 0.0
        
        if (pagingStyle == LPLayoutPagingStyle.fast || velocity.y == 0) {
            Y = asin(gap/roundRadius)*(4*roundRadius)/CGFloat(2*M_PI)
            Y = abs(proposedContentOffset.y + Y)
        }
        if (pagingStyle == LPLayoutPagingStyle.slow && velocity.y != 0) {
            let mutiple = Int((collectionView?.contentOffset.y)!/(roundRadius*4/CGFloat(itemCount)))
            if velocity.y > 0 {
                Y = (roundRadius*4/CGFloat(itemCount))*(CGFloat(mutiple+1))
            }
            if velocity.y < 0 {
                Y = (roundRadius*4/CGFloat(itemCount))*(CGFloat(mutiple))
            }
        }
        if (pagingStyle == LPLayoutPagingStyle.none) {
            Y = CGFloat(MAXFLOAT)
        }
        
        let point = CGPoint(x: proposedContentOffset.x, y: Y)
        
        return point
        
    }
    
    
    
    //自定义方法
    func attrsArrForVisible(rect: CGRect, offset: CGPoint) -> NSArray {
        let attrsArr = NSMutableArray.init()
        for i in 0..<itemCount {
            let indexPath = NSIndexPath.init(item: i, section: 0)
            let attr = layoutAttributesForItem(indexPath: indexPath, offset: offset)
            let isInter = rect.intersects(attr.frame)
            
            if isInter {
                attrsArr.add(attr)
            }
        }
        return attrsArr
    }
    
    func layoutAttributesForItem(indexPath: NSIndexPath, offset: CGPoint) -> UICollectionViewLayoutAttributes {
        let b = offset.y
        
        let angel = CGFloat(M_PI*2)/CGFloat(itemCount)
        let addAngel = angel*CGFloat(indexPath.row) + CGFloat(2*M_PI)/CGFloat(4*roundRadius)*b
        
        let x = roundCenter.x - roundRadius*cos(addAngel)
        let y = roundCenter.y - roundRadius*sin(addAngel) + b
        
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath as IndexPath)
        attr.center = CGPoint(x: x, y: y)
        attr.size = itemSize
        
        //等比例缩放，不需要可注释
        let bili = 1 - (roundRadius - abs(attr.center.x - roundCenter.x))*0.5/roundRadius
        attr.transform = CGAffineTransform(scaleX: bili, y: bili)
        
        return attr
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
