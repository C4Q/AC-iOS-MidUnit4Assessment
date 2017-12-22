//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardWrapper: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let code: String
    let imageURL: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case code, value
        case imageURL = "image"
    }
}
