//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String {
    case targetScore
}

class GameViewController: UIViewController {
    
     let cellSpacing: CGFloat = 5.0
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    var gameBrain = GameBrainModel(targetScore: 30)
    
    var cardDeck: CardDeck?
    
    var cardsDrawn = [Card]() {
        didSet {
            cardsCollectionView.reloadData()
            // https://stackoverflow.com/questions/40786699/how-to-scroll-to-a-particluar-index-in-collection-view-in-swift
            // reference for sscrolling to last collectionview cell after drawing new card
            if cardsDrawn.count > 0 {
                cardsCollectionView.scrollToItem(at:IndexPath(item: self.cardsDrawn.count - 1, section: 0), at: .right, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let targetScore = UserDefaults.standard.value(forKey: UserDefaultsKeys.targetScore.rawValue) as? Int {
            gameBrain = GameBrainModel(targetScore: targetScore)
        }
        targetLabel.text = "Get up to \(gameBrain.getGoal()) without going over"
        DataPersistenceModel.shared.load()
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.cardsCollectionView.register(nib, forCellWithReuseIdentifier: "GameCardCell")
        self.cardsCollectionView.delegate = self
        self.cardsCollectionView.dataSource = self
        CardDeckAPIClient.manager.getCardDeck(completionHandler: { self.cardDeck = $0 }, errorHandler: { print($0) })
    }
    

    @IBAction func stopButtonPressed(_ sender: UIButton) {
        let toSave = PastGame(finalScore: gameBrain.getScore(),targetScore: gameBrain.getGoal() , gameCards: cardsDrawn)
        DataPersistenceModel.shared.addPastGame(pastGame: toSave)
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
                let toSave = PastGame(finalScore: self.gameBrain.getScore(), targetScore: self.gameBrain.getGoal(), gameCards: self.cardsDrawn)
                DataPersistenceModel.shared.addPastGame(pastGame: toSave)
                self.showAlertAndStartNewGame(with: "You went over \(self.gameBrain.getGoal())")
            }
        }, errorHandler: { print($0) })
    }
    
    // https://stackoverflow.com/questions/25511945/swift-alert-view-ios8-with-ok-and-cancel-button-which-button-tapped
    // reference for using UIAlertController for handling of new game
    func showAlertAndStartNewGame(with message: String) {
        let alertController = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game", style: .default, handler: { (action: UIAlertAction!) in
            self.cardsDrawn = []
            if let newTargetScore = UserDefaults.standard.value(forKey: UserDefaultsKeys.targetScore.rawValue) as? Int {
                self.gameBrain = GameBrainModel(targetScore: newTargetScore)
                self.targetLabel.text = "Get up to \(self.gameBrain.getGoal()) without going over"
            } else {
                self.gameBrain.resetGame()
            }
            self.messageLabel.text = "Current Hand Value:"
            CardDeckAPIClient.manager.getCardDeck(completionHandler: { self.cardDeck = $0 }, errorHandler: { print($0) })
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
            switch card.value {
            case "JACK", "QUEEN", "KING":
                cardCell.cardValueLabel.text = "10"
            case "ACE":
                cardCell.cardValueLabel.text = "11"
            default:
                cardCell.cardValueLabel.text = card.value
            }
            cardCell.cardImageView.image = #imageLiteral(resourceName: "backOfCard")
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
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing/2, bottom: cellSpacing, right: cellSpacing/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}
