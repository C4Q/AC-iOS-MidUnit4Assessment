//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/25/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    var gameBrain = GameBrain()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CollectionViewCell1", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "nibCell")
        self.collectionView.dataSource = self
         HistoryStoreData.manager.load()
    }
    
    var deck: DeckInfo?
    var cards = [Card]()
    
    var playCards = [Card](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func EndGame(_ sender: UIButton) {
//       guard let image = playCards.first?.image else { return }
//        guard let card = playCards.first else { return }
//        let _ = HistoryStoreData.manager.addToHistory(card: card, andImage: image)
        navigationController?.popViewController(animated: true)
      
//        let _ = BookDataStore.manager.addToFavorites(book: book, andImage: image)
//        navigationController?.popViewController(animated: true)
    }

    @IBAction func drawAcard(_ sender: UIButton) {
      getCard()
        
    }
    
    
    func loadDeck() {
        let url = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        let completion: (DeckInfo) -> Void = {(onlineDeck: DeckInfo) in
            self.deck = onlineDeck
            print(self.deck)
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        GetDeckAPIClient.manager.getDeck(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
    func getCard() {
        let url = "https://deckofcardsapi.com/api/deck/fcjz7h0i4ymr/draw/?count=1"
        let completion: (Card) -> Void = {(onlineCard: Card) in
           self.cards.append(onlineCard)
            self.playCards.append(onlineCard)
            for value in self.playCards {
                guard let valueToUse = self.gameBrain.cardValues[value.value] else {return}
                    self.gameBrain.totalValueAtHand += valueToUse
              
                }
                
            }
                   //guard let playCards = self.playCards[key] else {return}
//                if playCards.contains(key) {
//                    self.gameBrain.totalValueAtHand += value
//                    print(value)
//                    print(self.gameBrain.totalValueAtHand)
                //}
            //}
        
        
        let printErrors = {(error: Error) in
            print(error)
        }
        getCardAPIClient.manager.getCard(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nibCell", for: indexPath)
        if let cell = cell as? CollectionViewCell1 {
            let card = playCards[indexPath.row]
            cell.cardValue.text = card.value
            cell.cellImage.image = nil
            guard let cardImageUrl = card.image else {return cell}
            let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
                cell.cellImage.image = onlineImage
                cell.cellImage.setNeedsLayout()
            }
            
            ImageAPIClient.manager.getImage(from: cardImageUrl, completionHandler: completion, errorHandler: {print($0.localizedDescription)})
        }
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numCells: CGFloat = 3
            let numSpaces: CGFloat = numCells + 1
            
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return cellSpacing
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return cellSpacing
        }
        
}
