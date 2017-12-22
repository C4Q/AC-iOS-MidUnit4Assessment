//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    

    
    var cards = [Card]() {
        didSet {
            self.cardCollectionView.reloadData()
        }
    }
   
    
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    
    @IBAction func stopGameButtonPressed(_ sender: UIButton) {
//        TODO setup alert and end game
        let alertController = UIAlertController(title:"Game Over", message: "You were points away from 30", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.cardCollectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
        cardCollectionView.delegate = self
        loadCards()
    }
    
    func loadCards() {
   
    }
    
    func loadCard() {
        
    }


    
    @IBAction func drawCardButtonPressed(_ sender: UIButton) {
        //        TODO load new card
        loadCard()
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = cards[indexPath.row]
        let cell = self.cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.cardImageView?.image = nil
        cell.configureCell(with: card)
        return cell
    }
}
