//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct RndCard: Codable {
    let deckId: String
    
    enum CodingKeys: String, CodingKey {
        case deckId = "deck_id"
    }
}

struct PieckedCard: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let code: String
    let image: String
    let value: String
    let images: Image
}

struct Image: Codable {
    let svg: String
    let png: String
}
