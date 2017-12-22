//
//  CardDeckModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//new deck of cards: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"

struct CardDeckInfo: Codable {
    
    let deckID: String //"3p40paa87x90"
    let success: Bool //true
    
    enum CodingKeys: String, CodingKey {
        case success
        case deckID = "deck_id"
    }
}


