//  CardCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class CardCell: UICollectionViewCell {
	//MARK: Outlets
	@IBOutlet weak var cardImage: UIImageView!
	@IBOutlet weak var valueLabel: UILabel!

	//MARK: Methods
	func configureCell(with card: Card) {
		self.valueLabel.text = card.value
		ImageHelper.manager.getImage(from: card.image, completionHandler: {self.card.Image.image = $0; self.cardImage.setNeedsLayout()},
		errorHandler: {print($0)})
	}
}


