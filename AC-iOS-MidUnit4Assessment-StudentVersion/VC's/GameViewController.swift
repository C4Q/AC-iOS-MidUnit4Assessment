//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var currentHandValueLabel: UILabel!
    
    @IBAction func stopButton(_ sender: UIButton) {
        //Save Hand
        //Show alert that displays "You are \(PointsToWin - currentsum) away from \(pointstowin)"
        //Once alert is clicked run resetfunction
        resetGame()
    }
    @IBAction func drawACard(_ sender: UIButton) {
        //Call CardAPI to draw one card
        
        //Add that cards value to the sum
        //Add that card to the collection view and refresh it
        //Check if sum of card values is over PointsToWin
        if GameLogic.gameOver {
            //Show alert
            //Save hand
            resetGame()
        }
        
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
        
        //reset sum tracker and gameState
        GameLogic.sum = 0
        GameLogic.gameOver = false
        //reset labels
        currentHandValueLabel.text = "Current Hand Value: \(GameLogic.sum)"
    }

    

}
