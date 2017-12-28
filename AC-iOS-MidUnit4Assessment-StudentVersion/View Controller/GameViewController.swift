//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

/*
 TODO:
 Have an additonal card show up in the collection view as I type on one card
 Create alerts
 Saving of images using File Manager
 Saving of values using user defaults
 Add the nibs
 */
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var cardValueLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stopGameBtn: UIButton!
    @IBOutlet weak var drawCardBtn: UIButton!
    
    //Mark: - Outlets
    let cellSpacing: CGFloat = 20.0 //creating constant for the cell spacing
    
    //MARK: - What's powering the app
//    var cardArray: [CardInfo] = [] //Empty array to add cards into as you draw them
    var cards = [CardInfo](){
        didSet{
//            //TODO: - based on whether the total value of the 6 cards is above or below 30, an alert will pop up
//            if cards[0].value < String(30){
//                //MARK: - GameOver alert: https://www.youtube.com/watch?v=lDMV8Um_8n8
//                //gameOverAlert(titleText: "GameOver", message: "You were \(30 - Int(cards[0].value)!) away from 30")
//                print("Not quite to 30!")
//            }
//
//            if cards[0].value > String(30){
//                //MARK: - BUST alert
//                //gameOverAlert(titleText: "BUST", message: "You went over 30")
//                print("You went over 30")
//            }
            
//            for card in cards {
//                cards.append(card)
//            }
//
            //change the value based on the card that is added
            cardValueLabel.text = "Current Hand Value: \(cards[0].value)"
            self.gameCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardValueLabel.text = "Current Hand Value: 0"
    }
    
    //MARK: - Button actions for the game
    @IBAction func DrawCardButtonPressed(_ sender: UIButton) {
        //Call Card API to get one new card
        loadCard()
        //adding a card to the array everytime user draws a card
    }
    
    @IBAction func stopGameButtonPressed(_ sender: UIButton) {
        //ResetGame: Current Value: 0,no cards in collection view
        cardValueLabel.text = "Current Hand Value: 0"
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        //Call the cardDeck API to get a new deck of cards
        //getNewDeck()
    }
    
    
    
    //MARK: - loading in cards from the internet
    func loadCard(){
        //set completion
        let setOnlineCardImage: ([CardInfo]) -> Void = {(onlineCard: [CardInfo]) in
            self.cards.append(onlineCard.first!) //appending the first card to the array of CardInfo
            print("You have cards!")
        }
        CardAPIClient.manager.getOneNewCard(from: setOnlineCardImage,
                                            errorHandler: {print($0)})
    }
    
    
    //MARK: - Getting a new deck from online
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
        var cardArray: [CardInfo] = [] //Empty array to add cards into as you draw them
        
        for card in cards {
            cardArray.append(card)
            print("adding card to cardArray")
        }
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let card = cards[indexPath.row]
        
        guard let cardCell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "Game Collection View Cell", for: indexPath) as? GameCollectionViewCell else {return UICollectionViewCell()}
        
        //cardCell properties
        cardCell.cardValueLabel.text = card.value
        cardCell.cardImage.image = nil
        
        //MARK: - Getting and setting card images
        let imageUrlStr = card.images.png //ONLY "IF LET" IF IT'S AN OPTIONAL!
        
        //set completion
        let setImageToOnlineImage : (UIImage) -> Void = {(onlineImage: UIImage) in
            cardCell.cardImage.image = onlineImage
            print("IMAGES!")
            //image loads as soon as it's ready
            cardCell.setNeedsLayout()
        }
        ImageAPIClient.manager.loadImage(from: imageUrlStr,
                                         completionHandler: setImageToOnlineImage,
                                         errorHandler: {print($0)})
        return cardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: Manipulating CollectionView cellsizing
extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    //returns how large the cells should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2//number of cells visible in row
        let numSpace: CGFloat = numCells + 5
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

//MARK: - crating functions for the alerts
func gameOverAlert(){}
func bustAlert(){}
