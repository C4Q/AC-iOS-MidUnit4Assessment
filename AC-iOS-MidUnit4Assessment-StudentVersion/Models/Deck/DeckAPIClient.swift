//
//  DeckAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class DeckAPIClient {
    private init() {}
    static let manager = DeckAPIClient()
    func getDeckID(completionHandler: @escaping (Deck) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlString = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        
        guard let url = URL(string: urlString) else {
            errorHandler(AppError.badURL(url: urlString))
            return
        }
        
        NetworkHelper.manager.performDataTask(
            with: url,
            completionHandler: { (data) in
                do {
                    let deck = try JSONDecoder().decode(Deck.self, from: data)
                    completionHandler(deck)
                } catch let error {
                    errorHandler(AppError.cannotParseJSON(rawError: error))
                }
        },
            errorHandler: errorHandler)
    }
}
