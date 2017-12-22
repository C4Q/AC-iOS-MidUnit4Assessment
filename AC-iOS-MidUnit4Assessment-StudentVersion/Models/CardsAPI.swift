//
//  CardsAPI.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Caroline Cruz on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class DeckOfCardsAPI {
    
    static let newDeckUrl = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
    static let drawOneUrl = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
    static let reshuffleUrl = "https://deckofcardsapi.com/api/deck/\(deckID)/shuffle/"
    static let deckID = "rt2pzsq1n9g6"
    
    
    static let session = URLSession.shared
  
    
    
    static func newDeck(url: String, completion: @escaping (Error?, NewDeck?) -> Void) {
        session.dataTask(with: URL(string: "\(newDeckUrl)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder() // just initializing a new JSON decoder
                    let newDecks = try decoder.decode(NewDeck.self, from: data) // here we're trying to decode our data
                    completion(nil, newDecks)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
    static func drawCard(url: String, completion: @escaping (Error?, [Card]?) -> Void) {
        session.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let card = try decoder.decode(DeckOfCards.self, from: data)
                    completion(nil, card.cards)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
}


