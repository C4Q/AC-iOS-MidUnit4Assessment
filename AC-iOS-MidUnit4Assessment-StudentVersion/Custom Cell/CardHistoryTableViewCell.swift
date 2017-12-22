//
//  CardHistoryTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardHistoryTableViewCell: UITableViewCell {
    


    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var finalHandLabel: UILabel!
    
    
    
    // I HAD TO LOOK THIS UP CAUSE WE NEVER DID SOMETHING LIKE THIS IN CLASS?!?! LIKE WHAT?!?!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout>
        (dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}


    



