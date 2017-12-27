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

}
