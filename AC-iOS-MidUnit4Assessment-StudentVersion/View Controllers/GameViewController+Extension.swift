//
//  GameViewController+Extension.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

// MARK: - viewController methods
extension GameViewController {
    func saveCurrentGame() {
        let totalScore = self.currentGame.reduce(0){(sum, num) in
            var total = sum
            total += num.cardVal
            return total
        }
        self.gameToSave = Game(score: totalScore, game: self.currentGame)
        KeyedArchiverClient.manager.saveGame(game: self.gameToSave)
    }
    
    func validCurrentGame() {
        let setNewGame: (UIAlertAction) -> Void = {(alert) in
            self.cancelButton.isEnabled = true
            self.drawCardButton.isEnabled = true
            self.cards = []
            self.saveCurrentGame()
        }
        if self.currentGameScore > self.valSetting {
            self.currentGameScoreLabel.text = "Current Hand Value: \(self.currentGameScore): BUST"
            self.cancelButton.isEnabled = false
            self.drawCardButton.isEnabled = false
            let alert = UIAlertController(title: "Defeat", message: "You went over \(self.valSetting)", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: setNewGame))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else if self.currentGameScore == self.valSetting {
            self.cancelButton.isEnabled = false
            self.drawCardButton.isEnabled = false
            let alert = UIAlertController(title: "Game Over", message: "You wont", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: setNewGame))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.currentGameScoreLabel.text = "Current Hand Value: \(self.currentGameScore)"
        }
        
    }
    
    func loadRndCard() {
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        let getCard: (RndCard) -> Void = {(card) in
            self.rndCard = card
        }
        RndCardAPIClient.manager.getRndCard(from: urlStr, completionHandler: getCard, errorHandler: {print($0)})
    }
    
    func loadPickedCard(from id: String) {
        let urlStrPickedCard = "https://deckofcardsapi.com/api/deck/\(id)/draw/?count=1"
        let addPickedCard: (PickedCard) -> Void = {(onlineCard) in
            if self.cards.isEmpty {
                self.cards = [onlineCard]
                self.currentGame = [GameSaved(cardVal: onlineCard.cards[0].cardVal, cardImage: onlineCard.cards[0].image)]
            } else {
                self.cards.append(onlineCard)
                self.currentGame.append(GameSaved(cardVal: onlineCard.cards[0].cardVal, cardImage: onlineCard.cards[0].image))
            }
        }
        PickedCardAPIClient.manager.getPickedCard(from: urlStrPickedCard, completionHandler: addPickedCard, errorHandler: {print($0)})
    }
}


// MARK: - CollectionView Cell dimensions
extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = collectionView.bounds.width
        let screenHeight = collectionView.bounds.height
        
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


// MARK: - CollectionView Datasource
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
