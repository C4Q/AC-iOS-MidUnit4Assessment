//
//  CardCollectionViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(withCard card: Card) {
        guard let cardValue = CardGame.cardValueDict[card.value] else {
            return
        }
        
        cardValueLabel.text = cardValue.description
        
        cardImageView.image = nil
        
        guard let url = URL(string: card.imageURL) else {
            print("Error setting up card image")
            return
        }
        
        if let image = PersistentData.manager.getImage(withURL: url) {
            cardImageView.image = image
            self.setNeedsLayout()
        } else {
            ImageAPIClient.manager.getImage(
                with: card.imageURL,
                completionHandler: { (cardImage) in
                    self.cardImageView.image = cardImage
                    self.setNeedsLayout()
                    PersistentData.manager.saveImage(cardImage, withURL: url)
            },
                errorHandler: {print($0)})
        }
    }

}
