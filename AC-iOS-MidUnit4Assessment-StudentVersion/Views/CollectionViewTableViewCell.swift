//
//  CollectionViewTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    let cellSpacing = UIScreen.main.bounds.width * 0.05
    
    var cards: [Card] = [] //the number of cards
    
    func setUpCollectionView(forCell cell: CollectionViewTableViewCell, withCards cards: [Card]) {
        
        historyCollectionView.delegate = cell
        historyCollectionView.dataSource = cell
        
        self.cards = cards
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        
        historyCollectionView.register(nib, forCellWithReuseIdentifier: "cardCell")
        
        historyCollectionView.reloadData()
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 2.5
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.bounds.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = collectionView.bounds.height - (cellSpacing * 2)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)
        
        guard let cardCell = cell as? CardCollectionViewCell else {
            return cell
        }
        
        let currentCard = cards[indexPath.row]
        
        cardCell.configureCell(withCard: currentCard)
    
        return cardCell
    }
}
