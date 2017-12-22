//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CurrentGameViewController: UIViewController {

    let logic = GameLogic()
    
    var newDeck = [Deck]() {
        didSet {
            gameCollectionView.reloadData()
        }
    }
    
    var currentCards = [CardDetails](){
        didSet {
            gameCollectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var drawCardButton: UIButton!
    @IBAction func stopGame(_ sender: UIButton) {
        logic.gameOver()
        loadDeck()
    }
    @IBAction func drawCard(_ sender: UIButton) {
        
        let deckId = newDeck[0].deckID
        
        DrawCardAPIClient.manager.getACard(deckId: deckId, completionHandler: {self.currentCards = $0},
            errorHandler: {print($0)})
        
       currentScore.text = "\(logic.getScore(value: currentCards[0].value))"
    }
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        
        loadDeck()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadDeck() {
        
        DeckAPIClient.manager.getDeck(completionHandler: {self.newDeck = [$0]}, errorHandler: {print($0)})
    }


}


extension CurrentGameViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CurrentGameCollectionViewCell
        let card = currentCards[indexPath.row]
        cell?.imageView.image = #imageLiteral(resourceName: "Cute-Girl-Cat-Names")
        cell?.valueLabel.text = logic.cardValueConverter(value: currentCards[0].value)
        let urlStr = currentCards[0].imageUrl
        
        ImageAPIClient.manager.getImage(urlStr: urlStr, completionHandler: {cell?.imageView.image = $0}, errrorHandler: {print($0)})
        
       
        
        
        return cell!
        
    }
}












