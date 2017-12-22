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
    //Mark: - Outlets
    @IBOutlet weak var cardValueLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stopGameBtn: UIButton!
    @IBOutlet weak var drawCardBtn: UIButton!
    let cellSpacing: CGFloat = 20.0 //creating constant for the cell spacing
    
    //TODO: - creating alerts
    
    //MARK: - What's powering the app
    var cards = [CardInfo](){
        didSet{
            //TODO: - based on whether the total value of the 6 cards is above or below 30, an alert will pop up
            //            if cards[0].value < String(30){
            //                //MARK: - GameOver alert: https://www.youtube.com/watch?v=lDMV8Um_8n8
            //                gameOverAlert(titleText: "GameOver", message: "You were \(30 - Int(cards[0].value)!) away from 30")
            //            }
            //
            //            if cards[0].value > String(30){
            //                //MARK: - BUST alert
            //                gameOverAlert(titleText: "BUST", message: "You went over 30")
            //            }
            self.gameCollectionView.reloadData()
        }
    }
    
    var cardDeck = CardDeckInfo.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardValueLabel.text = "Current Hand Value: 0"
        //loadCards()
        //loadTestCards() //-> for test images
    }
    
    //    func loadTestCards(){
    //        self.cards = [CardInfo.testCards[0]]
    //    }
    
    @IBAction func DrawCardButtonPressed(_ sender: UIButton) {
        //Call Card API to get one new card
        loadCards()
    }
    
    @IBAction func stopGameButtonPressed(_ sender: UIButton) {
        //ResetGame: Current Value: 0,no cards in collection view
        cardValueLabel.text = "Current Hand Value: 0"
        
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        //Call the cardDeck API to get a new deck of cards
        //getNewDeck()
    }
    
    
    //loadCardDeck
    func loadCards(){
        //completion
        let setOnlineCardImages: ([CardInfo]) -> Void = {(onlineCards: [CardInfo]) in
            self.cards = onlineCards
            print("You have cards!")
        }
        CardAPIClient.manager.getOneNewCard(from: setOnlineCardImages,
                                            errorHandler: {print($0)})
    }
    
    //    func getNewDeck(){
    //        //completion
    //        let setOnlineCardDeck: (CardDeckInfo) -> Void = {(onlineCardDeck: CardDeckInfo) in
    //            cardDeck = onlineCardDeck
    //            print("You have card decks!")
    //        }
    //        CardAPIClient.manager.getNewCardDeck(from: setOnlineCardDeck,
    //                                             errorHandler: {print($0)})
    //    }
    
    
}

//MARK: - CollectionView of books by Category
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let card = cards[indexPath.row]
        guard let cardCell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "Game Collection View Cell", for: indexPath) as? GameCollectionViewCell else {return UICollectionViewCell()}
        
        //properties
        cardCell.cardValueLabel.text = card.value
        
        //MARK: - Getting and setting card images
//        if let imageUrlStr = card.images?.png {
//
//        let completion : (UIImage) -> Void = {(onlineImage: UIImage) in
//            cardCell.cardImage.image = onlineImage
//            //image loads as soon as it's ready
//            cardCell.setNeedsLayout()
//        }
//       ImageAPIClient.manager.loadImage(from: imageUrlStr,
//                                        completionHandler: completion,
//                                        errorHandler: {print($0)})
//        } else {
//             cardCell.cardImage.image = #imageLiteral(resourceName: "launchImage")
//        }
        return cardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: Manipulation CollectionView cellsizing
extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    //returns how large the cells should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2//number of cells visible in row
        let numSpace: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width  // screen width fo the device
        //print("cells are large enough!")
        //cgsize expects a tuple: (width, height)
        //returns item size
        return CGSize(width:(screenWidth - (cellSpacing * numSpace)), height: collectionView.bounds.height - (cellSpacing * 2))
        //return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
    }
    
    //returns padding around the collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    //returns padding between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

