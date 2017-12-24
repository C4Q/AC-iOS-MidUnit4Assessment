//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

struct CardJSON: Codable {
	let cards: [Card]
	let deck_id: String //"3p40paa87x90",
	let remaining: Int //50
	let success: Bool // true,
}

struct Card: Codable {
	let code: String //"5H"
	let image: String // "https://deckofcardsapi.com/static/img/KH.png",
	let value: String // "5"
	let suit: String // "HEARTS"
	var cardValueInt: Int {
		switch value {
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
	var cardImage: UIImage? {
		get {
			do {
				let imageData = try Data.init(contentsOf: URL(string: image)!)
				let newImage = UIImage.init(data: imageData)
				return newImage
			}
			catch {print("image processing error: \(error.localizedDescription)")}
			return UIImage()
		}
	}
}

struct CardAPIClient {
	private init() {}
	static let manager = CardAPIClient()
	func getCard(fromDeckID deckID: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (Error) -> Void) {
		let urlStr = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=6"
		guard let url = URL(string: urlStr) else {return}
		let parseCard: (Data) -> Void = {(data: Data) in
			do {
				let cardJson = try JSONDecoder().decode(CardJSON.self, from: data)
				let card = cardJson.cards[0]
				completionHandler(card)
			}
			catch { errorHandler(error) }
		}
		NetworkHelper.manager.performDataTask(withURL: url, completionHandler: parseCard, errorHandler: errorHandler)
	}
}

