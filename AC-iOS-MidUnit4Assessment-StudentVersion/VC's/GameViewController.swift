//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    //Global Variables
    var newDeckID = [NewDeck]() {
        didSet{
            GameLogic.deckID = newDeckID[0].deckID
            if newDeckID[0].shuffled == false {
                //Shuffle Deck here
                let completion: ([NewDeck]) -> Void = {(onlineDeckInfo: [NewDeck]) in
                    self.newDeckID = onlineDeckInfo
                }
                ShuffledDeckAPIClient.manager.getShuffledDeck(fromDeckID: newDeckID[0].deckID, completionHandler: completion, errorHandler: {print($0)})
            }
        }
    }
    
    var currentHand = [[Card]](){
        didSet{
            collectionView.reloadData()
        }
    }
    let cellSpacing: CGFloat = 20.0
    
    
    @IBOutlet weak var currentHandValueLabel: UILabel!
    
    @IBAction func stopButton(_ sender: UIButton) {
        //TODO Save Hand
        SavedHandsArchiverClient.manager.add(hand: self.currentHand)
        
        //TODO Show alert that displays "You are \(PointsToWin - currentsum) away from \(pointstowin)"
        let alertVC = UIAlertController(title: "You Stopped", message: "You are \(GameLogic.pointsToWin - GameLogic.sum) points from \(GameLogic.pointsToWin)!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "New Game", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        
        //Once alert is clicked run resetfunction
        resetGame()
    }
    @IBAction func drawACard(_ sender: UIButton) {
        //Call CardAPI to draw one card
        let completion: ([Card]) -> Void = {(cardFromOnline: [Card]) in
            //Add that card to the collection view
            self.currentHand.append(cardFromOnline)
            //Add that cards value to the sum
            let cardValue = GameLogic.cardValues[cardFromOnline[0].value]
            GameLogic.sum = GameLogic.sum + (cardValue ?? 0)
            self.currentHandValueLabel.text = "Current Hand Value: \(GameLogic.sum)"
            
            //Check if sum of card values is over PointsToWin
            if GameLogic.gameOver {
                if GameLogic.sum == GameLogic.pointsToWin {
                    //TODO Show alert
                    let alertVC = UIAlertController(title: "You Win!", message: "You Win!!!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "New Game", style: .cancel, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                    //TODO Save hand
                    SavedHandsArchiverClient.manager.add(hand: self.currentHand)
                    //Reset Game
                    self.resetGame()
                } else {
                    //TODO Show alert
                    let alertVC = UIAlertController(title: "Game Over", message: "You Lose!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "New Game", style: .cancel, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                    //TODO Save hand
                    SavedHandsArchiverClient.manager.add(hand: self.currentHand)
                    //Reset Game
                    self.resetGame()
                }
            }
        }
        
        CardsAPIClient.manager.getACard(fromDeckID: GameLogic.deckID, completionHandler: completion, errorHandler: {print($0)})
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadData()
    }
    
    func loadData() {
        //Call the API for a new deck
        let completion: ([NewDeck]) -> Void = {(onlineDeckInfo: [NewDeck]) in
            
            self.newDeckID = onlineDeckInfo
            
        }
        
        NewDeckAPIClient.manager.getNewDeck(completionHandler: completion, errorHandler: {print($0)})
    }
    
    func resetGame() {
        //Empty collection view array
        currentHand = []
        
        //reset sum tracker and gameState
        GameLogic.sum = 0
        GameLogic.gameOver = false
        
        //reset labels
        currentHandValueLabel.text = "Current Hand Value: \(GameLogic.sum)"
        loadData()
    }
    
}
//MARK: Collection View Delegate and DataSource
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentHand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "handCollectionViewCell", for: indexPath) as? HandCollectionViewCell else {return UICollectionViewCell() }
        
        let aCard = currentHand[indexPath.row]
        cell.cardLabel.text = "\(aCard[0].value)"
        
        // TODO Call IMAGE API IN CELL
        let cardImageLink = aCard[0].imageLink
        cell.cardImage.image = nil
        cell.spinner.isHidden = false
        cell.spinner.startAnimating()
        let setImageToOnlineImage: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.cardImage.image = onlineImage
            cell.spinner.stopAnimating()
            cell.spinner.isHidden = true
            cell.cardImage.setNeedsLayout()
        }
        
        ImageAPIClient.manager.getImage(from: cardImageLink, completionHandler: setImageToOnlineImage, errorHandler: {print($0)})
        
        return cell
    }
    
    //FLOW LAYOUT DELEGATES
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = CGFloat(currentHand.count) // cells visible in row
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width // screen width of the device
        let screenHeight = UIScreen.main.bounds.height // screen height of the device
        
        //return item size
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: (screenHeight / 3) - (cellSpacing * 2))
    }
    
    //Padding around collection cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let numCells: CGFloat = CGFloat(currentHand.count) // cells visible in row
        let screenHeight = UIScreen.main.bounds.height // screen height of the device
        let totalCellHeight = (screenHeight / 3) - (cellSpacing * 2) * numCells
        let totalSpacingHeight = cellSpacing * (numCells - 1)
        
        let topInset = ((screenHeight / 3) - (cellSpacing * 2) - CGFloat(totalCellHeight + totalSpacingHeight)) / 2
        let bottomInset = topInset
        return UIEdgeInsets(top: topInset, left: topInset, bottom: bottomInset, right: bottomInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}


