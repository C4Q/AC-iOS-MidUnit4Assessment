//  TableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
	@IBOutlet fileprivate weak var collectionView: UICollectionView!
}

extension TableViewCell {
	func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

		//set Delegate and Datasource
		collectionView.delegate = dataSourceDelegate
		collectionView.dataSource = dataSourceDelegate

		//tag = row
		collectionView.tag = row

		//reload data
		collectionView.reloadData()
	}

}
