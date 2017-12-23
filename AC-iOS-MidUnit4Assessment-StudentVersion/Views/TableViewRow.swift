//  TableViewRow.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/23/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class TableViewRow: UITableViewCell {
	@IBOutlet weak fileprivate var collectionView: UICollectionView!
	var history: [SavedGame] = DataModel.manager.getHistory()
	let cellSpacing = UIScreen.main.bounds.size.width * 0.05
}

extension TableViewRow : UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		print("HVC - CollectionView - numberOfSections"); print()
		print("HVC - History.count: \(history.count)"); print()
		return history.count
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("HVC - CollectionView - numberOfItemsInSection"); print()
		print("HVC - numberOfItemInSection: \(history[collectionView.tag].cards.count)"); print()
//	return history[collectionView.tag].cards.count
		return history[section].cards.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	print("HVC - CollectionView - cellforItemAt"); print()
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveCardCell", for: indexPath) as! SaveCardCell
		let game = history[collectionView.tag]
	print("HVC - CollectionView - game: \(game)"); print()
		let gameCard = game.cards[indexPath.row]
	print("HVC - CollectionView - gameCard: \(gameCard)"); print()
		cell.valueLabel.text = "\(gameCard.cardValueInt)"
	print("HVC - CollectionView - cardValueInt: \(gameCard.cardValueInt)"); print()
		cell.cardImage.image = nil ?? #imageLiteral(resourceName: "placeholder-image")
		cell.cardImage.image = gameCard.cardImage
		return cell
	}
}

extension TableViewRow : UICollectionViewDelegateFlowLayout {
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//		let itemsPerRow:CGFloat = 4
//		let hardCodedPadding:CGFloat = 5
//		let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//		let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//		return CGSize(width: itemWidth, height: itemHeight)
//	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
			print("HVC - CollectionView - didSelectItemAt"); print()
			print("HVC - Collection view at row \(collectionView.tag) selected index path \(indexPath)"); print()
		}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numCells: CGFloat = 2.0
		let numSpaces: CGFloat = numCells + 1
		let screenWidth = UIScreen.main.bounds.width
		return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height:
			collectionView.bounds.height - (cellSpacing * 2))
	}
	//// padding around our collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
	}
	//// padding between cells / items
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}
}


