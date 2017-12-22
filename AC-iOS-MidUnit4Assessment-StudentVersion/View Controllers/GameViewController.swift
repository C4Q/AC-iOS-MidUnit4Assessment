//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
     let cellSpacing: CGFloat = 5.0
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    var gameBrain = GameBrainModel()
    
    var cardDeck: CardDeck?
    
    var cardsDrawn = [Card]() {
        didSet {
            cardsCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.cardsCollectionView.register(nib, forCellWithReuseIdentifier: "GameCardCell")
        self.cardsCollectionView.delegate = self
        self.cardsCollectionView.dataSource = self
        CardDeckAPIClient.manager.getCardDeck(completionHandler: { self.cardDeck = $0 }, errorHandler: { print($0) })
    }
    

    @IBAction func stopButtonPressed(_ sender: UIButton) {
        showAlertAndStartNewGame(with: "You are \(gameBrain.pointsAwayFromGoal()) away from \(gameBrain.goal)")
        CardDeckAPIClient.manager.getCardDeck(completionHandler: { self.cardDeck = $0 }, errorHandler: { print($0) })
    }
    
    @IBAction func drawCardButtonPressed(_ sender: UIButton) {
        guard let cardDeck = cardDeck else { return }
        CardAPIClient.manager.getCardDeck(from: cardDeck.deck_id, completionHandler: {
            self.cardsDrawn.append($0)
            self.gameBrain.addCardScore(card: $0)
            self.messageLabel.text = "Current Hand Value: \(self.gameBrain.getScore())"
            if self.gameBrain.didItGoOver() {
                self.messageLabel.text = "Current Hand Value: \(self.gameBrain.getScore()) BUST"
                self.showAlertAndStartNewGame(with: "You went over 30")
            }
        }, errorHandler: { print($0) })
    }
    
    func showAlertAndStartNewGame(with message: String) {
        let alertController = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        self.present(alertController, animated: true, completion: {
            self.cardsDrawn = []
            self.gameBrain.resetGame()
            self.messageLabel.text = "Current Hand Value:"
            CardDeckAPIClient.manager.getCardDeck(completionHandler: { self.cardDeck = $0 }, errorHandler: { print($0) })
        })
    }
    
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsDrawn.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCardCell", for: indexPath)
        let card = cardsDrawn[indexPath.row]
        if let cardCell = cardCell as? CardCollectionViewCell {
            cardCell.cardValueLabel.text = card.value
            ImageFetchHelper.manager.getImage(from: card.image, completionHandler: {
                cardCell.cardImageView.image = $0
                cardCell.setNeedsLayout()
            }, errorHandler: { print($0) })
        }
        return cardCell
    }
    
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing/2, bottom: cellSpacing, right: cellSpacing/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}
