//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation

//Draw a Card
struct CardJSON: Codable {
	let cards: [Card]
	let deck_id: String //"3p40paa87x90",
	let remaining: Int //50
	let success: Bool // true,
}

struct Card: Codable {
	let code: String //"5H"
	let image: URL // "https://deckofcardsapi.com/static/img/KH.png",
	let value: String // "5"
	let suit: String // "HEARTS"
//	let images: Images
}
struct Images: Codable {
	let svg: String //"http://deckofcardsapi.com/static/img/5H.svg"
	let png: String //"http://deckofcardsapi.com/static/img/5H.png"
}


struct CardAPIClient {
	//Singleton
	private init() {}
	static let manager = CardAPIClient()

	//Method - get ONE IMAGE
	func getCard(fromDeckID deckID: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (Error) -> Void) {

		//URL
		let urlStr = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
		guard let url = URL(string: urlStr) else {return}


		//ParseData
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

//	static func getCard(fromDeckID deckID: String, completion: @escaping (Error?, Card?) -> Void) {
//		let task = URLSession.shared.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1")!, completionHandler: { (data, response, error) in
//
//			if let error = error { completion(error, nil)}
//
//			else if let data = data {
//				do {
//					let cardJson = try JSONDecoder().decode(CardJSON.self, from: data)
//					let card = cardJson.cards[0]
//					completion(nil, card)
//				} catch { print("decoding error: \(error.localizedDescription)") }
//			}
//		})
//		task.resume()
//	}

}
