//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	//MARK: Outlets
	@IBOutlet weak var gameCollectionView: UICollectionView!

	
	//MARK: View Overrides
	override func viewDidLoad() {
		super.viewDidLoad()
		gameCollectionView.delegate = self
		gameCollectionView.dataSource = self
		getDeck()
		gameCollectionView.reloadData()
	}

	//MARK: Properties
//	var image: UIImage!
	let cellSpacing = UIScreen.main.bounds.size.width * 0.05

	var deck: Deck {
		didSet {
			getCard(fromDeckID: deck.deckId)
			gameCollectionView.reloadData()
		}
	}
	var currentCard: Card!
	var playerCards: [Card]{
		didSet {
			gameCollectionView.reloadData()
		}
	}


	//MARK: Methods
	func getDeck() {
		let print

		DeckAPIClient.manager.getDeck(completionHandler: { (onlineDeck) in
			self.deck = onlineDeck
		}, errorHandler: {_ in print({$0})})
	}
	func getCard(fromDeckID: String){
		CardAPIClient.manager.getCard(fromDeckID: deck.deckId, completionHandler: { (onlineCard) in
			self.currentCard = onlineCard
		}, errorHandler: {_ in print({$0})} )
	}



	}

	//MARK: CollectionView - Datasource
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
				let imageData = try Data.init(contentsOf: card.image)
				DispatchQueue.main.async {
					cell.imageView.image = UIImage.init(data: imageData)
				}
			} catch {print("image processing error: \(error.localizedDescription)")}
		}
	}


	//MARK: CollectionView - Flow Layour
	extension MovieSearchController: UICollectionViewDelegateFlowLayout {
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



}
