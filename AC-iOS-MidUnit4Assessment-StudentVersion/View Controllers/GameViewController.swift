//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class GameViewController: UIViewController {

	//MARK: Outlets
	@IBOutlet weak var gameCollectionView: UICollectionView!
	@IBOutlet weak var instructionsLabel: UILabel!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var drawCardButton: UIButton!

	//MARK: Actions
	@IBAction func stop(_ sender: UIButton) {
		let game: SavedGame = SavedGame.init(cards: playerCards, score: playerScore)
		DataModel.manager.addGameToHistory(game: game)
		showGameOverAlert()
	}
	@IBAction func drawCard(_ sender: UIButton) {
		getCard(fromDeckID: deck.deckId)
		playerCards.append(card) //add card to card array to be displayed by the collection view

		//TO DO
		if playerScore >= 30 { //end game
			showGameOverAlert()
		}
			//add cardValue to playerScore
	}

	//MARK: View Overrides
	override func viewDidLoad() {
		super.viewDidLoad()
		gameCollectionView.delegate = self
		gameCollectionView.dataSource = self
		getDeck()
		gameCollectionView.reloadData()
	}

	//MARK: Properties
	let cellSpacing = UIScreen.main.bounds.size.width * 0.05
	var deck: Deck {
		didSet { getCard(fromDeckID: deck.deckId) }
	}
	var card: Card!
	var playerCards = [Card]() {
		didSet { gameCollectionView.reloadData()}
	}
	var playerScore = 0
	

	//MARK: Methods
	func getDeck(){
		let setDeck = {(onlineDeck: Deck) in self.deck = onlineDeck}
		let printErrors = {(error: Error) in print(error)}
		DeckAPIClient.manager.getDeck(completionHandler: setDeck, errorHandler: printErrors)
	}

	func getCard(fromDeckID: String){
		let setCard = {(onlineCard: Card) in self.card = onlineCard}
		let printErrors = {(error: Error) in print(error)}
		CardAPIClient.manager.getCard(fromDeckID: deck.deckId, completionHandler: setCard, errorHandler: printErrors)
	}

	private func showGameOverAlert(){
		var message: String = ""
		if playerScore > 30 {
			message = "You went over by \(self.playerScore - 30)"
		} else {
			message = "You were \(30 - self.playerScore) from 30"
		}
		let alertController = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
		let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(okAlert)
		present(alertController, animated: true, completion: nil)
		resetGame()
	}

	func resetGame(){
		
		//TO DO - save playerCards array to dataStore
		playerScore = 0
		playerCards = [Card]()
		getDeck()
		gameCollectionView.reloadData()
	}

}



//MARK: CollectionView - Datasource
extension GameViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return playerCards.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
		let card = playerCards[indexPath.row]
		configureCard(card: card, forCell: cell)
		return cell
	}
	func configureCard(card: Card, forCell cell: CardCell) {
		DispatchQueue.global().async {
			do {
				let imageData = try Data.init(contentsOf: URL(string: card.image)!)
				DispatchQueue.main.async {
					cell.cardImage.image = UIImage.init(data: imageData)
				}
			} catch {print("image processing error: \(error.localizedDescription)")}
		}
	}

}

//MARK: CollectionView - Flow Layour
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








