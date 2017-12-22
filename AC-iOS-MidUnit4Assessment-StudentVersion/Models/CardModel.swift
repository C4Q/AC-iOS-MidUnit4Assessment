//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Caroline Cruz on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct DeckOfCards: Codable {
    let cards: [Card]
    let deckID: String

    enum CodingKeys: String, CodingKey {
        case cards
        case deckID = "deck_id"
    }
}

struct Card: Codable {
    let image: String
    let value: String
    let suit: String
    let code: String
}


