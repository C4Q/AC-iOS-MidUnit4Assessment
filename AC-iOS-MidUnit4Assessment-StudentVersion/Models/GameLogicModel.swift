//
//  GameLogicModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GameLogic {
    let cardValues: [String:Int] = ["KING":13,
                                    "QUEEN":12,
                                    "JACK": 11,
                                    "10":10,
                                    "9":9,
                                    "8":8,
                                    "7":7,
                                    "6":6,
                                    "5":5,
                                    "4":4,
                                    "3":3,
                                    "2":2,
                                    "ACE":1]
    
    var pointsToWin = 30
    var deckID = "" //Set by the deck_ID property of the CardsAPI
    var gameOver: Bool = false
    var sum = 0 {
        didSet {
            if sum >= pointsToWin {
                gameOver = true
            }
        }
    }
    
    
}
