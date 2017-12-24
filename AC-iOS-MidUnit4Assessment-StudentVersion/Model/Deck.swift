//  Deck.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation

struct Deck: Codable {
	let deckId: String // "3p40paa87x90",
	enum CodingKeys: String, CodingKey {
		case deckId = "deck_id"
	}
}

struct DeckAPIClient {
	private init() {}
	static let manager = DeckAPIClient()
	func getDeck(completionHandler: @escaping (Deck) -> Void, errorHandler: @escaping (Error) -> Void) {
		let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
		guard let url = URL(string: urlStr) else {return}
		let parseDeck: (Data) -> Void = {(data: Data) in
			do {
				let deck = try JSONDecoder().decode(Deck.self, from: data)
				completionHandler(deck)
			}
			catch { errorHandler(error) }
		}
		NetworkHelper.manager.performDataTask(withURL: url, completionHandler: parseDeck, errorHandler: errorHandler)
	}
}

