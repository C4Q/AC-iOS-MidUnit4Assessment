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
		showGameOverAlert()
	}
	@IBAction func drawCard(_ sender: UIButton) {
		getCard(fromDeckID: deck.deckId)
		playerCards.append(card) //add card to card array to be displayed by the collection view
		playerScore += getPoints(cardValue: card.value)
		if playerScore >= 30 { //end game
			showGameOverAlert()
		}
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
		SaveGame()
		resetGame()
	}
	func SaveGame(){
		let game: SavedGame = SavedGame.init(cards: playerCards, score: playerScore)
		DataModel.manager.addGameToHistory(game: game)
	}
	func resetGame(){
		playerScore = 0
		playerCards = [Card]()
		getDeck()
		gameCollectionView.reloadData()
	}
	func getPoints(cardValue: String)->Int {
		switch cardValue {
		case "1": return 1
		case "2": return 2
		case "3": return 3
		case "4": return 4
		case "5": return 5
		case "6": return 6
		case "7": return 7
		case "8": return 8
		case "9": return 9
		case "10","JACK","QUEEN","KING","ACE": return 10
		default: return 0
		}
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
//		//Image processing for cell
//		let imageURL = card.image //image url source
//		let setImage: (UIImage)-> Void = {(onlineImage: UIImage) in
//			cell.cardImage?.image = onlineImage
//			cell.setNeedsLayout()
//		}
//		ImageHelper.manager.getImage(from: imageURL, completionHandler: setImage, errorHandler: {print($0)})
	}

}

//MARK: CollectionView - Flow Layout
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



///extension AnimalPickerController: UICollectionViewDelegateFlowLayout {
//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//	let numCells: CGFloat = 2.0 // cells visible in row
//	let numSpaces: CGFloat = numCells + 1
//	let screenWidth = UIScreen.main.bounds.width // screen width of device
//
//	// retrun item size
//	return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: collectionView.bounds.height - (cellSpacing * 2))
//}
//
//// padding around our collection view
//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//	return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
//}
//
//// padding between cells / items
//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//	return cellSpacing
//}
//}







