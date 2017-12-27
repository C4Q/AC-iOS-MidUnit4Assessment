//
//  GameViewController+Extension.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

extension GameViewController: UICollectionViewDelegate {
    
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height
        
        return CGSize(width: (screenWidth - (self.cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card Cell", for: indexPath) as? CardCell {
            let card = cards[indexPath.row]
            cell.cardImageView.image = nil
            cell.cardValueLabel.text = "\(card.cards[0].cardVal)"
            ImageAPIClient.manager.getImage(from: card.cards[0].image, completionHandler: {cell.cardImageView.image = $0}, errorHandler: {print($0)})
            cell.cardImageView.setNeedsLayout()
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
