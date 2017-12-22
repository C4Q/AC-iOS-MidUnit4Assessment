//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BlackjackViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    
    @IBAction func stopPressed(_ sender: UIButton) {
        earlyStop()
    }
    
    @IBAction func drawACardPressed(_ sender: UIButton) {
        fetchCardsFromDeck()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        KeyedArchiverClient.shared.loadFavorites()
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
        DeckAPIClient.manager.fetchDeck()
    }
    
    func updateVC() {
        setScoreLabel()
        collectionView.reloadData()
    }
    
    func setScoreLabel() {
        self.scoreLabel.text = GameModel.manager.valueOfHand.description
    }
    
    func fetchCardsFromDeck() {
        guard let endpoint = DeckModel.shared.cardEndpoint else { return }
        
        let completion: (CardData) -> Void = { cardData in
            CardModel.shared.addCard(cardData)
            self.handleGameState(gameState: GameModel.manager.checkIfWon())
            self.updateVC()
        }
        
        CardAPIClient.manager.getCards(from: endpoint,
                                       completionHandler: completion,
                                       errorHandler: {print($0)})
        
    }
    
    
    
    func earlyStop() {
        
        let resetGame: (UIAlertAction) -> Void = { _ in
            KeyedArchiverClient.shared.addHandToHistory(hand: CardModel.shared.viewCards())
            CardModel.shared.resetCards()
            DeckAPIClient.manager.fetchDeck()
            self.updateVC()
        }
        
        let howFarFromWinningValue = GameModel.manager.winningHandValue - GameModel.manager.valueOfHand
        let earlyStopAlert = UIAlertController(title: "You have not won yet!", message: "You are \(howFarFromWinningValue) away from \(GameModel.manager.winningHandValue). Are you sure you want to stop?", preferredStyle: .alert)
        earlyStopAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        earlyStopAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: resetGame))
        present(earlyStopAlert, animated: true, completion: nil)
    }
    
    
    func handleGameState(gameState: GameState) {
        
        let resetGame: (UIAlertAction) -> Void = { _ in
            KeyedArchiverClient.shared.addHandToHistory(hand: CardModel.shared.viewCards())
            CardModel.shared.resetCards()
            DeckAPIClient.manager.fetchDeck()
            self.updateVC()
        }
        
        switch gameState {
        case .won:
            let wonGameAlert = UIAlertController(title: "You've won!", message: "You had exactly \(GameModel.manager.winningHandValue) points! Would you like to play again?", preferredStyle: .alert)
            wonGameAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            wonGameAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: resetGame))
            present(wonGameAlert, animated: true, completion: nil)
            
        case .lost:
            let pointsOverWinningValue = GameModel.manager.valueOfHand - GameModel.manager.winningHandValue
            let lostGameAlert = UIAlertController(title: "You've lost!", message: "You went \(pointsOverWinningValue) points over \(GameModel.manager.winningHandValue). Would you like to play again?", preferredStyle: .alert)
            lostGameAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            lostGameAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: resetGame))
            present(lostGameAlert, animated: true, completion: nil)
            
        case .ongoing:
            return
        }
    }
    
}

extension BlackjackViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardModel.shared.viewCards().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let index = indexPath.item
        let card = CardModel.shared.viewCards()[index]
        cell.bottomLabel.text = card.value.first?.description.capitalized
        
        ImageDownloader.manager.getImage(from: card.image,
                                         completionHandler: {cell.cardImage.image = UIImage(data: $0); cell.setNeedsLayout()},
                                         errorHandler: {print($0)})
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        return cell
    }
    
}

extension BlackjackViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
    }
}


