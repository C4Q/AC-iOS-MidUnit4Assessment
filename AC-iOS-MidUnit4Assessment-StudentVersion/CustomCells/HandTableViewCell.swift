//
//  HandTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HandTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Set a standard global scope spacing for your cells to refer too
    let cellSpacing:CGFloat = 10.0
    
    //I have no idea what this does
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var savedHands = [[[Card]]]()
    
    func configureCollectionView(forCell cell: HandTableViewCell, forIndexPath indexPath: IndexPath) {
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        // tag the collectionView here to so you can access the correct data set in UICollectionViewDataSource
        cell.collectionView.tag = indexPath.row
        
        setUpTheLabel()
    }
    func setUpTheLabel() {
        let aHand = savedHands[collectionView.tag]
        var totalValueOfHand = 0
        for cards in aHand {
            if let cardValue = GameLogic.cardValues[cards[0].value] {
                totalValueOfHand += cardValue
            }
        }
        
        self.headerLabel.text = "Total Value \(totalValueOfHand)"
        
    }
}

extension HandTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // here we use the tag to access the correct index of our data
        // e.g tag = 0, 1, 2, ...or the relavant index in the array
        return savedHands[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "handCollectionViewCell", for: indexPath) as! NetflixStyleCollectionViewCell
        
        let aCardInAHand = savedHands[collectionView.tag][indexPath.row] //The array that represents one card
        
        cell.valueLabel.text = "\(aCardInAHand[0].value)" //The value of that card
        
        let cardImageLink = aCardInAHand[0].imageLink //Link for the image of that card
        
        let setImageToOnlineImage: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.imageView.image = onlineImage
            cell.imageView.setNeedsLayout()
        }
        //API Call for image
        ImageAPIClient.manager.getImage(from: cardImageLink, completionHandler: setImageToOnlineImage, errorHandler: {print($0)})
        
        return cell
    }
    
}

//Literally the same collectionView Flow Layout we used before. If it ain't broke don't fix it.
extension HandTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2.0 // cells visible in row
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width // screen width of device
        
        // retrun item size
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: collectionView.bounds.height - (cellSpacing * 2))
    }
    
    // padding around our collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    // padding between cells / items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}


