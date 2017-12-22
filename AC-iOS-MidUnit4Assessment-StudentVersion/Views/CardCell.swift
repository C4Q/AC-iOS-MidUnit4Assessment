//  CardCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class CardCell: UICollectionViewCell {
	@IBOutlet weak var cardImage: UIImageView!
	@IBOutlet weak var cardLabel: UILabel!

	//MARK: Methods

	
}



class PixabayTableViewCell: UITableViewCell {
	//MARK: Outlets
	@IBOutlet weak var pixabayImageView: UIImageView!
	@IBOutlet weak var tagsLabel: UILabel!
	@IBOutlet weak var likesLabel: UILabel!

	//MARK: Methods
	func configureCell(with pixabay: Pixabay) {
		self.tagsLabel.text = pixabay.tags
		self.likesLabel.text = "\(pixabay.likes) likes"
		ImageAPIClient.manager.loadImage(from: pixabay.webformatURL, completionHandler: {self.pixabayImageView.image = $0;
			self.pixabayImageView.setNeedsLayout()},
																		 errorHandler: {print($0)})
	}

}
