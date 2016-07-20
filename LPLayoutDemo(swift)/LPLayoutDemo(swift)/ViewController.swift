//
//  ViewController.swift
//  LPLayoutDemo(swift)
//
//  Created by iOS on 16/7/20.
//  Copyright © 2016年 iOS. All rights reserved.
//


import UIKit

class ViewController: UIViewController {

    var SCREEN_WIDTH = UIScreen.main().bounds.size.width
    var SCREEN_HEIGHT = UIScreen.main().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }

    func setCollectionView() {
        let laytou = LPLayout.init()
        laytou.roundRadius = 200
        laytou.roundCenter = CGPoint(x: 300, y: 300)
        laytou.itemSize = CGSize(width: 100, height: 100)
        laytou.pagingStyle = LPLayoutPagingStyle.slow
        
        
        
        let col = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 600), collectionViewLayout: laytou)
        col.center = CGPoint(x: UIScreen.main().bounds.width/2, y: col.bounds.size.height/2)
        col.backgroundColor = UIColor.green()
        col.delegate = self;
        col.dataSource = self;
        col.register(UINib.init(nibName: "LPCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        view.addSubview(col)
        
        let vv = UIView.init(frame: CGRect(x: 0, y: 299, width: SCREEN_WIDTH, height: 2))
        vv.backgroundColor = UIColor.red()
        view.addSubview(vv)
        
        
        
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LPCell
        cell.titleLab.backgroundColor = UIColor.red()
        cell.titleLab.text = "\(indexPath.row+1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

