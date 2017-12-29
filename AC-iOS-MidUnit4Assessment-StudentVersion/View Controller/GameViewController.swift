//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

/*
 TODO:
 Saving of images using File Manager
 Saving of values using user defaults
 Add the nibs
 */
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var handValueLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stopGameBtn: UIButton!
    @IBOutlet weak var drawCardBtn: UIButton!
    
    //Mark: - Outlets
    let cellSpacing: CGFloat = 20.0 //creating constant for the cell spacing
    
    //MARK: - What's powering the app
    var cards = [CardInfo](){
        didSet{
            self.gameCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handValueLabel.text = "Current Hand Value: 0"
    }
    
    //MARK: - Button actions for the game
    @IBAction func DrawCardButtonPressed(_ sender: UIButton) {
        //Get one card
        loadCard()
    }
    
    @IBAction func stopGameButtonPressed(_ sender: UIButton) {
        stopGameAlert()
    }
    
    //MARK: - loading in cards from the internet
    func loadCard(){
        //set completion
        let setOnlineCardImage: ([CardInfo]) -> Void = {(onlineCard: [CardInfo]) in
            self.cards.append(onlineCard.first!) //instead of setting onlineCard to the array (self.cards = onlineCard), APPEND the onlineCard into the array
            print("card is appended to array")
            //update the score
            let cardValue = GameModel.cardValues[onlineCard[0].value] //string that goes into the dict to get the value that is an Int
            GameModel.currentPoints += (cardValue ?? 0)
            
            //update label
            self.handValueLabel.text = "Current Hand Value: \(GameModel.currentPoints)"
            
            //win situation
            if GameModel.currentPoints == GameModel.pointsToWin{
                self.winGameAlert()
            } else if GameModel.currentPoints > GameModel.pointsToWin{
                self.loseGameAlert()
            }
        }
        CardAPIClient.manager.getOneNewCard(from: setOnlineCardImage,
                                            errorHandler: {print($0)})
        setUpAutomaticScrolling()
    
    
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
    
    } //loadCard func ends
    
    
    //MARK: - Adding scrolling animation when the user draws another card: https://stackoverflow.com/questions/15985574/uicollectionview-auto-scroll-to-cell-at-indexpath
    func setUpAutomaticScrolling(){
        //set last index to be the last card in the array
        let lastIndex = self.cards.count - 1
        //make sure that the last Index is not negative or else you will crash
        guard lastIndex >= 0 else {return}
        //creates an indexpath based on the lastIndex and whatever section you are referencing
        let indexPathOfCard = IndexPath(item: lastIndex, section: 0)
        //set scrolling animation
        gameCollectionView.scrollToItem(at: indexPathOfCard, at: .right, animated: true)
    }
    
    //MARK: - creating functions for the alerts
    func winGameAlert(){
        // win alert
        let alertController = UIAlertController(title: "You win!",
                                                message:"#Boss",
                                                preferredStyle: UIAlertControllerStyle.alert)
        //create alert action
        let newGameAction = UIAlertAction(title: "New Game", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //call the cardDeck API to get a new deck of cards
            self.cards = []
            self.handValueLabel.text = "Current Hand Value: 0"
            GameModel.currentPoints = 0
            print("button pressed")
        }
        //add the actions
        alertController.addAction(newGameAction)
        //present alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func loseGameAlert(){
        // lose alert
        let alertController = UIAlertController(title: "Defeat!",
                                                message:"You went over 30 points!",
                                                preferredStyle: UIAlertControllerStyle.alert)
        //create alert action
        let newGameAction = UIAlertAction(title: "New Game", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //call the cardDeck API to get a new deck of cards
            self.cards = []
            self.handValueLabel.text = "Current Hand Value: 0"
            GameModel.currentPoints = 0
            print("button pressed")
        }
        //add the actions
        alertController.addAction(newGameAction)
        //present alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func stopGameAlert(){
        // stop game alert
        let alertController = UIAlertController(title: "So Soon?",
                                                message:"You were \(GameModel.pointsToWin - GameModel.currentPoints) points away from 30",
            preferredStyle: UIAlertControllerStyle.alert)
        //create alert action
        let newGameAction = UIAlertAction(title: "New Game", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //call the cardDeck API to get a new deck of cards
            self.cards = []
            self.handValueLabel.text = "Current Hand Value: 0"
            GameModel.currentPoints = 0
            print("button pressed")
        }
        //add the actions
        alertController.addAction(newGameAction)
        //present alert controller
        self.present(alertController, animated: true, completion: nil)
    }
}



//MARK: - CollectionView set up
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let card = cards[indexPath.row] //hand of card
        print(card.value)
        print(card)
        guard let cardCell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "Game Collection View Cell", for: indexPath) as? GameCollectionViewCell else {return UICollectionViewCell()}
        
        //cardCell properties
        cardCell.cardValueLabel.text = "\(GameModel.cardValues[card.value] ?? 0)"
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
        let numCells: CGFloat = 4//number of cells visible in row
        let numSpace: CGFloat = numCells + 9
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





