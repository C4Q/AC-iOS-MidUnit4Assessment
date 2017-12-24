//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct DeckID: Codable {
    let deck_id: String
}


struct DeckIDAPIClient {
    private init() {}
    static let manager = DeckIDAPIClient()
   // let count = arc4random_uniform(UInt32(12))
    func getDeckID(from randomCount: String,
                    completionHandler: @escaping (String) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=\(randomCount)"
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let result = try JSONDecoder().decode(DeckID.self, from: data)
                let deckID = result.deck_id
                print("===============\n)")
                print(deckID)
                completionHandler(deckID)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
        
    }
}



struct CardList: Codable {
    let cards: [Card]
}
struct Card: Codable {
    let image: URL
    let value: String
    
}

struct CardAPIClient {
    private init() {}
    static let manager = CardAPIClient()
    func getCards(from cardID: String,
                    completionHandler: @escaping ([Card]) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://deckofcardsapi.com/api/deck/\(cardID)/draw/?count=1"
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let result = try JSONDecoder().decode(CardList.self, from: data)
                let cards = result.cards
                print("cards' count is \(cards.count)")
                completionHandler(cards)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
        
    }
}
