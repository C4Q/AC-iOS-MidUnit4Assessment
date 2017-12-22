//
//  CardGameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardGameViewController: UIViewController {


    
    
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var currentHandLabel: UILabel!
    @IBOutlet weak var drawCardButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentHandValue = 0
    var currentDeck: DeckOfCards?
    var cards = [Card](){
        didSet{
            collectionView.reloadData()
        }
    }
   var cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersistentStoreManager.manager.load()
        loadDeck()
        loadNib()
        setRoundButtons()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func setRoundButtons(){
        drawCardButton.layer.cornerRadius = drawCardButton.frame.width/2
        stopButton.layer.cornerRadius = stopButton.frame.width/2
        
    }
    
    
    
    
    func loadNib(){
        let nib = UINib(nibName: "cardCollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
        
    }
    
    func loadDeck(){
        
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        
        let completion: (DeckOfCards) -> Void = {(onlineDeckOfCards: DeckOfCards) in
            self.currentDeck = onlineDeckOfCards
            }
        
        
    
        let errorHandler: (AppError) -> Void = {(error: AppError) in
            switch error{
            case .noInternetConnection:
                print("Deck of Cards: No internet connection")
            case .couldNotParseJSON:
                print("Deck of Cards: Could Not Parse")
            case .badStatusCode:
                print("Deck of Cards: Bad Status Code")
            case .badURL:
                print("Deck of Cards: Bad URL")
            case .invalidJSONResponse:
                print("Deck of Cards: Invalid JSON Response")
            case .noDataReceived:
                print("Deck of Cards: No Data Received")
            case .notAnImage:
                print("Deck of Cards: No Image Found")
            default:
                print("Deck of Cards: Other error")
            }
        }
    
        DeckOfCardsAPIClient.manager.getDeckOfCards(from: urlStr, completionHandler: completion, errorHandler: errorHandler)
        
    }
    
    
    
    
    
    
   
    @IBAction func stopPressed(_ sender: UIButton) {
        let difference = 30 - currentHandValue
        let alert = UIAlertController(title: "You quit!", message: "You were \(difference) points away from 30", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            self.resetGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBAction func drawCardPressed(_ sender: UIButton) {
        addCard()
        
        
    }
    
    
    
    
    func winCheck(){
        currentHandLabel.text = "Your current hand: " + currentHandValue.description
        if currentHandValue == 30{
            let alert = UIAlertController(title: "CONGRATULATIONS", message: "You Win!", preferredStyle: UIAlertControllerStyle.alert)
            
                alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                    self.resetGame()
                }))
                self.present(alert, animated: true, completion: nil)
        }
        
        if currentHandValue > 30{
            let difference = currentHandValue - 30
            let alert = UIAlertController(title: "Game Over!", message: "You were over \(difference) points", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                self.resetGame()
            }))
         self.present(alert, animated: true, completion: nil)
    }
    }
    
    
    
    func resetGame(){
        PersistentStoreManager.manager.addToFavorites(cards: cards, finalValue: currentHandValue, id: (currentDeck?.deckID)! )
        cards.removeAll()
        currentHandLabel.text = "Your current hand: 0"
        currentHandValue = 0
    }
    
    
    func addCard(){
    
        guard let deckId = currentDeck?.deckID else {
            print("error with deck ID")
            return
        }
        
        let urlStr = "https://deckofcardsapi.com/api/deck/\(deckId)/draw/?count=1"
        
        let completion: (Card) -> Void = {(onlineCard: Card) in
            
            self.currentHandValue += self.calculateCardValue(card: onlineCard)
            self.cards.append(onlineCard)
            self.winCheck()
            }
        
        
        let errorHandler: (AppError) -> Void = {(error: AppError) in
            switch error{
            case .noInternetConnection:
                print("Card Call: No internet connection")
            case .couldNotParseJSON:
                print("Card Call: Could Not Parse")
            case .badStatusCode:
                print("Card Call: Bad Status Code")
            case .badURL:
                print("Card Call: Bad URL")
            case .invalidJSONResponse:
                print("Card Call: Invalid JSON Response")
            case .noDataReceived:
                print("Card Call: No Data Received")
            case .notAnImage:
                print("Card Call: No Image Found")
            default:
                print("Card Call: Other error")
            }
        }
        CardAPIClient.manager.getCard(from: urlStr, completionHandler: completion, errorHandler: errorHandler)
    }
    
    
    func calculateCardValue(card: Card) -> Int{
        
        switch card.value{
            
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "10":
            return 10
        case "JACK":
            return 10
        case "QUEEN":
            return 10
        case "KING":
            return 10
        case "ACE":
            return 11
            
        default:
            print("ERROR WITH CARD VALUE")
            return 0

        }
    }
    
    

}









extension CardGameViewController: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 2
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}













extension CardGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }




    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let cardToSetUp = cards[indexPath.row]
        let valueString = calculateCardValue(card: cardToSetUp).description
        cell.cardValue.text = valueString
        setCardImage(card: cardToSetUp, cell: cell)
        return cell
}
    
    func setCardImage(card: Card, cell: CardCollectionViewCell){
        let imageUrl = card.image
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.cardImage.image = onlineImage
        }
        ImageAPIClient.manager.getImage(from: imageUrl, completionHandler: completion, errorHandler: {print ($0)})
        
    }
    
    
    
    
}

