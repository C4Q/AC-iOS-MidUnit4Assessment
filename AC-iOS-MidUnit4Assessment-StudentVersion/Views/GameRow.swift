//  GameRow.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

class GameRow : UITableViewCell {
	@IBOutlet weak var collectionView: UICollectionView!
}

extension GameRow : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		//TO DO -- change how to get savedGameIndex
		let savedGameIndex = 1
		return DataModel.manager.getHistory()[savedGameIndex].cards.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveCardCell", for: indexPath) as! CardCell
		return cell
	}

}

extension GameRow : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow:CGFloat = 4
		let hardCodedPadding:CGFloat = 5
		let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
		let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
		return CGSize(width: itemWidth, height: itemHeight)
	}

}
