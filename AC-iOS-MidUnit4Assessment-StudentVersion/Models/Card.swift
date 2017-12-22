//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


/// TO DRAW A SINGLE CARD FROM THE PLAY DECK, DECK ID CALLED IN ABOVE ENDPOINT: https://deckofcardsapi.com/api/deck/6bvrbab3jkzl/draw/?count=1


struct PlayDeck: Codable {
    let cards: [Card]? /// using this endpoint with count = 1, cards is only really ONE card in the array
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
    let image: String?
    let value: String
}
