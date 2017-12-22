//
//  Deck.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct Deck: Codable {
   let deckID: String
    
    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
    }
}

struct DeckAPIClient {
    private init() {}
    static let manager = DeckAPIClient()
    private let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
    func getDeck(completionHandler: @escaping(Deck) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string:urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoDeck: (Data) -> Void = {(data) in
            do {
                let deck = try JSONDecoder().decode(Deck.self, from: data)
                completionHandler(deck)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoDeck, errorHandler: errorHandler)
    }
}
