//
//  DeckAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Deck: Codable {
    let shuffled: Bool
    let deckID: String
    let remaining: Int
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case shuffled
        case deckID = "deck_id"
        case remaining
        case success
    }
}


struct DeckAPIClient {
    private init () {}
    static let manager = DeckAPIClient()

    func getDeck( completionHandler: @escaping (Deck) -> Void , errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        guard let url = URL(string: urlStr) else { errorHandler(AppError.badURL); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let newDeck = try JSONDecoder().decode(Deck.self, from: data)
                completionHandler(newDeck)
            } catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
