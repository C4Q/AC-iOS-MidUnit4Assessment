//
//  CardHistoryTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var finalHandLabel: UILabel!
    
    
    var favorites = PersistentStoreManager.manager.getFavorites()
    
    var cellSpacing = UIScreen.main.bounds.size.width * 0.05

    
    
    func configureCollectionView(forCell cell: CardHistoryTableViewCell, forIndexPath indexPath: IndexPath) {
        let nib = UINib(nibName: "cardCollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.row
        
    }

    
}


extension CardHistoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // here we use the tag to access the correct index of our data
        // e.g tag = 0, 1, 2, ...or the relavant index in the array
        return favorites[collectionView.tag].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        // here we use the tag to access the correct index of our data
        // e.g tag = 0, 1, 2, ...or the relavant index in the array
        let card = favorites[collectionView.tag].cards[indexPath.row]
        cell.cardValue.text = calculateCardValue(card: card).description
        
        
        
        let imageURL = card.image
        
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.cardImage.image = onlineImage
        }
        
        ImageAPIClient.manager.getImage(from: imageURL, completionHandler: completion, errorHandler: {print ($0)})
        
        
        
        return cell
    }
    
    
    
    func calculateCardValue(card: Card) -> Int{
        
        switch card.value{
            
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "10":
            return 10
        case "JACK":
            return 10
        case "QUEEN":
            return 10
        case "KING":
            return 10
        case "ACE":
            return 11
            
        default:
            print("ERROR WITH CARD VALUE")
            return 0
            
        }
    }
    
}

extension CardHistoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 2
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}




