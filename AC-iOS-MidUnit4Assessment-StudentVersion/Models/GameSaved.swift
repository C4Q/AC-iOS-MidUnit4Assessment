//
//  GameSaved.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

struct Game: Codable {
    var score: Int
    var game: [GameSaved]
}

struct GameSaved: Codable {
    var cardVal: Int
    var cardImage: String
}
