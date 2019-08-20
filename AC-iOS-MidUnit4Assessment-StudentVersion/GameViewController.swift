//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var currentValueLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var instructionLabel: UILabel!
    let cellSpacing: CGFloat = 15.0
    var currentCards = [Card]() {
        didSet {
            print("self current cards count is \(currentCards.count)")
            // currentValueLabel.text = "Current total in hand: \(currentTotal)"
            self.collectionView.reloadData()
            var sum = 0
            for card in currentCards {
                
                if ["jack", "queen", "king"].contains(card.value.lowercased()) {
                    sum += 10
                } else if card.value.lowercased() == "ace" {
                    sum += 11
                } else {
                    sum += Int(card.value)!
                }
            }
            self.currentTotal = sum
        }
    }
    var currentTotal = 0 {
        didSet {
             currentValueLabel.text = "Current total in hand: \(currentTotal)"
            presentAlert()
        }
    }
        
    
    let randomNum = arc4random_uniform(UInt32(20))
    override func viewDidLoad() {
        super.viewDidLoad()
       self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.currentValueLabel.text = "Current total in hand: 0"
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cardCell")
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        let stopAlert = UIAlertController(title: "Game Over", message: "You are \(30 - currentTotal) away from 30", preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
        stopAlert.addAction(newGameAction)
        present(stopAlert, animated: true, completion: {self.resetGame()})
        
    }
    
    @IBAction func drawACardButtonPressed(_ sender: UIButton) {

        loadCards(from: String(randomNum))
     
    }
    func presentAlert() {
        if currentTotal == 30 {
            let vicAlert = UIAlertController(title: "You Win", message: "You current total is 30", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
            vicAlert.addAction(okAction)
            present(vicAlert, animated: true, completion: {self.resetGame()})
        }
        if currentTotal > 30 {
            let deafeatAlert = UIAlertController(title: "Defeat", message: "You went over 30", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
            deafeatAlert.addAction(okAction)
            present(deafeatAlert, animated: true, completion: {self.resetGame()})
        }
    }
    func resetGame() {
        PersistentStoreManager.manager.addToHistory(of: currentCards, and: currentTotal)
        
        self.currentTotal = 0
        self.currentCards = [Card]()
        
    }
    func loadCards(from randomNum: String ) {
        let completion: (String) -> Void = {(onlineDeckId: String) in
            let getCardFromOnline: ([Card]) -> Void = {(onlineCards: [Card]) in
                guard !onlineCards.isEmpty else {return}
                self.currentCards.append(onlineCards.first!)
            }
               CardAPIClient.manager.getCards(from: onlineDeckId, completionHandler: getCardFromOnline, errorHandler: {print($0)})
            
            
        }
      DeckIDAPIClient.manager.getDeckID(from: randomNum, completionHandler: completion, errorHandler: {print($0)})
      
        
    }
  


}
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentCards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        cell.imageView.image = nil
        cell.spinner.isHidden = false
        cell.spinner.startAnimating()
       var value = self.currentCards[indexPath.row].value
        if ["jack", "queen", "king"].contains(value.lowercased()) {
            value = "10"
        } else if value.lowercased() == "ace" {
            value = "11"
        }
        cell.label.text = "\(value)"
        let imageURL = currentCards[indexPath.row].image
        ImageAPIClient.manager.getImages(from: imageURL, completionHandler: {cell.imageView.image = $0; cell.spinner.stopAnimating()}, errorHandler: {print($0)})
        cell.spinner.isHidden = true
        return cell
    }
}




extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCell: CGFloat = 3
        let numSpacing: CGFloat = numCell + 2
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (numSpacing * cellSpacing)) / numCell, height: screenHeight * 0.4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: cellSpacing, bottom: 0, right: cellSpacing) // EdgeInset is top, left, bottom, right spacing of cell to the section edge.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}



