//
//  cardCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
class cardCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var cardValueLabel: UILabel!
    var myCard: Card?
    
    //TODO Configure Cell with image and value 
    
    func configureCell(with card: Card) {
        if let myCard = myCard {
        self.cardValueLabel.text = "\(myCard.realValue)"
        ImageAPIClient.manager.getImage(from: myCard.image, completionHandler: {self.cardImageView.image = $0}, errorHandler: {print($0)})
        }
    }
    
    
    
}
