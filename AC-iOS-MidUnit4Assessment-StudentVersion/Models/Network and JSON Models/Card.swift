//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardWrapper: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let code: String //"AS",
    let image: String //"http://deckofcardsapi.com/static/img/AS.png",
    let value: String //"ACE",
    let suit: String //"SPADES",
}



