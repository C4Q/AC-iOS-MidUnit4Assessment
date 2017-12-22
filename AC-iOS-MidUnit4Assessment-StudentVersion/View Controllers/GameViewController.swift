//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var currentGameScoreLabel: UILabel!
    @IBOutlet weak var currentGameCollectionView: UICollectionView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    
    /// 2) Have deckId. Store here
    var currentDeckOfSix: NewCardDeck? {
        didSet {
            loadCardDeck()
        }
    } // make a function and call in the viewDidLoadto call the DeckAPIClient to populate this value
    
    /// 4) currentDeckOfCards is loaded. Waiting to be accessed by Draw Button
    var currentDeckOfCards = [Card]() // array of all the cards in 6 decks
    
    
    // whenever currentCardHand array is modified, the collectionView will reload to reflect the change (addition)
    var currentGameHand = [Card]() { // array of my current hand of <5 cards
        didSet {
            self.currentGameCollectionView.reloadData()
        }
    }
    
    var currentHandScore: Int = 0 {
        didSet {
            currentGameScoreLabel.text = "Current Hand Score: \(currentHandScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentGameCollectionView.dataSource = self
        self.currentGameCollectionView.delegate = self
        currentGameScoreLabel.text = "Current Hand Value: \(currentHandScore)"
        loadNewDeckOfSix() // gets us deckID
    }
    
    /// 1) Access Deck API Client. Get deckID
    // calls the Deck API Client to load the one NewCardDeck object which gives us access to the deckID
    func loadNewDeckOfSix() {
        let completion: (NewCardDeck) -> Void = {(onlineCardDeck: (NewCardDeck)) in
            self.currentDeckOfSix = onlineCardDeck
        }
        let errorHandler: (Error) -> Void = {(error: Error) in
        }
        DeckAPIClient.manager.getNewDeck(completionHandler: completion, errorHandler: errorHandler)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
    }
    
    /// 5) When Draw button pressed, take one card from the currentDeckOfCards array and load it to currentGameHand array to be shown in CollectionView
    @IBAction func drawButtonPressed(_ sender: UIButton) {
        // when button pressed, hit the draw card API
        // call function to load a Card, load image
//        loadACard(from: <#T##Card#>, cell: <#T##CustomCardCollectionViewCell#>)
        
        // get the value of the Card
        // save the values of Card to var currentCardHand
        // show the image of the Card in currentGameCollectionView
        // show the value of the Card in currentGameCollectionView
        // add the value of the Card to the var currentHandScore
        
        
        
    }
    
    
}


extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = currentGameHand[indexPath.row]
        let cardCell = currentGameCollectionView.dequeueReusableCell(withReuseIdentifier: "Card Cell", for: indexPath) as! CustomCardCollectionViewCell
        return cardCell
    }
    
    
    // calls the CardAPIClient, takes in the deckID from currentDeckID and gets an array of Cards to play with
    /// 3) Take deckID and hit Card API Client to load currentDeckOfCards
    func loadCardDeck() {
        guard let myDeckID = currentDeckOfSix?.deckID else { return }
        let completion: ([Card]) -> Void = {(onlineCards: [Card]) in
            self.currentDeckOfCards = onlineCards }
        CardAPIClient.manager.getOneCard(deckID: myDeckID, completionHandler: completion, errorHandler: {print($0)})
    }
}

extension GameViewController: UICollectionViewDelegate {
    
}
