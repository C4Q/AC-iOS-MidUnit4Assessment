//
//  HistoryTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var finalValue: UILabel!
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    // https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        let nibCell = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.collectionView.register(nibCell, forCellWithReuseIdentifier: "CardCollectionViewCell")
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.backgroundColor = UIColor.green
        collectionView.reloadData()
    }
}



