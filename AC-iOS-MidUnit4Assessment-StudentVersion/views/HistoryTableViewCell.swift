//
//  HistoryTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

  
    @IBOutlet weak var finalHandValueLabel: UILabel!
    
    
    @IBOutlet weak var pastHandCollectionView: UICollectionView!
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        self.pastHandCollectionView.delegate = dataSourceDelegate
        self.pastHandCollectionView.dataSource = dataSourceDelegate
        self.pastHandCollectionView.tag = row
        self.pastHandCollectionView.reloadData()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
//no idea how to do this So i googled and found this function https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/

    

