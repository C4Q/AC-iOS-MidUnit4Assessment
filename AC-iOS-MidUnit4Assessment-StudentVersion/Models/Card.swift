//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


/// TO CREATE A NEW PLAY OF 6 DECKS: https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6
/// TO DRAW A SINGLE CARD FROM THE PLAY DECK, DECK ID CALLED IN ABOVE ENDPOINT: https://deckofcardsapi.com/api/deck/6bvrbab3jkzl/draw/?count=1


struct PlayDeck: Codable {
    let cards: [Card]
    let deckID: String  /// use this in 2nd endpoint
    let remaining: Int /// number of cards left in the deck; decrements at each call
    
    enum CodingKeys: String, CodingKey {
        case cards
        case deckID = "deck_id"
        case remaining
    }
}


struct Card: Codable {
    let code: String
    let image: String
    let value: String
}
