//
//  PlayingCard.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardValues {
    private init() {}
    static let valOf = ["2": 2,
                        "3": 3,
                        "4": 4,
                        "5": 5,
                        "6": 6,
                        "7": 7,
                        "8": 8,
                        "9": 9,
                        "10": 10,
                        "JACK": 10,
                        "QUEEN": 10,
                        "KING": 10,
                        "ACE": 11]
}


struct DrawCardAPIResponse: Codable {
    var cards: [Card]
}

struct Card: Codable {
    let code: String
    let value: String
    let image: URL
}

struct NewDeckAPIResponse: Codable {
    let deckID: String?
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
        case success
    }
}





