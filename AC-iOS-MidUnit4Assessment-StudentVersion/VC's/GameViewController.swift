//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    let cardValues: [String:Int] = ["KING":13,
                                    "QUEEN":12,
                                    "JACK": 11,
                                    "10":10,
                                    "9":9,
                                    "8":8,
                                    "7":7,
                                    "6":6,
                                    "5":5,
                                    "4":4,
                                    "3":3,
                                    "2":2,
                                    "ACE":1]
    
    var deckID = "" //Set by the deck_ID property of the CardsAPI
    
    @IBOutlet weak var currentHandValueLabel: UILabel!
    
    @IBAction func stopButton(_ sender: UIButton) {
        
    }
    @IBAction func drawACard(_ sender: UIButton) {
        //Call CardAPI to draw one card
        //Add that card to the collection view and refresh it
        //Check if sum of card values is over 30
        //IF it is, end the game, save the hand, and show alert
        //Once alert is clicked run resetfunction
        //IF it isn't, do nothing.
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        //Call the API for a new deck
        //Set the deckID value in the completion handler
    }
    func resetGame() {
        //Empty collection view array
        //reset labels
        //reset sum tracker
    }

    

}
