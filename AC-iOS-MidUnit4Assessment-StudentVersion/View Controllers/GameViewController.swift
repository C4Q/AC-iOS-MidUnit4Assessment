//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var currentGameScoreLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var drawCardButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    var rndCard: RndCard! {
        didSet {
            loadPickedCard(from: rndCard.deckId)
        }
    }
    var cards = [PickedCard]() {
        didSet {
            self.currentGameScore = cards.reduce(0){(sum, val) in
                var total = sum
                total += val.cards[0].cardVal
                return total
            }
            
            validCurrentGame()
            self.gameCollectionView.reloadData()
        }
    }
    var valSetting = 0
    var currentGameScore: Int = 0
    var gameToSave: Game!
    var currentGame = [GameSaved]()
    var game: GameSaved!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyedArchiverClient.manager.load()
        let nib = UINib(nibName: "CardCell", bundle: nil)
        self.gameCollectionView.register(nib, forCellWithReuseIdentifier: "Card Cell")
        self.gameCollectionView.delegate = self
        self.gameCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let intValue = KeyedArchiverClient.manager.getSetting() {
            self.valSetting = intValue
            self.messageLabel.text = "Get up to \(intValue) without going over!"
        }
    }
    
    @IBAction func drawCardButton(_ sender: UIButton) {
        loadRndCard()
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        let pointsAway = self.valSetting - self.currentGameScore
        let alert = UIAlertController(title: "Game over", message: "You are \(pointsAway) point(s) away from \(self.valSetting)", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        let setNewGame: (UIAlertAction) -> Void = {(alert) in
            self.cancelButton.isEnabled = true
            self.drawCardButton.isEnabled = true
            self.cards = []
            self.saveCurrentGame()
        }
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: setNewGame))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
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
