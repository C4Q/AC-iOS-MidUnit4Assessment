//
//  PastGameTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class PastGameTableViewCell: UITableViewCell {
    
    let cellSpacing: CGFloat = 3.0
    
    @IBOutlet weak var pastGameScoreLabel: UILabel!
    @IBOutlet weak var pastGameCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.pastGameCollectionView.register(nib, forCellWithReuseIdentifier: "PastCardCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension PastGameTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        pastGameCollectionView.delegate = dataSourceDelegate
        pastGameCollectionView.dataSource = dataSourceDelegate
        pastGameCollectionView.tag = row
        pastGameCollectionView.setContentOffset(pastGameCollectionView.contentOffset, animated:false)
        pastGameCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { pastGameCollectionView.contentOffset.x = newValue }
        get { return pastGameCollectionView.contentOffset.x }
    }
    
}

