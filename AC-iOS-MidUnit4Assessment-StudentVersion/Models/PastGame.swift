//
//  PastGame.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct PastGame: Codable {
    let finalScore: Int
    let targetScore: Int
    let gameCards: [Card]
}
