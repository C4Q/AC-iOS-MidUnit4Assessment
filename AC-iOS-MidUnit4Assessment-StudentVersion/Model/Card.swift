//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation

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
	var cardImage: UIImage? {
		set{}
		get {
			let imageURL = DataStorage.manager.dataFilePath(withPathName: image)
			let docImage = UIImage(contentsOfFile: imageURL.path)
			return docImage
		}
	}
}

struct CardAPIClient {
	private init() {}
	static let manager = CardAPIClient()
	func getCard(fromDeckID deckID: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (Error) -> Void) {
		let urlStr = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
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

