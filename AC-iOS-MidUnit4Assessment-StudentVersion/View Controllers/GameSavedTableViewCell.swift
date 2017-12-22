//
//  GameSavedTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameSavedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreGameLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    var games = [GameSaved]() {
        didSet {
            self.gameCollectionView.reloadData()
        }
    }
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.gameCollectionView.delegate = self
        self.gameCollectionView.dataSource = self
    }

}

extension GameSavedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = collectionView.bounds.width
        
        let screenHeight = collectionView.bounds.width
        
        return CGSize(width: (screenWidth - (self.cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.60)
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

extension GameSavedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? GameSavedCollectionViewCell {
            let game = games[indexPath.row]
            cell.scoreLabel.text = "\(game.cardVal)"
            cell.imageView.image = nil
            ImageAPIClient.manager.getImage(from: game.cardImage, completionHandler: {cell.imageView.image = $0}, errorHandler: {print($0)})
            cell.imageView.setNeedsLayout()
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
