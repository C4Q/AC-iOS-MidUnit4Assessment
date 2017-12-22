//
//  NewDeck.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Caroline Cruz on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct NewDeck: Codable {
    let deckID: String
    
    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
    }
}


