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
    
    //maybe use a card game model?
    var deck: Deck?
    
    var cards: [Card] = [] {
        didSet {
            //reload collection view
            gameCollectionView.reloadData()
            if cards.count > 0 {
                gameCollectionView.scrollToItem(at: IndexPath.init(row: cards.count - 1, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            }
            checkGameStatus()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //the instructions label should change based on what the user sets the score to
        CardGame.delegate = self
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
        //user should be able to change target number any time
    }
    
    @IBAction func drawACardButtonPressed(_ sender: UIBarButtonItem) {
        //to do
        //should add card to collection view, then reload
        getCard()
        //also check if score is over 30? - maybe do in game model
        //maybe game model should return "victory, ongoing, defeat" or something, so we can present different things
        //alert should allow for new game
        //should also add card to persistent data
            
    }
    
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        //should stop game, and present (30 - current score) "you were __ away from 30!"
        //alert should allow for new game
        
    }
    
    func newGame() {
        //to do - should reset collection view
        //should reset labels
        let targetNumber = Settings.manager.getTargetNumber() ?? 30
        
        instructionsLabel.text = "Try to reach \(targetNumber) without going over!"
        
        CardGame.resetGame()
        loadNewDeck()
        scoreLabel.text = "Current Score: \(0)"
        cards = []
        
        //should reset current collectionview data source variable and reload data
        //should load new Deck
    }
    
    func loadNewDeck() {
        DeckAPIClient.manager.getDeckID(completionHandler: { (deck) in
            self.deck = deck
            
        }, errorHandler: { (appError) in
            self.presentErrorAlert(withError: appError)
        })
    }
    
    func getCard() {
        //should get a card using current deck
        //append to current card - using card game model
        
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
            self.presentErrorAlert(withError: appError)
        })
    }
    
    func checkGameStatus() {
        
        self.scoreLabel.text = "Current Score: \(CardGame.getScore())"
        
        switch CardGame.checkForWin() {
        case .ongoing:
            break
        case .defeat:
            presentGameOverAlert(withGameStatus: .defeat)
        case .victory:
            presentGameOverAlert(withGameStatus: .victory)
        }
    }
    
    //I should create an alert model to clean up the view controllers
    func presentErrorAlert(withError error: Error) {
        let message: String
        
        switch error {
        case AppError.badURL(let url):
            message = "Bad URL:\n\(url)"
        case AppError.badImageURL(let url):
            message = "Bad Image URL:\n\(url)"
        case AppError.badData:
            message = "Bad Data"
        case AppError.badImageData:
            message = "Bad Image Data"
        case AppError.badResponseCode(let code):
            message = "Bad Response Code:\n\(code)"
        case AppError.cannotParseJSON(let rawError):
            message = "Cannot Parse JSON:\n\(rawError)"
        case AppError.noInternet:
            message = "No Internet Connection."
        case AppError.other(let rawError):
            message = "\(rawError)"
        default:
            message = "\(error)"
        }
        
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentGameOverAlert(withGameStatus gameStatus: CardGame.GameStatus) {
        let title: String
        let message: String
        
        switch gameStatus {
        case .ongoing:
            return
        case .defeat:
            title = "LOOOOLLLLLLLL"
            message = "😂😂😂\nYOU LOST!!!!!\nGET CGRECT YA LOSER\n😂😂😂"
        case .victory:
            title = "Wooooooowww... 😒"
            message = "😒 So I guess you won >_> 😒"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "New Game", style: .default) { _ in
            self.newGame()
        }
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GameViewController: CardGameDelegate {
    
    func saveGame(withCards cards: [Card], score: Int, andTargetScore targetScore: Int) {
        //to do - should save in persistentdata model
        
        //save the cards
        
        //save the score
        
        //this way they both always have the same index number
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

