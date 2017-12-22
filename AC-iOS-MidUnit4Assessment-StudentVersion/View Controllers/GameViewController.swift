//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //maybe use a card game model?
    var deck: Deck?
    var cards: [Card] = [] {
        didSet {
            //reload collection view
            gameCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //the instructions label should change based on what the user sets the score to
        CardGame.delegate = self
        newGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let targetNumber = Settings.manager.getTargetNumber() ?? 30
        
        instructionsLabel.text = "Try to reach \(targetNumber) without going over!"
        //user should be able to change target number any time
    }
    
    @IBAction func drawACardButtonPressed(_ sender: UIBarButtonItem) {
        //to do
        //should add card to collection view, then reload
        getCard()
        //also check if score is over 30? - maybe do in game model
        //maybe game model should return "victory, ongoing, defeat" or something, so we can present different things
        //alert should allow for new game
        //should also add card to persistent data
            
    }
    
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        //should stop game, and present (30 - current score) "you were __ away from 30!"
        //alert should allow for new game
        
    }
    
    func newGame() {
        //to do - should reset collection view
        //should reset labels
        
        let targetNumber = Settings.manager.getTargetNumber() ?? 30
        
        instructionsLabel.text = "Try to reach \(targetNumber) without going over!"
    
        //should reset current collectionview data source variable and reload data
        //should load new Deck
        loadNewDeck()
    }
    
    func loadNewDeck() {
        //should set something to deck variable in game model
    }
    
    func getCard() {
        //should get a card using current deck
        //append to current card - using card game model
    }
    
}

extension GameViewController: CardGameDelegate {
    
    func saveGame(withCards cards: [Card], score: Int, andTargetScore targetScore: Int) {
        <#code#>
    }
    
}

