//  CardCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class CardCell: UICollectionViewCell {
	//MARK: Outlets
	@IBOutlet weak var cardImage: UIImageView!
	@IBOutlet weak var valueLabel: UILabel!

	//MARK: Initializers - Override both UIView initializers
	override init(frame: CGRect) {
		super .init(frame: frame)
		commonInit()
	}
	required init?(coder aDecoder: NSCoder) {
		super .init(coder: aDecoder)
		commonInit()
	}
	//MARK: Method - create a common
	private func commonInit() {
		//loaded the xib by name from memory
		Bundle.main.loadNibNamed("CardCell", owner: self, options: nil)
		//add the content view that we’ve dragged in as an outlet as a subview of the view we’ve created.
		addSubview(contentView)
		//Positioned the content view to take up the entire view’s appearance.
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}

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


