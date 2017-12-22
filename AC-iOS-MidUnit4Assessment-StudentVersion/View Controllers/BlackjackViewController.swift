//
//  BlackjackViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BlackjackViewController: UIViewController {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentHandValueLabel: UILabel!
    @IBOutlet weak var gameMessageLabel: UILabel!
    
    // Spacing for the collection view
    let spacing = UIScreen.main.bounds.size.width * 0.0125
    
    // Logic model
    var brain: BlackjackGameBrain?
    
    // Full array of deck - 52 cards
    var cards = [Card]()
    
    // Cards that the player draws
    var playerCards = [Card]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // Target amount for the game
    var targetAmount = 0 {
        didSet {
            gameMessageLabel.text = "Get up to \(targetAmount) without going over!"
            gameMessageLabel.isHidden = false
            currentHandValueLabel.isHidden = false
            brain = BlackjackGameBrain(target: self.targetAmount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self; collectionView.delegate = self
        
        // Use nib for collection view cell
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameSetup()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
    }

    // Stop button tapped
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        
        guard let brain = brain else { return }
        
        alertController(title: "Game Over", message: "Your total is: \(brain.cardTotal). The target was: \(brain.target).")

        DataPersistenceHelper.manager.addHand(playedCards: playerCards, target: brain.target, handTotal: brain.cardTotal)
        
        gameSetup()
        
    }
    
    // Draw button tapped
    @IBAction func drawACardButtonTapped(_ sender: UIButton) {
        
        guard let brain = brain else { return }
        
        let card = cards.removeLast()
        if let value = brain.cardValues[card.value] {
            brain.addCard(cardValue: value)
        }
        currentHandValueLabel.text = "Current hand value: \(brain.cardTotal)"
        
        playerCards.append(card)
        
        if brain.winner {
            alertController(title: "You Win!", message: "You hit the target of \(brain.target)!")
            
            DataPersistenceHelper.manager.addHand(playedCards: playerCards, target: brain.target, handTotal: brain.cardTotal)
            
            gameSetup()
        }
        
        if brain.totalIsOverTarget {
            alertController(title: "Game Over", message: "You went over \(brain.target).")
            
            DataPersistenceHelper.manager.addHand(playedCards: playerCards, target: brain.target, handTotal: brain.cardTotal)
            
            gameSetup()
            
        }
        
        
        
    }
    
    


}


// MARK: - Helper Functions

extension BlackjackViewController {
    
    func alertController(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func gameSetup() {
        
        // When the view is about to appear, reset game data and get a new deck of cards
        currentHandValueLabel.isHidden = true
        gameMessageLabel.isHidden = true
        currentHandValueLabel.text = "Current hand value: 0"
        playerCards.removeAll()
        
        DeckOfCardsAPIClient.manager.getCards(completionHandler: { self.cards = $0 }, errorHandler: { print($0) })
        
        // Checks for defaults or sets it a a default of 30
        if let defaults = UserDefaultsHelper.manager.getValue() {
            targetAmount = defaults.targetAmount
        } else {
            targetAmount = 30
        }
        
        
        
        
        
    }
    
    
}

extension BlackjackViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        
        if let cell = cell as? CardCollectionViewCell {
            
            let card = playerCards[indexPath.row]
            
            cell.cardImageView.image = nil
            
            let cardImgUrl = card.image
            
            ImageHelper.manager.getImage(from: cardImgUrl, completionHandler: { cell.cardImageView.image = $0 }, errorHandler: { print($0) } )
            
            if let brain = brain, let value = brain.cardValues[card.value] {
                cell.cardLabel.text = value.description
            }      
            
        }

        return cell
    }
    
    
}

extension BlackjackViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Define amount of cells I want per row
        let numCells: CGFloat = 3
        // Calculate the number of spaces I need to account for
        let numSpaces: CGFloat = numCells + 1
        // Return a CGSize to allow for a 4 by 1 view of cells
        return CGSize(width: ((collectionView.bounds.width - (spacing * numSpaces))/numCells), height: ((collectionView.bounds.height - (spacing * 2))))
    }
    
    // Set spacings to defined spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
}


