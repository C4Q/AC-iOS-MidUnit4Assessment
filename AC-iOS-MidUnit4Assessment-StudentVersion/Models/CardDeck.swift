//
//  CardDeck.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardDeck: Codable {
    let shuffled: Bool
    let deck_id: String
    let remaining: Int
    let success: Bool
}

struct CardDeckAPIClient {
    private init() {}
    static let manager = CardDeckAPIClient()
    
    let endpointUrlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
    
    func getCardDeck(completionHandler: @escaping (CardDeck) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: endpointUrlStr) else {
            errorHandler(AppError.badURL(str: endpointUrlStr))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let cardDeck = try JSONDecoder().decode(CardDeck.self, from: data)
                completionHandler(cardDeck)
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}
