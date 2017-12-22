//
//  CardCollectionViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Caroline Cruz on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
   
    
    func configureCell(with card: Card) {
        self.valueLabel.text = card.value
        ImageAPIClient.manager.loadImage(from: card.image, completionHandler: {self.cardImageView.image = $0; self.cardImageView.setNeedsLayout()}, errorHandler: {print($0)})
    }
}
