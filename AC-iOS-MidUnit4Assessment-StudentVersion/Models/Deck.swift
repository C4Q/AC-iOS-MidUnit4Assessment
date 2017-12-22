//
//  Deck.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


/// https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6

struct NewCardDeck: Codable {
    let deckID: String
    let remaining: Int /// number of cards in the generated play deck of 6 card decks
    
    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
        case remaining
    }
}
