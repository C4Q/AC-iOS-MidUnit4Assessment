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

struct PickedCard: Codable {
    let cards: [Card]
    let desckId: String
    
    enum CodingKeys: String, CodingKey {
        case cards
        case desckId = "deck_id"
    }
}

struct Card: Codable {
    let code: String
    let image: String
    let value: String
    var cardVal: Int {
        if let val = Int(value) {
            return val
        } else {
            let cardStrToIntDic = ["Jack":10,"Queen":10,"King":10,"Ace":11]
            let value = self.value.capitalized
            guard let val = cardStrToIntDic[value] else {return 0}
            return val
        }
    }
}


