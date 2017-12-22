//  CardCellView.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.


import UIKit

//class CardCellView: UIView {
//	//MARK: Outlets
//	@IBOutlet weak var cardImage: UIImageView!
//	@IBOutlet weak var valueLabel: UILabel!
//
//	//MARK: Methods
//	func configureCell(with card: Card) {
//		self.valueLabel.text = card.value
//		ImageHelper.manager.getImage(from: card.image, completionHandler: {self.card.Image.image = $0; self.cardImage.setNeedsLayout()},
//																 errorHandler: {print($0)})
//	}
//
//	//MARK: Initializers
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//	}
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		if let view = Bundle.main.loadNibNamed("Card", owner: self, options: nil)?.first as? UIView {
//			self.addSubview(view)
//			view.frame = self.bounds
//			backgroundColor = .black
//			layer.cornerRadius = 5.0
//			layer.masksToBounds = true
//			layer.borderWidth = 2.0
//			layer.borderColor = UIColor.black.cgColor
//			heightAnchor.constraint(equalToConstant: 150).isActive = true
//			widthAnchor.constraint(equalToConstant: 107).isActive = true
//			translatesAutoresizingMaskIntoConstraints = false
//		}
//	}
//}

