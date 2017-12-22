//  CardDataStore.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by Winston Maragh on 12/22/17.
//  Copyright © 2017 Winston Maragh. All rights reserved.


import Foundation
import UIKit

class DataStorage {

	static let kPathname = "History.plist"

	// singleton
	private init(){}
	static let manager = DataStorage()


	private var gameCards = [Card]() {
		didSet{
			saveToDisk()
		}
	}
	var playerScore = Int()
	var game = [SavedCard]()
	private var history = [SavedGames]() {
		didSet {
			saveToDisk()
		}
	}




	// returns documents directory path for app sandbox
	func documentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	// /documents/Favorites.plist
	// returns the path for supplied name from the dcouments directory
	func dataFilePath(withPathName path: String) -> URL {
		return DataStorage.manager.documentsDirectory().appendingPathComponent(path)
	}

	// save to documents directory
	// write to path: /Documents/
	func saveHistory() {
		do {
			let data = try PropertyListEncoder().encode(history)
			// Does the writing to disk
			try data.write(to: dataFilePath(withPathName: DataStorage.kPathname), options: .atomic)
		}
		catch {print("encoding error: \(error.localizedDescription)")}
	}

	// load from documents directory
	func loadHistory() {
		// what's the path we are reading from?
		let path = dataFilePath(withPathName: DataStorage.kPathname)
		do {
			let data = try Data.init(contentsOf: path)
			history = try PropertyListDecoder().decode([SavedGames].self, from: data)
		}
		catch {print("decoding error: \(error.localizedDescription)")}
	}


	func addGametoHistory(game: [SavedCard], score: Int, andImage: UIImage) ->Bool {


		history.append(game)
	}
	// does 2 tasks:
	// 1. stores image in documents folder
	// 2. appends card item to cards array
	func addToSavedGames(card: Card, andImage image: UIImage) -> Bool  {
		// checking for uniqueness
		let indexExist = gameCards.index{ $0.code == card.code}
		//		if indexExist != nil { print("FAVORITE EXIST"); return false }

		// 1) save image from favorite photo
		let success = storeImageToDisk(image: image, andCard: card)
		if !success { return false }

		// 2) save card
		let newCard = gameCards
		SavedCard.init(code: card.code, image: card.image, value: card.value, suit: card.suit)
		gameCards.append(newCard)
		return true
	}

	// store image
	func storeImageToDisk(image: UIImage, andCard card: Card) -> Bool {
		// packing data from image
		guard let imageData = UIImagePNGRepresentation(image) else { return false }

		// writing and saving to documents folder

		// 1) save image from card
		let imageURL = DataStorage.manager.dataFilePath(withPathName: card.image)
		do { try imageData.write(to: imageURL) }
		catch {print("image saving error: \(error.localizedDescription)")}
		return true
	}

	func isCardInFavorites(card: Card) -> Bool {
		// checking for uniqueness
		let indexExist = gameCards.index{ $0.code == card.code }
		if indexExist != nil { return true}
		else {return false}
	}

	func getCards() -> [Card] {
		return gameCards
	}


	//	func getCardWithId(imdbId: String) -> Card? {
	//		let index = getCards().index{$0. .imdbId == imdbId}
	//		guard let indexFound = index else { return nil }
	//		return gameCards[indexFound]
	//	}



	//	func removeCard(fromIndex index: Int, andCardImage gameCards: [Card]) -> Bool {
	//		favorites.remove(at: index)
	//		// remove image
	//		let imageURL = CardDataStore.manager.dataFilePath(withPathName: favorite.imdbId)
	//		do {
	//			try FileManager.default.removeItem(at: imageURL)
	//			print("\n==============================================================================")
	//			print("\(imageURL) removed")
	//			print("==============================================================================\n")
	//			return true
	//		} catch {
	//			print("error removing: \(error.localizedDescription)")
	//			return false
	//		}
	//	}

}



