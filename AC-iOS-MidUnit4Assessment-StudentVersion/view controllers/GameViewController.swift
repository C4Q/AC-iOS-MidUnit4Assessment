//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var handCollectionView: UICollectionView!
    
    @IBOutlet weak var currentHandValueLabel: UILabel!
    
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.04
    
    var deck: Deck?
    var hand = [Card]() {
        didSet {
            handCollectionView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "cardCell", bundle: nil)
        self.handCollectionView.register(nib, forCellWithReuseIdentifier: "cardCell")
        self.handCollectionView.dataSource = self
        self.handCollectionView.delegate = self
        instructionsLabel.text = "Get to 30 without going over!"
        GameBrain.manager.setUpDeck()
        self.deck = GameBrain.manager.deck
        self.hand = GameBrain.manager.getCurrentHand()
        currentHandValueLabel.text = "Current Hand Total: \(GameBrain.manager.currentTotal)"
        
    }
    
    private func showVictoryAlert() {
        let alertController = UIAlertController(title: "Victory!", message: "You got to 30!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
       
    }
    private func showDefeatAlert() {
        let alertController = UIAlertController(title: "Defeat!", message: "You went over 30!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    private func showStopAlert() {
        let alertController = UIAlertController(title: "Stopped", message: "you were \(GameBrain.manager.victoryTotal - GameBrain.manager.currentTotal) away from 30", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "New Game", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }

   //TODO button actions 

    
    @IBAction func drawButtonPressed(_ sender: UIButton) {
        GameBrain.manager.draw()
        self.hand = GameBrain.manager.hand
        currentHandValueLabel.text = "Current Hand Total: \(GameBrain.manager.currentTotal)"
        switch GameBrain.manager.victoryCheck(currentTotal: GameBrain.manager.currentTotal) {
        case .lose :
            showDefeatAlert()
            resetGame()
        case .win :
            showVictoryAlert()
            resetGame()
        case.playing :
            print("")

        }

    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        showStopAlert()
        Persistence.manager.addHand(cards: hand, total: GameBrain.manager.currentTotal)
        resetGame()
        
        

    }
    
    
    func resetGame() {
        currentHandValueLabel.text = "Current Hand Total: \(GameBrain.manager.currentTotal)"
        GameBrain.manager.clearCurrentGame()
        Persistence.manager.addHand(cards: self.hand, total:GameBrain.manager.currentTotal)
        self.hand = GameBrain.manager.hand
        
        handCollectionView.reloadData()
        
    }
    
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = hand[indexPath.row]
        let cell = handCollectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! cardCell
        cell.myCard = card
        cell.configureCell(with: card)
        return cell
    }
    
    
}
extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing/2
    }
    
    
    
    
}









