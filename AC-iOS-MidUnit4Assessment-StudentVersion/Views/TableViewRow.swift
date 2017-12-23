//  TableViewRow.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/23/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class TableViewRow: UITableViewCell  {
	@IBOutlet weak var collectionView: UICollectionView!
	var history: [SavedGame] = DataModel.manager.getHistory()
	let cellSpacing = UIScreen.main.bounds.size.width * 0.04
	var tableIndexPath: IndexPath?

}

extension TableViewRow : UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return history.count
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let numOfItems = history[section].cards.count
		return numOfItems
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveCardCell", for: indexPath) as! SaveCardCell
		let gameCard = history[(indexPath.section)].cards
		cell.valueLabel.text = "\(gameCard[(indexPath.row)].cardValueInt)"
		cell.cardImage.image = nil ?? #imageLiteral(resourceName: "placeholder-image")
		cell.cardImage.image = gameCard[(indexPath.row)].cardImage
		return cell
	}
}

extension TableViewRow : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numCells: CGFloat = 2.8
		let numSpaces: CGFloat = numCells + 1
		let screenWidth = UIScreen.main.bounds.width
		return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height:
			collectionView.bounds.height - (cellSpacing * 1.8))
	}
	//// padding around our collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
	}
	//// padding between cells / items
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}
}


