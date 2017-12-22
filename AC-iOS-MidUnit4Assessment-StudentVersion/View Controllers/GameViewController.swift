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
    
    /// 2) Obtained deckID from func loadNewDeckOfSix. Access deckID in this object
    // make a function and call in the viewDidLoadto call the DeckAPIClient to populate this value
    var currentDeckOfSix: NewCardDeck? = nil {
        didSet {
            print("deck id: \(currentDeckOfSix?.deckID.description)")
            print("currentDeckOfSix populated")
        }
    }
    
    /// 3B) Here is my current Card. When the Draw Button is pressed, that runs func drawACard() which hits the CardAPIClient and gets the details for one Card. Now can load, save views with the details from this object.
    var currentCard: [Card]? {
        didSet {
            print("\(currentCard?.description ?? "no current card")")
            print("currentCard populated")
        }
    }
    
    
    // whenever currentCardHand array is modified, the collectionView will reload to reflect the change (addition)
    var currentGameHand = [Card]() { // array of my current hand of <5 cards
        didSet {
            self.currentGameCollectionView.reloadData()
            print("\(currentGameHand.description ?? "no currentGameHand")")
            print("currentGameHand populated")
        }
    }
    
    var currentHandScore: Int = 0 {
        didSet {
            currentGameScoreLabel.text = "Current Hand Score: \(currentHandScore)"
            print("currentHandScore updated")
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
            print("this is set")
        }
        let errorHandler: (Error) -> Void = {(error: Error) in
        }
        DeckAPIClient.manager.getNewDeck(completionHandler: completion, errorHandler: errorHandler)
        print("\(currentDeckOfSix?.deckID)")
        print("step 1 finished. or IS IT. Nope, doesn't seem like it. fml bye")
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        // alert for game over
        // save game array to the history array using NSKeyedArchiver
        // start new game
    }
    
    /// 3) Click Draw
    /// 3A) Calls func drawACard() which takes the deckID and hits Card API Client to draw ONE card
    /// 3B) Loads details for one card in var currentCard
    // When Draw button pressed, take one card from the currentDeckOfCards array and load it to currentGameHand array to be shown in CollectionView
    @IBAction func drawButtonPressed(_ sender: UIButton) {
       
        // call function to load a Card, load image
        // get the value of the Card
        
        // save the values of Card to var currentCardHand
        // show the image of the Card in currentGameCollectionView
        // show the value of the Card in currentGameCollectionView
        // add the value of the Card to the var currentHandScore
      
//      drawACard(from: <#T##Card#>, cell: <#T##CardCollectionViewCell#>)
        
    }
    
    
    

}


extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // shows the array of Card objects loaded into currentGameHand
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardCell = currentGameCollectionView.dequeueReusableCell(withReuseIdentifier: "Card Cell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        let card = currentGameHand[indexPath.row]
        drawACard(from: card, cell: cardCell)
        return cardCell
    }
    
    
    /// 3A) Take deckID and hit Card API Client to draw ONE card
    func drawACard(from card: Card, cell: CardCollectionViewCell) {
        // check if there is a deck ID
        guard let myDeckID = currentDeckOfSix?.deckID else { return }
        CardAPIClient.manager.getOneCard(deckID: myDeckID, completionHandler: {
            let details = $0
            let imageURL = details[0].image
            ImageAPIClient.manager.loadImage(from: imageURL!, completionHandler: {
                cell.cardNib.imageView.image = $0
                cell.cardNib.setNeedsLayout()
            }, errorHandler: {print("error loading card image: \($0)")})
        }, errorHandler: {print($0)})
        print("step 3A finished")
    }
    

}



let spacingBetweenCells = UIScreen.main.bounds.size.width * 0.05

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    /// size of the item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfCells: CGFloat = 1
        let numOfSpaces: CGFloat = numOfCells + 1 // spaces between the cells left and right
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (spacingBetweenCells * numOfSpaces)) / numOfCells, height: screenHeight * 0.45) // this Double changes the height of the cells
    }
    
    /// insets for collection view - borders at the ENDS of the entire collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacingBetweenCells, left: spacingBetweenCells, bottom: spacingBetweenCells, right: spacingBetweenCells)
    }
    
    /// spacing between rows ^v
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /// spacing between columns <>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
}



