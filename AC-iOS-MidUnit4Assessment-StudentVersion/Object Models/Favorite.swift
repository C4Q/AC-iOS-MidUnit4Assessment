//
//  Favorite.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit



struct Favorite: Codable{
    let cards: [Card]
    let idDeck : String
    let finalValue: Int
    
    
    enum CodingKeys: String, CodingKey{
        case cards
        case idDeck = "deck_id"
        case finalValue
    }
    
    
    
    

}
