//
//  GameLogicModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GameLogic {
    static let cardValues: [String:Int] = ["KING":10,
                                    "QUEEN":10,
                                    "JACK": 10,
                                    "10":10,
                                    "9":9,
                                    "8":8,
                                    "7":7,
                                    "6":6,
                                    "5":5,
                                    "4":4,
                                    "3":3,
                                    "2":2,
                                    "ACE":11]
    
    static var pointsToWin = 30
    static var deckID = "" //Set by the deck_ID property of the CardsAPI
    static var gameOver: Bool = false
    static var sum = 0 {
        didSet {
            if sum >= pointsToWin {
                gameOver = true
            }
        }
    }
    
    
}
