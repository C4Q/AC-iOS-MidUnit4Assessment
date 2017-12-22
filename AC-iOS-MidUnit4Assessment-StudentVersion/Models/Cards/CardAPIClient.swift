//
//  CardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CardAPIClient {
    private init() {}
    static let manager = CardAPIClient()
    func getCard(fromDeck deck: Deck, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        let urlString = "https://deckofcardsapi.com/api/deck/\(deck.id)/draw/?count=1"
        
        guard let url = URL(string: urlString) else {
            errorHandler(AppError.badURL(url: urlString))
            return
        }
        
        NetworkHelper.manager.performDataTask(
            with: url,
            completionHandler: { (data) in
                do {
                    let results = try JSONDecoder().decode(CardWrapper.self, from: data)
                    completionHandler(results.cards[0])
                } catch let error {
                    errorHandler(AppError.cannotParseJSON(rawError: error))
                }
        },
            errorHandler: errorHandler)
    }
}
