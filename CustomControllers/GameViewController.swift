//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var handValue: UILabel!
    
    var cards = [Card]() {
        didSet {
            self.collectionView.reloadData()
            let lastItem = collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
            guard lastItem >= 0 else {
                return
            }
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    var target: Int {
        if UserDefaults.standard.integer(forKey: "target") == 0 {
            return 30
        } else {
            return UserDefaults.standard.integer(forKey: "target")
        }
    }
    var triedToQuit = false
    var totalVal = 0 {
        didSet {
            handValue.text = "Current Hand Value: \(totalVal)"
            if self.totalVal == target {
                // show win message
                self.present(self.winAlert, animated: true, completion: nil)
                // new game
            } else if self.totalVal > target {
                // show defeat message
                if triedToQuit {bustAlert.message = "You've gone over \(target). \n You should've stopped."}
                self.present(self.bustAlert, animated: true, completion: nil)
                // new game
            }
        }
    }
    
    
    let CardCollectionViewCellId: String = "CardCollectionViewCell"
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var cellSpacing: CGFloat {
        if screenHeight > screenWidth { return screenHeight * 0.05}
        return screenWidth * 0.05
    }
    
    let bustAlert = UIAlertController(title: "Bust!", message: "You've gone over 30.", preferredStyle: UIAlertControllerStyle.alert)
    let winAlert = UIAlertController(title: "You Won!", message: "You've hit 30.", preferredStyle: UIAlertControllerStyle.alert)
    let gaveUpAlert = UIAlertController(title: "Giving Up?", message: "placeHolder", preferredStyle: UIAlertControllerStyle.alert)
    func setupAlerts() {
        bustAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: { _ in
            self.resetGame()
        }))
        winAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: { _ in
            self.resetGame()
        }))
        gaveUpAlert.message = "You're still \(target - totalVal) points from hitting 30."
        gaveUpAlert.addAction(UIAlertAction(title: "KEEP TRYING", style: UIAlertActionStyle.default, handler: nil))
        gaveUpAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: { _ in
            self.resetGame()
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: CardCollectionViewCellId, bundle: nil)
        self.collectionView.register(nibCell, forCellWithReuseIdentifier: CardCollectionViewCellId)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.green
        
        setupAlerts()
        PlayingCardsAPIClient.manager.resetDeck { (error) in
            switch error {
            case AppError.defaultsNotSet, AppError.noJSONmaybe:
                PlayingCardsAPIClient.manager.getNewDeck(completionHandler: {}, errorHandler: {print($0)})
            default:
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        instructionsLabel.text = "Get up to \(target) without going over!"
    }
    
    func resetGame() {
        saveGame()
        PersistenceStoreManager.manager.load()
        self.cards = []
        self.totalVal = 0
        bustAlert.message = "You've gone over 30."
        PlayingCardsAPIClient.manager.resetDeck(errorHandler: {print($0)})
    }
    
    func saveGame() {
        let pastGamesCount = PersistenceStoreManager.manager.gameCount()
        
        let newPastGame = PastGame(finalVal: totalVal, cards: cards, id: pastGamesCount)
        
        var images = [UIImage]()
        
        for card in cards {
            images.append(ImageCache.manager.cachedImage(url: card.image)!)
        }
        let _ = PersistenceStoreManager.manager.addToPastGames(game: newPastGame, andImages: images)
    }
    @IBAction func drawACard(_ sender: UIButton) {
        PlayingCardsAPIClient.manager.getNewCard(completionHandler: {card in
            self.cards.append(card)
            
            self.totalVal += CardValues.valOf[card.value]!
            self.triedToQuit = false
        }, errorHandler: {print($0)})
    }
    @IBAction func stopDrawing(_ sender: UIButton) {
        self.present(gaveUpAlert, animated: true, completion: nil)
        triedToQuit = true
    }
    
}

extension GameViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCellId, for: indexPath) as! CardCollectionViewCell
        let card = cards[indexPath.row]
        
        cell.backgroundColor = UIColor.green
        cell.cardValue.text = "\(CardValues.valOf[card.value] ?? 0)"
        
        
        cell.cardImage.image = #imageLiteral(resourceName: "Tutr2")
        configureCell(withCard: card, forCell: cell)
        
        return cell
    }
    private func configureCell(withCard card: Card, forCell cell: CardCollectionViewCell) {
        
        // if we have the image in cache then set the image to the cell
        if let image = ImageCache.manager.cachedImage(url: card.image) {
            cell.cardImage.image = image
        } else { // we don't have an image for the cell in cache, let's process on background
            
            // keep track of cell that was set
            cell.urlString = card.image.absoluteString
            
            ImageCache.manager.processImageInBackground(imageURL: card.image, completion: { (error, image) in
                if let error = error {
                    // handle error
                    print("error: \(error.localizedDescription)")
                } else if let image = image {
                    
                    // set the cell if the url string matches
                    
                    // cells are being dequeued and reprocessed at this point
                    if cell.urlString == card.image.absoluteString {
                        DispatchQueue.main.async {
                            cell.cardImage.image = image
                            cell.urlString = card.image.absoluteString
                        }
                    }
                }
            })
        }
        
    }
}
extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numCells: CGFloat = 0
        let numSpaces: CGFloat = 2
        let shorterOfTwo = (screenHeight > screenWidth ? screenWidth : screenHeight)
        if screenHeight > screenWidth {
            numCells = 1.5
        }
        else {
            numCells = 1.5
        }
        return CGSize(width: (shorterOfTwo - (numSpaces * cellSpacing)) / numCells, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}


