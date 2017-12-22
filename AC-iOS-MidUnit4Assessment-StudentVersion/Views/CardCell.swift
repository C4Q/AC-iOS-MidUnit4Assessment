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
		let imageURL = card.image //image url source
		let setImage: (UIImage)-> Void = {(onlineImage: UIImage) in
			self.cardImage.image = onlineImage
			self.cardImage.setNeedsLayout()
		}
		ImageHelper.manager.getImage(from: imageURL, completionHandler: setImage, errorHandler: {print($0)})
	}
}


