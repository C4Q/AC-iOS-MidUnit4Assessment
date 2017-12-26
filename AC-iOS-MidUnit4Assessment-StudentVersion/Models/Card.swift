//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardResponse: Codable {
    let cards: [Card]
    let deck_id: String
    let remaining: Int
    let success: Bool
}

struct Card: Codable {
    let code: String
    let image: String
    let value: String
    let suit: String
    let images: ImagesWrapper
}

struct ImagesWrapper: Codable {
    let svg: String
    let png: String
}

struct CardAPIClient {
    private init() {}
    static let manager = CardAPIClient()
    
    let endpointUrlStr = "https://deckofcardsapi.com/api/deck/"
    
    func getCardDeck(from deckID: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (Error) -> Void) {
        let fullUrlStr = "\(endpointUrlStr)\(deckID)/draw/?count=1"
        guard let url = URL(string: fullUrlStr) else {
            errorHandler(AppError.badURL(str: fullUrlStr))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                completionHandler(cardResponse.cards[0])
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}
