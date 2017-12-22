//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

//NOTE TO TA: I was having issues with parsing the data(could'nt figure out what was wrong even though i've parsed tougher JSON :/ ) so I was unable to load data in the appropriate places. I will be resubmitting during the break. Enjoy the cute schnauzer pup in the meantime! :)

class BlackJackViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var currentHandValueLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        //TODO: disable draw button
        //TODO: Save final card value info
        //TODO: Show how far theu were away fro 30
        //TODO: Send to Recents view controller
    }
    
    
    @IBAction func drawACardButtonPressed(_ sender: UIButton) {
        //TODO: Keep track of hand value...add to the value total
        //TODO: Add conditional statement...if current hand value > 30 then defeat message via alert pop-up
        //TODO: Add conditional statement...if hand value == 30 then victory message via alert pop-up
    }
    
    let cellSpacing: CGFloat = 10.0
    
    var cardId: CardIdentity!
    var myCards = [CardInfo]()
    var cardImage: UIImage!
    
    var myCardsCode: String = ""
    var myCardsValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardCollectionView.dataSource = self
        self.cardCollectionView.delegate = self
        loadDeckIdentityData()
        loadTheCardData()
        //set nib here
    }
    
    
    //MARK: -Loading all Data
    func loadDeckIdentityData() {
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        let setIdentityToOnlineID: (CardIdentity) -> Void = {(onlineID: CardIdentity) in
            self.cardId = onlineID
        }
        DeckIdentityAPIClient.manager.getCardIdentity(from: urlStr, completionHandler: setIdentityToOnlineID, errorHandler: {print($0)})
    }
    
    func loadTheCardData() {
        //guard let cardId = cardId else { return }
        let testID = "7vlk6gflplio"
        let urlStr = "https://deckofcardsapi.com/api/deck/\(testID)/draw/?count=1"
        let setCardToOnlineCard: ([CardInfo]) -> Void = {(OnlineCard: [CardInfo]) in
            self.myCards = OnlineCard
        }
        CardAPIClient.manager.getCards(from: urlStr, completionHandler: setCardToOnlineCard, errorHandler: {print($0)})
    }
    

    func loadTheCardImage() {
        let urlStr = "http://deckofcardsapi.com/static/img/\(myCardsCode).png"
        let setImageToOnlineImage: (UIImage)->Void = {(OnlineImage: UIImage) in
            self.cardImage = OnlineImage
        }
        ImageAPIClient.manager.getImage(from: urlStr, completionHandler: setImageToOnlineImage, errorHandler: {print($0)})
    }
}

//MARK: -Collection View SetUp
extension BlackJackViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//bestSellerBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
        loadTheCardData()
        cell.imageView.image = #imageLiteral(resourceName: "puppy")
        cell.cardValueLabel.text = "10"//myCardsValue
        //TODO: Call the imageAPIClient & set completion like this...completion handler {cell.bookiangeView.image = $0}
        return cell
    }
}
//To customize my cell & set the delegate
extension BlackJackViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2.0 // cells visible in row
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width // screen width of device
        
        // retrun item size
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: collectionView.bounds.height - (cellSpacing * 2))
    }
    
    // padding around our collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    // padding between cells / items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}



