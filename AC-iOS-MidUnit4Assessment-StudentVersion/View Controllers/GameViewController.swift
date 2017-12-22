//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let cellSpacing = UIScreen.main.bounds.width * 0.05
    
    var deck: Deck?
    
    var cards: [Card] = [] {
        didSet {
            gameCollectionView.reloadData()
            if cards.count > 0 {
                gameCollectionView.scrollToItem(at: IndexPath.init(row: cards.count - 1, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            }
            checkGameStatus()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        gameCollectionView.register(nib, forCellWithReuseIdentifier: "cardCell")
        
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let targetNumber = Settings.manager.getTargetNumber() ?? 30
        
        instructionsLabel.text = "Try to reach \(targetNumber) without going over!"
    }
    
    @IBAction func drawACardButtonPressed(_ sender: UIBarButtonItem) {
        getCard()
    }
    
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        //should stop game, and present (30 - current score) "you were __ away from 30!"
        //alert should allow for new game
        stopGame()
        
    }
    
    func newGame() {
        let targetNumber = Settings.manager.getTargetNumber() ?? 30
        
        instructionsLabel.text = "Try to reach \(targetNumber) without going over!"
        
        CardGame.resetGame()
        loadNewDeck()
        scoreLabel.text = "Current Score: \(0)"
        cards = []
    }
    
    func stopGame() {
        let gameInfo = CardGame.stopGame()
        
        let alertController = Alert.createStoppedGameAlert(withScore: gameInfo.score, andTargetScore: gameInfo.targetScore, completionHandler: {
            self.newGame()
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadNewDeck() {
        DeckAPIClient.manager.getDeckID(completionHandler: { (deck) in
            self.deck = deck
            
        }, errorHandler: { (appError) in
            let alertController = Alert.createErrorAlert(withError: appError)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func getCard() {        
        guard let deck = deck else {
            print("No Deck Yet")
            return
        }
        
        CardAPIClient.manager.getCard(
            fromDeck: deck,
            completionHandler: { (card) in
                CardGame.addCard(card)
                self.cards = CardGame.getCards()
        },
            errorHandler: { (appError) in
            let alertController = Alert.createErrorAlert(withError: appError)
                
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func checkGameStatus() {
        
        self.scoreLabel.text = "Current Score: \(CardGame.getScore())"
        
        switch CardGame.checkForWin() {
        case .ongoing:
            break
        case .defeat:
            let alertController = Alert.createGameOverAlert(withGameStatus: .defeat, completionHandler: {
                self.newGame()
            })
            
            self.present(alertController!, animated: true, completion: nil)
        case .victory:
            let alertController = Alert.createGameOverAlert(withGameStatus: .victory, completionHandler: {
                self.newGame()
            })
            
            self.present(alertController!, animated: true, completion: nil)
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 1.5
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

extension GameViewController: UICollectionViewDataSource {
    
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

