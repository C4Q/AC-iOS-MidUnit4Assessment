//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct cards: Codable {
    let cards: [Card]
    let idDeck : String
    
    
    enum CodingKeys: String, CodingKey{
        case cards
        case idDeck = "deck_id"
    }
}

struct Card: Codable{
    let image: String
    let value: String
}


