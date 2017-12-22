//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var currentGameScoreLabel: UILabel!
    @IBOutlet weak var currentGameCollectionView: UICollectionView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    
    var currentHandScore: Int = 0 {
        didSet {
            currentGameScoreLabel.text = "Current Hand Score: \(currentHandScore)"
        }
    }
    
    // whenever currentCardHand array is modified, the collectionView will reload to reflect the change (addition)
    var currentCardHand = [Card]() {
        didSet {
            self.currentGameCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentGameCollectionView.dataSource = self
        self.currentGameCollectionView.delegate = self
        currentGameScoreLabel.text = "Current Hand Value: \(currentHandScore)"
    }

    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func drawButtonPressed(_ sender: UIButton) {
        // when button pressed, hit the draw card API
        // get the value of the Card
        // save the values of Card to var currentCardHand
        // show the image of the Card in currentGameCollectionView
        // show the value of the Card in currentGameCollectionView
        // add the value of the Card to the var currentHandScore
        
    }
    

}


extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = currentCardHand[indexPath.row]
        let cardCell = currentGameCollectionView.dequeueReusableCell(withReuseIdentifier: "Card Cell", for: indexPath)
        // call function to load a Card
        return UICollectionViewCell()
    }

    func loadACard(from card: Card, nib: CardNib) {
        // call the Card API Client
    }
    
}


extension GameViewController: UICollectionViewDelegate {
    
}
